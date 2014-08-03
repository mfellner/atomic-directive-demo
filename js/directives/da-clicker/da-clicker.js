(function() {
  'use strict';

  angular.module('demoApp.directives', []).directive('daClicker', function() {
    return {
      restrict: 'E',
      replace: true,
      templateUrl: 'js/directives/da-clicker/da-clicker.html',
      scope: {},
      controller: ['$scope', function($scope) {
          $scope.count = 0;

          $scope.isPrime = function(number) {
            var start = 2;
            while (start <= Math.sqrt(number)) {
              if (number % start++ < 1) return false;
            }
            return number > 1;
          };
        }]
    };
  });

}());
