App.Activity.FIXTURES =  [
  {
      "id": "1"                             
      "name": "Hiking at Schatzalp", "location": "Davos", "canton": "Graubunden", "lat": "46.9", "lon": "9.77"
      "seasons": ['summer', 'autumn']      
      "categories": ['hiking', 'nature']
      "info": {"Address" : "Obere Strasse 28", "Region" : "7270 Davos Platz", "Telephone" : "Tel. +41 (0)81 415 52 80"}
      "Website":"http://www.schatzalp.ch/p.cfm?s=15&lan=1&pf=1"
      "description":"Take the funicular up to **Schatzalp** and enjoy relaxed hiking through alpine gardens or more strenuous routes that explore the mountains' higher slopes.  Enjoy lunch at several restaurants at or a few minutes walk from the top of the lift.  There is an alpine slide that's fun enough for the big kids, but safe enough even for relatively young children to enjoy."
      "pics":["davos/davos_1", "davos/davos_2", "davos/davos_3", "davos/davos_4"]      
  }
  {
      "id": "2"
      "name": "Sledding in Regensberg", "location": "Regensberg", "canton": "Zurich", "lat": "47.48", "lon": "8.43"
      "seasons" : ['winter']
      "categories" : ['nature']
      "info" : {"Region" : "8429 Regensberg"}
      "description":"Thanks to its elevation, Regensburg typically has more snow than the surrounging areas and the fields just south of the town are always a favorite for **sledding in the Zurich or Baden** area.  There is free parking and even a ski lift that runs when the snow is deep enough."
      "pics":["regensberg/regensberg_1", "regensberg/regensberg_2", "regensberg/regensberg_3",]                           
  }
]

App.Season.FIXTURES = [
  {
    id : 'summer'
    name : 'Summer'
    file : 'summar.png'
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
