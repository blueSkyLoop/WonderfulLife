//
//  MHHomePayMyRoomCell.h
//  WonderfulLife
//
//  Created by hehuafeng on 2017/7/24.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHHomePayMyRoomCellDelegate <NSObject>

- (void)removeRoomWithIndexPath:(NSIndexPath *)indexPath PropertyID:(NSString *)property_id;

@end

@class MHHomeRoomModel,MHMineRoomModel;

@interface MHHomePayMyRoomCell : UITableViewCell
@property (nonatomic,assign) BOOL isHiddenArrow;
@property (nonatomic,strong) MHMineRoomModel *mineRoomModel;

@property (nonatomic,weak) id<MHHomePayMyRoomCellDelegate> delegate;

@end


