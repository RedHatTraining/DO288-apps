angular.module('BuildsApp')
    .factory('BuildsService', function($http){

        var buildService = {};

        buildService.findAll = function(){
            return $http.get('http://builds-for-managers.apps.lab.example.com/api/builds');
        }

        return buildService;
    });