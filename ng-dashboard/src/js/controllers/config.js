angular.module('orange').controller("ConfigController", ["$scope", "Orange", "Alert", "$location", function ($scope, Orange, Alert, $location) {
    $scope.config = angular.copy(Orange.config);

    var first_setup = !$scope.config.url;

    $scope.update = function () {
        if (!$scope.config.url) {
            Alert.error("You need to indicate the url and port of the Orange node you want to manage.");
            return;
        }

        Orange.setConfig($scope.config).then(function () {
            if (first_setup) {
                $location.path('/');
                first_setup = false;
            } else {
                // celebrate
                Alert.success('Saved!');
            }
        }, function (reason) {
            if (reason === 'Not Orange') {
                Alert.error("That's not a orange node.");
            } else if (reason === 'Forbidden') {
                Alert.error("Authentication failure");
            } else {
                Alert.error("Can't access a orange node with this url/port.");
            }
        });
    }
}]);
