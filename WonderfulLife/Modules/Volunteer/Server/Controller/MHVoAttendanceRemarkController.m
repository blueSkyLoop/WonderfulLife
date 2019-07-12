//
//  MHVoAttendanceRemarkController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/13.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHVoAttendanceRemarkController.h"

#import "UIView+NIM.h"
#import "MHMacros.h"
#import "MHAttendanceRecordHeader.h"

@interface MHVoAttendanceRemarkController ()
@property (nonatomic,strong) UILabel *countLabel;
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,strong) MHAttendanceRecordHeader *headerView;

@property (nonatomic,assign) NSInteger count;

@end


@implementation MHVoAttendanceRemarkController
CGFloat topInset;
#pragma mark - override
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirm setTitle:@"保存" forState:UIControlStateNormal];
    confirm.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirm sizeToFit];
    [confirm setTitleColor:MColorConfirmBtn forState:UIControlStateNormal];
    [confirm setTitleColor:MRGBColor(192, 204, 218) forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    [confirm addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self headerView];
    [self containerView];
    [self textView];
    [self countLabel];
    
    [self.textView becomeFirstResponder];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
    
}

#pragma mark - 按钮点击
- (void)save{
    self.remarks = self.textView.text;
    !self.saveBlock ? : self.saveBlock();
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - notification
- (void)textViewTextDidChange{
    _count = self.textView.text.length;
    self.countLabel.text = [NSString stringWithFormat:@"%zd",_count];
    if (_count > 500) {
        self.textView.text = [self.textView.text substringToIndex:500];
        self.countLabel.text = @"500";
        _count = 500;
    }
}

#pragma mark - delegate

#pragma mark - private

#pragma mark - lazy
- (MHAttendanceRecordHeader *)headerView{
    if (_headerView == nil) {
        _headerView = [[MHAttendanceRecordHeader alloc] initWithFrame:CGRectMake(0, 64, self.view.nim_width, 64)];
        _headerView.titleLabel.text = @"备注";
        _headerView.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:_headerView];
    }
    return _headerView;
}

- (UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(24, 128, self.view.nim_width-48, 204)];
        [self.view addSubview:_containerView];
    }
    return _containerView;
}

- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 8, _containerView.nim_width, _containerView.nim_height - 60)];
        _textView.textColor = MColorTitle;
        _textView.font = [UIFont systemFontOfSize:17];
        _textView.text = _remarks;
        [_containerView addSubview:_textView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return _textView;
}

- (UILabel *)countLabel{
    if (_countLabel == nil) {
        UILabel *fiveLabel = [[UILabel alloc] init];
        fiveLabel.text = @"/500";
        fiveLabel.textColor = MColorToRGB(0x99A9BF);
        fiveLabel.font = [UIFont systemFontOfSize:17];
        [fiveLabel sizeToFit];
        fiveLabel.nim_right = _containerView.nim_width;
        fiveLabel.nim_top = _textView.nim_bottom + 12;
        [_containerView addSubview:fiveLabel];
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.text = @"444";
        _countLabel.textColor = fiveLabel.textColor;
        _countLabel.font = fiveLabel.font;
        [_countLabel sizeToFit];
        _countLabel.textAlignment = NSTextAlignmentRight;
        _countLabel.nim_right = fiveLabel.nim_left;
        _countLabel.nim_top = fiveLabel.nim_top;
        _countLabel.text = @"0";
        [_containerView addSubview:_countLabel];
    }
    return _countLabel;
}

#ifdef DEBUG
- (void)dealloc{
    NSLog(@"%s",__func__);
}
#endif
@end







