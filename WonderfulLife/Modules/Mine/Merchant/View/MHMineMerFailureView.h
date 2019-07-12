//
//  MHMineMerFailureView.h
//  WonderfulLife
//
//  Created by Lol on 2017/11/2.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHMerPayIncomEnumResult.h"
@interface MHMineMerFailureView : UIView

+ (MHMineMerFailureView *)loadViewFromXibWithResultType:(MerColResultType)type;
@end
