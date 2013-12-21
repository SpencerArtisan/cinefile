"use strict"
console.log "Initializing Angular App"
app = angular.module("app", ["ngRoute", "ngResource"])

app.config ["$routeProvider", (routeProvider) ->
  routeProvider.when("/",
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
  )
]

