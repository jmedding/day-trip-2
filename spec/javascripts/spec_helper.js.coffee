//= require base_data
//= require set_testing
//= require application

#App.deferReadiness()

App.Router.reopen({location: 'none'})
Konacha.reset = Ember.K;


before ->
  console.log "begin before"
 

beforeEach ->
  console.log "begin beforeEach - helper"
  Em.run -> App.advanceReadiness()
  #App.router.transitionTo('') #doesn't work, no App.router
  #don't need to reset the store because it doesn't change
  # Em.run -> 
  #   App.store.destroy() if App.store
  #   App.store = DS.Store.create()

afterEach ->
  console.log "begin afterEach - helper"

App.injectTestHelpers()
find = window.find
visit = window.visit



window.waitUntilFound = (element) -> 
  window.waitfor = (deferred, element, time) -> 
    time ?= 0
    # console.log "finding ", element, time
    found = $.find(element)
    if found.length > 0
      # console.log "found ", found
      deferred.resolve(found)
      return
    else
      if time < 1500
        t = 10
        setTimeout((->waitfor(deferred, element, time+t)), t)
        return null
      else
        console.log "giving up ", time
        deferred.resolve(null)
        return null

  deferred = $.Deferred()
  # console.log "try to find ", element
  waitfor(deferred, element, 0)
  return deferred.promise()
