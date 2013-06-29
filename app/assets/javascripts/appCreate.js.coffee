createApp = ->
  Ember.Application.create({
    LOG_TRANSITIONS : true
    page_map : null
    googleAPI : "AIzaSyB85CMctwd2XSVRPBG-IBZEFLSaaMTMmq4"

    ready : ->
      @set('icons', @Icons.create())
      @set('user', App.User.create())

      if google?
        mapZoom = @locateUser(@get('user'))
        App.mapInitialize(mapZoom) 
    
      console.log "Ember is up and running"
      return null
  })


if window.testing #set window.testing = true prior to running tests
  Em.testing = true
  Em.run -> 
    window.App = createApp()
    App.deferReadiness()
else
  window.App = createApp()

# @appendTo = (approot) -> 
#   return $(approot).append('<div class="test">Hello</div>')