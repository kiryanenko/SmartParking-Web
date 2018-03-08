//= require map

let map;
let area_polygon;

function initParkingAreaMap(area, editable = false) {
    if (area.length === 0 && editable) {
        area = [
            MAP_CENTER,
            {lat: MAP_CENTER.lat, lng: MAP_CENTER.lng + 0.002},
            {lat: MAP_CENTER.lat + 0.002, lng: MAP_CENTER.lng}
        ];
    }
    let center = parkingAreaCenter(area);

    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 17,
        center: center
    });

    area_polygon = addParkingArea(map, area, editable)
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
