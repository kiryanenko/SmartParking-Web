//= require cable

'use strict';

App.map = App.cable.subscriptions.create({
    channel: "MapChannel",
    coord: MAP_CENTER,
    diag: 1
}, {
    received: (data) => {
        console.log(data)
    }
});
