//
//  MHVolActivityDetailsCancelCell.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVolActivityDetailsCancelCell ;
@protocol MHVolActivityDetailsCancelCellDelegate <NSObject>
@optional
- (void)didClickCellCancelButton ;

@end
@interface MHVolActivityDetailsCancelCell : UITableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView ;

@property (nonatomic, weak) id  <MHVolActivityDetailsCancelCellDelegate> delegate ;

@end
