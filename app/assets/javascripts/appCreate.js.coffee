@App = Ember.Application.create({
  LOG_TRANSITIONS : true

  ready : ->
    console.log ("Ember is up and running")
    return null
});