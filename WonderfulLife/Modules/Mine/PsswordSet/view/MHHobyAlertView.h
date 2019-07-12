//
//  MHHobyAlertView.h
//  WonderfulLife
//
//  Created by lgh on 2017/9/29.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHHobyAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *hobyTextF;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic,copy)void (^buttonClikBlock)(NSInteger index);

+ (MHHobyAlertView *)loadViewFromXib;

- (void)show;

@end
