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
		rebootButton.frame = CGRectMake(19.0,360.0,280.0,45.0);
		[rebootButton setTitle:@"Rebooter la neufbox" forState:UIControlStateNormal];
		[rebootButton addTarget:self action:@selector(rebootBox:) forControlEvents:UIControlEventTouchUpInside];
		firewallLabel.text = @"Firewall";
		wifiLabel.text=@"Wifi";
		telephoneLabel.text=@"Téléphone";
		hotspotLabel.text=@"Hotspot";
		loggedTv = [[UITextView alloc] initWithFrame:CGRectMake(0.0,45.0,300.0,100.0)];
		loggedTv.text=@"Attention, la désactivation du wifi entraine la fermeture de l'application et vous oblige à redémarrer le hotspot manuellement.";
		loggedTv.font =[UIFont fontWithName:@"Helvetica" size:16.0];
		loggedTv.textAlignment = UITextAlignmentCenter;
		loggedTv.textColor = [UIColor redColor];
		
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
		
		loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 100, 20.0)];
		loginLabel.text=@"Login";
		passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 190, 100, 20.0)];
		passwordLabel.text=@"Password";
		champlogin = [[UITextField alloc] initWithFrame:CGRectMake(20.0,160.0,280.0,30.0)];
		champlogin.textColor=[UIColor blackColor];
		[champlogin setDelegate:self];
		[champlogin setKeyboardType:UIKeyboardTypeDefault];
		[champlogin setClearsOnBeginEditing:YES];
		champlogin.borderStyle = UITextBorderStyleRoundedRect;
		champpassword = [[UITextField alloc] initWithFrame:CGRectMake(20.0,210.0,280.0,30.0)];
		champpassword.textColor=[UIColor blackColor];
		champpassword.borderStyle = UITextBorderStyleRoundedRect;
		[champpassword setDelegate:self];
		[champpassword setKeyboardType:UIKeyboardTypeDefault];
		[champpassword setClearsOnBeginEditing:YES];
		loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		loginButton.frame = CGRectMake(20.0,300.0,280.0,45.0);
		[loginButton setTitle:@"S'identifier" forState:UIControlStateNormal];
		[loginButton addTarget:self action:@selector(selogger:) forControlEvents:UIControlEventTouchUpInside];
		//texte
		loginTv = [[UITextView alloc] initWithFrame:CGRectMake(0.0,45.0,300.0,100.0)];
		loginTv.text=@"Veuillez vous identifier pour accéder aux services.";
		loginTv.font =[UIFont fontWithName:@"Helvetica" size:16.0];
		loginTv.textAlignment = UITextAlignmentCenter;
		loginTv.textColor = [UIColor redColor];

		[self.view addSubview:loginTv];

		[self.view addSubview:champlogin];
		[self.view addSubview:loginLabel];
		[self.view addSubview:champpassword];
		[self.view addSubview:passwordLabel];
		[self.view addSubview:loginButton];

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
