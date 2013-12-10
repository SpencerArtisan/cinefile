"use strict"
console.log "Initializing Angular App"
app = angular.module("app", ["ngRoute"])

app.config ["$routeProvider", (routeProvider) ->
  routeProvider.when("/",
    templateUrl: "views/films.html"
  )
]

