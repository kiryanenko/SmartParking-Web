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

        this.cluster = new MarkerClusterer(this.map, [], {});

        this.parkings = new Map();
        this.parkingPlaces = new Map();
        this.update(parkings, parkingPlaces);

        this.channel = new MapChannel(MAP_CENTER, 1, this)
    }

    update(parkings, parkingPlaces) {
        this.updateData(this.parkings, parkings, MainMap.createParking);
        this.updateData(this.parkingPlaces, parkingPlaces, MainMap.createParkingPlace);
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
                data.set(newEl.id, create(this, newEl));
            }
        });
    }

    static createParking(self, parking) {
        return new Parking(self.map, parking.area, parking);
    }

    static createParkingPlace(self, place) {
        return new ParkingPlace(self.map, place.coord, place, false, self.cluster);
    }
}
