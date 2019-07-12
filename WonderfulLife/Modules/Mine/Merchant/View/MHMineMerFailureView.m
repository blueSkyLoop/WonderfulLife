//
//  MHMineMerFailureView.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/2.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerFailureView.h"
@interface MHMineMerFailureView()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
@implementation MHMineMerFailureView

+ (MHMineMerFailureView *)loadViewFromXibWithResultType:(MerColResultType)type{
    MHMineMerFailureView *aview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    
    if (type == MerColResultType_FailurePay) {
        aview.titleLab.text = @"付款失败";
    }else {
        aview.titleLab.text = @"收款失败";
    }
    
    return aview;
}

@end
