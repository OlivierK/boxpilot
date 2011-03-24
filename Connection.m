//
//  connection.m
//  BoxPilot4
//
//  Created by Olivier on 10/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Connection.h"


@implementation Connection


+(BOOL) reseauDisponible{
	
	
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	
	SCNetworkReachabilityRef defaultRouteReachability =
	SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags =
	SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if(!didRetrieveFlags)
		return NO;
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
	
}
/* Fonctions pour tester le WiFI
+ (Connection*) reachabilityForLocalWiFi;
{
	struct sockaddr_in localWifiAddress;
	bzero(&localWifiAddress, sizeof(localWifiAddress));
	localWifiAddress.sin_len = sizeof(localWifiAddress);
	localWifiAddress.sin_family = AF_INET;
	// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0
	localWifiAddress.sin_addr.s_addr = htonl(IN_LINKLOCALNETNUM);
	Connection* retVal = [self reachabilityWithAddress: &localWifiAddress];
	if(retVal!= NULL)
	{
		retVal->localWiFiRef = YES;
	}
	return retVal;
}

- (NetworkStatus) localWiFiStatusForFlags: (SCNetworkReachabilityFlags) flags
{
	PrintReachabilityFlags(flags, "localWiFiStatusForFlags");
	
	BOOL retVal = NotReachable;
	if((flags & kSCNetworkReachabilityFlagsReachable) && (flags & kSCNetworkReachabilityFlagsIsDirect))
	{
		retVal = ReachableViaWiFi;	
	}
	return retVal;
}*/

+(void) afficherAlerte:(NSString *)string{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur: Absence de réseau"
													message:string delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

+(void) afficherAlerteFirmware:(NSString *)string{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur: Mauvais firmware"
													message:string delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}
+(void) afficherAlerteIdentification:(NSString *)string{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur: Problème d'identification"
													message:string delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}




@end
