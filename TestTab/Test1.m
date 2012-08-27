//
//  Test1.m
//  TestTab
//
//  Created by Ashish Sudra on 02/04/12.
//  Copyright (c) 2012 iCoderz. All rights reserved.
//

#import "Test1.h"
#import "test2.h"
#import <QuartzCore/QuartzCore.h>
#import "tab.h"

@implementation Test1

@synthesize vwInner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(IBAction)dismissVw{
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)ho{
    tab *tt = [[tab alloc] initWithNibName:@"tab" bundle:nil];
//    test2 *tts = [[test2 alloc] initWithNibName:@"test2" bundle:nil];
//    [self presentModalViewController:tts animated:YES];
}

@end
