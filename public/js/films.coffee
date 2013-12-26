'use strict'

angular.module("app").controller "FilmsController", ["$scope", "$routeParams", "$resource", "$location",
  (scope, routeParams, resource, location) ->
    scope.categories = ["All Movies", "Foreign Movies", "Classic Movies", "Latest Releases"]
    scope.categoryIndex = 0
    scope.filterOn = false

    scope.previousCategory = ->
      scope.changeCategory -1

    scope.nextCategory = ->
      scope.changeCategory 1

    scope.changeCategory = (delta) ->
      scope.categoryIndex += delta + scope.categories.length
      scope.categoryIndex %= scope.categories.length

    scope.category = ->
      scope.categories[scope.categoryIndex]

    scope.go = (url) ->
      location.path("#{url}")

    scope.filterStyle = ->
      if scope.filterOn then "filter-on" else "filter-off"

    scope.filterGreatMovies = ->
      scope.filterOn = !scope.filterOn

    scope.allFilms = ->
      (film for film in scope.films when scope.passesFilter(film))

    scope.passesFilter = (film) ->
      return false if scope.filterOn && !scope.great(film)
      return false if scope.categoryIndex == 2 && film.year >= 1980
      return false if scope.categoryIndex == 3 && film.year < new Date().getFullYear() - 1
      return false if scope.categoryIndex == 1 && (film.language == null || film.language == "EN")
      true

    scope.loadFilms = ->
      scope.loadFilmsFromBackend()

    scope.loadFilm = ->
      scope.loadFilmsFromBackend ->
        scope.film.image = '/images/startup-frankenstein.png' unless scope.film.image
        background = "<div class='main' style=\"background: url(\'#{scope.film.image}\');background-size:320px 550px;background-repeat: no-repeat\"/>"
        $('#template').append(background)

    scope.loadShowing = ->
      scope.loadFilmsFromBackend()

    scope.loadCinema = ->
      scope.loadFilmsFromBackend ->
        map = "<iframe width='320' height='500' frameborder='0' scrolling='no' marginheight='0' marginwidth='0' src='https://maps.google.co.uk/maps?q=#{scope.showing.cinema}+cinema+london&amp;spn=0.028411,0.007193&amp;t=m&amp;output=embed'></iframe>"
        $('#content').append(map)

    scope.loadFilmsFromBackend = (extra_success = null) ->
      success = (response) ->
        scope.films = response.films
        scope.film = response.films[parseInt(routeParams.id)] if routeParams.id
        scope.showing = scope.film.showings[parseInt(routeParams.showing_id)] if routeParams.showing_id
        _.each(scope.films, (film, film_index) ->
            film.id = film_index
            _.each(film.showings, (showing, showing_index) ->
                showing.id = showing_index))
        extra_success() if extra_success
      failure = (response) ->
        console.log("films failed with " + response.status)
      resource('/films', {}, {get: {method: 'GET', cache: true}}).get(success, failure)

    scope.filmsDates = ->
      showings = (film.showings for film in scope.allFilms())
      scope.showingDates(_.flatten(showings))
      
    scope.filmDates = ->
      if scope.film then scope.showingDates(scope.film.showings) else []

    scope.showingDates = (showings) ->
      days_on = (showing.day_on for showing in showings)
      days_on = _.uniq days_on
      _.sortBy(days_on, (day) -> moment(day))

    scope.showingsOn = (day) ->
      (showing for showing in scope.film.showings when showing.day_on == day)
      
    scope.filmsOn = (day) ->
      (film for film in scope.allFilms() when scope.isOn(film, day))

    scope.isOn = (film, day) ->
      _.some(film.showings, (showing) -> showing.day_on == day)

    scope.when_formatted = (day) ->
      moment(day).format('dddd D MMMM')

    scope.short_title = (film) ->
      if film then film.title.split("(")[0].trim() else ""

    scope.showFilm = (id) ->
      location.path("/films/#{id}")

    scope.link = (film) ->
      encodeURIComponent(film.link)

    scope.great = (film) ->
      film && film.rating and film.rating > 91
]
