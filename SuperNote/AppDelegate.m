//
//  AppDelegate.m
//  SuperNote
//
//  Created by Venkata Maniteja on 2016-01-11.
//  Copyright © 2016 Venkata Maniteja. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "ContainerViewController.h"
#import "SuperNoteManager.h"


@interface AppDelegate ()
@property (nonatomic, strong) SuperNoteManager *myManager;
@property (nonatomic,assign) BOOL databaseCreated;
@property (nonatomic,strong) NSString *databasePath;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _databaseCreated=[[NSUserDefaults standardUserDefaults]boolForKey:@"DatabaseCreated"];
    _databasePath=[[NSUserDefaults standardUserDefaults]objectForKey:@"DataBasePath"];
    
    _myManager=[SuperNoteManager sharedInstance];
    
    if(!_databaseCreated){
            [_myManager createDatabaseAndTable];
            
        }else{
            
            _myManager.databasePath=_databasePath;
            _myManager.dataBaseCreated=YES;
            [_myManager loadDatabase];
            [self checkForData];
            NSLog(@"Database already exists");
            NSLog(@"data base path is %@",_myManager.databasePath);
        }


    return YES;
}


-(void)checkForData{
    
    
    
    [self changeHomeViewController];
}

-(void)changeHomeViewController{
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
