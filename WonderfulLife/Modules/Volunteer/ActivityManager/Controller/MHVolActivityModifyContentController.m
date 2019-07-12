//
//  MHVolActivityModifyContentController.m
//  WonderfulLife
//
//  Created by zz on 14/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityModifyContentController.h"
#import "ReactiveObjC.h"
#import "MHMacros.h"
#import "UIView+NIM.h"

@interface MHVolActivityModifyContentController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numberOfWordsLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIButton *confirmButton;
@property (assign, nonatomic) CGFloat   kKeyboardShowHeight;
@end

@implementation MHVolActivityModifyContentController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm setTitle:@"保存" forState:UIControlStateNormal];
    confirm.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirm sizeToFit];
    [confirm setTitleColor:MColorBlue forState:UIControlStateNormal];
    [confirm setTitleColor:MColorContent forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    [confirm addTarget:self action:@selector(saveSender) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton = confirm;

    self.titleLabel.text = self.contentTitle;
    self.textView.text   = self.content;
    [self.textView becomeFirstResponder];
    
    @weakify(self);
    [[[self.textView.rac_textSignal
       distinctUntilChanged]
      throttle:0.1] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x.length > 0 && x.length < 501) {
            [self.confirmButton setTitleColor:MColorBlue forState:UIControlStateNormal];
            self.confirmButton.enabled = YES;
        }else {
            [self.confirmButton setTitleColor:MColorContent forState:UIControlStateNormal];
            self.confirmButton.enabled = NO;
        }
        self.numberOfWordsLabel.text = [NSString stringWithFormat:@"%ld / 500",x.length];
    }];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil]takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSNotification * _Nullable x) {
         @strongify(self);
         //获取键盘的高度
         NSDictionary *userInfo = [x userInfo];
         NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
         CGRect keyboardRect = [aValue CGRectValue];
         self.kKeyboardShowHeight = keyboardRect.size.height;
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

- (void)loadViewIfNeeded {
    [super loadViewIfNeeded];

}

- (void)saveSender {
    if (self.block) {
        self.block(self.textView.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
