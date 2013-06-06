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

  add_to_selected: (activity) ->
    #can remove this once all incoming calls are moved to activitiesCTRL
    @activitiesCTRLR.add_to_selected(activity)
)

App.ActivityController = Ember.ObjectController.extend(
  needs: ['activities']

  activity_clicked: (evt, activity) ->
    console.log @content
    @get('controllers').get('activities').add_to_selected(activity)
    # this.get('target') returns the current route
    # this.get('target').transitionTo('activity_detail', activity)
    @transitionToRoute('activity_detail', activity)
    return null

)


App.ActivityDetailController = Ember.ObjectController.extend(

)

App.NavbarController = Ember.ArrayController.extend(

  activity_clicked: (activity) -> 
    @content.pushObject(activity) if @content.indexOf(activity) < 0
    @set('selectedActivity', activity)
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
    
  seasons:    (-> [ @winter, @spring, @summer, @autumn ]).property('winter', 'spring', 'summer', 'autumn').cacheable()
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
    return null unless App.page_map?
    console.log 'page_map exists!'
    if(!@activity?)
        if (@activeMarker?)
          @activeMarker.setAnimation(null)
          @activeMarker = null
        
    else
        if (@activeMarker)
          @activeMarker.setAnimation(null)       
        if @activity.marker?
            @activeMarker = @activity.marker
            @activeMarker.setAnimation(google.maps.Animation.BOUNCE)
        return  
  ).observes('activity')

  
)   

