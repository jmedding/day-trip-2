App.Router.map ->
  this.resource('activities', {path : ""}, ->
    this.route('index', {path : ""})
    this.resource('activity_detail', {path : ":activity_id"})
  )