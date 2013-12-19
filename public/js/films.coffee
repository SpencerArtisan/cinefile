'use strict'

angular.module("app").controller "FilmsController", ["$scope", "$resource", "$location",
  (scope, resource, location) ->
    scope.loadFilms = ->
      scope.films = []

      success = (response) ->
        console.log("films succeeded with " + response.films)
        scope.films = response.films
        
      failure = (response) ->
        console.log("films failed with " + response.status)
          
      resource('/films').get(success, failure)

    scope.when_formatted = (showing) ->
      moment(showing.day_on).format('ddd Do MMM')

    scope.showFilm = (id) ->
      location.path("/films/#{id}")

    scope.link = (film) ->
      encodeURIComponent(film.link)
]
