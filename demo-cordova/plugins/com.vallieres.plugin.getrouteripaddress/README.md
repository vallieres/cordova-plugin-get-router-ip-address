# cordova-plugin-get-router-ip-address
Cordova (PhoneGap) plugin to fetch the router's IP address. Presently only for iOS, Android to follow.

Instructions
------------

#### Cordova 3.X (command line)

`cordova plugin add https://github.com/vallieres/cordova-plugin-get-router-ip-address`

#### Cordova 2.9 and earlier

Add *.h, *.m to your project and *.js to www/ directory.

Add node to config.xml:

    <feature name="com.vallieres.plugin.getrouteripaddress">
        <param name="ios-package" value="CDVGetRouterIPAddress"/>
    </feature>


Example
-------
There is a <a href="example/">simple DAAP browsing example</a> available,
it should list shared iTunes DAAP services and by tapping item, resolve the
actual IP address.


Legal
-----

**cordova-plugin-get-router-ip-address** is licensed with Apache License v2.0.
(same as Cordova, for license see http://www.apache.org/licenses/LICENSE-2.0)

Copyright (c) 2015 Alexandre Vallières-Lagacé <alexandre.valliereslagace@gmail.com>.
