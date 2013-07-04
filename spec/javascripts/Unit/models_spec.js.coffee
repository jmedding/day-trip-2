//=require application

describe 'Activity', ->
  it "should calculate the distance from the user's home", ->
    a = App.Activity.createRecord(
      lat: 100
      lon: 100
      home:
        lat: -> 110
        lng: -> 110
    )

    a.get('lat').should.equal 100
    a.get('home').lng().should.equal 110 
    a.get('distance_to_home').should.equal 1144