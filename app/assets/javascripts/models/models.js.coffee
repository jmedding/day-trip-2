App.User = Em.Object.extend(
    home : null
    marker : null
    set_home: (map) ->
      if @marker is null
        marker = new google.maps.Marker(
            position: @home
            title: "My Location (click and drag to move)"
            map : map
            draggable: true
            icon: '/assets/home2.png'
        )
        
        marker.user = @
        google.maps.event.addListener(marker, 'dragend', (evt) -> 
          marker.user.set('home', evt.latLng)
          #check if both lat and lon cookies are set, if not, then ask...
          
          if (Utils.get_cookie("visitor_lat")? and Utils.get_cookie("visitor_lon")? ) or confirm("Rember this home location for this computer?")
            Utils.set_cookie("visitor_lat", marker.user.home.lat(), "max")
            Utils.set_cookie("visitor_lon", marker.user.home.lng(), "max")
          return null
        )
        google.maps.event.addListener(marker, 'dblclick', (evt)->
          #automatically update home position using geocoder
          #get geocoder positions
          try
            if geoplugin_countryCode().indexOf('CH') is -1
              console.log(geoplugin_countryCode());
              throw("You aren't in Switzerland yet");
            
            #console.log(geoplugin_city());
            new_home = new google.maps.LatLng(geoplugin_latitude(), geoplugin_longitude());
            marker.user.set('home',new_home)
            marker.setPosition(new_home)
            Utils.delete_cookies( "visitor_lat", "visitor_lon")
            
          catch e
            #Not in Switzerland or geoplugin not working
            if geoplugin_country
              alert("The internet believes that you are in #{geoplugin_country} so we won't update your home position")
            else
              alert("The internet believes that you are in not in Switzerland so we won't update your home position")
        )
        @set('marker', marker)
)

App.Icon = DS.Model.extend(
  activities: DS.hasMany('App.Activity')
  name : DS.attr('string')
  file : DS.attr('string')
)

App.Season    = App.Icon.extend()
App.Category  = App.Icon.extend()
 
App.Activity = DS.Model.extend(
    seasons : DS.hasMany 'App.Season'
    categories : DS.hasMany 'App.Category'
    pictures : DS.hasMany 'App.Picture'

    name : DS.attr('string')
    lat : DS.attr('number')
    lon : DS.attr('number')
    #must set lat,lon when creating object...
    pics : []     #an array of image objects
    thumbs : []   #divs for displaying the thumb
    photos: []    #canvas for displaying the full photo
    marker : null
    highlighted : false
    homeBinding : 'App.user.home'
    
    url_name : (->
        return @name.toLowerCase().replace(/(\s)/g, "-")
    ).property()
    
    elementId : (->
      "list-item-" + @get('id');
      ).property()

    set_marker: (map, controller) -> 
      try
        #console.log "Setting marker for ", @get('name')
        marker = new google.maps.Marker({
          position : new google.maps.LatLng(@get('lat'), @get('lon'))
          title : @get('name')
          map : map
        })
        marker.activity = this
        google.maps.event.addListener(marker, 'mouseover', -> marker.activity.set('highlighted', true))
        google.maps.event.addListener(marker, 'mouseout', -> marker.activity.set('highlighted', false))
        google.maps.event.addListener(marker, 'click', -> controller.activity_clicked(marker.activity))
        
        @set('marker', marker)
      catch e
        console.log "Goodle Map Marker Creation failed", e
        return marker  

    distance_to_home: (->
      #console.log "setting distance_to_home"
      
      return 1 unless @home?

      toRad = (value) ->
          # Converts numeric degrees to radians
          value * Math.PI / 180
        
      if @lat is null or @lon is null 
        #error condition...
        return -1
      d = null
      lat1 = @get('lat')
      lon1 = @get('lon')
      lat2 = @get('home').lat()
      lon2 = @get('home').lng()
      R = 6371                # km
      dLat = toRad(lat2-lat1)
      dLon = toRad(lon2-lon1)
      lat1r = toRad(lat1)
      lat2r = toRad(lat2)
      
      a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1r) * Math.cos(lat2r)
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
      d = R * c
      #console.log d
      parseInt(d)
    
    ).property('home')
           
    set_images : (imageSrcs) ->
      @get('pictures').forEach(((pic, index, array) ->
        pic.set_image()
      ))

      return null
)

App.Picture = DS.Model.extend(
  activity : DS.belongsTo('App.Activity')
  file : DS.attr('string')

  load_image : (-> 
    @set_image() if @get('ready')
    ).observes('isLoaded')

  createThumb: (img) ->
    thumb = document.createElement("li")
    #thumb.className = "span1"
    div = document.createElement('div')
    div.className = "thumbnail"
    thumb.appendChild(div)
    canvas = document.createElement("canvas")
    canvas.id = "" + @get('id')
    ctx = canvas.getContext("2d")
    #set splice values      
    d = img.height * 0.8
    d = img.width  if img.width < img.height
    w = d
    h = d
    divSize = 75
    sx = parseInt((img.width - w) / 2)
    sy = parseInt((img.height - h) / 2)
    canvas.height = divSize
    canvas.width = divSize
    ctx.drawImage(img, sx, sy, w, h, 0, 0, divSize, divSize)
    div.appendChild(canvas)
    @set('thumb', thumb)
    return thumb

  createCanvas : (img, map) ->
    return null unless map.width() and map.height()

    canvas = document.createElement("canvas")
    canvas.setAttribute('class', 'photo')
    canvas.setAttribute('id', "canvas_#{@get('id')}")
    ctx = canvas.getContext("2d")
    #set splice values
    canvas.height =  map.outerHeight()
    canvas.width = map.outerWidth()
    
    #Use full width and adjust the height
    #normally will crop the top and bottom
    scale = canvas.width / img.width
    
    if img.height > img.width
      #unless image is portrait, then use full height and adjust width
      #will normaly give white space on edges
      scale = canvas.height / img.height
          
    h = parseInt(canvas.height / scale)
    w = parseInt(canvas.width / scale)
    sx = parseInt((img.width - w) / 2)
    sy = parseInt((img.height - h) / 2)
    dx = 0
    dy = 0
    cw = canvas.width
    ch = canvas.height
    if sx < 0
      sx = 0
      w = img.width
      cw = w * scale
      dx = parseInt((canvas.width-cw)/2)
    if sy < 0
      sy = 0
      h = img.height
      ch = h * scale
      dy = parseInt((canvas.height-ch)/2)
    #console.log("h: #{h}, w: #{w}, sx: #{sx}, sy: #{sy}, dx: #{dx}, dy: #{dy}, canvas.w: #{cw}, canvas.h: #{ch}")
    ctx.drawImage(img, sx, sy, w, h, dx, dy, cw, ch)
    #console.log "Canvas: ", canvas
    @set('canvas', canvas) 
    return canvas

  set_image : (src)->
    # only need to do this once
    return if @.get('img')?

    if !@.get('isLoaded')
      @set('ready' , true)
      return null

    source = src or @get('file')
    img = new Image()
    img.pic = @
    img.onload = ->
      # this refers to 'img'
      @pic.createThumb(@)
      return null
    img.src = "assets/" + source  #Loads image from source
    @set('img', img)
)

App.Icons = Em.Object.extend
    hiking : {name : "Hiking",    file : "hiking.png"}
    boat   : {name : "Boat",      file : "boat.png"  }
    nature : {name : "Nature",    file : "nature.png"}
    winter : {name : "Winter",    file : "winter.png"}
    spring : {name : "Spring",    file : "spring.png"}
    summer : {name : "Summer",    file : "summer.png"}
    autumn : {name : "Autumn",    file : "autumn.png"}