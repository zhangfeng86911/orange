angular.module('orange').controller("IndexController", ["initialData", "$scope", "Orange", "Alert", function (initialData, $scope, Orange, Alert) {

    if (initialData.success === false) {
        Alert.error(initialData.msg);
    } else {
        $scope.plugins = initialData.data.plugins;
    }
}]);
