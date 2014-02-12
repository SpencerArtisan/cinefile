'use strict'

angular.module("app").controller "FilmsController", ["$scope", "$routeParams", "$resource", "$location", "$cookieStore",
  (scope, routeParams, resource, location, cookies) ->
    scope.animateStyle = ""
    scope.categories = ["All Movies", "Classic Movies", "Latest Releases"]
    scope.categoryIndex = if cookies.get('categoryIndex')? then cookies.get('categoryIndex') else 1
    scope.ratingFilter = if cookies.get('ratingFilter')? then cookies.get('ratingFilter') else 0
    scope.byDate = if cookies.get('byDate')? then cookies.get('byDate') else false
    scope.backgroundImage = "batman"

    scope.toggleMode = =>
      scope.byDate = !scope.byDate
      cookies.put('byDate', scope.byDate)

    scope.modeStyle = ->
      if scope.byDate then "icon-movie" else "icon-calendar"

    scope.backgroundStyle = ->
      "background-#{scope.categoryIndex}"

    scope.previousCategory = ->
      scope.changeCategory -1

    scope.nextCategory = ->
      scope.changeCategory 1

    scope.changeCategory = (delta) ->
      scope.categoryIndex += delta + scope.categories.length
      scope.categoryIndex %= scope.categories.length
      cookies.put('categoryIndex', scope.categoryIndex)

    scope.category = ->
      scope.categories[scope.categoryIndex]

    scope.goForward = (url) ->
      scope.go url, "slide-left"

    scope.goBackward = (url) ->
      scope.go url, "slide-right"

    scope.goUp = (url) ->
      scope.go url, ""

    scope.go = (url, animation) ->
      scope.animateStyle = animation
      location.path("#{url}")

    scope.filterStyle = ->
      "rating-#{scope.ratingFilter}"

    scope.toggleRatingFilter = ->
      scope.ratingFilter += 1
      scope.ratingFilter %= 3
      cookies.put('ratingFilter', scope.ratingFilter)

    scope.allFilms = ->
      return [] unless scope.films
      (film for film in scope.films when scope.passesFilter(film))

    scope.passesFilter = (film) ->
      return false if scope.ratingFilter == 1 && !scope.great(film)
      return false if scope.ratingFilter == 2 && !scope.superb(film)
      return false if scope.categoryIndex == 1 && film.year >= 1980
      return false if scope.categoryIndex == 2 && film.year < new Date().getFullYear() - 1
      true

    scope.loadFilms = ->
      scope.loadFilmsFromBackend()

    scope.loadFilm = ->
      scope.loadFilmsFromBackend ->
        scope.film.image = '/images/startup-frankenstein.png' unless scope.film.image
        background = "<div class='main' style=\"background: url(\'#{scope.film.image}\');background-size:320px 550px;background-repeat: no-repeat\"/>"
        $('#film-template').append(background)

    scope.loadShowing = ->
      scope.loadFilmsFromBackend()

    scope.loadCinema = ->
      scope.loadFilmsFromBackend ->
        map = "<iframe width='320' height='500' frameborder='0' scrolling='no' marginheight='0' marginwidth='0' src='https://maps.google.co.uk/maps?q=#{scope.showing.cinema}+cinema+london&amp;spn=0.028411,0.007193&amp;t=m&amp;output=embed'></iframe>"
        console.log "Appending map element: #{map}"
        $('#maparea').append(map)

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
      return [] unless scope.film && scope.film.showings
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
      film && film.rating and film.rating > 86

    scope.superb = (film) ->
      film && film.rating and film.rating > 94
]
