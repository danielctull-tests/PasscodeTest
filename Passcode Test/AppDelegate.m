//
//  AppDelegate.m
//  Passcode Test
//
//  Created by Daniel Tull on 28.02.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate {
	NSURL *_fileURL;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOption {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];

	NSString *string = @"Test";
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
																  inDomains:NSUserDomainMask] lastObject];
	_fileURL = [documentsURL URLByAppendingPathComponent:@"test"];

	NSLog(@"%@", _fileURL);

	[data writeToURL:_fileURL options:NSDataWritingFileProtectionComplete error:NULL];

	NSData *data2 = [NSData dataWithContentsOfURL:_fileURL options:NSDataReadingUncached error:NULL];
	NSString *string2 = [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding];

	NSLog(@"%@ %@", string, string2);

	NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
	NSURL *fileURL = [temporaryDirectoryURL URLByAppendingPathComponent:@"passcodetest"];
	[@"" writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:NULL];
	NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[fileURL path] error:NULL];

	NSLog(@"Given: %@", [attributes objectForKey:NSFileProtectionKey]);
	NSLog(@"%@", NSFileProtectionNone);
	NSLog(@"%@", NSFileProtectionComplete);
	NSLog(@"%@", NSFileProtectionCompleteUnlessOpen);
	NSLog(@"%@", NSFileProtectionCompleteUntilFirstUserAuthentication);

	return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

	UIBackgroundTaskIdentifier backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];

	[[NSOperationQueue new] addOperationWithBlock:^{
		NSData *data = [NSData dataWithContentsOfURL:_fileURL options:NSDataReadingUncached error:NULL];
		NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@", string);
		[[UIApplication sharedApplication] endBackgroundTask:backgroundTaskIdentifier];
	}];



}

@end
