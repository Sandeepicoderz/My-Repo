//
//  AppDelegate.h
//  TestTab
//
//  Created by Ashish Sudra on 31/03/12.
//  Copyright (c) 2012 iCoderz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tab.h"
#import "Test1.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) tab *tabCntlr;
@property (strong, nonatomic) Test1 *ttt1;

@end
