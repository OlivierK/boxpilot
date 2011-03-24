//
//  InfosServicesViewController.m
//  Boxpilot4
//
//  Created by Maxime Fiba on 09/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InfosServicesViewController.h"
#import "Connection.h"


@implementation InfosServicesViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

//test login
NSString* login = @"ok";



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	


	[self testLogin];

	
    [super viewDidLoad];
	
	
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
		currentAuth = [[NSMutableString alloc] init];
		currentConnection = [[NSMutableString alloc] init];

		currentConnection = [attributeDict objectForKey:@"stat"];
		if (currentConnection)
			NSLog(@"Stat: %@",currentConnection);
		return;
		
	}
	else if([elementName isEqualToString:@"auth"]) {
		
		currentToken = [[NSMutableString alloc] init];
		currentConnection = [[NSMutableString alloc] init];
		
		currentToken = [attributeDict objectForKey:@"token"];
		if (currentToken)
			NSLog(@"Token: %@",currentToken);
		return;		
		
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	NSLog(@"ended element: %@", elementName);
	
    if ([elementName isEqualToString:@"rsp"]) {
		// save values to an item, then store that item into the array...
		
		[item setObject:currentToken forKey:@"token"];
		[item setObject:currentConnection forKey:@"stat"];
		
		[stories addObject:[item copy]];
		
		NSLog(@"adding story: %@", currentAuth);
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    NSLog(@"found characters: %@", string);
    // save the characters for the current item...
    if ([currentElement isEqualToString:@"auth"]) {
        [currentAuth appendString:string];
    }
	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
    NSLog(@"all done!");
    NSLog(@"stories array has %d items", [stories count]);
    //[tblSimpleTable reloadData];
}

-(void) postSynch:(NSString*)commande{
	//verif de la dispo du réseau
	if(![Connection reseauDisponible]){
		[Connection afficherAlerte:@"Le r√©seau est indisponible"];
	}
	else {
		NSURL *url = [NSURL URLWithString:@"http://neufbox/api/1.0/?method="];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
		//passage du param dans le corps de la requ√™te m√©thode post
		[request setHTTPMethod:@"POST"];
		[request setHTTPBody:[commande 
							  dataUsingEncoding:NSUTF8StringEncoding]];
		NSURLResponse *reponse = nil;
		NSError *error = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:request 
											 returningResponse:&reponse error:&error];
		//l'appli bloque ici le temps d'ex√©cuter la requ√™te
		if(error){
			//affichage de l'erreur
			[Connection afficherAlerte:[error localizedDescription]];
		}
	}
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//Gestion des événements du switch
- (void)gestionFirewall:(id)sender{
	if (firewall.on) {
		//firewallLabel.text = @"Firewall ON";
		[self getSynch:@"http://neufbox/api/1.0/?method=auth.getToken"];
		
	}else {
			firewallLabel.text = @"Firewall OFF";
	}

	//UISwitch *theSwitch = (UISwitch*)sender;
}

//masquage si pas de login
- (void)testLogin{
	if(login == @"k")
	{	
		
		//effaçage de la partie login
		[loginTv removeFromSuperview];
		[loginLabel removeFromSuperview];
		[passwordLabel removeFromSuperview];
		[champlogin removeFromSuperview];
		[champpassword removeFromSuperview];
		[loginButton removeFromSuperview];
		[btnServiceLabel removeFromSuperview];
		[loginByServiceButton removeFromSuperview];
		//creation de l'interface
		firewall =[[UISwitch alloc] initWithFrame:CGRectMake(198.0,160.0,94.0,27.0)];
		[firewall addTarget:self action:@selector(gestionFirewall:)
		   forControlEvents:UIControlEventValueChanged];
		wifi =[[UISwitch alloc] initWithFrame:CGRectMake(198.0,210.0,94.0,27.0)];
		[wifi addTarget:self action:@selector(gestionWifi:)
	   forControlEvents:UIControlEventValueChanged];
		telephone =[[UISwitch alloc] initWithFrame:CGRectMake(198.0,260.0,94.0,27.0)];
		[telephone addTarget:self action:@selector(gestionTelephone:)
			forControlEvents:UIControlEventValueChanged];
		hotspot =[[UISwitch alloc] initWithFrame:CGRectMake(198.0,310.0,94.0,27.0)];
		[hotspot addTarget:self action:@selector(gestionHotSpot:)
		  forControlEvents:UIControlEventValueChanged];
		firewallLabel = [[UILabel alloc] initWithFrame:CGRectMake(37.0,160.0,150.0,20.0)];
		wifiLabel = [[UILabel alloc] initWithFrame:CGRectMake(37.0,210.0,150.0,20.0)];
		telephoneLabel= [[UILabel alloc] initWithFrame:CGRectMake(37.0,260.0,150.0,20.0)];
		hotspotLabel= [[UILabel alloc] initWithFrame:CGRectMake(37.0,310.0,150.0,20.0)];
		rebootButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		rebootButton.frame = CGRectMake(20.0,360.0,280.0,45.0);
		[rebootButton setTitle:@"Rebooter la neufbox" forState:UIControlStateNormal];
		[rebootButton addTarget:self action:@selector(rebootBox:) forControlEvents:UIControlEventTouchUpInside];
		firewallLabel.text = @"Firewall";
		wifiLabel.text=@"Wifi";
		telephoneLabel.text=@"Téléphone";
		hotspotLabel.text=@"Hotspot";
		loggedTv = [[UILabel alloc] initWithFrame:CGRectMake(0.0,45.0,320.0,100.0)];
		loggedTv.text=@"Attention, la désactivation du wifi \n entraine la fermeture de l'application \net vous oblige  à redémarrer le hotspot manuellement.";
		loggedTv.font =[UIFont fontWithName:@"Helvetica" size:16.0];
		loggedTv.textAlignment = UITextAlignmentCenter;
		loggedTv.textColor = [UIColor redColor];
		loggedTv.numberOfLines=4;
		loggedTv.textAlignment=UITextAlignmentCenter;
		loggedTv.backgroundColor = [UIColor clearColor];
		telephoneLabel.backgroundColor = [UIColor clearColor];
		wifiLabel.backgroundColor = [UIColor clearColor];
		hotspotLabel.backgroundColor = [UIColor clearColor];
		firewallLabel.backgroundColor = [UIColor clearColor];
		
		[self.view addSubview:loggedTv];
	
		[self.view addSubview:firewall];
		[self.view addSubview:wifi];
		[self.view addSubview:telephone];
		[self.view addSubview:hotspot];
		[self.view addSubview:rebootButton];
		[self.view addSubview:firewallLabel];
		[self.view addSubview:wifiLabel];
		[self.view addSubview:telephoneLabel];
		[self.view addSubview:hotspotLabel];
		
		//test des services
		[self checkServices];
		[firewall release];
		[wifi release];
		[telephone release];
		[hotspot release];
		[firewallLabel release];
		[wifiLabel release];
		[telephoneLabel release];
		[hotspotLabel release];
		[loggedTv release];
	}else {
		//formulaire de connexion
		
		loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 100, 20.0)];
		loginLabel.text=@"Login";
		passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, 100, 20.0)];
		passwordLabel.text=@"Password";
		champlogin = [[UITextField alloc] initWithFrame:CGRectMake(20.0,140.0,280.0,30.0)];
		champlogin.textColor=[UIColor blackColor];
		[champlogin setDelegate:self];
		[champlogin setKeyboardType:UIKeyboardTypeDefault];
		[champlogin setClearsOnBeginEditing:YES];
		champlogin.borderStyle = UITextBorderStyleRoundedRect;
		champpassword = [[UITextField alloc] initWithFrame:CGRectMake(20.0,190.0,280.0,30.0)];
		champpassword.textColor=[UIColor blackColor];
		champpassword.borderStyle = UITextBorderStyleRoundedRect;
		[champpassword setDelegate:self];
		[champpassword setKeyboardType:UIKeyboardTypeDefault];
		[champpassword setClearsOnBeginEditing:YES];
		loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		loginButton.frame = CGRectMake(20.0,230.0,280.0,45.0);
		[loginButton setTitle:@"S'identifier" forState:UIControlStateNormal];
		[loginButton addTarget:self action:@selector(selogger:) forControlEvents:UIControlEventTouchUpInside];
		loginByServiceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		loginByServiceButton.frame = CGRectMake(20.0,350.0,280.0,45.0);
		[loginByServiceButton setTitle:@"Bouton service" forState:UIControlStateNormal];
		[loginByServiceButton addTarget:self action:@selector(loginByButton:) forControlEvents:UIControlEventTouchUpInside];
		
		//texte
		loginTv = [[UILabel alloc] initWithFrame:CGRectMake(0.0,35.0,320,100.0)];
		loginTv.text=@"Veuillez vous identifier afin \n d'accéder aux services.";
		loginTv.font =[UIFont fontWithName:@"Helvetica" size:16.0];
		loginTv.numberOfLines=2;
		loginTv.textAlignment = UITextAlignmentCenter;
		loginTv.textColor = [UIColor redColor];
		loginTv.textAlignment=UITextAlignmentCenter;
		loginTv.backgroundColor = [UIColor clearColor];
		btnServiceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,270.0,320,100.0)];
		btnServiceLabel.text=@"Ou appuyez 5 secondes\n sur le bouton service.";
		btnServiceLabel.font =[UIFont fontWithName:@"Helvetica" size:16.0];
		btnServiceLabel.numberOfLines=2;
		btnServiceLabel.textAlignment = UITextAlignmentCenter;
		btnServiceLabel.textColor = [UIColor redColor];
		btnServiceLabel.textAlignment=UITextAlignmentCenter;
		btnServiceLabel.backgroundColor = [UIColor clearColor];
		loginLabel.backgroundColor = [UIColor clearColor];
		passwordLabel.backgroundColor = [UIColor clearColor];
		[self.view addSubview:loginTv];

		[self.view addSubview:champlogin];
		[self.view addSubview:loginLabel];
		[self.view addSubview:champpassword];
		[self.view addSubview:passwordLabel];
		[self.view addSubview:loginButton];
		[self.view addSubview:loginByServiceButton];
		[self.view addSubview:btnServiceLabel];


		[loginLabel release];
		[champlogin release];
		[passwordLabel release];
		[champpassword release];
		[loginTv release];
		//pas de release pour button sinon crash?

	}
}


- (void)gestionWifi:(id)sender{
	if (wifi.on) {
		wifiLabel.text = @"Wifi ON";
	}else {
		wifiLabel.text = @"wifi OFF";
	}
}

- (void)gestionTelephone:(id)sender{
	if (telephone.on) {
		telephoneLabel.text = @"Telephone ON";
	}else {
	telephoneLabel.text = @"Telephone OFF";
	}
}
- (void)gestionHotSpot:(id)sender{
	if (hotspot.on) {
		hotspotLabel.text = @"HotSpot ON";
	}else {
		hotspotLabel.text = @"Hotspot OFF";
	}	
}

//fct reboot
- (void)rebootBox:(id)sender{
	//UISwitch *theSwitch = (UISwitch*)sender;
}

//fct login
- (void)selogger:(id)sender{
//appel identification avec les paramètres
	[self identification:champlogin.text withPassword:champpassword.text];

}

- (void)loginByButton:(id)sender{
//login par bouton service
	login=@"k";

	if(![Connection reseauDisponible]){
		[Connection afficherAlerte:@"Votre Iphone ne dispose pas de connection réseau. Vérifiez que votre WiFi est activé ou que vous avez accés à internet"];
	}
	else {
		
		if ([stories count]==0)
		{
			path = @"http://neufbox/api/1.0/?method=auth.getToken";
			[self parseXMLFileAtURL:path];
			[Connection afficherAlerte:currentToken];
		}  
		
		
		if (currentToken)
		{
			
			//path = @"http://neufbox/api/1.0/?method=auth.checkToked=%@",currentToken;
			
			path=[NSString stringWithFormat:@"http://neufbox/api/1.0/?method=auth.checkToken\\&token=%@",currentToken];
			[self parseXMLFileAtURL:path];
			[Connection afficherAlerte:path];
			[Connection afficherAlerte:currentConnection];
		}  
		if(currentConnection=="ok")
			[self testLogin];
		else 
			[Connection afficherAlerteIdentification:@"Le délai a été dépacé ou le bouton n'a pas été appuyé"];

	}
 

}

- (void) identification:(NSString *) log withPassword:(NSString *) pass{
	log = @"Ok";
	pass = @"Ok";
	if(log == @"Ok" && pass == @"Ok")
	{

		login=@"k";
		[self testLogin];

	}
}

- (void)actualiserLabel:(NSData *)data{
	
	NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding ];
	firewallLabel.text=message;
	[message release];
}
	
- (void) getAsynch{
	//on passe le paramettre dans l'url -> Get
	
	NSURL *url = [NSURL URLWithString: @"http://www.ipup.fr/livre/getPost?parametre=get_a_synch"];
	NSURLRequest* request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:40.0];
	getConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
	getData = [[NSMutableData data] retain];
	[getConnection release];
}


- (void) getSynch:(NSString *)string{
	if(![Connection reseauDisponible]){
		[Connection afficherAlerte:@"Pas de réseau disponible"];
	}
	else {
		//on passe le paramettre dans l'url -> methode Get
		NSURL *url = [[NSURL alloc] initWithString:string];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
		[url release];
		NSURLResponse *response=nil;
		NSError *error=nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:request
											 returningResponse:&response error:&error];
		//l'application va bloquer ici le temps de faire la requete
		[request release];
		[self actualiserLabel:data];
		if(error){
			[Connection afficherAlerte:[error localizedDescription]];
		}		
	}
}


//methode qui rétracte le clavier lors du clic sur retour
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if(textField == champlogin || textField == champpassword) {
		//Permet la rétractation du clavier virtuel
		[textField resignFirstResponder];
	}
	return YES;
}

-(void) checkServices{
	[hotspot setOn:YES animated:YES];
	[firewall setOn:YES animated:YES];

}
		

- (void)dealloc {


    [super dealloc];
}


@end
