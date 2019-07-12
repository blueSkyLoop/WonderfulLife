//
//  MHCePaymentBillController.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHCePaymentBillController.h"
#import "MHCertificationSuccessController.h"

#import "MHMacros.h"

#import "UIView+GradientColor.h"
#import "UIViewController+CameraSheet.h"
#import "UIButton+MHImageUpTitleDown.h"

#import "MHHUDManager.h"
#import "MHAliyunManager.h"

#import "MHThemeButton.h"

#import "MHStructRoomModel.h"

#import "MHCertificationRequestHandler.h"

#import <YYModel.h>

@interface MHCePaymentBillController ()
@property (weak, nonatomic) IBOutlet UILabel *roomNameLab;
@property (weak, nonatomic) IBOutlet UIButton *imv;
@property (weak, nonatomic) IBOutlet MHThemeButton *commitBtn;

@end

@implementation MHCePaymentBillController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupControls];
    
}


- (void)setupControls {
    [self.imv setImage:[UIImage imageNamed:@"ce_upload_receipt"] forState:UIControlStateNormal];
    self.imv.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imv.titleEdgeInsets = UIEdgeInsetsZero;
    self.imv.imageEdgeInsets = UIEdgeInsetsZero;
    
    [self.imv mh_imageUpTitleDownWithOffset:16.0];
   
    self.imv.layer.masksToBounds = YES;
    self.imv.layer.cornerRadius = 6;
    self.imv.layer.borderColor = MColorSeparator.CGColor;
    self.imv.layer.borderWidth = 1;
    
    self.roomNameLab.text = self.room.room_info;
    
    self.commitBtn.enabled = NO;
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = MCornerRadius;
    

}

#pragma mark - Request
- (void)requestCommitWithImgs:(NSString *)imgs {
    [MHCertificationRequestHandler postUploadBillWithStructId:self.room.struct_id imgs:imgs success:^{
        [MHHUDManager dismiss];
        
        MHCertificationSuccessController *vc = [[MHCertificationSuccessController alloc] initWithType:MHCertificationSuccessTypeHouseholdCommit];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSString *errmsg) {
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
}
#pragma mark - Event
- (IBAction)uploadImageAction:(UIButton *)sender {
    [self mh_showCameraSheet];
}

- (IBAction)commitAction:(UIButton *)sender {
    //upload oss
    [MHHUDManager show];
    [[MHAliyunManager sharedManager] uploadImageToAliyunWithImage:self.imv.currentImage success:^(MHOOSImageModel *imageModel) {
        NSDictionary *dict = @{@"name": imageModel.name,
                               @"width": @(imageModel.width),
                               @"height": @(imageModel.height)};
        NSArray *arr = @[dict];
        //request
        [self requestCommitWithImgs:[arr yy_modelToJSONString]];
    } failed:^(NSString *errmsg){
        [MHHUDManager dismiss];
        [MHHUDManager showErrorText:errmsg];
    }];
    
}

#pragma mark - UIImagePickerController Delegate
- (void)dosomethingWithImage:(UIImage *)image{
    [self.imv setImage:image forState:UIControlStateNormal];
    [self.imv setTitle:nil forState:UIControlStateNormal];
    
    self.commitBtn.enabled = YES;
}

@end
