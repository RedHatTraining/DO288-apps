angular.module('BuildsApp')
    .controller('BuildController', function($scope, BuildsService){


        function listAllBuilds(){
            BuildsService.findAll().then(
                function (success) {
                    $scope.builds = success.data;
                },
                function (error) {
                    $scope.error = "Error while fetching data."
                }
            );
        };

        function init() {
            $scope.builds = [];
            $scope.error = null;
            listAllBuilds();
        }

        init();

        $scope.getDate = function(dateMilis) {
            console.log(dateMilis);
            var d = new Date(dateMilis);
            console.log(d);
            return d;
        }

    });