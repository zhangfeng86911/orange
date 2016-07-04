angular.module('orange').directive("appSlideOut", function () {
    return {
        restrict: 'C',
        link: function(scope, element, attrs) {
            $(element).sideNav();
        }
    };
});
