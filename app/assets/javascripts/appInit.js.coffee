#App.icons = App.Icons.create()

#App.user = App.User.create()
App.locateUser = (user) ->
  map_zoom = 9;
  visitor_lat;
  visitor_lon;
  console.log(document.cookie)
  #console.log(Utils.get_cookie("visitor_lat"))
  #lets see if this user has previousely saved thier location
  #visitor_lat = parseFloat(Utils.get_cookie("visitor_lat"));
  #visitor_lon = parseFloat(Utils.get_cookie("visitor_lon"));
  if (isNaN(visitor_lat) || isNaN (visitor_lon))
    #no cookies found so try to find the location
    console.log("trying geoplugin")
    try
      if (geoplugin_countryCode().indexOf('CH') == -1)
        throw("You aren't in Switzerland yet(#{geoplugin_countryCode()})")
      
      console.log(geoplugin_city())
      console.log("trying geoplugin")
      visitor_lat = geoplugin_latitude()
      visitor_lon = geoplugin_longitude()
      console.log(visitor_lat)
      console.log(visitor_lon)
      
    catch e
      #Not in Switzerland or geoplugin not working
      console.log(e)
      #use a location in the center of Switzerland
      visitor_lat = 46.8
      visitor_lon = 8.26
      map_zoom =7

    finally
      home = new google.maps.LatLng(visitor_lat, visitor_lon)
      user.set('home', home)
      return  map_zoom

App.mapInitialize = (map_zoom, wait_time) ->
  console.log "intitializing map"
  try
    unless (document.getElementById("map_canvas"))
      throw("waiting for ember to insert map element")
    console.log App.user.home.lat(), App.user.home.lng()
    if (isNaN(App.user.home.lat()) || isNaN(App.user.home.lng()))
      throw("visitor location not defined yet - waiting")

  catch e
    console.log("caught error: " + e)
    if (e.toString().indexOf("waiting") != -1)
      wait_time ?= 100
      wait_time *= 2
      console.log(wait_time)
      setTimeout("App.mapInitialize( #{map_zoom}, #{wait_time})", wait_time)      
    return null
    
  console.log "a"
  myOptions = 
    center: App.user.home
    zoom: map_zoom
    mapTypeId: google.maps.MapTypeId.ROADMAP
  
  console.log "b"
  map = new google.maps.Map(document.getElementById("map"), myOptions)
  console.log "c"
  App.user.set_home(map)
  console.log "d", map
  Em.run -> App.set( 'page_map', map)
  console.log "g"

    
      