#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVInvokedUrlCommand.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

@interface CDVGetRouterIPAddress : CDVPlugin

- (void) getRouterIPAddress:(CDVInvokedUrlCommand*)command;

@end
