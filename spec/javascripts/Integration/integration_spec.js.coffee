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

describe 'Activity Details Page', ->
  beforeEach ->    
    
  afterEach ->

  it 'it shows that activity if its table element is clicked', (mochaDone)->
    # starting in activities index view
    t = null
    Em.run -> 
      waitUntilFound('#list-item-2').then((result)->
        assert.ok(result, "regensberg activity table item")
        regensberg = result[0]
        t = Date.now()
        Em.run => regensberg.click()
        Em.run -> waitUntilFound('div.thumbnail')
      ).then((result) -> 
        assert.ok(result, "no thumbnails were found")
        assert.equal(result.length, 3, "Not all thumbnails were found")
        Em.run -> 
          details = $('.row').find('.span7').find('.well').html()
          assert.include(details, "Regensberg", "Activity Detail not displayed")
        mochaDone()
      )

  it 'shows a quick link for the activity', ->
    # starting in Regensber activity detials view
    Em.run -> 
      quickLink = $.find("ul.nav li a:contains('Regensberg')")
      assert.equal(quickLink.length, 1, "Regensberg quickLink not found")

  it 'continues to display the quickLink of a visited activity', ->
    # starting in Regensber activity detials view
    Em.run -> visit('/')
    Em.run -> 
      quickLink = $.find("ul.nav li a:contains('Regensberg')")
      assert.equal(quickLink.length, 1, "Regensberg quickLink not found")

  it 'shows quickLinks for all visited activities', ->
    # starting in index view, with Regensberg quickling existing
    Em.run -> $.find('#list-item-1')[0].click()
    s_quickLink = $.find("ul.nav li a:contains('Schatzalp')")
    assert.equal(s_quickLink.length, 1, "Schatzalp quickLink not found")
    r_quickLink = $.find("ul.nav li a:contains('Regensberg')")
    assert.equal(r_quickLink.length, 1, "Regensberg quickLink not found")

  it 'has the right number of thumbs for Schatzalp', (mochaDone) ->
    # starting in Schatzalp details view
    Em.run -> 
      waitUntilFound('div.thumbnail').then((result) -> 
        assert.ok(result, "did not find any thumbs for Schatzalp")
        assert.equal(result.length, 4, "did not find the right number of thumbs for Schatzalp")    
        mochaDone()
      )

  it 'updates the thumbs when switching directly to another activity detail view', () ->
    # starting in Schatzalp detail view
    r_quickLink = $.find("ul.nav li a:contains('Regensberg')")
    assert.equal(r_quickLink.length, 1, "Regensberg quickLink not found")
    Em.run -> r_quickLink[0].click()    
    details = $('.row').find('.span7').find('.well').html()
    assert.include(details, "Regensberg", "Activity Detail did not change to Regensberg")
    thumbs = $.find('div.thumbnail')
    assert.equal(thumbs.length, 3, "did not properly update thumbnails")
