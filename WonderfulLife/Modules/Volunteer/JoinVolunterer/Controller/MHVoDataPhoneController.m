//
//  MHVoDataPhoneController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoDataPhoneController.h"
#import "MHMacros.h"
#import "MHHUDManager.h"
#import "MHNavigationControllerManager.h"
#import "NSString+Chinese.h"
#import "MHVolunteerDataHandler.h"

@interface MHVoDataPhoneController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITextField *namefield;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) UIButton *confirm;
@property (weak, nonatomic) IBOutlet UIView *warnView;

@end

@implementation MHVoDataPhoneController{
    NSInteger kMaxLength;
}

#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.top.constant = 64;
    self.namefield.borderStyle = UITextBorderStyleNone;
    [self setupContainerLayer];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirm setTitle:@"确认" forState:UIControlStateNormal];
    confirm.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirm sizeToFit];
    [confirm setTitleColor:MColorConfirmBtn forState:UIControlStateNormal];
    [confirm setTitleColor:MRGBColor(192, 204, 218) forState:UIControlStateDisabled];
    confirm.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    [confirm addTarget:self action:@selector(buttonConfirm) forControlEvents:UIControlEventTouchUpInside];
    self.confirm = confirm;
    
    self.top.constant = 64;
    
    if (_type == MHVoDataPhoneControllerTypeRealName) {
        kMaxLength = 15;
        self.namefield.placeholder = @"请输入真实姓名";
        self.titleLabel.text = @"姓名";
        self.namefield.keyboardType = UIKeyboardTypeDefault;
        
    }else if (_type == MHVoDataPhoneControllerTypePhone){
        kMaxLength = 12;
    }else if (_type == MHVoDataPhoneControllerTypeName){
        self.namefield.placeholder = @"请输入昵称";
        self.titleLabel.text = @"昵称";
        self.namefield.keyboardType = UIKeyboardTypeDefault;
        kMaxLength = 10;
        
    }else if (_type == MHVoDataPhoneControllerTypeCompany){
        self.namefield.placeholder = @"请输入公司名称";
        self.titleLabel.text = @"公司名称";
        self.namefield.keyboardType = UIKeyboardTypeDefault;
        kMaxLength = 50;
    }else if (_type == MHVoDataPhoneControllerTypeIdentity){
        self.namefield.placeholder = @"请输入身份证号码";
        self.titleLabel.text = @"身份证号码";
        self.namefield.keyboardType = UIKeyboardTypeDefault;
        kMaxLength = 18;
    }
    
    self.namefield.text = self.string;
 
    if (_type) {
        [self.warnView removeFromSuperview];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:) name:UITextFieldTextDidChangeNotification object:self.namefield];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:self.namefield];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
//    [nav navigationBarTranslucent];
    if (self.string.length) {
        if (self.type == MHVoDataPhoneControllerTypeRealName) {
            self.confirm.enabled = self.string.length>=2;
        }else if (self.type == MHVoDataPhoneControllerTypeIdentity){
            self.confirm.enabled = self.string.length == 18;
        }else{
            self.confirm.enabled = self.string.length;
        }
    }else{
        self.confirm.enabled = NO;
    }
    
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    MHNavigationControllerManager *nav = (MHNavigationControllerManager *)self.navigationController;
//    [nav navigationBarWhite];
//}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.isMaskCode) {
        [self.namefield becomeFirstResponder];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.namefield];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:self.namefield];

#ifdef DEBUG
    NSLog(@"%s",__func__);
#endif
    
}

#pragma mark - private

- (void)setupContainerLayer{
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.borderColor = MRGBColor(211, 220, 231).CGColor;
    self.containerView.layer.borderWidth = 1;
    
    self.containerView.layer.shadowOffset = CGSizeMake(0, 2);
    self.containerView.layer.shadowRadius = 5;
    self.containerView.layer.shadowColor = MRGBColor(239,242,247).CGColor;
    self.containerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.containerView.layer.shadowOpacity = 1;
    
}

//是否全数字
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否有emoji
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

- (BOOL)isCorrect:(NSString *)IDNumber {
    NSMutableArray *IDArray = [NSMutableArray array];
    // 遍历身份证字符串,存入数组中
    for (int i = 0; i <18; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [IDNumber substringWithRange:range];
        [IDArray addObject:subString];
    }
    // 系数数组
    NSArray *coefficientArray = @[@7, @9, @10, @5, @8, @4, @2, @1, @6, @3, @7, @9, @10, @5, @8, @4, @"2"];
    // 余数数组
    NSArray *remainderArray = @[@"1", @"0", @"X", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    // 每一位身份证号码和对应系数相乘之后相加所得的和
    int sum = 0;
    for (int i = 0; i <17; i++) {
        int coefficient = [coefficientArray[i] intValue];
        int ID = [IDArray[i] intValue];
        sum += coefficient * ID;
    }
    // 这个和除以11的余数对应的数
    NSString *str = remainderArray[(sum % 11)];
    // 身份证号码最后一位
    NSString *string = [IDNumber substringFromIndex:17];
    // 如果这个数字和身份证最后一位相同,则符合国家标准,返回YES
    return [str isEqualToString:string];
}

#pragma mark - textView通知
- (void)textFieldTextDidBeginEditing:(NSNotification*)obj {
    if (self.isMaskCode) {
        UITextField *textField = (UITextField *)obj.object;
        textField.text = @"";
        self.isMaskCode = NO;
    }
}

-(void)textFieldEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = self.textInputMode.primaryLanguage;
    
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        if (!position && toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
    
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]) {
        if (self.type == MHVoDataPhoneControllerTypeRealName) {
            self.confirm.enabled = textField.text.length >=2;
        }else if (self.type == MHVoDataPhoneControllerTypeIdentity){
            self.confirm.enabled = textField.text.length == 18;
        }else{
            self.confirm.enabled = textField.text.length;
        }
    }else{
        self.confirm.enabled = NO;
    }
    
}

#pragma mark - confirm
- (void)buttonConfirm{
    //判断是否全空格
    if([[self.namefield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        return;
    }
    
    if (self.type==MHVoDataPhoneControllerTypePhone && [self isPureInt:self.namefield.text] == NO) {
        [MHHUDManager showText:@"请输入正确手机或固定号码格式"];
        return;
    }else if (self.type == MHVoDataPhoneControllerTypeCompany && [self stringContainsEmoji:self.namefield.text]) {
        [MHHUDManager showText:@"请不要输入表情符号"];
        return;
    }else if (self.type == MHVoDataPhoneControllerTypeRealName && [self.namefield.text isChinese] == NO){
        [MHHUDManager showText:@"请输入中文"];
        return;
    }else if (self.type == MHVoDataPhoneControllerTypeIdentity && [self isCorrect:self.namefield.text] == NO){
        [MHHUDManager showText:@"身份证信息有误，请输入正确的身份证号码！"];
        return;
    }
    
    if (self.type == MHVoDataPhoneControllerTypeIdentity) {
        [MHHUDManager show];
        [MHVolunteerDataHandler postVolunteerInfoIdentityValidateWithIdentity:self.namefield.text CallBack:^(BOOL success, NSDictionary *data, NSString *errmsg) {
            [MHHUDManager dismiss];
            if (success) {
                if (self.confirmBlock) {
                    self.confirmBlock(self.namefield.text);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MHHUDManager showErrorText:errmsg];
                return ;
            }
        }];
    }else{
        if (self.confirmBlock) {
            self.confirmBlock(self.namefield.text);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end






