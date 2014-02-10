//
//  CeedVocalDemoViewController.h
//  CeedVocalDemo
//
//  Created by Raphael Sebbe on 17/04/09.
//  Copyright Creaceed 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CeedVocalDemoViewController : UIViewController {
	IBOutlet UITextView *resultView;
	
}

- (void)setResultString:(NSString*)val;
- (IBAction)start:sender;

@end

