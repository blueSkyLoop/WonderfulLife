//
//  MHAttendancenDetailBottomView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHAttendancenDetailBottomView.h"
#import "UIView+NIM.h"
#import "MHMacros.h"
#import "YYText.h"

@interface MHAttendancenDetailBottomView ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation MHAttendancenDetailBottomView

#pragma mark - override
+ (instancetype)bottomView{
    return [[NSBundle mainBundle] loadNibNamed:@"MHAttendancenDetailBottomView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.subviews.lastObject.nim_height = 0.5;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_type == MHAttendancenDetailBottomViewTypeDidAudit || _type == MHAttendancenDetailBottomViewTypeCheck || _type == MHAttendancenDetailBottomViewTypeDisableFullRejuctAudit || _type == MHAttendancenDetailBottomViewTypeDisableFullUnAudit || _type == MHAttendancenDetailBottomViewTypeDisableFullDidAudit){
        self.button.frame = CGRectMake(24*MScale, 20, 327*MScale, 56);
    }
}

- (void)setCrewCount:(NSInteger)crewCount{
    _crewCount = crewCount;
    NSString *string = [NSString stringWithFormat:@"已登记 %zd 人",crewCount];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    attr.yy_kern = @1;
    NSInteger sum = [self nsinterLength:crewCount];
    sum = sum==0 ? 1 : sum;
    [attr yy_setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20] range:NSMakeRange(4, sum)];
    self.label.attributedText = attr;
    [self.label sizeToFit];
}


#pragma mark - 按钮点击
- (IBAction)buttonDidClick{
    if ([self.delegate respondsToSelector:@selector(bottomButtonDidClick)]) {
        [self.delegate bottomButtonDidClick];
    }
}

#pragma mark - delegate

#pragma mark - private
- (void)setType:(MHAttendancenDetailBottomViewType)type{
    _type = type;
    if (type == MHAttendancenDetailBottomViewTypeDisableFullUnAudit) {
        [self.button setTitle:@"待审核" forState:UIControlStateDisabled];
        self.button.enabled = NO;
    }else if (type == MHAttendancenDetailBottomViewTypeDisableFullDidAudit) {
        [self.button setTitle:@"已通过" forState:UIControlStateDisabled];
        self.button.enabled = NO;
    }else if (type == MHAttendancenDetailBottomViewTypeDisableFullRejuctAudit) {
        [self.button setTitle:@"不通过" forState:UIControlStateDisabled];
        self.button.enabled = NO;
        
    }else if (type == MHAttendancenDetailBottomViewTypeEnableUnAudit){
        [self.button setTitle:@"修改考勤" forState:UIControlStateNormal];
        self.label.text = @"待审核";
        [self.label sizeToFit];
    }else if (type == MHAttendancenDetailBottomViewTypeCommitAttendance){
        [self.button setTitle:@"提交考勤" forState:UIControlStateNormal];
        
        
    }else if (type == MHAttendancenDetailBottomViewTypeReject){
        [self.button setTitle:@"修改考勤" forState:UIControlStateNormal];
        
    }else if (type == MHAttendancenDetailBottomViewTypeDidAudit){
        [self.button setTitle:@"考勤已通过" forState:UIControlStateDisabled];
        self.button.enabled = NO;
        
    }else if (type == MHAttendancenDetailBottomViewTypeSave){
        [self.button setTitle:@"保存" forState:UIControlStateNormal];
        
    }else if (type == MHAttendancenDetailBottomViewTypeCheck){
        [self.button setTitle:@"查看" forState:UIControlStateNormal];
        
    }
}

- (NSInteger)nsinterLength:(NSInteger)x {
    NSInteger sum=0,j=1;
    while( x >= 1 ) {
        x=x/10;
        sum++;
        j=j*10;
    }
    return sum;
}
#pragma mark - lazy

@end







