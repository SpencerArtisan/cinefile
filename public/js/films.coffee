'use strict'

angular.module("app").controller "FilmsController", ["$scope", "$routeParams", "$resource", "$location",
  (scope, routeParams, resource, location) ->
    console.log "route params are #{routeParams.id}"

    scope.loadFilms = ->
      success = (response) ->
        scope.films = response.films
      failure = (response) ->
        console.log("films failed with " + response.status)
      resource('/films', {}, {get: {method: 'GET', cache: true}}).get(success, failure)

    scope.loadFilm = ->
      console.log "route params are #{routeParams.id}"
      success = (response) ->
        scope.film = response.films[parseInt(routeParams.id) - 1]
        console.log "film is #{scope.film}"
      failure = (response) ->
        console.log("films failed with " + response.status)
      resource('/films', {}, {get: {method: 'GET', cache: true}}).get(success, failure)

    scope.loadReview = ->
      console.log "route params are #{routeParams.id}"
      success = (response) ->
        scope.film = response.films[parseInt(routeParams.id) - 1]
        console.log "film for review is #{scope.film}"
        rottentomatoes = "<object data='#{scope.film.link}' type='text/html' style='margin-top:-155px' width='100%' height='3000px'>"
        $('#content').append(rottentomatoes)
      failure = (response) ->
        console.log("films failed with " + response.status)
      resource('/films', {}, {get: {method: 'GET', cache: true}}).get(success, failure)

    scope.when_formatted = (showing) ->
      moment(showing.day_on).format('ddd Do MMM')

    scope.short_title = (film) ->
      film.title.split("(")[0]

    scope.showFilm = (id) ->
      location.path("/films/#{id}")

    scope.link = (film) ->
      encodeURIComponent(film.link)
]
