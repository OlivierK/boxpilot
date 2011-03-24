//
//  ListeClients.h
//  BoxPilot4
//
//  Created by Maxime Fiba on 13/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfosLigneAdsl : UITableViewController <NSXMLParserDelegate> {
	IBOutlet UITableView *tblSimpleTable;
	NSArray *infosSysteme;
	NSArray *lanNetwork;
	

	
	//IBOutlet UITableView *tutorielsTable;
	CGSize cellSize;
	NSXMLParser *rssParser;
	NSMutableArray *stories;
	
	NSMutableDictionary *item;
	
	NSString *path;
	
	NSString *currentElement;
	
	NSMutableString *currentDsl, *currentCounter, *currentStatus, *currentCrc, *currentRateDown, *currentRateUp, *currentLink;
}

- (void)parseXMLFileAtURL:(NSString *)URL;

@end
