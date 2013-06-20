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
      activity = @get('controller').get('content')     
      # will transition to activity_detail route
      @get('controller').activity_clicked(evt, activity)
      return null
)

App.ActivityDetialView = Ember.View.extend(
  templateName : 'activity_detail'

)

App.MapView = Em.View.extend(
  templateName: 'map'
  classNames: ['map rounded shadow']
)

App.ThumbsView = Em.View.extend(
  templateName: 'thumbs'
  picsBinding: 'controller.content'
  tagName: 'ul'
  classNames: ['thumbnails']

  remove_old_thumbs: (->
    node = @$()
    while node and node.firstChild
      node.removeChild(node.firstChild)
  ).observes('pics.@each')

  didInsertElement: -> 
    map = document.getElementById("map")
    map = $(map)
    console.log "map:", map.width()
    @show_thumbs()

  show_thumbs: (->
    node = @$()
    return unless node?

    @.get('pics').forEach(((pic) -> 
      thumb = pic.get('thumb')
      map = document.getElementById("map")
      map = $(map)
      controller = @get('controller')
      if thumb?
        console.log "map:", map.width() #, canvas.width
        thumb.onmouseout = controller.removePhoto()
        thumb.onmouseover = controller.displayPhoto(pic)
      node.append(pic.thumb)), @)
  ).observes('pics.@each.thumb')
)