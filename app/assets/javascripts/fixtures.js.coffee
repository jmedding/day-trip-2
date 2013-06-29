App.Activity.FIXTURES =  [
  {
      "id": "1"                             
      "name": "Hiking at Schatzalp", "location": "Davos", "canton": "Graubunden", "lat": "46.9", "lon": "9.77"
      "seasons": ['summer', 'autumn']      
      "categories": ['hiking', 'nature']
      "info": {"Address" : "Obere Strasse 28", "Region" : "7270 Davos Platz", "Telephone" : "Tel. +41 (0)81 415 52 80"}
      "website":"http://www.schatzalp.ch/p.cfm?s=15&lan=1&pf=1"
      "description":"Take the funicular up to **Schatzalp** and enjoy relaxed hiking through alpine gardens or more strenuous routes that explore the mountains' higher slopes.  Enjoy lunch at several restaurants at or a few minutes walk from the top of the lift.  There is an alpine slide that's fun enough for the big kids, but safe enough even for relatively young children to enjoy."
      "pictures":[4, 5, 6, 7]      
  }
  {
      "id": "2"
      "name": "Sledding in Regensberg", "location": "Regensberg", "canton": "Zurich", "lat": "47.48", "lon": "8.43"
      "seasons" : ['winter']
      "categories" : ['nature']
      "info" : {"Region" : "8429 Regensberg"}
      "description":"Thanks to its elevation, Regensburg typically has more snow than the surrounging areas and the fields just south of the town are always a favorite for **sledding in the Zurich or Baden** area.  There is free parking and even a ski lift that runs when the snow is deep enough."
      "pictures": [1, 2, 3]                           
  }
]

App.Picture.FIXTURES = [
  { id : 1,   file : "regensberg/regensberg_1.jpg" }
  { id : 2,   file : "regensberg/regensberg_2.jpg" }
  { id : 3,   file : "regensberg/regensberg_3.jpg" }
  { id : 4,   file : "davos/davos_1.jpg" }
  { id : 5,   file : "davos/davos_2.jpg" }
  { id : 6,   file : "davos/davos_3.jpg" }
  { id : 7,   file : "davos/davos_4.jpg" }
]

App.Category.FIXTURES = [
  {
    id : 'hiking'
    name : 'Hiking'
    file : 'hiking.png'
  }
  {
    id : 'nature'
    name : 'Nature'
    file : 'nature.png'
  }
  {
    id : 'boat'
    name : 'Boat'
    file : 'boat.png'
  }

]

App.Season.FIXTURES = [
  {
    id : 'summer'
    name : 'Summer'
    file : 'summer.png'
  }
  {
    id : 'autumn'
    name : 'Autumn'
    file: 'autumn.png'
  }
  {
    id : 'winter'
    name : 'Winter'
    file : 'windter.png'
  }
  {
    id : 'spring'
    name : 'Spring'
    file : 'spring.png'
  }
]
