App.ActivitiesController = Ember.ArrayController.extend(
  #itemController : 'activity'
  test : "Test"
  selectedActivity : null
  selectedActivities : Ember.A([])
  mapBinding : 'App.page_map'

  add_to_selected: (activity) ->
    @set('selectedActivity', activity)
    if @get('selectedActivities').indexOf(activity) < 0
      @selectedActivities.pushObject(activity) 
   
  set_markers : (->
    if App.page_map
      @forEach (activity, index, array) ->
        activity.set_marker(App.page_map) 
  ).observes('content.isLoaded', 'map')
)


App.ActivitiesIndexController = Ember.ArrayController.extend(
  needs : ['activities', 'query']
  distanceBinding : 'controllers.query.distance'
  sortProperties : ['distance_to_home']
  sortAscending : true
  homeBinding : 'App.user.home'
  allActivitiesBinding : 'controllers.activities.content'
  mapBinding : 'App.page_map'
  seasonsBinding: 'controllers.query.seasons'

  filterActivities : ->
    console.log "filtering activities", @get('allActivities')
    # reset this.content based on query panel settings
    filtered =  @get('allActivities').filter(((activity)-> 
      console.log activity.get('distance_to_home'), @distance
      if activity.get('distance_to_home') < @get('distance')
        true
      else 
        false
      ), @)
    filtered = filtered.filter(@check_season, @)
    console.log filtered
    @set('content', filtered)
    

  triggerFilterActivities: (->  
    console.log 'time to filter!'
    @filterActivities()
    ).observes('distance', 'home', 'map', 'seasons.#each.val')

  compare_activities: (a,b) ->
      result = 0
      if App.user.home?
        result =  a.get('distance_to_home') - b.get('distance_to_home')
      return result 

  check_season: (activity) ->
    #show anything that meets any of the selected items
    for season in @seasons
      console.log season.label, season.val
      if season.val
        key = season.label.toLowerCase()
        console.log key, activity.get('seasons').someProperty('id', key)
        activity.get('seasons').forEach (item)-> console.log item.get('name')
        return true if activity.get('seasons').someProperty('id', key)
    return false  
)


App.ActivityController = Ember.ObjectController.extend(

  activity_clicked: (evt, activity) ->
    @transitionToRoute('activity_detail', activity)
    return null

)


App.ActivityDetailController = Ember.ObjectController.extend(

)


App.NavbarController = Ember.ArrayController.extend(

)

App.NavItemController = Ember.ObjectController.extend(

)

App.QueryController = Em.Controller.extend(
  distances: [5,10,15,25,50,100,250,500]
  distance_index: 4
  winter: { label: 'Winter', val:  true}
  spring: { label: 'Spring', val:  true}
  summer: { label: 'Summer', val:  true}
  autumn: { label: 'Autumn', val:  true}
  
  hiking: { label: 'Hiking', val:  true}
  nature: { label: 'Nature', val:  true}
  boat:   { label: 'Boat',   val:  true}
    
  seasons:    (-> [ @winter, @spring, @summer, @autumn ]).property('winter.val', 'spring.val', 'summer.val', 'autumn.val').cacheable()
  attributes: (-> [ @hiking, @nature, @boat ]).property('hiking', 'nature', 'boat').cacheable()
  
  distance: (-> @distances[@distance_index]).property('distance_index')
  
  set_distance: (increment) ->
    temp = @distance_index + increment
    @set('distance_index', temp) if temp >= 0 and temp < @distances.length
    return null
  
  increment_distance: ->
    @set_distance(1)
    return null
  
  decrement_distance: ->
    @set_distance(-1)
    return null
)  

App.MapController = Em.Controller.extend(
  needs: ['activities']

  activityBinding:      'controllers.activities.selectedActivity'
  activeMarker:         null
  
  activityChanged : (->
    console.log "a"
    return null unless App.page_map?
    console.log 'page_map exists!'
    if(!@activity?)
        if (@activeMarker?)
          @activeMarker.setAnimation(null)
          @activeMarker = null
        
    else
        console.log "activityfound"
        if (@activeMarker)
          @get('activeMarker').setAnimation(null)       
        if @activity.marker?
          @set('activeMarker', @get('activity').get('marker'))
          @activeMarker.setAnimation(google.maps.Animation.BOUNCE)
        return  
  ).observes('activity')

  
)   

