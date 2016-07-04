var orange = angular.module('orange', ['ngRoute', 'ngCookies', 'ngAnimate', 'ngSanitize'])
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
                resolve: {
                    isAppReady: isAppReady
                }
            })
            .when('/config', {
                templateUrl: 'html/config.html',
                controller: 'ConfigController'
            })
            .otherwise({redirectTo: '/'});
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
