//
//  MHActivityActionView.m
//  WonderfulLife
//
//  Created by Lucas on 17/9/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHActivityActionView.h"

#import "MHMacros.h"
#import "UILabel+Attributed.h"
@interface MHActivityActionView()

@property (weak, nonatomic) IBOutlet UILabel *leftLB;
@property (weak, nonatomic) IBOutlet UIImageView *iconIv;


@property (weak, nonatomic) IBOutlet UILabel *signUpLB;

@property (nonatomic, assign) MHActivityActionViewType type;

@end


@implementation MHActivityActionView

 // 若 参数的总人数  qty == 0 （不限人数参加） ， 否则显示 参数剩余名额(sty)
+ (instancetype)activityActionViewWithStatus:(MHActivityActionViewType)type qty:(NSInteger)qty  sty:(NSInteger)sty handler:(ActivityAction)handler{
    MHActivityActionView *view = [MHActivityActionView loadView];
    view.RightHandler = handler ;
    view.type = type;
    [view setConfigWithType:type qty:qty sty:sty];
    return view;
}


- (void)setConfigWithType:(MHActivityActionViewType)type qty:(NSInteger)qty  sty:(NSInteger)sty{
    
    
    switch (type) {
        case MHActivityActionViewTypeRepairNormal:
        {
            self.leftLB.hidden = YES;
            [self normalBtnTitle:@"提交修改"];
        }
            break;
        case MHActivityActionViewTypeRepairDisabled:
        {
            self.leftLB.hidden = YES;
            [self disabledBtnTitle:@"提交修改"];
        }
            break;
        case MHActivityActionViewTypeRegAttendance:
        {
            self.leftLB.text = @"活动已结束";
            [self normalBtnTitle:@"登记考勤"];
        }
            break;
        case MHActivityActionViewTypeManagementSignUp:
        {
            [self normalBtnTitle:@"管理报名"];
           [self setLabelAttributedWithQty:qty sty:sty];
        }
            break;
        case MHActivityActionViewTypeMembersSignUpNormal:
        {
            [self normalBtnTitle:@"立即报名"];

            [self setLabelAttributedWithQty:qty sty:sty];
        }
            break;
        case MHActivityActionViewTypeMembersSignUpFill:
        {
            self.leftLB.text = @"不可报名";
            [self disabledBtnTitle:@"名额已满"];
        }
            break;
        case MHActivityActionViewTypeMembersSignUpCancel:
        {
            self.leftLB.hidden = YES;
            self.signUpLB.hidden = NO;
            self.iconIv.hidden = NO;
            [self cancelSignUpStatusBtn:@"取消报名"];
        }
            break;
        case MHActivityActionViewTypeActivityPublish:
        {
            self.leftLB.hidden = YES;
            [self normalBtnTitle:@"发布活动"];
        }
            break;
        case MHActivityActionViewTypeActivityPublishDisabled:
        {
            self.leftLB.hidden = YES;
            [self disabledBtnTitle:@"发布活动"];
        }
            break;
        default:
            break;
    }
}

/**  普通可点击状态*/
- (void)normalBtnTitle:(NSString *)title{
    self.doneBtn.enabled = YES;
    [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneBtn setTitle:title forState:UIControlStateNormal];
}

/** 禁止点击状态*/
- (void)disabledBtnTitle:(NSString *)title{
    self.doneBtn.enabled = NO;
    [self.doneBtn setTitleColor:MColorToRGB(0x717F95) forState:UIControlStateNormal];
    [self.doneBtn setBackgroundColor:MColorToRGB(0x717F95)];
    [self.doneBtn setTitle:title forState:UIControlStateNormal];
}

/** 取消报名 队员专用*/
- (void)cancelSignUpStatusBtn:(NSString *)title{
    [self.doneBtn setTitle:title forState:UIControlStateNormal];
    [self.doneBtn setTitleColor:MColorTitle forState:UIControlStateNormal];
    [self.doneBtn setBackgroundColor:[UIColor whiteColor]];
    self.doneBtn.layer.masksToBounds = YES;
    self.doneBtn.layer.borderColor = MColorTitle.CGColor ;
    self.doneBtn.layer.borderWidth = 1 ;
    self.doneBtn.noShadow = YES;
    [self.doneBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.doneBtn setBackgroundImage:nil forState:UIControlStateHighlighted];
}


- (void)setLabelAttributedWithQty:(NSInteger)qty  sty:(NSInteger)sty{
    // 若 参数的总人数  qty == 0 （不限人数参加） ， 否则显示 参数剩余名额(sty)
    NSString *peopleCount ;
    NSString *attstr;
    if (qty == 0) {
        peopleCount = @"不限";
        attstr = peopleCount;
    }else {
        peopleCount = [NSString stringWithFormat:@"%ld 人",sty];
        attstr = [NSString stringWithFormat:@"%ld",sty];
    }
    self.leftLB.text = [NSString stringWithFormat:@"剩名额 %@",peopleCount] ;

    NSRange tmpRange = [self.leftLB.text rangeOfString:attstr];
    [self.leftLB mh_setAttributedWithRange:tmpRange attributeName:NSFontAttributeName font:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20]];
    
}


+ (instancetype)loadView{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

- (IBAction)action:(id)sender {
    if (self.RightHandler) {
        self.RightHandler();
    }
}
@end
