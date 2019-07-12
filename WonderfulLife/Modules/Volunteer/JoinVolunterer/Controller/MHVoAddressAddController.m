//
//  MHVoAddressAddController.m
//  WonderfulLife
//
//  Created by zz on 26/08/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVoAddressAddController.h"
#import "MHCommunityModel.h"
#import "MHUserInfoManager.h"
#import "ReactiveObjC.h"
#import "MHMacros.h"
#import "MHCityModel.h"
#import "MHVolCreateModel.h"
#import "MHNavigationControllerManager.h"
#import "UINavigationController+RemoveChildController.h"
#import "MHVoDataFillController.h"

@interface MHVoAddressAddController ()<UITextViewDelegate,UITextFieldDelegate,MHNavigationControllerManagerProtocol>
@property (weak, nonatomic) IBOutlet UITextField *cityTextView;
@property (weak, nonatomic) IBOutlet UITextField *housingEstateTextView;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) UIButton *confirm;

@property (assign,nonatomic) BOOL isShowButton;
@end

@implementation MHVoAddressAddController{
    BOOL changed;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // configure rightBarButtonItem
    UIButton *confirm = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirm setTitle:@"确定" forState:UIControlStateNormal];
    confirm.titleLabel.font = [UIFont systemFontOfSize:17];
    [confirm sizeToFit];
    [confirm setTitleColor:MColorConfirmBtn forState:UIControlStateNormal];
    [confirm setTitleColor:MRGBColor(192, 204, 218) forState:UIControlStateDisabled];
    confirm.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:confirm];
    self.confirm = confirm;

    
    // configure placeholderLabel
    [self configTextView:self.addressTextView placeHolder:@"填写楼栋名和房间号"];
    [self.cityTextView setValue:MColorToRGB(0Xc0ccda) forKeyPath:@"_placeholderLabel.textColor"];
    [self.housingEstateTextView setValue:MColorToRGB(0Xc0ccda) forKeyPath:@"_placeholderLabel.textColor"];

    
    // configure baseView
    self.baseView.layer.borderColor = MColorSeparator.CGColor;
    self.baseView.layer.borderWidth = 1;
    self.baseView.layer.cornerRadius = 6;
    self.baseView.layer.masksToBounds = YES;
    
    [self.cityTextView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.housingEstateTextView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    // bind RAC signal
    [self setupTextViewRACSignal];
    
    self.addressTextView.delegate = self;
    
    if (self.type == MHVoAddressAddTypeFillDatas) {

        self.cityTextView.text = [MHUserInfoManager sharedManager].volUserInfo.address.city;
        self.housingEstateTextView.text = [MHUserInfoManager sharedManager].volUserInfo.address.community;
        self.addressTextView.text = [MHUserInfoManager sharedManager].volUserInfo.address.room;
        self.isShowButton = YES;
    }else if (self.type == MHVoAddressAddTypeFillDatasNoRoom){
        self.cityTextView.text = [MHUserInfoManager sharedManager].city.city_name;
        self.housingEstateTextView.text = [MHUserInfoManager sharedManager].community_name;
        self.isShowButton = YES;
    }
    if (self.communityName) {
        self.housingEstateTextView.text = self.communityName;
        self.cityTextView.text = self.cityName;
        self.isShowButton = YES;
    }
}

- (BOOL)bb_ShouldBack{
    if (changed == NO) {
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[MHVoDataFillController class]]) {
                MHVoDataFillController *dataVc = (MHVoDataFillController *)vc;
                NSInteger dataIndex = [self.navigationController.childViewControllers indexOfObject:dataVc]+1;
                NSInteger length = self.navigationController.childViewControllers.count-1-dataIndex;
                [self.navigationController mh_removeChildViewControllersInRange:NSMakeRange(dataIndex, length)];
                break;
            }
        }
        changed = YES;
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField == self.cityTextView||textField == self.housingEstateTextView) {
        if (textField.text.length > 20) {
            UITextRange *markedRange = [textField markedTextRange];
            if (markedRange) {
                return;
            }
            NSRange range = [textField.text rangeOfComposedCharacterSequenceAtIndex:15];
            textField.text = [textField.text substringToIndex:range.location];
        }
        
        if (self.cityTextView.text.length > 0&&self.housingEstateTextView.text.length > 0) {
            self.isShowButton = YES;
        }else{
            self.isShowButton = NO;
        }
    }
}

- (void)setupTextViewRACSignal{
    
    RAC(self.confirm,enabled) = RACObserve(self, isShowButton);
    
    @weakify(self);
    
    [[self.confirm rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        NSString *cityName = self.cityTextView.text;
        NSString *communityName = self.housingEstateTextView.text;
        NSString *roomName = self.addressTextView.text;
        
        NSString *resultAddres = [NSString stringWithFormat:@"%@%@%@",
                                  self.cityTextView.text,
                                  self.housingEstateTextView.text,
                                  self.addressTextView.text];
        
        MHVolUserInfoAddress *address = [[MHVolUserInfoAddress alloc] init];
        address.city = cityName;
        address.community = communityName;
        address.room = roomName;
        address.localWrite = YES; //记录是否手写地址
        MHUserInfoManager *user = [MHUserInfoManager sharedManager];
        MHVolUserInfo *vouserinfo = [[MHVolUserInfo alloc]init];
        vouserinfo.address = address;
        user.volUserInfo = vouserinfo;
        [user saveUserInfoData];
        
        if (self.confirmBlock) {
            self.confirmBlock(resultAddres);
        }
        
        MHCommunityModel * community = [[MHCommunityModel alloc]init];
        community.city_name = cityName;
        community.community_name = communityName;
        community.community_address = roomName;
        MHCityModel *city = [[MHCityModel alloc]init];
        city.city_name = self.cityTextView.text;
        
        if (self.callBack) {
            self.callBack(city, community);
        }
        
        [MHVolCreateModel sharedInstance].address.city = cityName;
        [MHVolCreateModel sharedInstance].address.community = communityName;
        [MHVolCreateModel sharedInstance].address.room = roomName;
        
        if (self.type == MHVoAddressAddTypeFillDatas || self.type == MHVoAddressAddTypeFillDatasNoRoom) {
            [self.navigationController popViewControllerAnimated: YES];
        }
    }];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    if (textView.markedTextRange == nil && textView.text.length > 20) {
        textView.text = [textView.text substringToIndex:20];
    }
    if (self.cityTextView.text.length > 0 && self.housingEstateTextView.text.length > 0) {
        self.isShowButton = YES;
    }
    if (self.cityTextView.text.length == 0 || self.housingEstateTextView.text.length == 0) {
        self.isShowButton = NO;
    }
}

// _placeholderLabel
- (void)configTextView:(UITextView *)view placeHolder:(NSString *)string {
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = string;
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = MColorToRGB(0Xc0ccda);
    [placeHolderLabel sizeToFit];
    [view addSubview:placeHolderLabel];
    
    [view setValue:placeHolderLabel forKey:@"_placeholderLabel"];
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
