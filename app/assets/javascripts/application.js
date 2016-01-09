var starbucksMap = {
    mapSelector: '#map-canvas',

    start: {
        lat: 52.200,
        lng: 19.134,
        zoom: 7,
    },
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
    }],
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
    directionsDisplay: null ,

    init: function() {
        this.map = new google.maps.Map(jQuery(this.mapSelector).get(0), { // google.maps needs DOM not a jQuery object
            zoom: this.start.zoom,
            center: this.start
        });
        this.drawMarkers();
        this.drawPolyline();
        this.drawRouteToShop();
    },
    setMarkers: function() {
        //get all markers form ajax
    },
    drawMarkers: function() {
        if (this.samplePoints) {
            for (i = 0; i < this.samplePoints.length; i++) {
                this.addMarker(this.samplePoints[i]);
                this.getDrawPoints(this.samplePoints[i]);
            }
        }
    },
    getDrawPoints: function(pointsToDraw) {
        this.coordinates.push({
            "lat": Number(pointsToDraw.lat),
            "lng": Number(pointsToDraw.lng),
        });
    },
    addMarker: function(shop) {
        marker = new google.maps.Marker({
            position: new google.maps.LatLng(shop.lat, shop.lng),
            map: this.map,
            icon: this.iconOptions,
            animation: google.maps.Animation.DROP,
            title: shop.title,
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
    drawPolyline: function() {
        var routePath = new google.maps.Polyline({
            path: this.coordinates,
            geodesic: true,
            strokeOpacity: 1.0,
            strokeWeight: 3
        });

        routePath.setMap(this.map);
        this.directionsService = new google.maps.DirectionsService();
    },
    drawRouteToShop: function() {
        this.directionsService = new google.maps.DirectionsService();
        this.directionsDisplay = new google.maps.DirectionsRenderer({
            suppressMarkers: true
        });
        this.directionsDisplay.setMap(this.map);
    console.log('test');
    }


}
jQuery(window).load(function() {
    starbucksMap.init();
});
