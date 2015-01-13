//
//  RouterAndRoutes.h
//  NetworkTests
//
//  Created by Alexandre Vallières-Lagacé on 2015-01-13.
//
//

#ifndef NetworkTests_GetRouter_h
#define NetworkTests_GetRouter_h

#include <stdio.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <net/if_dl.h>
#import <sys/sysctl.h>

#define RTF_PRCLONING	0x10000		/* protocol requires cloning */
#define RTF_WASCLONED	0x20000		/* route generated through cloning */
#define RTF_PROTO3	0x40000		/* protocol specific routing flag */

#define RTAX_DST	0	/* destination sockaddr present */
#define RTAX_GATEWAY	1	/* gateway sockaddr present */
#define RTAX_NETMASK	2	/* netmask sockaddr present */
#define RTAX_GENMASK	3	/* cloning mask sockaddr present */
#define RTAX_IFP	4	/* interface name sockaddr present */
#define RTAX_IFA	5	/* interface addr sockaddr present */
#define RTAX_AUTHOR	6	/* sockaddr for author of redirect */
#define RTAX_BRD	7	/* for NEWADDR, broadcast or p-p dest addr */
#define RTAX_MAX	8	/* size of array to allocate */

#define RTA_DST		0x1	/* destination sockaddr present */
#define RTA_GATEWAY	0x2	/* gateway sockaddr present */
#define RTA_NETMASK	0x4	/* netmask sockaddr present */
#define RTA_GENMASK	0x8	/* cloning mask sockaddr present */
#define RTA_IFP		0x10	/* interface name sockaddr present */
#define RTA_IFA		0x20	/* interface addr sockaddr present */
#define RTA_AUTHOR	0x40	/* sockaddr for author of redirect */
#define RTA_BRD		0x80	/* for NEWADDR, broadcast or p-p dest addr */


struct rt_metrics {
    u_int32_t	rmx_locks;	/* Kernel must leave these values alone */
    u_int32_t	rmx_mtu;	/* MTU for this path */
    u_int32_t	rmx_hopcount;	/* max hops expected */
    int32_t		rmx_expire;	/* lifetime for route, e.g. redirect */
    u_int32_t	rmx_recvpipe;	/* inbound delay-bandwidth product */
    u_int32_t	rmx_sendpipe;	/* outbound delay-bandwidth product */
    u_int32_t	rmx_ssthresh;	/* outbound gateway buffer limit */
    u_int32_t	rmx_rtt;	/* estimated round trip time */
    u_int32_t	rmx_rttvar;	/* estimated rtt variance */
    u_int32_t	rmx_pksent;	/* packets sent using this route */
    u_int32_t	rmx_filler[4];	/* will be used for T/TCP later */
};


struct rt_msghdr2 {
    u_short	rtm_msglen;		/* to skip over non-understood messages */
    u_char	rtm_version;		/* future binary compatibility */
    u_char	rtm_type;		/* message type */
    u_short	rtm_index;		/* index for associated ifp */
    int	rtm_flags;		/* flags, incl. kern & message, e.g. DONE */
    int	rtm_addrs;		/* bitmask identifying sockaddrs in msg */
    int32_t	rtm_refcnt;		/* reference count */
    int	rtm_parentflags;	/* flags of the parent route */
    int	rtm_reserved;		/* reserved field set to 0 */
    int	rtm_use;		/* from rtentry */
    u_int32_t rtm_inits;		/* which metrics we are initializing */
    struct rt_metrics rtm_rmx;	/* metrics themselves */
};

@interface Route_Info : NSObject
{
    struct sockaddr     m_addrs[RTAX_MAX];
    struct rt_msghdr2   m_rtm;
    int                 m_len;      /* length of the sockaddr array */
}
- initWithRtm: (struct rt_msghdr2*) rtm;

+ (NSMutableArray*) getRoutes;
+ (Route_Info*) getRoute:(struct rt_msghdr2 *)rtm;

- (NSString*) getDestination;
- (NSString*) getNetmask;
- (NSString*) getGateway;
- (NSString*) getAddrStringByIndex: (int)rtax_index;

+ (NSString*) getRouterIpAddress;

- (void) setAddr:(struct sockaddr*)sa index:(int)rtax_index;
@end

#endif
