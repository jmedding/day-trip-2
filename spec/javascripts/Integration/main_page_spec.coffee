//= require spec_helper

describe 'Main Page', ->
  beforeEach ->    
    
  afterEach ->    
    #App.reset() #reset is used mainly for integration testing


  it 'should load the application', ->
    assert.ok(find('#map').length)

  it 'should show the regensberg activity in the table', (mochaDone)->
    Em.run -> 
      waitUntilFound('#list-item-2').then((result) ->
        mochaDone()
      )

  it 'should show all activities if the range is increased', (mochaDone)->
    Em.run -> $.find('#search-far')[0].click()  
    Em.run -> $.find('#search-far')[0].click()  
    Em.run -> 
      waitUntilFound('#list-item-1').then((result) ->
        assert.ok(result, "schatzalp activit not found after increase range")
        mochaDone()
      )  

