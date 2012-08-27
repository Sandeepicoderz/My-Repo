//
//  FirstViewController.m
//  TestTab
//
//  Created by Ashish Sudra on 31/03/12.
//  Copyright (c) 2012 iCoderz. All rights reserved.
//

#import "FirstViewController.h"
#import "Test1.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@implementation FirstViewController

@synthesize sc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyPressed:) name: UITextFieldTextDidChangeNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyPressed:) name: UITextFieldTextDidEndEditingNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyPressed:) name: UITextFieldTextDidBeginEditingNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyPressed:) name: UITextViewTextDidChangeNotification object: nil];

    
    sc = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    [sc setDividerImage:[UIImage imageNamed:@""] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [sc setApportionsSegmentWidthsByContent:YES];
    
    CKSMSService *smsService = [CKSMSService sharedSMSService];
    
    //id ct = CTTelephonyCenterGetDefault();
    CKConversationList *conversationList = nil;
    
    NSString *value =[[UIDevice currentDevice] systemVersion];          
    if([value hasPrefix:@"5"])
    {
        //CKMadridService *madridService = [CKMadridService sharedMadridService];
        //NSString *foo = [madridService _temporaryFileURLforGUID:@"A5F70DCD-F145-4D02-B308-B7EA6C248BB2"];
        
        NSLog(@"Sending SMS");
        conversationList = [CKConversationList sharedConversationList];
        CKSMSEntity *ckEntity = [smsService copyEntityForAddressString:Phone];
        CKConversation *conversation = [conversationList conversationForRecipients:[NSArray arrayWithObject:ckEntity] create:TRUE service:smsService];
        NSString *groupID = [conversation groupID];           
        CKSMSMessage *ckMsg = [smsService _newSMSMessageWithText:msg forConversation:conversation];
        [smsService sendMessage:ckMsg];
        [ckMsg release];     
        
    } else {
        //4.0
        id ct = CTTelephonyCenterGetDefault();
        void* address = CKSMSAddressCreateWithString(pid); 
        
        int group = [grp intValue];         
        
        if (group <= 0) {
            group = CKSMSRecordCreateGroupWithMembers([NSArray arrayWithObject:address]);       
        }
        
        void *msg_to_send = _CKSMSRecordCreateWithGroupAndAssociation(NULL, address, msg, group, 0);    
        CKSMSRecordSend(ct, msg_to_send);        
    }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)go{
    AppDelegate *addDel = [[UIApplication sharedApplication] delegate];
    [self.navigationController pushViewController:addDel.ttt1 animated:YES];
    //[self.view addSubview:tt.view];
    //[self presentModalViewController:tt animated:YES];
}

@end
