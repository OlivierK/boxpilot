//
//  ListeClients.h
//  BoxPilot4
//
//  Created by Maxime Fiba on 13/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ListeClients : UITableViewController {
	IBOutlet UITableView *tblSimpleTable;
	//Creation des tableaux dans lesquels on met les données
	NSArray *wifiNetwork;
	NSArray *lanNetwork;
}

@end
