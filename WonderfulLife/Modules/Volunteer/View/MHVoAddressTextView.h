//
//  MHVoAddressTextView.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MHVoAddressTextViewTypeAddress,
    MHVoAddressTextViewTypeIntroduce
} MHVoAddressTextViewType;

@interface MHVoAddressTextView : UITextView

@property (nonatomic,assign) MHVoAddressTextViewType type;
@property (nonatomic,strong) UILabel *placeHolderLabel;


@end
