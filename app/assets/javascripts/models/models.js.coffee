App.User = Em.Object.extend(
    home : null
    marker : null
    set_home: (homeLocation, map) ->
      @set('home', homeLocation)
      if @marker is null
        marker = new google.maps.Marker(
            position: homeLocation
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
 
App.Activity = DS.Model.extend(
    name : DS.attr('string')
    #must set lat,lon when creating object...
    pics : []     #an array of image objects
    thumbs : []   #divs for displaying the thumb
    photos: []    #canvas for displaying the full photo
    marker : null
    highlighted : false
    homeBinding : 'App.user.home'
    distance_to_home: 1
    
    url_name : (->
        return @name.toLowerCase().replace(/(\s)/g, "-")
    ).property()
    
    elementId : (->
      "list-item-" + @get('id');
      ).property()

    set_distance_to_home: (->
      toRad = (value) ->
          # Converts numeric degrees to radians
          value * Math.PI / 180
        
      if @lat is null or @lon is null 
        #error condition...
        return -1
        
      d = null
      if @home?
        lat1 = this.lat
        lon1 = this.lon
        lat2 = this.home.lat()
        lon2 = this.home.lng()
        R = 6371                # km
        dLat = toRad(lat2-lat1)
        dLon = toRad(lon2-lon1)
        lat1r = toRad(lat1)
        lat2r = toRad(lat2)
        
        a = Math.sin(dLat/2) * Math.sin(dLat/2) + Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1r) * Math.cos(lat2r)
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
        d = R * c
        @set('distance_to_home',parseInt(d))
      return null
    ).observes('home')
        
    set_marker: (map) -> 
      try
        marker = new google.maps.Marker({
                      position : new google.maps.LatLng(@get('lat'), @get('lon')),
                      title : @get('name'),
                      map : map
                    })
        marker.activity = this
        
        google.maps.event.addListener(marker, 'mouseover', -> marker.activity.set('highlighted', true))
        
        google.maps.event.addListener(marker, 'mouseout', -> marker.activity.set('highlighted', false))
        
        google.maps.event.addListener(marker, 'click', -> App.navController.activity_clicked(marker.activity))
        
        @set('marker', marker)
      catch e
        console.log ("Goodle Map Marker Creation failed")
      return marker
    
    createThumb: (img, i) ->
      #create thumb elements
      thumb = document.createElement("div")
      thumb.className = "thumb thumbShadow rounded"
      canvas = document.createElement("canvas")
      canvas.id = "" + this.id + "_" + i
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
      thumb.appendChild(canvas)
      return thumb

    
    createCanvas : (img, map) ->
      canvas = document.createElement("canvas")
      canvas.className = "photo"
      ctx = canvas.getContext("2d")
      #set splice values
      canvas.height =  map.height
      canvas.width = map.width
      
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
      return canvas

    
    
    set_images : (imageSrcs) ->
      #map div not loaded yet...
      map = 
        width : 420
        height : 240
      sources = imageSrcs or this.pics
      bucket = []
      tempThumbs = []
      tempCanvases = []
      i = 0
      for src, i in sources
        img = new Image()
        img.activity = @        
        img.onload = ->
            thumb = @activity.createThumb(@, i); #'this' refers to img
            canvas = @activity.createCanvas(@, map)
            tempThumbs.push(thumb)
            tempCanvases.push(canvas)
            return null
        img.src = "/assets/#{sources[i]}.jpg"   
        bucket.push(img)

      @pics = bucket
      @thumbs = tempThumbs
      @photos = tempCanvases
      return null
)

App.Icons = Em.Object.extend
    hiking : {name : "Hiking",    file : "hiking.png"}
    boat   : {name : "Boat",      file : "boat.png"  }
    nature : {name : "Nature",    file : "nature.png"}
    winter : {name : "Winter",    file : "winter.png"}
    spring : {name : "Spring",    file : "spring.png"}
    summer : {name : "Summer",    file : "summer.png"}
    autumn : {name : "Autumn",    file : "autumn.png"}