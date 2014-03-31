'use strict';

/* Controllers */

angular.module('strangelove.controllers', []).
        controller('devices', function($scope, $http) {
        $scope.mySelections = [];

        $scope.gridOptions = {
            data: 'average',
            columnDefs: [
                {field: 'device_id', displayName: 'Id Gpu', width: '60'},
                {field: 'model', displayName: 'Modèle de GPU'},
                {field: 'hashrate', displayName: 'AVG Hashrate', cellTemplate: '<div>{{row.entity[col.field]}} kh/s</div>'},
                {field: 'shares', displayName: 'Shares acceptés'},
                {field: 'invalid_shares', displayName: 'Shares refusés'},
                {field: 'rejected_ratio', displayName: 'Ratio de refus'},
                {field: 'pool_shares', displayName: 'Ratio du pool'}
            ],
            selectedItems: $scope.mySelections,
            enableColumnResize: true,
            multiSelect: false
        };
        $scope.getTableStyle = function() {
            var rowHeight = 30;
            var headerHeight = 45;
            return {
                height: ($scope.average.length * rowHeight + headerHeight)
            };
        };
        /**
         * Sets the interval of days from right now
         */
        var setLastDays = $scope.setLastDays = function(nbDays) {
            $scope.endDate = Date.now() / 1000;
            $scope.startDate = $scope.endDate - 24 * 3600 * nbDays;
            refresh();
        };

        var refresh = $scope.refresh = function() {

          $scope.average = [];
          $scope.current = [];

          // Refresh the averages and sums of cards
            $http({method: 'GET', url: 'http://localhost:3000/api/summary/' + $scope.startDate + '/' + $scope.endDate})
                .success(function(data, status, headers, config) {

                    if (data.devices.length > 0) {
                        data.devices.push(
                          {device_id: '0',model: 'Total', invalid_shares: data.total.invalid_shares, shares: data.total.shares, hashrate: data.total.hashrate, rejected_ratio: data.total.reject_ratio}
                        );
                    }

                    //$scope.devices = data.devices;
                    data.devices.forEach(
                      function(device) {
                        $scope.average[device.device_id] = device;
                      });
                    $scope.status = data.status;
                    $scope.total = data.total;
                    $scope.status.start_date_str = new Date($scope.status.start_date * 1000).toLocaleString();
                    $scope.status.end_date_str = new Date($scope.status.end_date * 1000).toLocaleString();
                });

          // Refresh the current data of cards
             $http({method: 'GET', url: 'http://localhost:3000/api/lastest/'})
                .success(function(data, status, headers, config) {
                    data.devices.forEach(
                      function(device) {
                        $scope.current[device.device_id] = device;
                      });
             });
        }

        setLastDays(0.041666667);

        })
        .controller('servers', function($scope) {

            $scope.mySelections = [];

            $scope.servers = [
                {'id': '1', 'uptime': '15 jours 7 heures', 'admin': 'Justin', 'freeSlots': '0'}
            ];

            $scope.gridOptions = {
                data: 'servers',
                columnDefs: [
                    {field: 'id', displayName: 'Id serveur'},
                    {field: 'uptime', displayName: 'Uptime'},
                    {field: 'admin', displayName: 'Admin Responsable'},
                    {field: 'freeSlots', displayName: 'Ports libres'}
                ],
                selectedItems: $scope.mySelections,
                multiSelect: false
            };
            $scope.getTableStyle = function() {
                var rowHeight = 30;
                var headerHeight = 45;
                return {
                    height: ($scope.servers.length * rowHeight + headerHeight) + "px"
                };
            };
        })
        .controller('HeaderController', function($scope, $location) {
            $scope.isActive = function(viewLocation) {
                return viewLocation === $location.path();
            };
        });