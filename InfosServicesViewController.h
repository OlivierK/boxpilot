//
//  InfosServicesViewController.h
//  Boxpilot4
//
//  Created by Maxime Fiba on 09/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfosServicesViewController : UIViewController<UITextFieldDelegate> {
	UISwitch *firewall;
	UISwitch *wifi;
	UISwitch *telephone;
	UISwitch *hotspot;
	UILabel *firewallLabel;
	UILabel *wifiLabel;
	UILabel *telephoneLabel;
	UILabel *hotspotLabel;
	UILabel *loginLabel;
	UILabel *passwordLabel;
	UITextField *champlogin;
	UITextField *champpassword;
	UIButton *rebootButton;
	UIButton *loginButton;
	UIButton *loginByServiceButton;
	UILabel *btnServiceLabel;
	UILabel *loginTv;
	UILabel *loggedTv;


	NSURLConnection *getConnection;
	NSMutableData *getData;
	
	NSURLConnection *postConnection;
	NSMutableData *postData;
	
	//parsage XML
	NSXMLParser *rssParser;
	NSMutableArray *stories;
	
	NSMutableDictionary *item;
	
	NSString *path;
	
	NSString *currentElement;
	
	NSMutableString *currentAuth, *currentToken, *currentConnection, *currentHost, *currentStat, *currentDate, *currentSummary, *currentLink;
	


}
-(void)actualiserLabel:(NSData *)data;
-(void) getSynch:(NSString *)string;
//-(void) postSynch;
-(void) getAsynch;
//fct check statut service
-(void) checkServices;
//gestion du login
-(IBAction)selogger:(id)sender;
- (void) identification:(NSString *)log withPassword:(NSString *) pass;
//-(void) postAsynch;

@end
