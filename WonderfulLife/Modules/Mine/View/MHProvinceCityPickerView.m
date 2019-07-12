//
//  MHProvinceCityPickerView.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHProvinceCityPickerView.h"
#import "MHMineProvince.h"
#import "MHMineCity.h"
#import "MHMineProvince.h"
#import "MHMineNative.h"
#import "MHUserInfoManager.h"

#import "MHMacros.h"
#import "UIView+NIM.h"
#import "UIPickerView+RemoveSeparator.h"

@interface MHProvinceCityPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) UIButton *coverButton;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) UIView *containerView;
@property (nonatomic,assign) NSInteger selectedProvince;
@property (nonatomic,assign) NSInteger selectedCity;

@property (nonatomic,strong) NSDictionary *attribute;
@property (nonatomic,strong) UIToolbar *toolBar;
@property (nonatomic,strong) MHMineNative *mineNative;

@end

@implementation MHProvinceCityPickerView{
    CGFloat scale;
    CGFloat x;

}

- (void)show{
    scale = MScreenW/375;
    x = 24*scale;
    [self addSubview:self.coverButton];
    [self addSubview:self.containerView];
    [self setupPickerView];
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.nim_top -= (237+32)*scale;
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.nim_top = self.nim_height;
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)toolBarConfirm{
    BOOL scrolling = [self anySubViewScrolling:self.pickerView];
    if (scrolling) {
        return;
    }
    
    _selectedProvince = [self.pickerView selectedRowInComponent:0];
    _selectedCity = [self.pickerView selectedRowInComponent:1];
    MHMineProvince *province = self.provinceCities[_selectedProvince];
    self.mineNative.native_province_id = province.province_id;
    self.mineNative.native_province_name = province.province_name;
    if (province.cityList.count == 0) {
        self.mineNative.native_city_id = nil;
        self.mineNative.native_city_name = nil;
    }else{
        if (province.cityList.count >= _selectedCity) {//防crash
        MHMineCity *city = province.cityList[_selectedCity];
        self.mineNative.native_city_id = city.city_id;
            self.mineNative.native_city_name = city.city_name;
        }
    }
    
    if (self.confirmBlock) {
        self.confirmBlock(self.mineNative);
    }
    [self dismiss];
}

- (BOOL)anySubViewScrolling:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    return NO;
}

- (void)dealloc{
    NSLog(@"%s",__func__);
}

#pragma mark - provinceCityPicker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.provinceCities.count;
    }else{
        MHMineProvince *province = self.provinceCities[_selectedProvince];
        return province.cityList.count;
    }
    return self.provinceCities.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    [pickerView mh_clearSpearatorLine];
    
    UILabel *label = (UILabel *)view;
    if (label == nil) {
        label = [[UILabel alloc] init];
    }
    
    if (component == 0) {
        MHMineProvince *province = self.provinceCities[row];
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:province.province_name attributes:self.attribute];
        label.attributedText = attString;
        
        [label sizeToFit];
        return label;
    }else{
        MHMineProvince *province = self.provinceCities[_selectedProvince];
        if (province.cityList.count >= row) {//防崩溃
            MHMineCity *city = province.cityList[row];
            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:city.city_name attributes:self.attribute];
            label.attributedText = attString;
            [label sizeToFit];
            return label;
        }
        return nil;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return pickerView.nim_height/3;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _selectedProvince = row;
        [pickerView reloadComponent:1];
    }
}

- (void)setProvinceCities:(NSArray *)provinceCities{
    _provinceCities = provinceCities;
    [self.pickerView reloadAllComponents];
    
    [self setupPickerView];
    
}

- (void)setupPickerView{
    MHUserInfoManager *user = [MHUserInfoManager sharedManager];
    
    for (NSInteger i = 0; i < _provinceCities.count; i++) {
        MHMineProvince *province = _provinceCities[i];
        if ([user.nativeprovince.native_province_id isEqualToNumber:province.province_id]) {
            _selectedProvince = i;
            [_pickerView selectRow:_selectedProvince inComponent:0 animated:NO];
            [_pickerView reloadComponent:1];
            break;
        }
    }
    
    MHMineProvince *selectedProvince = _provinceCities[_selectedProvince];
    for (NSInteger i = 0; i < selectedProvince.cityList.count; i++) {
        MHMineCity *city = selectedProvince.cityList[i];
        if ([user.nativecity.native_city_id isEqualToNumber:city.city_id]) {
            _selectedCity = i;
            [_pickerView selectRow:_selectedCity inComponent:1 animated:NO];
            break;
        }
    }
}

#pragma mark - lazy

- (UIPickerView *)pickerView{
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, self.toolBar.nim_bottom, self.containerView.nim_width, 180*scale);
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
    }
    return _pickerView;
}

- (UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(x, self.nim_height, self.nim_width-2*x, 237*scale)];
        _containerView.layer.cornerRadius = 8*scale;
        _containerView.layer.masksToBounds = YES;
        _containerView.backgroundColor = [UIColor whiteColor];
        [_containerView addSubview:self.toolBar];
        [_containerView addSubview:self.pickerView];
    }
    return _containerView;
}

- (UIButton *)coverButton{
    if (!_coverButton) {
        _coverButton = [[UIButton alloc] initWithFrame:self.bounds];
        [_coverButton setBackgroundColor:MRGBAColor(0, 0, 0, 0.3)];
        [_coverButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}

- (UIToolbar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.containerView.nim_width, 56*scale)];
        _toolBar.backgroundColor = [UIColor whiteColor];
        
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
        [confirm setTitle:@"确定" forState:UIControlStateNormal];
        confirm.titleLabel.font = [UIFont systemFontOfSize:16];
        [confirm sizeToFit];
        [confirm addTarget:self action:@selector(toolBarConfirm) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
        
        UIBarButtonItem *fiexibleSpaceLeft = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        cancel.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancel sizeToFit];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancel];
        [_toolBar setItems:@[cancelItem,fiexibleSpaceLeft ,confirmItem]];
    }
    return _toolBar;
}

- (NSDictionary *)attribute{
    if (_attribute == nil) {
        if (iOS8) {
            _attribute = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:18*scale],NSForegroundColorAttributeName:MColorTitle};
        }else{
            _attribute = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:18*scale],NSForegroundColorAttributeName:MColorTitle};
        }
    }
    return _attribute;
}

- (MHMineNative *)mineNative{
    if (_mineNative == nil) {
        _mineNative = [MHMineNative new];
    }
    return _mineNative;
}

@end





