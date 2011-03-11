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

+(void) afficherAlerte:(NSString *)string{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerte"
													message:string delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
}

@end
