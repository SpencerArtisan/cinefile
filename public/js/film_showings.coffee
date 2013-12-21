'use strict'

angular.module("app").controller "FilmShowingsController", ["$scope", "$routeParams", "$resource", "$location",
  (scope, routeParams, resource, location) ->
    scope.showings = []

    scope.loadFilm = ->
      success = (response) ->
        console.log("film succeeded with showings")
        console.log response.showings
        scope.showings = response.showings
        scope.film = response
        
      failure = (response) ->
        console.log("film failed with " + response.status)
          
      resource("/films/#{routeParams.id}").get(success, failure)

    scope.when_formatted = (showing) ->
      moment(showing.day_on).format('ddd Do MMM')
]

