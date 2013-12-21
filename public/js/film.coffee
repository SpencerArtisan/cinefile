'use strict'

angular.module("app").controller "FilmController", ["$scope", "$routeParams", "$resource", "$location",
  (scope, routeParams, resource, location) ->
    scope.loadFilm = ->
      success = (response) ->
        console.log("film succeeded with " + response.films)
        scope.film = response
        
      failure = (response) ->
        console.log("film failed with " + response.status)
          
      resource("/films/#{routeParams.id}").get(success, failure)

    scope.when_formatted = (showing) ->
      moment(showing.day_on).format('ddd Do MMM')

    scope.back = (id) ->
      location.path("/")

    scope.init = ->
      rottentomatoes = "<object data='#{scope.link}' type='text/html' style='margin-top:-155px' width='100%' height='3000px'>"
      #rottentomatoes = "<iframe src='#{scope.link}' seamless='seamless' width='100%' height='100%'>"
      $('#content').append(rottentomatoes)
]
