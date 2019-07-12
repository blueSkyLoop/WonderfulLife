//
//  MHVolJoinSerMsgCell.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHVolJoinSerSelectedProtocol <NSObject>

@optional
- (void)didTouchUpInsideSelectedButtonIndexPath:(NSIndexPath *)indexPath;
@end

@interface MHVolJoinSerMsgCell : UITableViewCell
@property (weak,nonatomic) id<MHVolJoinSerSelectedProtocol> delegate;
/// <#summary#>
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *mh_imageButton;
@property (weak, nonatomic) IBOutlet UILabel *mh_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *mh_subTitleLabel;
@end
