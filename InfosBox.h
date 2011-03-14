//
//  ListeClients.h
//  BoxPilot4
//
//  Created by Maxime Fiba on 13/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfosBox : UITableViewController {
	IBOutlet UITableView *tblSimpleTable;
	NSArray *wifiNetwork;
	NSArray *lanNetwork;
}

@end
