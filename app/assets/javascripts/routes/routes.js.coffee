App.IndexRoute = Ember.Route.extend(
  redirect : -> @transitionTo 'activities'
)

App.ActivitiesRoute = Ember.Route.extend(
  model : ->
    App.Activity.find()

  setupController : (controller, model) ->
    controller.set('content', model)
    return null

  renderTemplate: ->
    @render(  'activities', 
      into:   'application'
      outlet: 'main'
      controller: 'activities'
    )
    @render(  'navbar', 
      into:   'application'
      outlet: 'navbar'
    )

)

App.ActivityDetailRoute = Ember.Route.extend(
  model : (params) ->
    # this function will only be called if 
    # we enter app directly at the activity_detial route
    # it is not called when using the #linkTo helper

    m = App.Activity.find(params.activity_id)
    App.navbarController.activity_clicked(m)
    console.log "Model", m
    return m

  setupController : (controller, model) ->
    controller.set('content', model)
    return null

  renderTemplate: ->

    @render(  'activity_detail', 
      into:   'application'
      outlet: 'main'
      controller: 'activity_detail'
    )
)