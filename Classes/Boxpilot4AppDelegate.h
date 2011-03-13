//
//  Boxpilot4AppDelegate.h
//  Boxpilot4
//
//  Created by Maxime Fiba on 09/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Boxpilot4AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	//creation de la tabbar
	UITabBarController *tabBarController;
	UINavigationController *navigationBarController;
	
	
	NSURLConnection *getConnection;
	NSMutableData *getData;
	NSURLConnection *postConnection;
	NSMutableData *postData;

}


@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) UITabBarController *tabBarController;
@property (nonatomic, retain) UINavigationController *navigationBarController;
@end

