'use strict'

angular.module("app").controller "FilmReviewController", ["$scope", "$routeParams", "$resource", "$location",
  (scope, routeParams, resource, location) ->
    scope.loadFilm = ->
      success = (response) ->
        console.log("film succeeded with " + response.films)
        scope.film = response
        rottentomatoes = "<object data='#{scope.film.link}' type='text/html' style='margin-top:-155px' width='100%' height='3000px'>"
        $('#content').append(rottentomatoes)
        
      failure = (response) ->
        console.log("film failed with " + response.status)
          
      resource("/films/#{routeParams.id}").get(success, failure)
]

