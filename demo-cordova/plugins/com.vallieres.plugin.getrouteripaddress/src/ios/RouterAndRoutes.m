//
//  RouterAndRoutes.m
//  NetworkTests
//
//  Created by Alexandre Vallières-Lagacé on 2015-01-13.
//
//

#import <Foundation/Foundation.h>
#import "RouterAndRoutes.h"
#import <arpa/inet.h>

@implementation Route_Info
-initWithRtm: (struct rt_msghdr2*) rtm
{
    int i;
    struct sockaddr* sa = (struct sockaddr*)(rtm + 1);

    memcpy(&(m_rtm), rtm, sizeof(struct rt_msghdr2));
    for(i = 0; i < RTAX_MAX; i++)
    {
        [self setAddr:&(sa[i]) index:i];
    }

    return self;
}

+ (NSMutableArray*) getRoutes
{
    NSMutableArray* routeArray = [NSMutableArray array];
    Route_Info* route = nil;

    size_t len;
    int mib[6];
    char *buf;
    register struct rt_msghdr2 *rtm;

    mib[0] = CTL_NET;
    mib[1] = PF_ROUTE;
    mib[2] = 0;
    mib[3] = 0;
    mib[4] = NET_RT_DUMP2;
    mib[5] = 0;

    sysctl(mib, 6, NULL, &len, NULL, 0);
    buf = malloc(len);
    if (buf && sysctl(mib, 6, buf, &len, NULL, 0) == 0)
    {
        for (char * ptr = buf; ptr < buf + len; ptr += rtm->rtm_msglen)
        {
            rtm = (struct rt_msghdr2 *)ptr;
            route = [self getRoute:rtm];
            if(route != nil)
            {
                [routeArray addObject:route];
                break;
            }
        }

        free(buf);
    }

    return routeArray;
}


+ (Route_Info*) getRoute:(struct rt_msghdr2 *)rtm
{
    struct sockaddr* dst_sa = (struct sockaddr *)(rtm + 1);
    Route_Info* route = nil;

    if(rtm->rtm_addrs & RTA_DST)
    {
        if(dst_sa->sa_family == AF_INET && !((rtm->rtm_flags & RTF_WASCLONED) && (rtm->rtm_parentflags & RTF_PRCLONING)))
        {
            route = [[Route_Info alloc] initWithRtm:rtm];
        }
    }

    return route;
}

-(void) setAddr:(struct sockaddr*)sa index:(int)rtax_index
{
    if(rtax_index >= 0 && rtax_index < RTAX_MAX)
    {
        memcpy(&(m_addrs[rtax_index]), sa, sizeof(struct sockaddr));
    }
}

-(NSString*) getDestination
{
    return [self getAddrStringByIndex:RTAX_DST];
}

-(NSString*) getNetmask
{
    return [self getAddrStringByIndex:RTAX_NETMASK];
}

-(NSString*) getGateway
{
    return [self getAddrStringByIndex:RTAX_GATEWAY];
}


-(NSString*) getAddrStringByIndex: (int)rtax_index
{
    NSString * routeString = nil;
    struct sockaddr* sa = &(m_addrs[rtax_index]);
    int flagVal = 1 << rtax_index;

    if(!(m_rtm.rtm_addrs & flagVal))
    {
        return nil;
    }

    if(rtax_index >= 0 && rtax_index < RTAX_MAX)
    {
        switch(sa->sa_family)
        {
            case AF_INET:
            {
                struct sockaddr_in* si = (struct sockaddr_in *)sa;
                if(si->sin_addr.s_addr == INADDR_ANY)
                    routeString = @"default";
                else
                    routeString = [NSString stringWithCString:(char *)inet_ntoa(si->sin_addr) encoding:NSASCIIStringEncoding];
            }
                break;

            case AF_LINK:
            {
                struct sockaddr_dl* sdl = (struct sockaddr_dl*)sa;
                if(sdl->sdl_nlen + sdl->sdl_alen + sdl->sdl_slen == 0)
                {
                    routeString = [NSString stringWithFormat: @"link #%d", sdl->sdl_index];
                }
                else
                    routeString = [NSString stringWithCString:link_ntoa(sdl) encoding:NSASCIIStringEncoding];
            }
                break;

            default:
            {
                char a[3 * sa->sa_len];
                char *cp;
                char *sep = "";
                int i;

                if(sa->sa_len == 0)
                {
                    routeString = nil;
                }
                else
                {
                    a[0] = '\0';
                    for(i = 0, cp = a; i < sa->sa_len; i++)
                    {
                        cp += sprintf(cp, "%s%02x", sep, (unsigned char)sa->sa_data[i]);
                        sep = ":";
                    }
                    routeString = [NSString stringWithCString:a encoding:NSASCIIStringEncoding];
                }
            }
        }
    }

    return routeString;
}

+ (NSString*) getRouterIpAddress
{
    NSString* routerIP = nil;
    NSMutableArray *routerArray = [Route_Info getRoutes];
    for(int i = 0; i < (int)[routerArray count]; i++)
    {
        Route_Info* router = (Route_Info*)[routerArray objectAtIndex:i];
        routerIP = [router getGateway];
    }
    return routerIP;
}

@end
