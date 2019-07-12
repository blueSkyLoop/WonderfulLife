//
//  MHVoApplyDetailView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/8/21.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoApplyDetailView.h"
#import <UIImageView+WebCache.h>
#import "MHMacros.h"
#import "PYPhotoBrowser.h"

@interface MHVoApplyDetailView ()
@property (weak, nonatomic) IBOutlet UIView *line;

@end
@implementation MHVoApplyDetailView

+ (instancetype)voApplyDetailView{
    return [[NSBundle mainBundle] loadNibNamed:@"MHVoApplyDetailView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.line.backgroundColor = MColorSeparator;
    
}

@end




@interface MHVoApplyDetailIconView ()


@end

@implementation MHVoApplyDetailIconView

+ (instancetype)voApplyDetailIconView{
    return [[NSBundle mainBundle] loadNibNamed:@"MHVoApplyDetailView" owner:nil options:nil].lastObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.imageView.layer.cornerRadius = 32;
    self.imageView.layer.masksToBounds = YES;
}

@end

