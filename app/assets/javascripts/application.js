var starbucksMap = {
    mapSelector: '#map-canvas',

    start: {
        lat: 52.200,
        lng: 19.134,
        zoom: 7,
    },
    /* test data
    samplePoints: [{
         "id": "1",
         "lat": "52.200",
         "lng": "19.134",
         "title": "test1"
     }, {
         "id": "2",
         "lat": "52.700",
         "lng": "18",
         "title": "test2"
     }, {
         "id": "3",
         "lat": "52.450",
         "lng": "17",
         "title": "test3"
     }],*/
    iconOptions: {
        url: 'http://media.tumblr.com/tumblr_m3zftkAVn41r017k2.gif',
        size: new google.maps.Size(32, 32),
        origin: new google.maps.Point(0, 0),
        anchor: new google.maps.Point(16, 32)
    },
    map: {},
    markers: [],
    infoBox: null,
    coordinates: [],
    directionsService: null,
    directionsDisplay: null,

    init: function() {
        this.map = new google.maps.Map(jQuery(this.mapSelector).get(0), { // google.maps needs DOM not a jQuery object
            zoom: this.start.zoom,
            center: this.start
        });
        this.setMarkers();
        this.drawMarkers();
    },
    setMarkers: function() {
        var json = window.rails_data;
        this.drawMarkers(json.nodes);
        this.getDrawPoints(json.edges)
        if (json.path) {
            this.drawRouteToShop(json.path.nodes_sequence);
            this.removeLine(null);
        }
        else {
            this.addLine(this.map);
        }
    },
    drawMarkers: function(nodes) {
        if (nodes) {
            for (i = 0; i < nodes.length; i++) {
                this.addMarker(nodes[i]);
            }
        }
    },
    getDrawPoints: function(pointsToDraw) {
        that = this;
        jQuery.each(pointsToDraw, function() {
            that.coordinates.push({
                "from": new google.maps.LatLng(this.node1.latitude, this.node1.longitude),
                "to": new google.maps.LatLng(this.node2.latitude, this.node2.longitude)
            });
        });
    },
    addMarker: function(shop) {
        marker = new google.maps.Marker({
            position: new google.maps.LatLng(shop.latitude, shop.longitude),
            map: this.map,
            icon: this.iconOptions,
            animation: google.maps.Animation.DROP,
            title: '<span><b>' + shop.name + '</b><span><br />' + shop.address_line_1,
            zIndex: 9998
        });
        this.setMarkerInfo(marker);
        this.markers.push(marker);
    },
    setMarkerInfo: function(marker) {
        var that = this;
        google.maps.event.addListener(marker, 'click', function() {
            that.infoBox = new google.maps.InfoWindow({
                content: marker.title
            });
            that.infoBox.open(that.map, this);
        })
    },
    drawPolyline: function(map) {
        jQuery.each(this.coordinates, function() {
            var line = [
                this.from,
                this.to
            ];
            var routePath = new google.maps.Polyline({
                path: line,
                geodesic: true,
                strokeOpacity: 1.0,
                strokeWeight: 1
            });
            routePath.setMap(map);
        });
    },
    addLine: function(map) {
        this.drawPolyline(map);
    },
    removeLine: function(map) {
        this.drawPolyline(null);
    },
    drawRouteToShop: function(nodes) {
        that = this;
        if (nodes.length > 1) {
            var waypts = [];
            var iterator = 0;
            jQuery.each(nodes, function() {
                if (iterator == 0) {
                    start = new google.maps.LatLng(this.latitude, this.longitude);
                }
                else if (iterator == nodes.length - 1) {
                    end = new google.maps.LatLng(this.latitude, this.longitude);
                }
                else {
                    waypts.push({
                        location: new google.maps.LatLng(this.latitude, this.longitude),
                        stopover: true
                    });
                }
                iterator++;
            });
            that.directionsService = new google.maps.DirectionsService();
            that.directionsDisplay = new google.maps.DirectionsRenderer({
                suppressMarkers: true
            });

            that.directionsDisplay.setMap(that.map);
            var routeToShop = {
                origin: start,
                destination: end,
                waypoints: waypts,
                optimizeWaypoints: true,
                travelMode: google.maps.DirectionsTravelMode.DRIVING
            };

            that.directionsService.route(routeToShop, function(response, status) {
                if (status == google.maps.DirectionsStatus.OK) {
                    that.directionsDisplay.setDirections(response);
                    var route = response.routes[0];
                }
            });
        }
    }


}
jQuery(window).load(function() {
    starbucksMap.init();
});
