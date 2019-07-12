//
//  MHMineMerFinHeaderView.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/6.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerFinHeaderView.h"
#import "MHMineMerFinModel.h"

#import "UIView+Shadow.h"
#import "UILabel+isNull.h"
#import "NSString+CountComma.h"
@interface MHMineMerFinHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *turnoverLB; // 总数
@property (weak, nonatomic) IBOutlet UILabel *incomeLB; // 收入
@property (weak, nonatomic) IBOutlet UILabel *withdrawLab; // 提现

@property (weak, nonatomic) IBOutlet UIView *layerView;
@end

@implementation MHMineMerFinHeaderView

+ (instancetype)mineMerfinHeaderViewWithFrame:(CGRect)frame{
    MHMineMerFinHeaderView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    view.frame = frame ;
    return view ;
}


- (void)awakeFromNib{
    [super awakeFromNib];
    [self.layerView mh_setupContainerLayerWithContainerView];
}

- (void)setModel:(MHMineMerFinModel *)model {
    _model = model ;
    
    [self.incomeLB mh_isNullWithDataSourceText:model.income allText:[NSString stringWithFormat:@"收入：%@",[NSString mh_countNumAndChangeformat:model.income]] isNullReplaceString:@"收入：0"];
    
    [self.withdrawLab mh_isNullWithDataSourceText:model.withdraw_sum allText:[NSString stringWithFormat:@"提现：%@",[NSString mh_countNumAndChangeformat:model.withdraw_sum]] isNullReplaceString:@"提现：0"];

    
    [self.turnoverLB mh_isNullWithDataSourceText:model.turnover allText:[NSString mh_countNumAndChangeformat:model.turnover] isNullReplaceString:@"0"];
}


@end
