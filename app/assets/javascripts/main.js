//= require channels/map

'use strict';

class MainMap {
    constructor(map) {
        this.map = new google.maps.Map(map, {
            zoom: 13,
            center: MAP_CENTER
        });
    }
}
