//
//  MHStoreQrcodeConfirmPayView.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHStoreQrcodeConfirmPayView.h"
#import "ReactiveObjC.h"
#import "UIImageView+WebCache.h"

#import "MHReportRepairPhotoPreViewController.h"

@interface MHStoreQrcodeConfirmPayView()<UITextFieldDelegate>

@property (nonatomic,strong)NSDictionary *dict;

@end

@implementation MHStoreQrcodeConfirmPayView

- (void)awakeFromNib{
    [super awakeFromNib];
    [LCommonModel resetFontSizeWithView:self];
    
    self.pictureView.layer.cornerRadius = 50;
    self.pictureView.layer.masksToBounds = YES;
    
    self.nameBgView.layer.borderColor = [MRGBColor(229, 233, 242) CGColor];
    self.nameBgView.layer.borderWidth = 1;
    self.nameBgView.layer.cornerRadius = 19;
    self.nameBgView.layer.masksToBounds = YES;
    
    self.textField.layer.borderColor = [MRGBColor(229, 233, 242) CGColor];
    self.textField.layer.borderWidth = 1;
    self.textField.layer.cornerRadius = 3;
    self.textField.layer.masksToBounds = YES;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 56)];
    self.textField.leftView = leftView;
    self.textField.leftViewMode = UITextFieldViewModeAlways;
    [self.textField setValue:MRGBColor(192, 204, 218) forKeyPath:@"_placeholderLabel.textColor"];
    
    
    [self bindView];
    
    self.textField.delegate = self;
    
}

- (void)bindView{
    @weakify(self);
    [[self.textField rac_textSignal] subscribeNext:^(NSString *text) {
        @strongify(self);
        CGFloat score = self.textField.text.floatValue;
        if(score){
            self.comfirmBtn.enabled = YES;
        }else{
            self.comfirmBtn.enabled = NO;
        }
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [[tap.rac_gestureSignal throttle:.2] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        NSString *s_imageUrl = self.dict[@"user_s_img"];
        NSString *imageUrl = self.dict[@"user_img"];
        MHReportRepairPhotoPreViewController *photoVC = [MHReportRepairPhotoPreViewController new];
        MHReportRepairPhotoPreViewModel *model = [MHReportRepairPhotoPreViewModel new];
        model.bigPicUrl = imageUrl?:s_imageUrl;
        model.type = 1;
        photoVC.dataArr = [@[model] mutableCopy];
        [[self viewController].navigationController pushViewController:photoVC animated:YES];
        
    }];
    self.pictureView.userInteractionEnabled = YES;
    [self.pictureView addGestureRecognizer:tap];
    
}


- (void)confitUIWithInfor:(NSDictionary *)dict{
    self.dict = dict;
    self.nameLabel.text = dict[@"merchant_name"];
    NSString *s_imageUrl = dict[@"user_s_img"];
    NSString *imageUrl = dict[@"user_img"];
    //图片
    [self.pictureView sd_setImageWithURL:[NSURL URLWithString:s_imageUrl?:imageUrl] placeholderImage:[UIImage imageNamed:@"StHoRePlaceholder"]];
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
    
    return YES;
}

//获取控制器
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
