App.IndexRoute = Ember.Route.extend(
  redirect : -> @transitionTo 'activities'
)
App.ActivitiesRoute = Ember.Route.extend(
  model : ->
    App.Activity.find()
    
)

App.ActivitiesIndexRoute = Ember.Route.extend(
  model : ->
    this.modelFor 'activities'

  # setupController : (controller, model) ->
  #   controller.set('content', model)
  #   return null

  renderTemplate: ->
    @render(  'activities_table', 
      into:   'activities'
      outlet: 'main'
      controller: 'activities_index'
    )
    @render( 'query',
      into: 'activities'
      outlet: 'query'
      controller: 'query'
    )


)

App.ActivityDetailRoute = Ember.Route.extend(
  model : (params) ->
    # this function will only be called if 
    # we enter app directly at the activity_detial route
    # it is not called when using the #linkTo helper
    m = App.Activity.find(params.activity_id)
    console.log m
    @controllerFor('activities').add_to_selected(m)
    # @controllerFor('activity').activity_clicked(m)
    return m

  setupController : (controller, model) ->
    controller.set('content', model)
    return null

  renderTemplate: ->

    @render(  'activity_detail', 
      into:   'activities'
      outlet: 'main'
      controller: 'activity_detail'
    )
)