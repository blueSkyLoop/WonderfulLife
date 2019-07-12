//
//  MHVoDataAddressController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoDataAddressController.h"
#import "MHMacros.h"
#import "MHVoAddressTextView.h"
#import "MHNavigationControllerManager.h"

@interface MHVoDataAddressController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (nonatomic,weak) UIButton *confirm;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MHVoAddressTextView *textView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation MHVoDataAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    self.titleLabel.text = self.topTitle;
    self.textView.text = self.address;
    if (self.address.length && self.type == MHVoAddressTextViewTypeIntroduce) {
        self.textView.placeHolderLabel.hidden = YES;
    }
    self.textView.type = _type;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.type == MHVoAddressTextViewTypeIntroduce) {
        self.confirm.enabled = self.address.length;
        
    }else if (self.type == MHVoAddressTextViewTypeAddress){
        self.confirm.enabled = self.address.length >= 5;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

-(void)dealloc{
    NSLog(@"%s",__func__);
}

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

#pragma mark - textViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (self.type == MHVoAddressTextViewTypeIntroduce) {
        self.confirm.enabled = textView.text.length && [[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    }else if (self.type == MHVoAddressTextViewTypeAddress){
        self.confirm.enabled = textView.text.length >= 5 && [[textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length];
    }
}

#pragma mark - confirm
- (void)buttonConfirm{
    if([[self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length]==0) {
        return;
    }
    if (self.confirmBlock) {
        self.confirmBlock(self.textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end




