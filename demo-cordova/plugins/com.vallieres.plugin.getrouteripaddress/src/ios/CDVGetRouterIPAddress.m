#import "CDVGetRouterIPAddress.h"
#import "RouterAndRoutes.h"

@implementation CDVGetRouterIPAddress

- (void) getRouterIPAddress:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* ipaddr = [Route_Info getRouterIpAddress];

    if (ipaddr != nil && ![ipaddr isEqualToString:@"error"]) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:ipaddr];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end

