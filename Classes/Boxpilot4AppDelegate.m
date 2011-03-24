//
//  Boxpilot4AppDelegate.m
//  Boxpilot4
//
//  Created by Maxime Fiba on 09/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Boxpilot4AppDelegate.h"
#import "InfosBox.h"
#import "InfosServicesViewController.h"
#import "ListeClients.h"
#import "InfosLigneAdsl.h"


@implementation Boxpilot4AppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize navigationBarController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

	
	self.tabBarController = [[[UITabBarController alloc] init]autorelease];

    // Override point for customization after application launch.
	InfosBox *infosbox = [[InfosBox alloc]
						  initWithNibName:@"InfosBox" bundle:nil];
	UITabBarItem *itemBox = [[UITabBarItem alloc] initWithTitle:@"Box" image:[UIImage imageNamed:@"infosBox.png"] tag:2]; 
	infosbox.tabBarItem = itemBox;
	infosbox.title=@"Infos box";
	
	InfosLigneAdsl *ligneAdsl = [[InfosLigneAdsl alloc]
								 initWithNibName:@"InfosLigneAdsl" bundle:nil];
	UITabBarItem *itemAdsl = [[UITabBarItem alloc] initWithTitle:@"Adsl" image:[UIImage imageNamed:@"infosAdsl.png"] tag:1]; 
	ligneAdsl.tabBarItem = itemAdsl;
	ligneAdsl.title=@"Infos ligne Adsl";
	
	
	ListeClients *infosclients = [[ListeClients alloc]
								  initWithNibName:@"ListeClients" bundle:nil];
	UITabBarItem *itemClients = [[UITabBarItem alloc] initWithTitle:@"clts" image:[UIImage imageNamed:@"infosClients.png"] tag:3]; 
	infosclients.tabBarItem = itemClients;
	infosclients.title=@"Liste clients";
	/*InfosClientsViewController *infosclients = [[InfosClientsViewController alloc]
								  initWithNibName:@"InfosClientsViewController" bundle:nil];
	infosclients.title=@"clients";*/
	
	InfosServicesViewController *services = [[InfosServicesViewController alloc]
						initWithNibName:@"InfosServicesViewController" bundle:nil];
							 services.title=@"Gestion Services";
	UITabBarItem *itemServices = [[UITabBarItem alloc] initWithTitle:@"Services" image:[UIImage imageNamed:@"gestionServices.png"] tag:1]; 
	services.tabBarItem = itemServices;

	
	
	//ajout des controleurs aux tabbar
	tabBarController.viewControllers = [NSArray arrayWithObjects:infosbox,ligneAdsl,infosclients,services,nil];
	[infosclients release];
	[infosbox release];
	[services release];
	[ligneAdsl release];
	[itemClients release];
	[itemBox release];
	[itemAdsl release];
	[itemServices release];
	[window addSubview:tabBarController.view];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark NSURLConnection delegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if(connection == getConnection)
	{
		[getData appendData:data];
	}
	else if(connection == postConnection)
	{
		[postData appendData:data];
	}
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if(connection == getConnection)
	{
		[getData release];
	}
	else if(connection == postConnection)
	{
		[postData release];
	}
	[connection afficherAlerte:[error localizedDescription]];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection{
	if(connection == getConnection)
	{
		[self actualiserLabel:getData];
		[getData release];
	}
	else if(connection == postConnection)
	{
		[self actualiserLabel:postData];
		[postData release];
	}
}

@end
