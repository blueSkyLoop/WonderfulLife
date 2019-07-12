//
//  MHStoreGoodsSubmitDetailView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreGoodsSubmitDetailView.h"
#import "MHMacros.h"
#import "LCommonModel.h"
#import "ReactiveObjC.h"
#import "UIImageView+WebCache.h"
#import "MHHUDManager.h"

@interface MHStoreGoodsSubmitDetailView()<UITextFieldDelegate>

@property (nonatomic,strong)MHStoreGoodsDetailModel *model;

//最大库存
@property (nonatomic,assign)NSInteger maxNum;

@property (nonatomic,strong)NSTimer *plusTimer;
@property (nonatomic,strong)NSTimer *addTimer;


@end

@implementation MHStoreGoodsSubmitDetailView

- (void)dealloc{
    if(self.plusTimer){
        [self.plusTimer invalidate];
        self.plusTimer = nil;
    }
    if(self.addTimer){
        [self.addTimer invalidate];
        self.addTimer = nil;
    }
}


- (void)awakeFromNib{
    [super awakeFromNib];
    
    [LCommonModel resetFontSizeWithView:self];
    
    self.distanceBgView.layer.borderWidth = 1;
    self.distanceBgView.layer.borderColor = [MRGBColor(132, 146, 166) CGColor];
    self.distanceBgView.layer.cornerRadius = 4;
    self.distanceBgView.layer.masksToBounds = YES;
    
    self.orderBgView.layer.borderColor = [MRGBColor(211, 220, 230) CGColor];
    self.orderBgView.layer.borderWidth = 1;
    
    self.orderBgView.layer.cornerRadius = 3;
    self.orderBgView.layer.masksToBounds = YES;
    
    self.numTextFiled.font = [UIFont systemFontOfSize:20 * MScale];
    
    self.numTextFiled.delegate = self;
    
     self.numTextFiled.text = @"1";
    [self bind];
    
}
- (void)setMaxNum:(NSInteger)maxNum{
    
    _maxNum = maxNum;
    
    if(_maxNum <= 1){
        self.addBtn.enabled = NO;
        self.plusBtn.enabled = NO;
        self.model.currentNum = _maxNum;
        self.numTextFiled.text = [NSString stringWithFormat:@"%ld",self.model.currentNum];
    }else{
        NSInteger anum = self.numTextFiled.text.integerValue;
        if(anum > self.maxNum){
            self.addBtn.enabled = NO;
        }else{
            self.model.currentNum = anum;
            if(anum < 1){
                self.plusBtn.enabled = NO;
            }else{
                self.plusBtn.enabled = YES;
            }
            self.addBtn.enabled = YES;
        }
        self.numTextFiled.text = [NSString stringWithFormat:@"%ld",self.model.currentNum];
    }
    self.numTextFiled.enabled = _maxNum <= 0?NO:YES;
    self.stockLabel.text = [NSString stringWithFormat:@"%ld",_maxNum];
    
    [self calculateTotalPrice];
    
}

- (void)doPlusNum{
    NSInteger anum = self.numTextFiled.text.integerValue;
    if(anum ==1){
        [MHHUDManager showErrorText:@"购买数量不能为零"];
        return;
    }
    anum -- ;
    if(anum == self.maxNum){
        self.addBtn.enabled = NO;
    }else{
        if(anum < 1){
            self.plusBtn.enabled = NO;
        }else{
            self.plusBtn.enabled = YES;
        }
        self.addBtn.enabled = YES;
    }
    if(anum > self.maxNum){
        anum = self.maxNum;
    }
    self.model.currentNum = anum;
    
    self.numTextFiled.text = [NSString stringWithFormat:@"%ld",self.model.currentNum];
    
    [self calculateTotalPrice];
    
    if(anum <= 1){
        [self clearTimer];
    }
    
}
- (void)doAddNum{
    NSInteger anum = self.numTextFiled.text.integerValue;
    anum ++ ;
    if(anum >= self.maxNum){
        self.addBtn.enabled = NO;
    }else{
        if(anum < 1){
            self.plusBtn.enabled = NO;
        }else{
            self.plusBtn.enabled = YES;
        }
        self.addBtn.enabled = YES;
    }
    if(anum > self.maxNum){
        anum = self.maxNum;
    }
    self.model.currentNum = anum;
    self.numTextFiled.text = [NSString stringWithFormat:@"%ld",self.model.currentNum];
    
    [self calculateTotalPrice];
    
    if(anum >= self.maxNum){
        [self clearTimer];
    }
}

- (IBAction)plusAction:(UIButton *)sender {
    if(self.plusTimer){
        [self.plusTimer invalidate];
        self.plusTimer = nil;
    }
    if(self.addTimer){
        [self.addTimer invalidate];
        self.addTimer = nil;
    }
    [self doPlusNum];
}
- (IBAction)addAction:(UIButton *)sender {
    if(self.plusTimer){
        [self.plusTimer invalidate];
        self.plusTimer = nil;
    }
    if(self.addTimer){
        [self.addTimer invalidate];
        self.addTimer = nil;
    }
    [self doAddNum];
}


- (void)bind{
    @weakify(self);
    [self.numTextFiled.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        NSInteger anum = self.numTextFiled.text.integerValue;
        if(anum >= self.maxNum){
            self.model.currentNum = self.maxNum;
            self.addBtn.enabled = NO;
            if(self.maxNum > 1){
                self.plusBtn.enabled = YES;
            }
        }else{
            self.model.currentNum = anum;
            if(anum < 1){
                self.plusBtn.enabled = NO;
            }else{
                self.plusBtn.enabled = YES;
            }
            self.addBtn.enabled = YES;
        }
        
        [self calculateTotalPrice];
        
    }];
    
    [[self.plusBtn rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(self.plusTimer){
            [self.plusTimer invalidate];
            self.plusTimer = nil;
        }
        self.plusTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(doPlusNum) userInfo:nil repeats:YES];
    }];
    
    [[self.plusBtn rac_signalForControlEvents:UIControlEventTouchUpOutside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self clearTimer];
    }];
    
    [[self.addBtn rac_signalForControlEvents:UIControlEventTouchUpOutside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self clearTimer];
    }];
    
    [[self.addBtn rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if(self.addTimer){
            [self.addTimer invalidate];
            self.addTimer = nil;
        }
        self.addTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(doAddNum) userInfo:nil repeats:YES];
    }];
    
}


- (void)clearTimer{
    if(self.plusTimer){
        [self.plusTimer invalidate];
        self.plusTimer = nil;
    }
    if(self.addTimer){
        [self.addTimer invalidate];
        self.addTimer = nil;
    }
}

//计算总价钱
- (void)calculateTotalPrice{
    CGFloat totalPrice = self.model.coupon_price.floatValue * self.model.currentNum;
    totalPrice = round(totalPrice * 100) / 100;
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%@%.2lf",@"￥",totalPrice];
    self.model.totalPriceStr = [NSString stringWithFormat:@"%.2lf",totalPrice];
}

- (void)configWithModel:(MHStoreGoodsDetailModel *)model{
    self.model = model;
    self.maxNum = model.inventory;
    self.nameLabel.text = model.coupon_name;
    self.merchantNameLabel.text = model.merchant_name;
    if(model.distance && model.distance.length){
        self.distanLabel.text = model.distance;
        self.distanceBgView.hidden = NO;
    }else{
        self.distanLabel.text = nil;
        self.distanceBgView.hidden = YES;
    }
    self.saleLabel.text = [NSString stringWithFormat:@"%@%ld",@"销量:",model.sales];
    
    if(model.coupon_price && model.coupon_price.length){
        NSString *priceStr = [NSString stringWithFormat:@"%@%@",@"￥",model.coupon_price];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:MScale * 14] range:NSMakeRange(0, 1)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:MScale * 18] range:NSMakeRange(1, model.coupon_price.length)];
        self.priceLabel.attributedText = attrStr;
    }else{
        self.priceLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@"￥"];
    }
    if(model.retail_price && model.retail_price.length){
        NSString *retail_priceStr = [NSString stringWithFormat:@"%@%@",@"门市价：￥",model.retail_price];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:retail_priceStr];
        if([UIDevice currentDevice].systemVersion.floatValue >= 8.3){
            [attrStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, retail_priceStr.length)];
            [attrStr addAttribute:NSStrikethroughColorAttributeName value:MRGBColor(132, 146, 166) range:NSMakeRange(0, retail_priceStr.length)];
            [attrStr addAttribute:NSBaselineOffsetAttributeName value:@(0) range:NSMakeRange(0, retail_priceStr.length)];
        }else{
            [attrStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, retail_priceStr.length)];
            [attrStr addAttribute:NSStrikethroughColorAttributeName value:MRGBColor(132, 146, 166) range:NSMakeRange(0, retail_priceStr.length)];
        }
        self.marketPriceLabel.attributedText = attrStr;
        
    }else{
        self.marketPriceLabel.attributedText = nil;
    }
    self.stockLabel.text = [NSString stringWithFormat:@"%ld",model.inventory];
    //图片
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:model.img_cover.s_url?:model.img_cover.url] placeholderImage:[UIImage imageNamed:@"StHoRePlaceholder"]];
    @weakify(self);
    [RACObserve(self.model, currentNum) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if([x integerValue] && [x integerValue] <= self.model.inventory){
            self.payBtn.enabled = YES;
        }else{
            self.payBtn.enabled = NO;
        }
    }];
    
}

/**
 *  textField的代理方法，监听textField的文字改变
 *  textField.text是当前输入字符之前的textField中的text
 *
 *  @param textField textField
 *  @param range     当前光标的位置
 *  @param string    当前输入的字符
 *
 *  @return 是否允许改变
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    BOOL isHaveDian;
    if ([textField.text containsString:@"."]) {
        isHaveDian = YES;
    }else{
        isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            
            return NO;
        }
        
        // 只能有一个小数点
        if (isHaveDian && single == '.') {
            
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    return NO;
                }
            }
        }
        
    }
    NSString *astr = [NSString stringWithFormat:@"%@%@",textField.text?:@"",string?:@""];
    if(astr.integerValue > self.maxNum){
        return NO;
    }
    if(astr.integerValue == 0){
        return NO;
    }
    
    return YES;
}




@end
