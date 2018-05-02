//= require channels/map
//= require parking
//= require parking-place.js.erb

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

        this.map.bounds_changed = this.sendSetParams.bind(this);

        this.filterForm = document.getElementById('filter_form');
        this.costField = document.getElementById('cost');
        this.costRangeField = document.getElementById('cost_range');
        this.withDisabledField = document.getElementById('with_disabled');

        this.filterForm.onchange = this.sendSetParams.bind(this);
        this.costField.oninput = this.onChangeCostField.bind(this);
        this.costRangeField.oninput = this.onChangeCostRangeField.bind(this);
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
            return 0.1;
        }

        let ne = bounds.getNorthEast();
        let sw = bounds.getSouthWest();
        return Math.sqrt((ne.lat() - sw.lat()) * (ne.lat() - sw.lat()) +
            (ne.lng() - sw.lng()) * (ne.lng() - sw.lng())) / 2;
    }

    sendSetParams() {
        this.channel.setParams(
            this.map.getCenter(),
            this.getRadius(),
            parseFloat(this.costField.value),
            this.withDisabledField.checked
        );
    }

    onChangeCostField() {
        this.costRangeField.value = this.costField.value;
    }

    onChangeCostRangeField() {
        this.costField.value = this.costRangeField.value;
    }
}
