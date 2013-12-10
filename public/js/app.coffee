"use strict"
console.log "Initializing Angular App"
app = angular.module("app", ["ngRoute", "ngResource"])

#angular.module "app.controllers", []

app.config ["$routeProvider", (routeProvider) ->
  routeProvider.when("/",
    templateUrl: "views/films.html"
    controller: "FilmsController"
  )
]

