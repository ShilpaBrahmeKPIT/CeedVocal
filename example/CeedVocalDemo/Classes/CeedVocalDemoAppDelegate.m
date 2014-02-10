//
//  CeedVocalDemoAppDelegate.m
//  CeedVocalDemo
//
//  Created by Raphael Sebbe on 17/04/09.
//  Copyright Creaceed 2009. All rights reserved.
//

#import "CeedVocalDemoAppDelegate.h"
#import "CeedVocalDemoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@implementation CeedVocalDemoAppDelegate

@synthesize window;
@synthesize viewController;


- (void)dealloc {
	[viewController release];
	[window release];
	[super dealloc];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	//NSLog(@"%s", _cmd);
	
	if(_restartRecognizer && !speechRecognizer.recognitionStarted)
	{
		NSLog(@"restarting recognizer");
		[speechRecognizer startRecognition];
	}
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	//NSLog(@"%s", _cmd);
	
	if(speechRecognizer.recognitionStarted)
	{
		NSLog(@"stopping recognizer");
		_restartRecognizer = YES;
		[speechRecognizer stopRecognition];
	}
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	
	// Override point for customization after app launch    
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
	
	NSError *error = nil;
	
	NSLog(@"setting audio session...");
	if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:&error])
	{
		NSLog(@"setCategory error %@", error);
	}
//	if(![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
//	{
//		NSLog(@"error: %@", error);
//	}
	NSLog(@"audio session set");
	
	NSLog(@"setting active...");
	if(![[AVAudioSession sharedInstance] setActive:YES error:&error])
	{
		NSLog(@"error: %@", error);		
	}
	NSLog(@"set");
	
	//	[[[NSClassFromString(@"SPGlobalRingRecorder") class] sharedRingRecorder] clearBuffer];
	//	[[[NSClassFromString(@"SPGlobalRingRecorder") class] sharedRingRecorder] startRecording];
	
	// set your license here
	[CVSpeechRecognizer setLicense:@"7LFL5377HNPG6HQOV7H572Q3FLNTUGZ3N7PQ7T37V7PU72Q3NR6F3252DPFNVGP2FN642DL4VQ6G2OZ676XQ47R3HRWB37NNBU5RX26LZMWT4PX7N7F4W7L4PU5TZ7NNBR6DWKW3HLF4W3O5DM5RXP36PY7JVS6LJZHE5WZPHY7P6363B7H67S35PR6Q5SZ4D3HT43Y6P2XP3LYOP3VSVWZ23N7X47Y33KM7UPX7V4HH4O26N4PA5L6P37VBWKW3HIN5VGP2P6XQ67W2TGU7VD3PV3NC6PR6V577VS4PN6XNVGNJ7IHH4HVP35H5UD6P57NQ6HTPF4HW63377LFQ47Q6V7PU7WUZVH5I635O3JXV4L777LFY635O3KM2T6T6DZXG7S62TGU7VD3PV3NG7PR6V4PC67VPZ7PX2L36N75MXD3PV3NJTKP2P4XX4362DI5CUCXLFINOWOS2PQVAVGQKFKNBVKU47LFX6L36N7NJTKP2R5X25WW7F7XW76WLR5X25WUZVH5A47Q6V7PU7WQNN5XX6XGPB4X776WLBZ7B5L67J7NJT6WLP6XQ67W2TH5MWPX7V4HH5WUZHE"];

// When keyword spotting is activated, you can speak any phrase that contain one of the words.
// To try it, uncomment next line:
	
//#define USE_KEYWORD_SPOTTING
#ifdef USE_KEYWORD_SPOTTING
	speechRecognizer = [[CVSpeechRecognizer alloc] initWithLanguage:CV_LANGUAGE_ENGLISH 
													  acousticModel:[[NSBundle mainBundle] pathForResource:@"ceedmodel-en" ofType:@"enchmm"]
															   mode:CV_KEYWORD_SPOTTING];
	
	[speechRecognizer addPhrase:@"flower"];
	[speechRecognizer addPhrase:@"sun"];
	[speechRecognizer addPhrase:@"mountain"];
	[speechRecognizer addPhrase:@"river"];
	[speechRecognizer addPhrase:@"sky"];
	[speechRecognizer addPhrase:@"clouds"];
	
#else
	speechRecognizer = [[CVSpeechRecognizer alloc] initWithLanguage:CV_LANGUAGE_ENGLISH acousticModel:[[NSBundle mainBundle] pathForResource:@"ceedmodel-en" ofType:@"enchmm"]];
	
	[speechRecognizer addPhrase:@"flower"];
	[speechRecognizer addPhrase:@"sun"];
	[speechRecognizer addPhrase:@"mountain"];
	[speechRecognizer addPhrase:@"river"];
	[speechRecognizer addPhrase:@"sky"];
	[speechRecognizer addPhrase:@"clouds"];
	
#endif
	speechRecognizer.delegate = self;
	
	
	
	[speechRecognizer prepareRecognizer];
}


- (IBAction)toggleRecognition:sender
{
	NSLog(@"toggling...");
	if(speechRecognizer.recognitionStarted) [speechRecognizer stopRecognition];
	else [speechRecognizer startRecognition];
	NSLog(@"toggled.");
}

- (IBAction)startRecognition:sender
{
	//_ignoresRecognition = NO;
	NSLog(@"starting...");
	[speechRecognizer startRecognition]; 
	NSLog(@"started...");
}

- (IBAction)stopRecognition:sender
{
	[speechRecognizer stopRecognition];
}
- (IBAction)updateResult:sender
{
	[viewController setResultString:result];
}
- (void)speechRecognizerDidRecognizeSpeech:(CVSpeechRecognizer*)recognizer
{	
	[result release];
	result  = [NSMutableString new];
	
	int i=0;
	for(id res in [recognizer recognizedPhrases])
	{
		NSLog(@"%@ (score=%f)", res, [recognizer scoreForRecognizedPhrase:res]);
		
		[(NSMutableString*)result appendString:[NSString stringWithFormat:@"%d. %@ (score=%f)\n", ++i, res, [recognizer scoreForRecognizedPhrase:res]]];
	}
	
	// Call to UI on main thread only !!!
	[self performSelectorOnMainThread:@selector(updateResult:) withObject:nil waitUntilDone:YES];
	
	// If you need to stop the recognizer, do it on main thread
	//[self performSelectorOnMainThread:@selector(stopRecognition:) withObject:nil waitUntilDone:YES];
}


@end
