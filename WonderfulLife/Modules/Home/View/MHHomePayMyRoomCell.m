//
//  MHHomePayMyRoomCell.m
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHHomePayMyRoomCell.h"
#import "MHMacros.h"
#import "MHHomeRoomModel.h"
#import "MHMineRoomModel.h"
#import "UIView+NIM.h"
#import "MHUserInfoManager.h"

typedef enum : NSUInteger {
    MHHomePayMyRoomCellTpyeMineCeitified,
    MHHomePayMyRoomCellTpyeCanDelete,
    MHHomePayMyRoomCellTpyeMineCeitifying,
} MHHomePayMyRoomCellTpye;

@interface MHHomePayMyRoomCell ()
/**
 子控件容器View
 */
@property (weak, nonatomic) IBOutlet UIView *containerView;
/**
 详细地址
 */
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
/**
 业主名称
 */
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;
/**
 删除按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
/**
 已认证按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *certificationButton;

@property (weak, nonatomic) IBOutlet UILabel *certifyingLabel;

@property (weak, nonatomic) IBOutlet UIImageView *arrowView;

@property (nonatomic,assign) MHHomePayMyRoomCellTpye type;

@end

@implementation MHHomePayMyRoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置容器View相关属性
    self.containerView.layer.borderColor = MColorToRGB(0XD3DCE6).CGColor;
    self.containerView.layer.borderWidth = 1;
    self.containerView.layer.cornerRadius = 6;
    self.containerView.layer.masksToBounds = YES;
    
    self.certificationButton.layer.borderColor = MColorToRGB(0X20A0FF).CGColor;
    self.certificationButton.layer.borderWidth = 1;
    self.certificationButton.layer.cornerRadius = 3;
    self.certificationButton.layer.masksToBounds = YES;
}


- (void)setMineRoomModel:(MHMineRoomModel *)mineRoomModel{
    _mineRoomModel = mineRoomModel;
    self.ownerNameLabel.text = [NSString stringWithFormat:@"业主：%@",mineRoomModel.real_name?:@""];
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",mineRoomModel.community_name,mineRoomModel.room_info];
    self.arrowView.hidden = self.isHiddenArrow;
    
    BOOL status = [mineRoomModel.audit_status isEqualToNumber:@2];
    if (status) {
        [MHUserInfoManager sharedManager].validate_status = @2;
        [self setType:MHHomePayMyRoomCellTpyeMineCeitified];
    }else {
        [self setType:MHHomePayMyRoomCellTpyeMineCeitifying];
    }
    
}

- (void)setType:(MHHomePayMyRoomCellTpye)type{
    _type = type;
    self.deleteButton.hidden = YES;
    self.certificationButton.hidden = YES;
    self.certifyingLabel.hidden = YES;
    if (type == MHHomePayMyRoomCellTpyeMineCeitified) {
        self.certificationButton.hidden = NO;
    }else if (type == MHHomePayMyRoomCellTpyeCanDelete){
        self.deleteButton.hidden = NO;
    }else if (type == MHHomePayMyRoomCellTpyeMineCeitifying){
        self.certifyingLabel.hidden = NO;
    }

}

#pragma mark - 删除按钮点击事件
- (IBAction)deleteButtonClick:(UIButton *)sender {
    //.....
}

@end
