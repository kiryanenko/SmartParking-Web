//= require cable

'use strict';

class MapChannel {
    constructor(coord, radius, onRecv) {
        this.connection = App.cable.subscriptions.create({
            channel: "MapChannel",
            coord: coord,
            radius: radius
        }, {
            received: (data) => {
                console.log(data);
                data.parking_places.forEach((place) => {
                    place.parking = data.parkings.find((el) => { return el.id === place.parking_id; })
                });
                onRecv(data.parkings, data.parking_places);
            }
        });
    }

    setParams(coord, radius) {
        this.connection.send({coord: coord, radius: radius});
    }
}
