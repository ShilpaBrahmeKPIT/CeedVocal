//
//  CeedVocalDemoViewController.m
//  CeedVocalDemo
//
//  Created by Raphael Sebbe on 17/04/09.
//  Copyright Creaceed 2009. All rights reserved.
//

#import "CeedVocalDemoViewController.h"
#import "CeedVocalDemoAppDelegate.h"

@implementation CeedVocalDemoViewController

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


- (IBAction)start:sender
{
	CeedVocalDemoAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
	
	[appDelegate toggleRecognition:sender];
	
	((UIButton*)sender).selected = !((UIButton*)sender).selected;
}

- (void)setResultString:(NSString*)val
{
	resultView.text = val;
}

@end
