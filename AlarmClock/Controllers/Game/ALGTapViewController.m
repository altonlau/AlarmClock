//
//  ALGTapViewController.m
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-28.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

#import "ALGTapViewController.h"

@interface ALGTapViewController ()

@property (nonatomic) BOOL didStartConstantDrop;

@end

@implementation ALGTapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clockImageViewTopEdgeConstraint.constant = UIScreen.mainScreen.bounds.size.height;
    
    play_sound(@"Bee_Do.mp3", -1);
    [self startConstantDropAnimation];
}


//------------------------------------------------------------------------------
#pragma mark - Public Methods

- (IBAction)handleViewTap:(id)sender {
    if (self.clockImageViewTopEdgeConstraint.constant > 0) {
        self.clockImageViewTopEdgeConstraint.constant -= 20;
    }
}

- (void)startConstantDropAnimation {
    if (self.clockImageViewTopEdgeConstraint.constant < UIScreen.mainScreen.bounds.size.height) {
        [UIView animateWithDuration:0.1 animations:^{
            self.clockImageViewTopEdgeConstraint.constant += 1;
            [self.view layoutIfNeeded];
        }];
    }
    
    if (self.clockImageViewTopEdgeConstraint.constant <= 0) {
        self.clockImageViewTopEdgeConstraint.constant = 0;
        stop_sound();
        [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [[self.clockImageView.subviews objectAtIndex:0] setAlpha:1];
        } completion:^(BOOL finished) {
            dispatch_later(0.5, ^{
                [self dismissViewControllerAnimated:YES completion:nil];
            });
        }];
    }
    else {
        dispatch_later(0.01, ^{
            [self startConstantDropAnimation];
        });
    }
}

@end
