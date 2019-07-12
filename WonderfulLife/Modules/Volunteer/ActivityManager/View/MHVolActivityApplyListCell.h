//
//  MHVolActivityApplyListCell.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/18.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MHVolActivityApplyType){
    /**
     *  可报名
     */
    MHVolActivityApplyTypeApply  = 0,
    
    /**
     * 已报名
     */
    MHVolActivityApplyTypeAlreadyApply = 1,
    
    /**
     * 可取消
     */
    MHVolActivityApplyTypeCancelApply = 2
};

@class MHVolActivityApplyCrew,MHVolActivityApplyListCell;
@protocol MHVolActivityApplyListCellDelegate <NSObject>
@optional

/** 报名*/
- (void)didClickCellWithApply:(MHVolActivityApplyCrew *)model ;

/** 取消报名*/
- (void)didClickCellWithCancelApply:(MHVolActivityApplyCrew *)model ;

/** 点击头像*/
- (void)didClickIcon:(MHVolActivityApplyCrew *)model ;
@end



@interface MHVolActivityApplyListCell : UITableViewCell



@property (nonatomic,weak) id<MHVolActivityApplyListCellDelegate> delegate;


@property (nonatomic, strong) MHVolActivityApplyCrew  *model;

@property (nonatomic, assign) MHVolActivityApplyType type;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
