//
//  MHAlertView.h
//  Sakura
//
//  Created by zz on 28/11/2017.
//  Copyright © 2017 ikrulala. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MHAlertActionStyle) {
    MHAlertActionStyleDefault,
    MHAlertActionStyleCancel,
    MHAlertActionStyleDestructive,
    MHAlertActionStyleSelected
};

@interface MHVoAlertAction : NSObject <NSCopying>

+ (instancetype)actionWithTitle:(NSString *)title style:(MHAlertActionStyle)style handler:(void (^)(NSInteger index))handler;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) MHAlertActionStyle style;
@property (nonatomic, getter=isEnabled) BOOL enabled;

@end


@interface MHVoSheetView : UIView
@property (nonatomic, weak, readonly) UILabel *messageLabel;

@property (nonatomic, strong, readonly) NSArray *textFieldArray;

@property (nonatomic, assign) CGFloat alertViewWidth;

@property (nonatomic, assign) CGFloat contentViewSpace;

@property (nonatomic, assign) CGFloat textLabelSpace;
@property (nonatomic, assign) CGFloat textLabelContentViewEdge;

@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, assign) CGFloat buttonSpace;
@property (nonatomic, assign) CGFloat buttonContentViewEdge;
@property (nonatomic, assign) CGFloat buttonContentViewTop;
@property (nonatomic, assign) CGFloat buttonCornerRadius;
@property (nonatomic, strong) UIFont  *buttonFont;
@property (nonatomic, strong) UIColor *buttonDefaultBgColor;
@property (nonatomic, strong) UIColor *buttonCancelBgColor;
@property (nonatomic, strong) UIColor *buttonDestructiveBgColor;

@property (nonatomic, assign) BOOL clickedAutoHide;


+ (instancetype)alertViewWithTitle:(NSString *)title message:(NSString *)message;

- (void)addAction:(MHVoAlertAction *)action;

@end
