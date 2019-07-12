//
//  MHVolSerMemberCell.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MHVolSerTeamMember;

@protocol MHVolSerMemberDelegate <NSObject>
- (void)volSerMemberdidSelectItemWithModel:(MHVolSerTeamMember *)model;
@end

@interface MHVolSerMemberCell : UITableViewCell
@property (strong,nonatomic) NSArray<MHVolSerTeamMember *>* memberLiat;
@property (weak,nonatomic) id<MHVolSerMemberDelegate> delegate;
@end
