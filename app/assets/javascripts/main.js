//= require channels/map
//= require parking
//= require parking-place

'use strict';

class MainMap {
    constructor(map, parkings = [], parkingPlaces = []) {
        this.map = new google.maps.Map(map, {
            zoom: 13,
            center: MAP_CENTER
        });

        this.cluster = new MarkerClusterer(this.map, [],
            {imagePath: '/assets/images/m'});

        this.parkings = new Map();
        this.parkingPlaces = new Map();
        this.update(parkings, parkingPlaces);

        this.channel = new MapChannel(MAP_CENTER, this.getRadius(), this.update.bind(this));

        this.map.bounds_changed = this.onBoundsChanged.bind(this)
    }

    update(parkings, parkingPlaces) {
        this.updateData(this.parkings, parkings, this.createParking.bind(this));
        this.updateData(this.parkingPlaces, parkingPlaces, this.createParkingPlace.bind(this));
    }

    updateData(data, newData, create) {
        let newDataMap = new Map();
        newData.forEach((el) => { newDataMap.set(el.id, el) });

        for (let id of data.keys()) {
            let current = data.get(id);

            if (!newDataMap.has(id)) {
                current.remove();
                data.delete(id);
                continue;
            }

            current.properties = newDataMap.get(id);
        }

        newData.forEach((newEl) => {
            if (!data.has(newEl.id)) {
                data.set(newEl.id, create(newEl));
            }
        });
    }

    createParking(parking) {
        return new Parking(this.map, parking.area, parking);
    }

    createParkingPlace(place) {
        return new ParkingPlace(this.map, place.coord, place, false, this.cluster);
    }

    getRadius() {
        let bounds = this.map.getBounds();

        if (!bounds) {
            console.log('bounds undefined');
            return 0.01;
        }

        let ne = bounds.getNorthEast();
        let sw = bounds.getSouthWest();
        return Math.sqrt((ne.lat() - sw.lat()) * (ne.lat() - sw.lat()) +
            (ne.lng() - sw.lng()) * (ne.lng() - sw.lng())) / 2;
    }

    onBoundsChanged() {
        this.channel.setParams(this.map.getCenter(), this.getRadius());
    }
}
