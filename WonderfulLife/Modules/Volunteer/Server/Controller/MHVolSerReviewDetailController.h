//
//  MHVolSerReviewDetailController.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MHVolSerReviewDetailControllerType) {
    MHVolSerReviewDetailControllerReview, // 待审核
    MHVolSerReviewDetailControllerPass,   // 通过
    MHVolSerReviewDetailControllerRefuse,  // 拒绝
    MHVolSerReviewDetailControllerBack  // 撤回
};

@interface MHVolSerReviewDetailController : UIViewController
@property (nonatomic, assign) MHVolSerReviewDetailControllerType type;
@property (nonatomic, strong) NSNumber *applyId;
@property (nonatomic,copy) void (^refreshRevokeBlock)();
@end
