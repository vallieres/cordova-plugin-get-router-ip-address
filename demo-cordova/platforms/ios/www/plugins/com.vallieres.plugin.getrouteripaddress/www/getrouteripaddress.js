cordova.define("com.vallieres.plugin.getrouteripaddress.getrouteripaddress", function(require, exports, module) { var getrouteripaddress = function() {
};

getrouteripaddress.getRouterIPAddress = function(success, fail) {
    cordova.exec(success, fail, "getrouteripaddress", "getRouterIPAddress", []);
};

module.exports = getrouteripaddress;

});
