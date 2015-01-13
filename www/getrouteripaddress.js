var getrouteripaddress = function() {
};

getrouteripaddress.getIPAddress = function(success, fail) {
    cordova.exec(success, fail, "getrouteripaddress", "getRouterIPAddress", []);
};

module.exports = getrouteripaddress;
