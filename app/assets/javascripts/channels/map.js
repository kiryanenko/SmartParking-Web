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
                let parking_places = data.reduce((res, parking) => {
                    parking.parking_places.forEach((place) => {
                        place.parking = parking;
                        res.push(place);
                    });
                    return res;
                }, []);
                onRecv(data, parking_places);
            }
        });
    }

    setParams(coord, radius, cost, onlyFree, canBook, withDisabled) {
        this.connection.send({
            coord: coord,
            radius: radius,
            cost: cost,
            only_free: onlyFree,
            can_book: canBook,
            with_disabled: withDisabled});
    }
}
