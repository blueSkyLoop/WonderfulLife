//
//  UIView+HLNib.m
//  HLCategory
//
//  Created by hanl on 2017/7/18.
//  Copyright © 2017年 hanl. All rights reserved.
//

#import "UIView+HLNib.h"

@implementation UIView (HLNib)
+ (instancetype)hl_awakeFromNibName:(NSString *)nibName {
    return [[UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]]
            instantiateWithOwner:self options:nil].firstObject;
}
@end
