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

        this.parkings = {};
        this.parkingPlaces = {};
        this.update(parkings, parkingPlaces);

        this.channel = new MapChannel(MAP_CENTER, 1, this.update)
    }

    update(parkings, parkingPlaces) {
        this.updateElements(this.parkings, parkings, this.createParking);
        this.updateElements(this.parkingPlaces, parkingPlaces, this.createParkingPlace);
    }

    updateElements(elements, newElements, create) {
        let newElementsHash = {};
        newElements.forEach((el) => {newElementsHash[el.id] = el});

        for (let id in elements) {
            let current = elements[id];

            if (!(id in newElementsHash)) {
                current.remove();
                continue;
            }

            current.properties = newElementsHash[id];
        }

        newElements.forEach((newEl) => {
            if (!(newEl.id in elements)) {
                elements[newEl.id] = create(newEl);
            }
        });
    }

    createParking(parking) {
        return new Parking(this.map, parking.area, parking);
    }

    createParkingPlace(place) {
        return new ParkingPlace(this.map, place.coord, place);
    }
}
