//
//  ViewController.h
//  tice tac toe
//
//  Created by Kyle Newsome on 15-08-21.
//  Copyright (c) 2015 Kyle Newsome. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *boardView;
@property (nonatomic, weak) IBOutlet UILabel *youLabel;
@property (nonatomic, weak) IBOutlet UILabel *turnLabel;

-(IBAction) playerFirst:(id)sender;

-(IBAction) aiFirst:(id)sender;

@end
