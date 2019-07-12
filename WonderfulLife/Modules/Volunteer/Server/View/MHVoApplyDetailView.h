//
//  MHVoApplyDetailView.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/8/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVoApplyDetailView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

+ (instancetype)voApplyDetailView;

@end


@interface MHVoApplyDetailIconView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

+ (instancetype)voApplyDetailIconView;
@end





