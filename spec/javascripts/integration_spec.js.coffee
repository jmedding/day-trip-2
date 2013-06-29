//= require spec_helper

describe 'application', ->
  beforeEach ->
    console.log "begin beforeEach - integration_spec", Ember.testing
    Em.run -> App.advanceReadiness()
    
  afterEach ->
    
    #App.reset() #reset is used mainly for integration testing


  it 'should load the application', ->
    console.log "*** it should load..."
    #debugger
    assert.ok(find('#map').length)
    console.log "*** it should have loaded.."


  it 'should show the activite details view', (mochaDone)->
    console.log "*** it should load 2..."
    t = null
    
    $.when(waitUntilFound('#list-item-2')).then((result)->
      assert.ok(result, "regensberg activity table item")
      regensberg = result[0]
      t = Date.now()
      Em.run => regensberg.click()
      console.log "clicked regensberg"
      return waitUntilFound('div.thumbnail')
    ).then((result) ->
      console.log result, Date.now() - t
      assert.equal(result.length, 3, "find the three regensberg thumbs")
      home = $.find('a.brand')[0]
      assert.ok(home, "didn't find the link")
      Em.run => home.click()
      Em.run -> visit('/')
      console.log "*** it should have loaded2..", Date.now() - t
      return waitUntilFound('#list-item-2')
    ).done( (result) ->
      assert.ok(result, "regensberg activity table item")
      mochaDone()
    )
    # debugger

