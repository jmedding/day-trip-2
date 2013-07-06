App.User = Em.Object.extend(
    home : null
    marker : null
    set_home: (map) ->
      if @marker is null
        console.log "e"
        marker = new google.maps.Marker(
            position: @home
            title: "My Location (click and drag to move)"
            map : map
            draggable: true
            icon: '/assets/home2.png'
        )
        
        console.log "f"
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





App.Icons = Em.Object.extend
    hiking : {name : "Hiking",    file : "hiking.png"}
    boat   : {name : "Boat",      file : "boat.png"  }
    nature : {name : "Nature",    file : "nature.png"}
    winter : {name : "Winter",    file : "winter.png"}
    spring : {name : "Spring",    file : "spring.png"}
    summer : {name : "Summer",    file : "summer.png"}
    autumn : {name : "Autumn",    file : "autumn.png"}