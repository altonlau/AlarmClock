//
//  ALGTapViewController.h
//  AlarmClock
//
//  Created by Alton Lau on 2015-06-28.
//  Copyright (c) 2015 Alton Lau. All rights reserved.
//

@interface ALGTapViewController : UIViewController
<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *clockImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *clockImageViewTopEdgeConstraint;

- (IBAction)handleViewTap:(id)sender;

@end
