//
//  MHOwnerCheckController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHOwnerCheckController.h"
#import "MHMacros.h"
#import "MHOwnerCheckView.h"
#import "MHThemeButton.h"
#import "MHCertificationRequestHandler.h"
#import "MHStructRoomModel.h"
#import "MHCertificationSuccessController.h"
#import "MHHUDManager.h"
#import "NSString+Chinese.h"
#import "NSString+Number.h"

@interface MHOwnerCheckController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (strong, nonatomic) IBOutletCollection(MHOwnerCheckView) NSArray *numberTextViews;
@property (weak, nonatomic) IBOutlet UIView *nameContainerView;
@property (weak, nonatomic) IBOutlet UIView *numberContainer;
@property (weak, nonatomic) IBOutlet MHThemeButton *commitButton;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation MHOwnerCheckController

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupContainerLayer];
    
    self.firstNameLabel.text = self.room.first_name;
    self.addressLabel.text = self.room.room_info;
    NSInteger length = self.room.name_length.integerValue;
    if (length <= 3) {
        MHOwnerCheckView *textView = self.nameContainerView.subviews.lastObject;
        [textView removeFromSuperview];
    }
    if (length <= 2) {
        MHOwnerCheckView *textView = self.nameContainerView.subviews.lastObject;
        [textView removeFromSuperview];
    }

    if (MScreenW == 320) {
        self.top.constant = 64;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }else if (MScreenW == 375){
        
    }else{
        
    }
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewEndEditing)]];
}

-(void)dealloc{
    if (MScreenW == 320) {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    }
}

- (void)setupContainerLayer{
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.borderColor = MRGBColor(211, 220, 231).CGColor;
    self.containerView.layer.borderWidth = 1;
    
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.shadowRadius = 5;
    self.containerView.layer.shadowColor = MRGBColor(239,242,247).CGColor;
    self.containerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.containerView.layer.shadowOpacity = 1;
    
}

- (IBAction)commit {
    NSString *name = self.room.first_name;
    for (UITextView *textView in self.nameContainerView.subviews) {
        if ([textView isKindOfClass:[UITextView class]]) {
            if ([textView.text isChinese]) {
                name = [name stringByAppendingString:textView.text];
            }else{
                
                return;
            }
        }
    }
    
    NSString *numStr = @"";
    for (UITextView *textView in self.numberContainer.subviews) {
        if ([textView isKindOfClass:[UITextView class]]) {
            if ( (textView != self.numberContainer.subviews.lastObject && ![textView.text isPureInt]) || (textView == self.numberContainer.subviews.lastObject && ![textView.text isEqualToString:@"X"] && ![textView.text isEqualToString:@"x"] && ![textView.text isPureInt]) ) {
                [MHHUDManager showText:@"请输入正确的身份证号码格式"];
                return;
            }
            if (textView == self.numberContainer.subviews.lastObject && [textView.text isEqualToString:@"x"]) {
                numStr = [numStr stringByAppendingString:@"X"];
            }else{
                numStr = [numStr stringByAppendingString:textView.text];
            }
        }
    }
    
    [MHCertificationRequestHandler postCheckUserWithName:name Number:numStr RoomID:self.room.struct_id SuccessBlock:^(NSInteger is_validate) {
        if (is_validate) {
            MHCertificationSuccessController *vc = [[MHCertificationSuccessController alloc] initWithType:MHCertificationSuccessTypeNone];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您提供的业主信息不正确，请核对后再试" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            if (iOS8_2_OR_LATER) {
                [action1 setValue:MRGBColor(32, 160, 255) forKey:@"titleTextColor"];
            }
            [alert addAction:action1];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

#pragma mark - private
- (void)viewEndEditing{
    [self.view endEditing:YES];
    for (MHOwnerCheckView *textView in self.nameContainerView.subviews) {
        if ([textView isKindOfClass:[MHOwnerCheckView class]] && textView.text.length == 0) {
            self.commitButton.enabled = NO;
            return;
        }
    }
    for (MHOwnerCheckView *textView in self.numberContainer.subviews) {
        if ([textView isKindOfClass:[MHOwnerCheckView class]] && textView.text.length == 0) {
            self.commitButton.enabled = NO;
            return;
        }
    }
    self.commitButton.enabled = YES;
    
}

#pragma mark - 键盘通知
- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary*info=[notification userInfo];
    CGFloat during = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:during animations:^{
        self.top.constant = -50;
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary*info=[notification userInfo];
    CGFloat during = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:during animations:^{
        self.top.constant = 64;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - textViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        return;
    }
    
    if (textView.superview == self.nameContainerView && [textView.text isChinese]) {
        if (textView != textView.superview.subviews.lastObject) {
            NSInteger index = [textView.superview.subviews indexOfObject:textView];
            UITextView *nextTextView = textView.superview.subviews[index + 1];
            [nextTextView becomeFirstResponder];
        }else{
            UITextView *nextTextView = self.numberTextViews[0];
            [nextTextView becomeFirstResponder];
        }
    }else if (textView.superview == self.numberContainer) {
        if (textView != textView.superview.subviews.lastObject) {
            if ([textView.text isPureInt]) {
                NSInteger index = [textView.superview.subviews indexOfObject:textView];
                UITextView *nextTextView = textView.superview.subviews[index + 1];
                [nextTextView becomeFirstResponder];
            }
        }else{
            if ([textView.text isPureInt] || [textView.text isEqualToString:@"X"] || [textView.text isEqualToString:@"x"]) {
                [self viewEndEditing];
            }
            
        }
        
    }
    
}

- (BOOL) textView: (UITextView *) textView  shouldChangeTextInRange: (NSRange) range replacementText: (NSString *)text {
    if( [ @"\n" isEqualToString: text] && textView.text.length == 0){//空的时候点下一个
        return NO;
    }else if ([text isEqualToString:@""]){//删除回退
        textView.text = @"";
        return YES;
    }
    if (textView.keyboardType == UIKeyboardTypeNumberPad) {
        return [text isPureInt];
    }
    return YES;

}



@end






