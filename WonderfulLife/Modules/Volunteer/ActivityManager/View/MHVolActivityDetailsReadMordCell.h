//
//  MHVolActivityDetailsReadMordCell.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"

typedef NS_ENUM(NSInteger, MHVolActivityDetailsReadMordType){
    
    /** 活动内容*/
    MHVolActivityDetailsReadMordTypeIntro  = 0,
    
    /** 活动规则*/
    MHVolActivityDetailsReadMordTypeRules = 1
};


@class MHVolActivityDetailsReadMordCell , MHVolActivityDetailsModel;
@protocol MHVolActivityDetailsReadMordCellDelegate <NSObject>
@optional
- (void)didClickReadMoreWithIndexPath:(NSIndexPath *)indexPath;

@end


@interface MHVolActivityDetailsReadMordCell : UITableViewCell

@property (nonatomic, strong) MHVolActivityDetailsModel  *model;

@property (strong,nonatomic) NSIndexPath *indexPath;

@property (nonatomic, weak) id<MHVolActivityDetailsReadMordCellDelegate>delegate;


@property (nonatomic, assign) MHVolActivityDetailsReadMordType readMoreType;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
