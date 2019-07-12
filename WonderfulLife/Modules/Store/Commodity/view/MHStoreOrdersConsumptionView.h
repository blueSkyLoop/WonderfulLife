//
//  MHStoreOrdersConsumptionView.h
//  WonderfulLife
//
//  Created by lgh on 2017/11/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseView.h"

@interface MHStoreOrdersConsumptionView : MHBaseView
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkDetailBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

//index  1 查看详情      2取消      3确定
@property (nonatomic,copy)void (^buttonClikBlock)(NSInteger index);

@property (nonatomic,strong)NSDictionary *inforDict;

- (void)configWithDict:(NSDictionary *)dict;

@end
