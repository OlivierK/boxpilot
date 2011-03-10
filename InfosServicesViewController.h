//
//  InfosServicesViewController.h
//  Boxpilot4
//
//  Created by Maxime Fiba on 09/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfosServicesViewController : UIViewController {
	UISwitch *firewall;
	UISwitch *wifi;
	UISwitch *telephone;
	UISwitch *hotspot;
	UILabel *firewallLabel;
	UILabel *wifiLabel;
	UILabel *telephoneLabel;
	UILabel *hotspotLabel;
	UIButton *rebootButton;

	NSURLConnection *getConnection;
	NSMutableData *getData;
	
	NSURLConnection *postConnection;
	NSMutableData *postData;


}
-(void)actualiserLabel:(NSData *)data;
-(void) getSynch;
//-(void) postSynch;
-(void) getAsynch;
//-(void) postAsynch;

@end
