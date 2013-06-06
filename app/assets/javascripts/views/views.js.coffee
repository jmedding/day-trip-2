App.NavbarView = Ember.View.extend(
  templateName: 'navbar'
  activitiesBinding: 'App.navbarController'
)

App.ActivityView = Em.View.extend(
    templateName: 'activity'
    tagName : 'td'
    classNames: ['rrounded']
    classNameBindings: ['highlighted','style']
    style: 'activity'
    highlightedBinding: 'this.activity.highlighted'
    distanceBinding: 'this.activity.distance_to_home'
    
    # didInsertElement : ->
    #   activity = @get('controller').get('model')
    #   console.log "Inserting activity", @get('controller').get('model')
    #   console.log App.page_map, App.page_map? 
    #   activity.set_marker(App.page_map) if App.page_map?

    click : (evt) -> 
      #following line gets controller and then the activity 
      console.log 'zero', @get('controller')
      console.log 'first', @get('model')
      console.log 'second', @get('controller').get('content')
      activity = @get('controller').get('content')
      console.log "third", activity
      # set_active will transition to activity_detail route
      @get('controller').activity_clicked(evt, activity)

      return null

)

App.ActivityDetialView = Ember.View.extend(
  templateName : 'activity_detail'

)

App.QueryPanelView = Em.View.extend(
  templateName: 'query-panel'
  classNames: ['query rounded shadow']
  distanceBinding:'App.queryPanelController.distance'
  seasonsBinding: 'App.queryPanelController.seasons'
  attributesBinding: 'App.queryPanelController.attributes'
  
  increment_distance: ->
    App.queryPanelController.set_distance(1)
    return null
  decrement_distance: ->
    App.queryPanelController.set_distance(-1)
    return null
  
)

App.MapView = Em.View.extend(
  templateName: 'map'
  classNames: ['map rounded shadow']

      

)