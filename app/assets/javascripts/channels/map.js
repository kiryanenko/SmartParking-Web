//= require cable

'use strict';

class MapChannel {
    constructor(coord, radius, listener) {
        this.connection = App.cable.subscriptions.create({
            channel: "MapChannel",
            coord: coord,
            radius: radius
        }, {
            received: (data) => {
                console.log(data);
                listener.update(data.parkings, data.parking_places)
            }
        });
    }
}
