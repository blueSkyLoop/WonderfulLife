//
//  MHMineMerPayComView.m
//  WonderfulLife
//
//  Created by Lol on 2017/11/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMineMerPayComView.h"
#import "MHMineMerchantPayModel.h"
#import "UILabel+isNull.h"
@interface MHMineMerPayComView()
/** 付款积分额*/
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLab;

@end
@implementation MHMineMerPayComView

+ (MHMineMerPayComView *)loadViewFromXib:(MHMineMerchantPayModel *)model {
    MHMineMerPayComView *aview = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    [aview.moneyLab mh_isNullWithDataSourceText:model.pay_money allText:[NSString stringWithFormat:@"%@积分",model.pay_money] isNullReplaceString:@""];
    
    [aview.merchantNameLab mh_isNullText:model.merchant_name];
    return aview;
}


- (IBAction)action:(id)sender {
    [self.doneSubject sendNext:self];
}


- (RACSubject *)doneSubject{
    if(!_doneSubject){
        _doneSubject = [RACSubject subject];
    }
    return _doneSubject;
}

@end
