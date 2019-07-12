//
//  MHStoreGoodsSubmitDetailView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseView.h"
#import "MHThemeButton.h"

#import "MHStoreGoodsDetailModel.h"

@interface MHStoreGoodsSubmitDetailView : MHBaseView

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *merchantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UIView *distanceBgView;
@property (weak, nonatomic) IBOutlet UIView *orderBgView;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UITextField *numTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet MHThemeButton *payBtn;

////最大库存
//@property (nonatomic,assign)NSInteger maxNum;
////当前数量
//@property (nonatomic,assign)NSInteger currentNum;

- (void)configWithModel:(MHStoreGoodsDetailModel *)model;

@end
