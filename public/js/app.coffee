"use strict"
console.log "Initializing Angular App"
app = angular.module("app", ["ngTouch", "ngRoute", "ngResource", "ngAnimate", "ngCookies", "pasvaz.bindonce", "angular-google-analytics"])

app.config ["$routeProvider", (routeProvider) ->
  routeProvider.when("/",
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

app.config ["AnalyticsProvider", (AnalyticsProvider) ->
    AnalyticsProvider.setAccount('UA-40622076-4');
    AnalyticsProvider.trackPages(true);
    AnalyticsProvider.setDomainName('none');
    AnalyticsProvider.useAnalytics(true);
    AnalyticsProvider.ignoreFirstPageLoad(true);
    AnalyticsProvider.setPageEvent('$stateChangeSuccess');
]

