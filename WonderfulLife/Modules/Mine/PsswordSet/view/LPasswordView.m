//
//  LPasswordView.m
//  WonderfulLife
//
//  Created by lgh on 2017/9/22.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "LPasswordView.h"
#import "MHMacros.h"
#import "Masonry.h"
#import "LPasswordTextField.h"
#import "ReactiveObjC.h"

@interface LPasswordView()<UITextFieldDelegate>

@property (nonatomic,assign)NSInteger anum;
@property (nonatomic,copy)NSString *titleName;

@property (nonatomic,strong)UIView *bgView;

@end

@implementation LPasswordView

- (id)initWithInputNum:(NSInteger)num titleName:(NSString *)titleName{
    self = [super init];
    if(self){
        self.anum = num;
        self.titleName = titleName;
        [self setUpUI];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setUpUI{
    UILabel *albel;
    if(self.titleName && self.titleName.length){
        albel = [UILabel new];
        albel.textColor = MRGBColor(50, 64, 87);
        albel.font = [UIFont systemFontOfSize:MScale * 18];
        albel.text = self.titleName;
        albel.tag = 3000;
        [self addSubview:albel];
    }
    
    _bgView = [UIView new];
    _bgView.backgroundColor = MRGBColor(153, 169, 191);
    _bgView.layer.borderWidth = .5;
    _bgView.layer.borderColor = [MRGBColor(153, 169, 191) CGColor];
    _bgView.layer.cornerRadius = 2;
    _bgView.layer.masksToBounds = YES;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(passwordBgTapAction:)];
    [self.bgView addGestureRecognizer:tapGes];
    
    [self addSubview:_bgView];
    
    LPasswordTextField *tempTextf;
    
    for(int i=0;i<self.anum;i++){
        LPasswordTextField *atextF = [LPasswordTextField new];
        atextF.tag = 1000+i;
        atextF.delegate = self;
        atextF.font = [UIFont systemFontOfSize:MScale * 24];
        atextF.keyboardType = UIKeyboardTypeNumberPad;
        atextF.backgroundColor = [UIColor whiteColor];
        atextF.textColor = MRGBColor(71, 86, 105);
        atextF.secureTextEntry = YES;
        atextF.textAlignment = NSTextAlignmentCenter;
        //写这句就会让光标不可见
//        atextF.tintColor = [UIColor clearColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:atextF];
        [_bgView addSubview:atextF];
        if(i == 0){
            [atextF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bgView.mas_top);
                make.left.equalTo(_bgView.mas_left);
                make.bottom.equalTo(_bgView.mas_bottom);
                make.height.equalTo(@52).priorityHigh();
            }];
        }else if(i == self.anum - 1){
            [atextF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bgView.mas_top);
                make.left.equalTo(tempTextf.mas_right).offset(.5);
                make.right.equalTo(_bgView.mas_right);
                make.bottom.equalTo(_bgView.mas_bottom);
                make.height.equalTo(@52).priorityHigh();
                make.width.equalTo(tempTextf.mas_width);
            }];
        }else{
            [atextF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bgView.mas_top);
                make.left.equalTo(tempTextf.mas_right).offset(.5);
                make.bottom.equalTo(_bgView.mas_bottom);
                make.height.equalTo(@52).priorityHigh();
                make.width.equalTo(tempTextf.mas_width);
            }];
        }
        
        tempTextf = atextF;
    }
    
    if(albel){
        [albel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.lessThanOrEqualTo(self.mas_right);
        }];
    }
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(albel?albel.mas_bottom:self.mas_top).offset(albel?16:0);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    LPasswordTextField *atextF = (LPasswordTextField *)[self.bgView viewWithTag:1000];
    if(atextF){
        [self makeOtherTextfieldUnenable:atextF];
    }
    
}

- (void)textFieldChange:(NSNotification *)not{
    LPasswordTextField *atextF = (LPasswordTextField *)not.object;
    NSInteger index = atextF.tag;
    NSString *astr = [atextF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(astr.length == 1){
        LPasswordTextField *theTextF = (LPasswordTextField *)[self.bgView viewWithTag:index + 1];
        if(theTextF){
            [theTextF becomeFirstResponder];
        }else{
            [atextF resignFirstResponder];
        }
    }else if(astr.length == 0){
        LPasswordTextField *theTextF = (LPasswordTextField *)[self.bgView viewWithTag:index - 1];
        if(theTextF){
            [theTextF becomeFirstResponder];
        }else{
            //            [atextF resignFirstResponder];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        BOOL isChange = NO;
        for(LPasswordTextField *textf in self.bgView.subviews){
            NSString *textStr = [textf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if(!textStr || textStr.length == 0){
                isChange = YES;
                break;
            }
        }
        
        if(isChange && self.passwordChangeBlock){
            self.passwordChangeBlock();
        }
        
    });
    
}

- (void)updataTitleNameWith:(NSString *)titleName{
    UILabel *albel = (UILabel *)[self viewWithTag:3000];
    if(albel){
        albel.text = titleName?titleName:nil;
    }
    [self clearInput];
    
    
}

- (void)clearInput{
    for(int i=0;i<self.anum;i++){
        LPasswordTextField *atextF = (LPasswordTextField *)[self.bgView viewWithTag:1000 + i];
        atextF.text = nil;
        if(i == 0){
            atextF.enabled = YES;
        }else{
            atextF.enabled = NO;
        }
    }
    self.inputStrig = nil;
}

- (void)makeFirstResponderIndex:(NSInteger)index{
    LPasswordTextField *atextF = (LPasswordTextField *)[self.bgView viewWithTag:1000 + index];
    atextF.enabled = YES;
    [atextF becomeFirstResponder];
}


- (NSString *)inputStrig{
    NSString *password = nil;
    for(int i=0;i<self.anum;i++){
        LPasswordTextField *atextF = (LPasswordTextField *)[self.bgView viewWithTag:1000 + i];
        NSString *astr = [atextF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        password = [NSString stringWithFormat:@"%@%@",password?password:@"",astr?astr:@""];
    }
    
    _inputStrig = password;
    return _inputStrig;
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    NSInteger index = textField.tag - 1000;
//    if(index == 0){
//        return YES;
//    }else{
//        UITextField *atext = (UITextField *)[_bgView viewWithTag:1000 + index - 1];
//        if(atext){
//            NSString *astr = [atext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            if(astr.length){
//                atext.enabled = YES;
//                return YES;
//            }
//            return NO;
//        }else{
//            return YES;
//        }
//    }
//    return YES;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *astr = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if([string isEqualToString:@""]){
        
        NSInteger index = textField.tag;
        LPasswordTextField *atextF = (LPasswordTextField *)[self.bgView viewWithTag:index - 1];
        if(atextF){
            atextF.enabled = YES;
            [atextF becomeFirstResponder];
            textField.text = nil;
            [self makeOtherTextfieldUnenable:atextF];
            [self passwordCombination];
            return NO;
        }
        
        [self passwordCombination];
        return YES;
    }
    
    //只能输入一位
    if(astr.length){
        
        NSInteger index = textField.tag;
        LPasswordTextField *atextF = (LPasswordTextField *)[self.bgView viewWithTag:index + 1];
        if(atextF){
            atextF.enabled = YES;
            atextF.text = string;
            if(atextF.tag - 1000 == self.anum - 1 && ![string isEqualToString:@""]){
                atextF.text = string;
                [textField resignFirstResponder];
                if(self.passwordInputCompleBlock){
                    [self passwordCombination];
                    self.passwordInputCompleBlock();
                }
            }else{
                [atextF becomeFirstResponder];
            }
            [self makeOtherTextfieldUnenable:atextF];
            [self passwordCombination];
            return NO;
        }
        
        [self passwordCombination];
        return YES;
        
//        return NO;
    }
    
    [self passwordCombination];
    return YES;
}

- (void)passwordCombination{
    NSString *password = nil;
    for(int i=0;i<self.anum;i++){
        LPasswordTextField *atextF = (LPasswordTextField *)[self.bgView viewWithTag:1000 + i];
        NSString *astr = [atextF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        password = [NSString stringWithFormat:@"%@%@",password?password:@"",astr?astr:@""];
    }
    
    self.inputStrig = password;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if(textField.tag == 1000 + self.anum - 1){
//        if(self.passwordInputCompleBlock){1
//            self.passwordInputCompleBlock();
//        }
//    }
//}

- (void)makeOtherTextfieldUnenable:(LPasswordTextField *)textField{
    for(int i=0;i<self.anum;i++){
        LPasswordTextField *atextF = (LPasswordTextField *)[self.bgView viewWithTag:1000+i];
        if(atextF && atextF != textField){
            atextF.enabled = NO;
        }
    }
}

- (void)passwordBgTapAction:(UITapGestureRecognizer *)sender{
    for(int i=0;i<self.anum;i++){
        LPasswordTextField *atextF = (LPasswordTextField *)[self.bgView viewWithTag:1000+i];
        if(atextF.enabled && ![atextF isFirstResponder]){
            [atextF becomeFirstResponder];
            break;
        }
    }
}

@end
