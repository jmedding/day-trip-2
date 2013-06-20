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
  
  activity_clicked: (activity) ->
    @transitionToRoute('activity_detail', activity)

  set_markers : (->
    if App.page_map
      @forEach( ((activity, index, array) ->
        activity.set_marker(App.page_map, @)), @)
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
  categoriesBinding: 'controllers.query.attributes'

  filterActivities : ->
    # reset this.content based on query panel settings
    filtered =  @get('allActivities').filter(((activity)-> 
      if activity.get('distance_to_home') < @get('distance')
        true
      else 
        false
      ), @)
    filtered = filtered.filter(@check_season, @).filter(@check_category, @)
    @set('content', filtered)
    

  triggerFilterActivities: (->  
    @filterActivities()
    ).observes('distance', 'home', 'map', 'seasons.#each.val', 'categories.#each.val')

  compare_activities: (a,b) ->
      result = 0
      if App.user.home?
        result =  a.get('distance_to_home') - b.get('distance_to_home')
      return result 

  check_season: (activity) ->
    #show anything that meets any of the selected items
    for season in @seasons
      if season.val
        key = season.label.toLowerCase()
        return true if activity.get('seasons').someProperty('id', key)
    return false  

  check_category: (activity) ->
    # remove any activitiy that includes an unselected category
    for category in @categories
      if !category.val
        key = category.label.toLowerCase()
        return false if activity.get('categories').someProperty('id', key)
    return true
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
  attributes: (-> [ @hiking, @nature, @boat ]).property('hiking.val', 'nature.val', 'boat.val').cacheable()
  
  distance: (-> @distances[@distance_index]).property('distance_index')
  
  set_distance: (increment) ->
    temp = @distance_index + increment
    @set('distance_index', temp) if temp >= 0 and temp < @distances.length
  
  increment_distance: -> @set_distance(1)
  decrement_distance: -> @set_distance(-1)
)  

App.MapController = Em.Controller.extend(
  needs: ['activities']

  activityBinding:      'controllers.activities.selectedActivity'
  activeMarker:         null
  
  activityChanged : (->
    return null unless App.page_map?
    if(!@activity?)
        if (@activeMarker?)
          @activeMarker.setAnimation(null)
          @activeMarker = null
        
    else
        if (@activeMarker)
          @get('activeMarker').setAnimation(null)       
        if @activity.marker?
          @set('activeMarker', @get('activity').get('marker'))
          @activeMarker.setAnimation(google.maps.Animation.BOUNCE)
        return  
  ).observes('activity')

  
)   

App.ThumbsController = Ember.ArrayController.extend(
  # this should probably be refactored to use a 
  # ThumbView for each thumbnail.  Then, all of the 
  # Adding and removal would be managed by ember.
  # The mouseover/out actions could be defined in the view
  # or maybe even controller. The only trick is how to 
  # display the cpic.get('canvas')s for thumb. Worst case would be to 
  # append it with didInsertElement.

  # Problem: different screen sizes will have different Map widths.
  # This means that setting the picture canvas one time won't work.
  # Solution: Before rendering the pic, check that the canvas size
  # matches the map div size. If canvas is null or different size, 
  # the set it.

  displayPhoto: (pic) ->
        return ->
          map = $('#map')
          canvas = pic.get('canvas') 
          if !canvas? or map.width() != canvas.width or map.height() != canvas.height
            canvas = pic.createCanvas(pic.get('img'), map)
          if map? and canvas?
              map.append(canvas)
          else
              null
    
    removePhoto : () ->
        map = $('#map')
        return ->
            if map? 
                $('canvas.photo').detach()
            else
                null

)