'use strict'

console.log "Initializing Angular Controllers"

controllers = angular.module("app")
#controllers = angular.module("app.controllers")

controllers.controller "FilmsController", ["$scope", "$resource",
  (scope, resource) ->
    scope.loadFilms = ->
      scope.films = []

      success = (response) ->
        console.log("films succeeded with " + response.films)
        scope.films = response.films
        
      failure = (response) ->
        console.log("films failed with " + response.status)
          
      resource('/films').get(success, failure)
]
