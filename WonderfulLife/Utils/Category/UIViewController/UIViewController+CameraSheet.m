//
//  UIViewController+CameraSheet.m
//  WonderfulLife
//
//  Created by Beelin on 17/7/5.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+CameraSheet.h"
#import "MHNavigationControllerManager.h"
#import "UIImage+Color.h"

#import "JFAuthorizationStatusManager.h"

#import "MHMacros.h"

#import "UIView+NIM.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIViewController (CameraSheet)

- (UIAlertController *)mh_showCameraSheet {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
   
    UIAlertAction *shootAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushTZImagePickerController];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    if (iOS8_2_OR_LATER ) {
        [shootAction setValue:MColorTitle forKey:@"titleTextColor"];
        [albumAction setValue:MColorTitle forKey:@"titleTextColor"];
        [cancelAction setValue:MColorContent forKey:@"titleTextColor"];
    }
    
    [alert addAction:shootAction];
    [alert addAction:albumAction];
    [alert addAction:cancelAction];
    
    
    [self presentViewController:alert animated:YES completion:nil];

    return alert;
}

- (void)pushTZImagePickerController {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        //无权限 做一个友好的提示
            [JFAuthorizationStatusManager authorizationType:JFAuthorizationTypeAlbum target:self];
        return ;
    } else {
        //打开相机
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:3 delegate:nil pushPhotoPickerVc:YES];
        
        //梁斌文
            imagePickerVc.navigationBar.shadowImage = [UIImage mh_imageWithColor:MColorSeparator size:CGSizeMake(MScreenW, 1)];
            imagePickerVc.navigationBar.tintColor = MRGBColor(50, 64, 81);
            imagePickerVc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:MRGBColor(50, 64, 81), NSFontAttributeName: [UIFont systemFontOfSize:17]};
            [imagePickerVc.navigationBar setBackgroundImage:[UIImage mh_imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowTakePicture = NO;
        imagePickerVc.isStatusBarDefault = YES;
        imagePickerVc.allowCrop = YES;
        imagePickerVc.showSelectBtn = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [self dosomethingWithImage:photos.firstObject];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
//        [alert show];
        
    [JFAuthorizationStatusManager authorizationType:JFAuthorizationTypeVideo target:self];
        
        
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        } else {
            [self takePhoto];
        }
        // 拍照之前还需要检查相册权限
    } else if ([TZImageManager authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
            [JFAuthorizationStatusManager authorizationType:JFAuthorizationTypeAlbum target:self];
        
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        weakSelf.mhLocation = location;
    } failureBlock:^(NSError *error) {
        weakSelf.mhLocation = nil;
    }];
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [self mhImagePickerVc];
        [self presentViewController:self.mhImagePickerVc animated:YES completion:nil];
        
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark - 相机代理
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dosomethingWithImage:image];
    
}


#pragma mark - setter
static NSString *locationKey = @"locationKey";
static NSString *imagePickerVCKey = @"imagePickerVCKey";
static NSString *iconViewKey = @"iconViewKey";

-(void)setMhLocation:(CLLocation *)mhLocation{
    objc_setAssociatedObject(self, &locationKey, mhLocation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setMhImagePickerVc:(UIImagePickerController *)mhImagePickerVc{
    objc_setAssociatedObject(self, &imagePickerVCKey, mhImagePickerVc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    mhImagePickerVc.delegate = self;
    mhImagePickerVc.sourceType = UIImagePickerControllerSourceTypeCamera;
    mhImagePickerVc.allowsEditing = YES;
    // set appearance / 改变相册选择页的导航栏外观
    mhImagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    mhImagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
    
}

- (void)setMhIconView:(UIImageView *)mhIconView{
    objc_setAssociatedObject(self, &iconViewKey, mhIconView, OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - getter
- (UIImagePickerController *)mhImagePickerVc{
    
    UIImagePickerController *mhImagePickerVc = objc_getAssociatedObject(self, &imagePickerVCKey);
    if (mhImagePickerVc == nil) {
        [self setMhImagePickerVc:[UIImagePickerController new]];
    }
    return mhImagePickerVc;
}

- (CLLocation *)mhLocation{
    CLLocation *mhLocation = objc_getAssociatedObject(self, &locationKey);
    if (mhLocation == nil) {
        [self setMhLocation:[CLLocation new]];
    }
    return mhLocation;
}

- (UIImageView *)mhIconView{
    return objc_getAssociatedObject(self, &iconViewKey);
}

@end




