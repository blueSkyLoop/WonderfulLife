//
//  MHVolSerRefuseAlertView.m
//  WonderfulLife
//
//  Created by Beelin on 17/8/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVolSerRefuseAlertView.h"
#import "MHMacros.h"
#import "UIView+MHFrame.h"


@interface MHVolSerRefuseAlertView () <UITextViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UITextView *tv;
@property (weak, nonatomic) IBOutlet UILabel *titleLB;

@property (nonatomic, strong) UIView  *backgroundView;

@property (nonatomic, copy) sureBlock sureBlock;
@property (nonatomic, assign) CGFloat boxViewConverWindowMaxHeightFalg;

@end

@implementation MHVolSerRefuseAlertView

+ (instancetype)volSerRefuseAlertViewWithTitle:(NSString *)title tipStr:(NSString *)tipStr clickSureButtonBlock:(sureBlock)block{
    

    
    MHVolSerRefuseAlertView *view = [[[NSBundle mainBundle] loadNibNamed:@"MHVolSerRefuseAlertView" owner:nil options:nil] lastObject];
    view.titleLB.text = title;
    view.tv.text = tipStr;
    view.backgroundView = [[UIView alloc] initWithFrame:WINDOW.bounds];
    view.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [WINDOW addSubview:view.backgroundView];
    
    
    view.sureBlock = block;
    view.frame = WINDOW.bounds;
    [WINDOW addSubview:view];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:view action:@selector(tapAction:)];
    [view addGestureRecognizer:tap];
    [view.backgroundView addGestureRecognizer:tap];
    return view;
}
- (void)tapAction:(UITapGestureRecognizer *)sender{
   [self removeFromSuperview];
    [self.backgroundView removeFromSuperview];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.boxView.layer.masksToBounds = YES;
    self.boxView.layer.cornerRadius = 6;
    self.tv.layer.borderColor = MColorSeparator.CGColor;
    self.tv.layer.borderWidth = 1;
    self.tv.layer.masksToBounds = YES;
    self.tv.layer.cornerRadius = 6;
    self.tv.textColor = MColorFootnote;
    
    self.boxViewConverWindowMaxHeightFalg = [self.boxView.superview convertRect:self.boxView.frame toView:WINDOW].origin.y + self.boxView.mh_h;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyborad:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyborad:) name:UIKeyboardWillHideNotification object:nil];
   
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)cancel:(UIButton *)sender {
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

- (IBAction)sure:(UIButton *)sender {

    [self resetTextViewString];
    NSString *reason = self.tv.text;
    !self.sureBlock ?: self.sureBlock(reason);
    [self.backgroundView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self resetTextViewString];
}


- (void)resetTextViewString{
    if ([self.tv.text isEqualToString:@"填写退出原因150字以内"] || [self.tv.text isEqualToString:@"填写拒绝原因150字以内"] || [self.tv.text isEqualToString:@"填写删除原因150字以内"]) {
         self.tv.text = @"";
        self.tv.textColor = MColorTitle;
    }
}


- (void)textViewDidChange:(UITextView *)textView {
    //字数限制操作
    if (textView.text.length >= 150) {
        textView.text = [textView.text substringToIndex:150];
    }
}

- (void)showKeyborad:(NSNotification *)noti {
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat h = keyboardF.size.height - (MScreenH - self.boxViewConverWindowMaxHeightFalg);
    
    [UIView animateWithDuration:duration animations:^{
        if (isIPhone6) {
            self.mh_y = 0 - h - 50;

        } else if (isIPhone6Plus) {
            self.mh_y = 0 - h - 100;

        } else {
            self.mh_y = 0 - h ;
        }
    }];
}
- (void)hideKeyborad:(NSNotification *)noti{
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.mh_y = 0 ;
        self.mh_h = MScreenH ;
    }];
}
@end
