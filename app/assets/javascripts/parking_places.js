//= require map

let map;
let parkingPlaceMarker;

function initParkingPlaceMap(location, area, editable = false) {
    if (location == null) {
        location = parkingAreaCenter(area);
    }

    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 17,
        center: location
    });

    addParkingArea(map, area);


    parkingPlaceMarker = new google.maps.Marker({
        position: location,
        map: map,
        draggable: editable
    });
}

function setCoordField() {
    let field = document.getElementById('parking_place_coord');
    let pos = parkingPlaceMarker.position;

    field.value = 'POINT (' + pos.lat() + ' ' + pos.lng() + ')';
}
