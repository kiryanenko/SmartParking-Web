//= require markerclusterer

'use strict';

class Parking {
    constructor(map, area, properties = {}, editable = false, strokeColor = '#3557ff') {
        this.map = map;
        this.area = area;
        this.polygon = Parking.addParkingArea(this.map, area, editable, strokeColor);
        this.properties = properties;
    }

    static addParkingArea(map, area, editable = false, strokeColor = '#3557ff') {
        return new google.maps.Polygon({
            map: map,
            paths: area,
            strokeColor: strokeColor,
            strokeOpacity: 0.8,
            strokeWeight: 2,
            fillColor: '#36cfff',
            fillOpacity: 0.35,
            editable: editable,
            draggable: editable,
            geodesic: true
        });
    }

    static parkingAreaCenter(area) {
        let center;
        let count = area.length;
        if (count === 0) {
            center = MAP_CENTER;
        } else {
            center = area.reduce((res, point) => {
                res.lat += point.lat / count;
                res.lng += point.lng / count;
                return res;
            }, {lat: 0.0, lng: 0.0});
        }
        return center;
    }

    parkingAreaCenter() {
        return Parking.parkingAreaCenter(this.area);
    }

    remove() {
        this.polygon.setMap(null);
    }
}
