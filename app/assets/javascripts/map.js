function addParkingArea(map, area, editable = false) {
    return new google.maps.Polygon({
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

function parkingAreaCenter(area) {
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
    return center
}
