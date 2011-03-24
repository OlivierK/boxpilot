//
//  Connection.h
//  BoxPilot4
//
//  Created by Olivier on 10/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkConfiguration.h>
#import <netinet/in.h>

typedef enum {
	NotReachable = 0,
	ReachableViaWiFi,
	ReachableViaWWAN
} NetworkStatus;
#define kReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"

@interface Connection : NSObject {
	
BOOL localWiFiRef;
SCNetworkReachabilityRef reachabilityRef;
	
}

+(BOOL) reseauDisponible;
+(Connection*) reachabilityForLocalWiFi;
+(void) afficherAlerte:(NSString *)string;
+(void) afficherAlerteFirmware:(NSString *)string;
@end
