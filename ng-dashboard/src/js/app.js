var orange = angular.module('orange', ['ngRoute', 'ngCookies', 'ngAnimate', 'ngSanitize', 'chart.js'])
    .config(['$routeProvider', function ($routeProvider) {

        var appStarted = false;

        var isAppReady = ['Orange', '$location', function (Orange, $location) {
            if (appStarted) {
                return true;
            }
            if (!Orange.config.url) {
                $location.path('/config');
                return false;
            }
        }];

        // Request route handle
        $routeProvider
            .when('/', {
                templateUrl: 'html/home.html',
                controller: 'IndexController',
                resolve: {
                    isAppReady: isAppReady,
                    initialData: ['Orange', '$location', function (Orange) {
                        return Orange.get('/plugins');
                    }]
                }
            })
            .when('/status', {
                templateUrl: 'html/status.html',
                controller: 'StatusController'
            })
            .when('/config', {
                templateUrl: 'html/config.html',
                controller: 'ConfigController'
            })
            .otherwise({redirectTo: '/'});
    }])
    .config(['ChartJsProvider', function(ChartJsProvider) {
        // Configure all charts
        ChartJsProvider.setOptions({
            colours: ['#97BBCD', '#DCDCDC', '#F7464A', '#46BFBD', '#FDB45C', '#949FB1', '#4D5360'],
            responsive: true
        });

        // Configure all doughnut charts
        ChartJsProvider.setOptions('Doughnut', {
            animateScale: true
        });
    }])
    .run(['$rootScope', 'Orange', '$location', function ($rootScope, Orange, $location) {
        $rootScope.initialized = false;
        Orange.checkConfig(Orange.config).then(function () {
            $rootScope.app = Orange;
            $rootScope.initialized = true;
        }, function () {
            Orange.config.url = null;
            $rootScope.app = Orange;
            $rootScope.initialized = true;
            $location.path("/config");
        })
    }]);
