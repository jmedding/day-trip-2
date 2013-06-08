@App = Ember.Application.create({
  LOG_TRANSITIONS : true
  page_map : null

  ready : ->
    if google?
      mapZoom = @locateUser()
      @mapInitialize(mapZoom) 
    
    console.log "Ember is up and running"

    return null
});