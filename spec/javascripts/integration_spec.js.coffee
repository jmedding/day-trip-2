//= require spec_helper

describe 'Main Page', ->
  beforeEach ->    
    
  afterEach ->    
    #App.reset() #reset is used mainly for integration testing


  it 'should load the application', ->
    assert.ok(find('#map').length)

  it 'should show the regensberg activity in the table', (mochaDone)->
    $.when(waitUntilFound('#list-item-2')).done((result) ->
      mochaDone()
    )

  it 'should show all activities if the range is increased', (mochaDone)->
    Em.run -> $.find('#search-far')[0].click()  
    Em.run -> $.find('#search-far')[0].click()  
    $.when(waitUntilFound('#list-item-1')).done((result) ->
      assert.ok(result, "schatzalp activit not found after increase range")
      mochaDone()
    )

describe 'Activity Details Page', ->
  beforeEach ->    
    
  afterEach ->

  it 'it shows that activity if its table element is clicked', (mochaDone)->
    t = null
    $.when(waitUntilFound('#list-item-2')).then((result)->
      assert.ok(result, "regensberg activity table item")
      regensberg = result[0]
      t = Date.now()
      Em.run => regensberg.click()
      return waitUntilFound('div.thumbnail')
    ).done((result) -> 
      assert.ok(result, "no thumbnails were found")
      assert.equal(result.length, 3, "Not all thumbnails were found")
      Em.run -> 
        details = $('.row').find('.span7').find('.well').html()
        assert.include(details, "Activity Detail", "Activity Detail not displayed")
      mochaDone()
    )

  it 'shows a quick link for the activity', ->
    Em.run -> 
      quickLink = $.find("ul.nav li a:contains('Regensberg')")
      assert.equal(quickLink.length, 1, "Regensberg quickLink not found")

  it 'continues to display the quickLink of a visited activity', ->
    Em.run -> visit('/')
    Em.run -> 
      quickLink = $.find("ul.nav li a:contains('Regensberg')")
      assert.equal(quickLink.length, 1, "Regensberg quickLink not found")

  it 'shows quickLinks for all visited activities', ->
    Em.run -> $.find('#list-item-1')[0].click()
    s_quickLink = $.find("ul.nav li a:contains('Schatzalp')")
    assert.equal(s_quickLink.length, 1, "Schatzalp quickLink not found")
    r_quickLink = $.find("ul.nav li a:contains('Regensberg')")
    assert.equal(r_quickLink.length, 1, "Regensberg quickLink not found")

  it 'has the right number of thumbs for Schatzalp', (mochaDone) ->
    $.when(waitUntilFound('div.thumbnail')).done((result) -> 
      assert.ok(result, "did not find any thumbs for Schatzalp")
      assert.equal(result.length, 4, "did not find the right number of thumbs for Schatzalp")    
      mochaDone()
    )
  it 'updates the thumbs when switching directly to another activity detail view', () ->
    #starting in Schatzalp detail view
    r_quickLink = $.find("ul.nav li a:contains('Regensberg')")
    assert.equal(r_quickLink.length, 1, "Regensberg quickLink not found")
    Em.run -> r_quickLink[0].click()    
    details = $('.row').find('.span7').find('.well').html()
    assert.include(details, "Regensberg", "Activity Detail did not change to Regensberg")
    thumbs = $.find('div.thumbnail')
    assert.equal(thumbs.length, 3, "did not properly update thumbnails")
  

  # it 'it has two quick links if the second activity is clicked', (mochaDone)->
  #   t = null
  #   $.when(waitUntilFound('#list-item-2')).then((result)->
  #     assert.ok(result, "regensberg activity table item")
  #     regensberg = result[0]
  #     t = Date.now()
  #     Em.run => regensberg.click()
  #     return waitUntilFound('div.thumbnail')

  #   ).then((result) ->
  #     console.log result, Date.now() - t
  #     assert.equal(result.length, 3, "find the three regensberg thumbs")
  #     home = $.find('a.brand')[0]
  #     assert.ok(home, "didn't find the link")
  #     Em.run -> visit('/')
  #     return waitUntilFound('#list-item-2')

  #   ).done( (result) ->
  #     assert.ok(result, "regensberg activity table item")
  #     mochaDone()
  #   )
