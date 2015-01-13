package com.vallieres.plugin.getrouteripaddress;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;

/**
 *
 *	The following code is untested. Please do NOT use yet!
 *
 */
public class GetRouterIPAddress extends CordovaPlugin {
	public static final String GET_IP_ADDRESS="getRouterIPAddress";

	@Override
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
		try {
			if (GET_IP_ADDRESS.equals(action)) {
				String ip = getRouterIPAddress();
				String fail = "0.0.0.0";
				if (ip.equals(fail)) {
					callbackContext.error("Got no valid IP address");
					return false;
				}
				callbackContext.success(ip);
				return true;
			}
			callbackContext.error("Error no such method '" + action + "'");
			return false;
		} catch(Exception e) {
			callbackContext.error("Error while retrieving the IP address. " + e.getMessage());
			return false;
		}
	}

	private String getRouterIPAddress() {
		WifiManager wifiManager = (WifiManager) cordova.getActivity().getSystemService(Context.WIFI_SERVICE);
		DhcpInfo dhcp = manager.getDhcpInfo();

		return Formatter.formatIpAddress(dhcp.gateway);
	}
}
