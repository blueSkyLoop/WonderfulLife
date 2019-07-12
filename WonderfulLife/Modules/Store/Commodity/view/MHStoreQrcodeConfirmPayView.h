//
//  MHStoreQrcodeConfirmPayView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/27.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHBaseView.h"
#import "MHThemeButton.h"

@interface MHStoreQrcodeConfirmPayView : MHBaseView
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UIView *nameBgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet MHThemeButton *comfirmBtn;

- (void)confitUIWithInfor:(NSDictionary *)dict;

@end
