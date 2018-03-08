//= require map

'use strict';


class ParkingAreaMap {
    constructor(map, area, editable = false) {
        if (area.length === 0 && editable) {
            area = [
                MAP_CENTER,
                {lat: MAP_CENTER.lat, lng: MAP_CENTER.lng + 0.002},
                {lat: MAP_CENTER.lat + 0.002, lng: MAP_CENTER.lng}
            ];
        }
        let center = parkingAreaCenter(area);

        this.map = new google.maps.Map(map, {
            zoom: 17,
            center: center
        });
        this.area_polygon = addParkingArea(this.map, area, editable)
    }

    removePolygonPoint() {
        if (this.area_polygon.getPath().length > 3) {
            this.area_polygon.getPath().removeAt(0);
        }
    }

    setAreaField() {
        let field = document.getElementById('parking_area');
        let area = this.area_polygon.getPath().getArray();
        area.push(area[0]);

        let res = 'POLYGON ((';
        res += area.map((coord) => {
            console.log(coord);
            return coord.lat() + ' ' + coord.lng()
        }).join(', ');
        res += '))';
        field.value = res;
    }
}
