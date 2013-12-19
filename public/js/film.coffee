'use strict'

angular.module("app").controller "FilmController", ["$scope", "$routeParams", "$resource", "$location",
  (scope, routeParams, resource, location) ->
    scope.link = routeParams.link
    console.log scope.link
    scope.back = (id) ->
      location.path("/")
    scope.init = ->
      #rottentomatoes = "<object data='#{scope.link}' type='text/html' width='100%' height='100%'>"
      rottentomatoes = "<iframe src='#{scope.link}' seamless='seamless' width='100%' height='100%'>"
      $('#content').append(rottentomatoes)
]
