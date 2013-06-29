window.google =
  maps :
    LatLng : (lat, lon) -> 
      lat: -> lat
      lng: -> lon
    MapTypeId :
      ROADMAP: "roadmap"
    Map : class Map
      constructor : (element, options) ->
        @element = element
    Marker : class Marker
      constructor : (params) ->
        for key, value of params
          @[key] = value
        return @
      setAnimation : (status) -> 
        
    event : 
      addListener : (marker, eventType, callback) -> null
    Animation : 
      BOUNCE : 1

window.geoplugin_countryCode = -> "CH"
window.geoplugin_city = -> "Baden"
window.geoplugin_latitude = -> 47.47
window.geoplugin_longitude = -> 8.32
