"use strict"
console.log "Initializing Angular App"
app = angular.module("app", ["ngRoute", "ngResource", "ngAnimate"])

app.directive 'fastClick', ->
  (scope, element, attrs) ->
    scope.shortlyAfterTouchStart = =>
      console.log "Shortly after touch start isMoving is #{scope.isMoving}"
      scope.$apply(attrs['fastClick']) unless scope.isMoving

    element.bind 'touchmove', => scope.isMoving = true
    element.bind 'touchstart', => scope.isMoving = false; setTimeout(scope.shortlyAfterTouchStart, 20)

app.config ["$routeProvider", (routeProvider) ->
  routeProvider.when("/films;by-date",
    templateUrl: "views/films_by_date.html"
    controller: "FilmsController"
  ).when("/",
    templateUrl: "views/films.html"
    controller: "FilmsController"
  ).when("/films/:id",
    templateUrl: "views/film.html"
    controller: "FilmsController"
  ).when("/films/:id/showings/:showing_id",
    templateUrl: "views/showing.html"
    controller: "FilmsController"
  )
]

