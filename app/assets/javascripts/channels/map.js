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
                onRecv(data.parkings, data.parking_places)
            }
        });
    }
}
