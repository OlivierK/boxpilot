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


@interface Connection : NSObject 
	
+(BOOL) reseauDisponible;
+(void) afficherAlerte:(NSString *)string;
+(void) afficherAlerteFirmware:(NSString *)string;
@end
