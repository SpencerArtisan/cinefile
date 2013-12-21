'use strict'

angular.module("app").controller "FilmController", ["$scope", "$routeParams", "$resource", "$location",
  (scope, routeParams, resource, location) ->
    scope.loadFilm = ->
      success = (response) ->
        console.log("film succeeded")
        scope.film = response
        
      failure = (response) ->
        console.log("film failed with " + response.status)
          
      resource("/films/#{routeParams.id}").get(success, failure)

    scope.when_formatted = (showing) ->
      moment(showing.day_on).format('ddd Do MMM')
]
