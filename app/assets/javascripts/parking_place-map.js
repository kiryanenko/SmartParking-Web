//= require map
//= require parking

'use strict';


class ParkingPlaceMap {
    constructor(map, location, area, editable = false) {
        if (location == null) {
            location = Parking.parkingAreaCenter(area);
        }

        this.map = new google.maps.Map(map, {
            zoom: 17,
            center: location
        });

        Parking.addParkingArea(this.map, area);

        this.parkingPlaceMarker = new google.maps.Marker({
            position: location,
            map: this.map,
            draggable: editable
        });
    }

    setCoordField() {
        let field = document.getElementById('parking_place_coord');
        let pos = this.parkingPlaceMarker.position;

        field.value = 'POINT (' + pos.lat() + ' ' + pos.lng() + ')';
    }
}
