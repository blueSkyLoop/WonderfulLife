//
//  MHVolActivityModifyAddressController.m
//  WonderfulLife
//
//  Created by zz on 14/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityModifyAddressController.h"
#import "ReactiveObjC.h"
#import "MHMacros.h"

@interface MHVolActivityModifyAddressController ()
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (strong, nonatomic) UIButton *confirmButton;
@end

@implementation MHVolActivityModifyAddressController

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请输入活动地点地址";
    placeHolderLabel.textColor = MColorToRGB(0X99A9BF);
    [self.textField addSubview:placeHolderLabel];
    
    // same font
    self.textField.font = [UIFont systemFontOfSize:18.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:18.f];
    
    [self.textField setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setTitle:@"保存" forState:UIControlStateNormal];
    confirm.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirm sizeToFit];
    [confirm setTitleColor:MColorBlue forState:UIControlStateNormal];
    [confirm setTitleColor:MColorContent forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    [confirm addTarget:self action:@selector(resetSelectedSender) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton = confirm;
    
    if (![self.content isEqualToString:@"必填"]) {
        self.textField.text = self.content;
    }
    
    @weakify(self);
    [[[self.textField.rac_textSignal
       distinctUntilChanged]
      throttle:0.1] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x.length > 0&&x.length < 50) {
            [self.confirmButton setTitleColor:MColorBlue forState:UIControlStateNormal];
            self.confirmButton.enabled = YES;
        }else {
            [self.confirmButton setTitleColor:MColorContent forState:UIControlStateNormal];
            self.confirmButton.enabled = NO;
        }
    }];
}


- (void)resetSelectedSender {
    if (self.block) {
        self.block(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
