'use strict'

angular.module("app").controller "FilmsController", ["$scope", "$routeParams", "$resource", "$location",
  (scope, routeParams, resource, location) ->
    scope.go = (url) ->
      document.location.href = "##{url}"

    scope.loadFilms = ->
      scope.loadFilmsFromBackend()

    scope.loadFilm = ->
      scope.loadFilmsFromBackend ->
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
        scope.film = response.films[parseInt(routeParams.id) - 1] if routeParams.id
        scope.showing = scope.film.showings[parseInt(routeParams.showing_id)] if routeParams.showing_id
        _.each(scope.films, (film) ->
            _.each(film.showings, (showing, index) ->
                showing.id = index))
        extra_success() if extra_success
      failure = (response) ->
        console.log("films failed with " + response.status)
      resource('/films', {}, {get: {method: 'GET', cache: true}}).get(success, failure)

    scope.filmsDates = ->
      showings = (film.showings for film in scope.films)
      scope.showingDates(_.flatten(showings))
      
    scope.filmDates = ->
      scope.showingDates(scope.film.showings)

    scope.showingDates = (showings) ->
      days_on = (showing.day_on for showing in showings)
      days_on = _.uniq days_on
      _.sortBy(days_on, (day) -> moment(day))

    scope.showingsOn = (day) ->
      (showing for showing in scope.film.showings when showing.day_on == day)
      
    scope.filmsOn = (day) ->
      (film for film in scope.films when scope.isOn(film, day))

    scope.isOn = (film, day) ->
      _.some(film.showings, (showing) -> showing.day_on == day)

    scope.when_formatted = (day) ->
      moment(day).format('dddd D MMMM')

    scope.short_title = (film) ->
      film.title.split("(")[0]

    scope.showFilm = (id) ->
      location.path("/films/#{id}")

    scope.link = (film) ->
      encodeURIComponent(film.link)
]
