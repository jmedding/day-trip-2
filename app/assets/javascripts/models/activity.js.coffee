App.Icon = DS.Model.extend(
  activities: DS.hasMany('App.Activity')
  name : DS.attr('string')
  file : DS.attr('string')

  path : ( ->
    "/assets/icons/#{@get('file')}"
  ).property('file')
)

App.Season    = App.Icon.extend()
App.Category  = App.Icon.extend()
 
App.Activity = DS.Model.extend(
    seasons : DS.hasMany 'App.Season'
    categories : DS.hasMany 'App.Category'
    pictures : DS.hasMany 'App.Picture'

    name : DS.attr('string')
    info : DS.attr('string')
    location : DS.attr('string')
    canton : DS.attr('string')
    address : DS.attr('string')
    region : DS.attr('string')
    telephone : DS.attr('string')
    website : DS.attr('string')
    description : DS.attr('string')

    lat : DS.attr('number')
    lon : DS.attr('number')

    
    #must set lat,lon when creating object...
    pics : []     #an array of image objects
    thumbs : []   #divs for displaying the thumb
    photos: []    #canvas for displaying the full photo
    marker : null
    highlighted : false
    homeBinding : 'App.user.home'

    icons : (-> 
      result = new Em.A
      for icon in @get('seasons')
        result.pushObject(icon)
      for icon in @get('categories')
        result.pushObject(icon)
      console.log 'icons', result
      result
    ).property('seasons', 'categories')
    
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
    ctx.drawImage(img, sx, sy, w, h, dx, dy, cw, ch)
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
    img.src = "/assets/" + source  #Loads image from source
    @set('img', img)
)