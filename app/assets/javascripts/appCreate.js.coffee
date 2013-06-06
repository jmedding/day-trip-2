@App = Ember.Application.create({
  LOG_TRANSITIONS : true
  page_map : null

  ready : ->
    if google?
      mz = @locateUser()
      @mapInitialize(mz) 
    
    console.log "Ember is up and running"

    return null
});