'use strict';

class ParkingPlace {
    constructor(map, coord, properties = {}, editable = false) {
        this.map = map;
        this.coord = coord;
        this.marker = Parking.addParkingArea(this.map, area, editable, strokeColor);
        this.properties = properties;
    }

    remove() {
        polygon.setMap(null);
    }
}