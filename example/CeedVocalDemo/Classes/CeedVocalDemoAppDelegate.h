//
//  CeedVocalDemoAppDelegate.h
//  CeedVocalDemo
//
//  Created by Raphael Sebbe on 17/04/09.
//  Copyright Creaceed 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVSpeechRecognizer.h"

@class CeedVocalDemoViewController;

@interface CeedVocalDemoAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	CeedVocalDemoViewController *viewController;
	
	CVSpeechRecognizer *speechRecognizer;
	
	//BOOL _ignoresRecognition;
	
	BOOL _restartRecognizer;
	
	NSString *result;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CeedVocalDemoViewController *viewController;

- (IBAction)toggleRecognition:sender;
- (IBAction)updateResult:sender;

@end

