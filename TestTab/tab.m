//
//  tab.m
//  TestTab
//
//  Created by Ashish Sudra on 11/04/12.
//  Copyright (c) 2012 iCoderz. All rights reserved.
//

#import "tab.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@implementation tab

@synthesize tabbarCntlr;

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
    
    UIViewController *viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    UINavigationController *navCntlr = [[UINavigationController alloc] initWithRootViewController:viewController1];
    UIViewController *viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
    self.tabbarCntlr = [[UITabBarController alloc] init];
    
    self.tabbarCntlr.viewControllers = [NSArray arrayWithObjects:navCntlr, viewController2, nil];
    
    [self.view addSubview:self.tabbarCntlr.view];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
