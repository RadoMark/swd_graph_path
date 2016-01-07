var starbucksMap = {
    mapSelector: '#map-canvas',
    
    start: {
        lat: 52.200,
        lng: 19.134,
        zoom: 6
    },
    map: {},
     markers: [],
    
    init: function() {
        this.map = new google.maps.Map(jQuery(this.mapSelector).get(0), { // google.maps needs DOM not a jQuery object
            zoom: this.start.zoom,
            center: this.start
        });
        this.addMarker();
    },
    setMarkers: function(){
        //get all markers form ajax
    },
    addMarker: function(){
        marker = new google.maps.Marker({
            position: new google.maps.LatLng(this.start.lat, this.start.lng),
            map: this.map,
            title: 'test'
        });
        this.markers.push(marker);
    }
    
    
}
jQuery(document).ready(function(){
   starbucksMap.init(); 
});