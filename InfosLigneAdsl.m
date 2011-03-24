//
//  ListeClients.m
//  BoxPilot4
//
//  Created by Maxime Fiba on 13/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfosLigneAdsl.h" 
#import "Connection.h"


@implementation InfosLigneAdsl


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	//ajout des données
	//wifiNetwork = [[NSArray alloc] initWithObjects:@"F0:B4:34:C3:CB:D9 - 192.168.1.123",nil];
	[super viewDidLoad];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	//if qui permet de vérifier si l'Iphone possède une connection internet
	if(![Connection reseauDisponible]){
		[Connection afficherAlerte:@"Votre Iphone ne dispose pas de connection réseau. Vérifiez que votre WiFi est activé ou que vous avez accés à internet"];
	}
	else {
		
		if ([stories count]==0)
		{
			path = @"http://neufbox/api/1.0/?method=dsl.getInfo";
			[self parseXMLFileAtURL:path];
		}  
	}
	
}

- (void)parseXMLFileAtURL:(NSString *)URL {
	stories = [[NSMutableArray alloc] init];
	
	NSURL *xmlURL = [NSURL URLWithString:URL];
	
	rssParser=[[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
	[rssParser setDelegate:self];
	
	[rssParser setShouldProcessNamespaces:NO];
	
	[rssParser setShouldReportNamespacePrefixes:NO];
	
	[rssParser setShouldResolveExternalEntities:NO];
	
	[rssParser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"found file and started parsing");
}
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSString * errorString = [NSString stringWithFormat:@"Verifier que votre neufbox est allumée et que vous êtes connecté à celle-ci (Erreur n°%i)", [parseError code]];
    NSLog(@"error parsing XML: %@", errorString);
	
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Erreur: Aucune neufbox détectée" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    NSLog(@"found this element: %@", elementName);
    currentElement = [elementName copy];
	
    if ([elementName isEqualToString:@"rsp"]) {
        // clear out our story item caches...
        item = [[NSMutableDictionary alloc] init];
		currentDsl = [[NSMutableString alloc] init];
		/*currentDate = [[NSMutableString alloc] init];
		 currentSummary = [[NSMutableString alloc] init];
		 currentLink = [[NSMutableString alloc] init];*/
	}
	else if([elementName isEqualToString:@"dsl"]) {
		
		/*//Initialize the book.
		 currentProductId = [[NSMutableString alloc] init];
		 
		 //Extract the attribute here.
		 currentProductId= [attributeDict objectForKey:@"product_id"];*/		
		
		currentStatus = [[NSMutableString alloc] init];
		currentCounter = [[NSMutableString alloc] init];
		currentCrc = [[NSMutableString alloc] init];
		currentRateDown = [[NSMutableString alloc] init];
		currentRateUp = [[NSMutableString alloc] init];
		

		currentStatus = [attributeDict objectForKey:@"status"];
		if (currentStatus)
			NSLog(@"Adresse Mac: %@",currentStatus);
		
		currentCounter = [attributeDict objectForKey:@"counter"];
		if (currentCounter)
			NSLog(@"Modèle: %@",currentCounter);
		
		currentCrc = [attributeDict objectForKey:@"crc"];
		if (currentCrc)
			NSLog(@"Mode: %@",currentCrc);
		
		currentRateDown = [attributeDict objectForKey:@"rate_down"];
		if (currentRateDown)
			NSLog(@"Connection internet: %@",currentRateDown);
		
		currentRateUp = [attributeDict objectForKey:@"rate_up"];
		if (currentRateUp)
			NSLog(@"Temps d'activité de la box: %@",currentRateUp);
		return;
		
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	NSLog(@"ended element: %@", elementName);
	
    if ([elementName isEqualToString:@"rsp"]) {
		// save values to an item, then store that item into the array...
		[item setObject:currentDsl forKey:@"dsl"];
		[item setObject:currentStatus forKey:@"status"];
		[item setObject:currentCounter forKey:@"counter"];
		[item setObject:currentCrc forKey:@"crc"];
		[item setObject:currentRateDown forKey:@"rate_down"];
		[item setObject:currentRateUp forKey:@"rate_up"];
		
		//[stories addObject:currentSystem];
		
		
		/*[item setObject:currentLink forKey:@"link"];
		 [item setObject:currentSummary forKey:@"summary"];
		 [item setObject:currentDate forKey:@"date"];*/
		
		[stories addObject:[item copy]];
		
		
		//[stories addObject:currentSystem];
		//[stories addObject:currentProductId];
		//[stories addObject:currentStatus];
		//[stories addObject:currentCrc];
		
		NSLog(@"adding story: %@", currentDsl);
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSLog(@"found characters: %@", string);
    // save the characters for the current item...
    if ([currentElement isEqualToString:@"dsl"]) {
        [currentDsl appendString:string];
    }
	/*else if ([currentElement isEqualToString:@"product_id"]) {
	 [currentProductId appendString:string];
	 }*/
	/* else if ([currentElement isEqualToString:@"link"]) {
	 [currentLink appendString:string];
	 } else if ([currentElement isEqualToString:@"description"]) {
	 [currentSummary appendString:string];
	 } else if ([currentElement isEqualToString:@"pubDate"]) {
	 [currentDate appendString:string];
	 }*/
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
    NSLog(@"all done!");
    NSLog(@"stories array has %d items", [stories count]);
    [tblSimpleTable reloadData];
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */
/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */



#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [stories count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	
	int storyIndex = [indexPath indexAtPosition:[indexPath length]-1];
	
	
	// Set up the cell...
	if(indexPath.section == 0)
		cell.text = [[stories objectAtIndex:storyIndex] objectForKey:@"status"];
	else if(indexPath.section == 1)
		cell.text = [[stories objectAtIndex:storyIndex] objectForKey:@"counter"];
	else if(indexPath.section == 2)
		cell.text = [[stories objectAtIndex:storyIndex] objectForKey:@"crc"];
	else if(indexPath.section == 3)
		cell.text = [[stories objectAtIndex:storyIndex] objectForKey:@"rate_down"];
	else if(indexPath.section == 4)
		cell.text = [[stories objectAtIndex:storyIndex] objectForKey:@"rate_up"];
	return cell;
	
	
	//[stories addObject:[item setObject:currentSystem forKey:@"System"]];
	//
	
	//
	//cell.text = [[stories objectAtIndex:storyIndex] objectForKey:@"status"];
	//
	//
	//
	//
	
	
	//return cell;
	
	[currentStatus release];
	
}

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
 static NSString *CellIdentifier = @"CellIndent";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 UIViewController *c = [[UIViewController alloc] initWithNibName:@"TableViewCell" bundle:nil];
 cell = (TableViewCell *)c.view;
 [c release];
 }
 
 // Set up the cell...
 int storyIndex = [indexPath indexAtPosition:[indexPath length]-1];
 cell.label1.text = [[stories objectAtIndex:storyIndex] objectForKey:@"title"];
 return cell;
 }*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if(section == 0)
		return @"Statut de la connection";
	else if(section == 1)
		return @"Nombre de connexions effectuées";
	else if(section == 2)
		return @"Nombre d’erreurs CRC";
	else if(section == 3)
		return @"Débit flux descendant";
	else if(section == 4)
		return @"Débit flux montant";
}

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 return 1;
 }
 
 
 // Customize the number of rows in the table view.
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 return [stories count];
 }*/
// Customize the appearance of table view cells.
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
	 // ...
	 // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

