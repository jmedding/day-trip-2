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
    
    click : (evt) -> 
      #following line gets controller and then the activity 
      console.log 'first', @get('content')
      console.log 'second', @get('content').get('content')
      activity = @get('content').get('content')
      console.log "third", activity
      # set_active will transition to activity_detail route
      @get('controller').set_active(evt, activity)

      return null

)

App.ActivityDetialView = Ember.View.extend(
  templateName : 'activity_detail'
  didInsertElement : ->
    App.navbarController.activity_clicked(content)
    console.log "didInsertElement"
)