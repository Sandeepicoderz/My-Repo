//
//  AppDelegate.m
//  TestTab
//
//  Created by Ashish Sudra on 31/03/12.
//  Copyright (c) 2012 iCoderz. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"

#import "SecondViewController.h"

#import <stdio.h>
#import <string.h>

#import <mach/mach_host.h>
#import <sys/sysctl.h>
#import <mach/mach.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabCntlr, ttt1;
void printMemoryInfo()
{
	size_t length;
	int mib[6];	
	int result;
    
	printf("Memory Info\n");
	printf("-----------\n");
    
	int pagesize;
	mib[0] = CTL_HW;
	mib[1] = HW_PAGESIZE;
	length = sizeof(pagesize);
	if (sysctl(mib, 2, &pagesize, &length, NULL, 0) < 0)
	{
		perror("getting page size");
	}
	printf("Page size = %d bytes\n", pagesize);
	printf("\n");
    
	mach_msg_type_number_t count = HOST_VM_INFO_COUNT;
	
	vm_statistics_data_t vmstat;
	if (host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmstat, &count) != KERN_SUCCESS)
	{
		printf("Failed to get VM statistics.");
	}
	
	double total = vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count;
	double wired = vmstat.wire_count / total;
	double active = vmstat.active_count / total;
	double inactive = vmstat.inactive_count / total;
	double free = vmstat.free_count / total;
    
	printf("Total =    %8d pages\n", ((vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count)/4096));
	printf("\n");
	printf("Wired =    %8d bytes\n", vmstat.wire_count * pagesize);
	printf("Active =   %8d bytes\n", vmstat.active_count * pagesize);
	printf("Inactive = %8d bytes\n", vmstat.inactive_count * pagesize);
	printf("Free =     %8d bytes\n", vmstat.free_count * pagesize);
	printf("\n");
	printf("Total =    %8d bytes\n", (vmstat.wire_count + vmstat.active_count + vmstat.inactive_count + vmstat.free_count) * pagesize);
	printf("\n");
	printf("Wired =    %0.2f %%\n", wired * 100.0);
	printf("Active =   %0.2f %%\n", active * 100.0);
	printf("Inactive = %0.2f %%\n", inactive * 100.0);
	printf("Free =     %0.2f %%\n", free * 100.0);
	printf("\n");
    
	mib[0] = CTL_HW;
	mib[1] = HW_PHYSMEM;
	length = sizeof(result);
	if (sysctl(mib, 2, &result, &length, NULL, 0) < 0)
	{
		perror("getting physical memory");
	}
	printf("Physical memory = %8d bytes\n", result);
	mib[0] = CTL_HW;
	mib[1] = HW_USERMEM;
	length = sizeof(result);
	if (sysctl(mib, 2, &result, &length, NULL, 0) < 0)
	{
		perror("getting user memory");
	}
	printf("User memory =     %8d bytes\n", result);
	printf("\n");
}

void printProcessorInfo()
{
	size_t length;
	int mib[6];	
	int result;
    
	printf("Processor Info\n");
	printf("--------------\n");
    
	mib[0] = CTL_HW;
	mib[1] = HW_CPU_FREQ;
	length = sizeof(result);
	if (sysctl(mib, 2, &result, &length, NULL, 0) < 0)
	{
		perror("getting cpu frequency");
	}
	printf("CPU Frequency = %d hz\n", result);
	
	mib[0] = CTL_HW;
	mib[1] = HW_BUS_FREQ;
	length = sizeof(result);
	if (sysctl(mib, 2, &result, &length, NULL, 0) < 0)
	{
		perror("getting bus frequency");
	}
	printf("Bus Frequency = %d hz\n", result);
}

void report_memory(void) {
    static unsigned last_resident_size=0;
    static unsigned greatest = 0;
    static unsigned last_greatest = 0;
    
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        int diff = (int)info.resident_size - (int)last_resident_size;
        unsigned latest = info.resident_size;
        if( latest > greatest   )   greatest = latest;  // track greatest mem usage
        int greatest_diff = greatest - last_greatest;
        int latest_greatest_diff = latest - greatest;
        NSLog(@"Mem: %10u (%10d) : %10d :   greatest: %10u (%d)", info.resident_size, diff,
              latest_greatest_diff,
              greatest, greatest_diff  );
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
    last_resident_size = info.resident_size;
    last_greatest = greatest;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    printMemoryInfo();
    printProcessorInfo();
    report_memory();
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    ttt1 = [[Test1 alloc] initWithNibName:@"Test1" bundle:nil ];
    [self.window addSubview:ttt1.view];
    
    tabCntlr = [[tab alloc] initWithNibName:@"tab" bundle:nil];
    self.window.rootViewController = self.tabCntlr;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
