App.ActivitiesController = Ember.ArrayController.extend(
  itemController: 'activity'
)

App.ActivityController = Ember.ObjectController.extend(
  
  set_active: (evt, activity) ->
    App.navbarController.activity_clicked(activity)  
    # this.get('target') returns the current route
    this.get('target').transitionToRoute('activity_detail', activity)
    return null


)

App.ActivityDetailController = Ember.ObjectController.extend(

)

App.NavbarController = Ember.ArrayController.extend(

  activity_clicked: (activity) -> 
    console.log @content.length
    @content.pushObject(activity) if @content.indexOf(activity) < 0
    console.log @content.length
    @set('selectedActivity', activity)
    for act in @content 
      console.log act
)

App.NavItemController = Ember.ObjectController.extend(

)

