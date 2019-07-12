//
//  MHMineMerColCompView.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/2.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerColCompView.h"
#import "MHMineMerchantPayModel.h"

#import "UILabel+isNull.h"
@interface MHMineMerColCompView()

/** 收款多少钱*/
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

@end


@implementation MHMineMerColCompView

+ (MHMineMerColCompView *)loadViewFromXib:(MHMineMerchantPayModel *)model resultType:(MerColResultType)type{
    MHMineMerColCompView *aview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    
    [aview.moneyLab mh_isNullWithDataSourceText:model.income_amount allText:[NSString stringWithFormat:@"%@积分",model.income_amount] isNullReplaceString:@""];

    [aview.timeLab mh_isNullWithDataSourceText:model.income_datetime allText:[NSString stringWithFormat:@"收款时间：%@",model.income_datetime] isNullReplaceString:@""];
    
    return aview;
}


- (IBAction)action:(id)sender {
    [self.paySubject sendNext:self];
}


- (RACSubject *)paySubject{
    if(!_paySubject){
        _paySubject = [RACSubject subject];
    }
    return _paySubject;
}
@end
