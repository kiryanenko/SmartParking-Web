'use strict';

class ParkingPlace {
    constructor(map, location, properties = {}, editable = false, cluster = null) {
        this.map = map;
        this.location = location;
        this.properties = properties;
        this.cluster = cluster;

        this.marker = new google.maps.Marker({
            position: location,
            map: map,
            draggable: editable
        });

        if (cluster != null) {
            cluster.addMarker(this.marker);
        }
    }

    remove() {
        if (this.cluster != null) {
            this.cluster.removeMarker(this.marker);
        }
        this.marker.setMap(null);
    }
}