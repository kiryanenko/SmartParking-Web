let map;
let area_polygon;

function initParkingAreaMap(area, editable) {
    let center;
    if (area.length === 0) {
        center = MAP_CENTER;
        if (editable) {
            area = [
                MAP_CENTER,
                {lat: MAP_CENTER.lat, lng: MAP_CENTER.lng + 0.002},
                {lat: MAP_CENTER.lat + 0.002, lng: MAP_CENTER.lng}
            ];
        }
    } else {
        center = area[0];
    }

    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 17,
        center: center
    });

    area_polygon = new google.maps.Polygon({
        map: map,
        paths: area,
        strokeColor: '#FF0000',
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: '#36cfff',
        fillOpacity: 0.35,
        editable: editable,
        draggable: editable,
        geodesic: true
    });
}

function removePolygonPoint() {
    if (area_polygon.getPath().length > 3) {
        area_polygon.getPath().removeAt(0);
    }
}

function setAreaField() {
    let field = document.getElementById('parking_area');
    let area = area_polygon.getPath().getArray();
    area.push(area[0]);

    let res = 'POLYGON ((';
    res += area.map((coord) => { console.log(coord); return coord.lat() + ' ' + coord.lng() }).join(', ');
    res += '))';
    field.value = res;
}
