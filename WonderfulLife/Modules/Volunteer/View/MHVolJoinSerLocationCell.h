//
//  MHVolJoinSerLocationCell.h
//  WonderfulLife
//
//  Created by hanl on 2017/7/11.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHVolJoinChangeButtonProtocol <NSObject>

@optional

- (void)didTouchUpInsideChangeButton;

@end

@interface MHVolJoinSerLocationCell : UITableViewCell
@property (weak,nonatomic) id<MHVolJoinChangeButtonProtocol> delegate;
@property (weak, nonatomic) IBOutlet UILabel *mh_titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *mh_button;
@end
