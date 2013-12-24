"use strict"
console.log "Initializing Angular App"
app = angular.module("app", ["ngRoute", "ngResource"])

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
  ).when("/films;showings/:id",
    templateUrl: "views/film_showings.html"
    controller: "FilmsController"
  ).when("/films;reviews/:id",
    templateUrl: "views/film_reviews.html"
    controller: "FilmsController"
  ).when("/films/:id/showings/:showing_id",
    templateUrl: "views/showing.html"
    controller: "FilmsController"
  )
]

