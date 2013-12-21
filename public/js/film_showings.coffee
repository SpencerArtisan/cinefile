'use strict'

angular.module("app").controller "FilmShowingsController", ["$scope", "$routeParams", "$resource", "$location",
  (scope, routeParams, resource, location) ->
    scope.showings = []

    scope.loadFilm = ->
      success = (response) ->
        console.log("film succeeded with showings #{response.showings}")
        scope.showings = response.showings
        
      failure = (response) ->
        console.log("film failed with " + response.status)
          
      resource("/films/#{routeParams.id}").get(success, failure)
]

