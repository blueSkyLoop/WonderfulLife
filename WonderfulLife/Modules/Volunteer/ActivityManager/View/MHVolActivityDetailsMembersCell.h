//
//  MHVolActivityDetailsMembersCell.h
//  WonderfulLife
//
//  Created by Lucas on 17/9/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHVolSerTeamMember;
@protocol MHVolActivityDetailsMembersCellDelegate <NSObject>
- (void)volSerMemberdidSelectItemWithModel:(MHVolSerTeamMember *)model;
@end

@interface MHVolActivityDetailsMembersCell : UITableViewCell
@property (strong,nonatomic) NSArray<MHVolSerTeamMember *>* memberList;
@property (weak,nonatomic) id<MHVolActivityDetailsMembersCellDelegate> delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
