var getrouteripaddress = function() {
};

getrouteripaddress.getRouterIPAddress = function(success, fail) {
    cordova.exec(success, fail, "GetRouterIPAddress", "getRouterIPAddress", []);
};

module.exports = getrouteripaddress;
