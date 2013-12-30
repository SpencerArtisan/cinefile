"use strict"
console.log "Initializing Angular App"
app = angular.module("app", ["ngRoute", "ngResource", "ngAnimate"])

app.directive 'gfTap', ->
  (scope, element, attrs) ->
    tapping = false
    element.bind 'touchstart', -> tapping = true
    element.bind 'touchmove', -> tapping = false
    element.bind 'touchend', -> scope.$apply(attrs['gfTap']) if tapping

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

