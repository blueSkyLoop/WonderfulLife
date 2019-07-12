//
//  MHReportRepairNewEnableEditCell.m
//  WonderfulLife
//
//  Created by zz on 16/10/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairNewEnableEditCell.h"
#import "MHReportRepairPictureView.h"
#import "ReactiveObjC.h"
#import "TZImageManager.h"

#import "MHReportRepairNewModel.h"

#import "MHMacros.h"
#import <AVFoundation/AVFoundation.h>

#import "TZImagePickerController.h"
#import "MHReportRepairPhotoPreViewController.h"
#import "TZLocationManager.h"
#import "JFAuthorizationStatusManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface MHReportRepairNewEnableEditCell ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *fontNumberLabel;
@property (weak, nonatomic) IBOutlet MHReportRepairPictureView *pictureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@property (strong, nonatomic) NSMutableArray *selectedAssets;
@property (strong, nonatomic) UIImagePickerController *imagePickerVc;
@property (strong, nonatomic) CLLocation *location;
@end

@implementation MHReportRepairNewEnableEditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *placeHolderLabel = [[UILabel alloc] init];
    placeHolderLabel.text = @"请详细描述您遇到的问题，我们会尽快为您解决";
    placeHolderLabel.numberOfLines = 0;
    placeHolderLabel.textColor = MColorToRGB(0X99A9BF);
    [self.textView addSubview:placeHolderLabel];
    
    // same font
    self.textView.font = [UIFont systemFontOfSize:17.f];
    placeHolderLabel.font = [UIFont systemFontOfSize:17.f];
    [self.textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    
    self.textView.textContainerInset = UIEdgeInsetsMake(5, -5, 5, -5);
    
    self.textView.delegate = self;
    @weakify(self);
    CGFloat itemWidth = (MScreenW - 80.f)/3.f;
    self.pictureViewHeightConstraint.constant = itemWidth; //适配4寸屏幕，pictureView的height过高的issue
    self.pictureView.itemGap  = 12.f;
    self.pictureView.itemSize = CGSizeMake(itemWidth, itemWidth);
    self.pictureView.pictreCollectionViewDidSelectBlock = ^(NSIndexPath *indexPath, MHReportRepairPictureModel *cellModel) {
        @strongify(self);
        [MHReportRepairNewModel share].imgs = nil;
        if (cellModel.isTakePhoto) {
            [self showSheet];
        }else {
            //跳到预览图
            MHReportRepairPhotoPreViewController *controller = [MHReportRepairPhotoPreViewController new];
            NSMutableArray *preArray = [NSMutableArray array];
            [[MHReportRepairNewModel share].images enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                MHReportRepairPhotoPreViewModel *model = [MHReportRepairPhotoPreViewModel new];
                model.bigImage = obj;
                model.type = 3;
                [preArray addObject:model];
            }];
            controller.dataArr = preArray;
            controller.showDeleteButton = YES;
            controller.clickNum = indexPath.row;
            controller.previewDeleteBlock = ^(NSInteger removeIndex) {
                [self.selectedAssets removeObjectAtIndex:removeIndex];
                [[MHReportRepairNewModel share].images removeObjectAtIndex:removeIndex];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.pictureView.pictureArr = [MHReportRepairNewModel share].images;
                });
            };
            [[self viewController].navigationController pushViewController:controller animated:YES];
        }
    };
    self.pictureView.pictureRemoveBlock = ^(MHReportRepairPictureModel *model, NSInteger removeIndex) {
        [MHReportRepairNewModel share].imgs = nil;
        [self.selectedAssets removeObjectAtIndex:removeIndex];
        [[MHReportRepairNewModel share].images removeObjectAtIndex:removeIndex];
    };
    
    UITableView *tableView = [self tableView];
    [tableView beginUpdates];
    [tableView endUpdates];
}


- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *atext = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (atext.length >300) {
        atext = [self.textView.text substringToIndex:300];
        self.textView.text = atext;
    }else if (atext.length == 0){
        self.textView.text = atext;
        return;
    }

    [MHReportRepairNewModel share].repairment_cont = self.textView.text;
    self.fontNumberLabel.text = [NSString stringWithFormat:@"%ld / 300",self.textView.text.length];

    CGRect bounds = self.textView.bounds;
    CGSize maxSize = CGSizeMake(bounds.size.width, CGFLOAT_MAX);
    CGSize newSize = [self.textView sizeThatFits:maxSize];
    bounds.size = newSize;
    
    if (bounds.size.height > 96) {
        self.textView.bounds = bounds;
        UITableView *tableView = [self tableView];
        [tableView beginUpdates];
        [tableView endUpdates];
    }
    
}



- (void)showSheet {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *shootAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhoto];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self pushTZImagePickerController];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    if (iOS8_2_OR_LATER) {
        [shootAction setValue:MColorTitle forKey:@"titleTextColor"];
        [albumAction setValue:MColorTitle forKey:@"titleTextColor"];
        [cancelAction setValue:MColorContent forKey:@"titleTextColor"];
    }
    
    [alert addAction:shootAction];
    [alert addAction:albumAction];
    [alert addAction:cancelAction];
    [[self viewController] presentViewController:alert animated:YES completion:nil];
}

- (void)pushTZImagePickerController {
    
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        //无权限 做一个友好的提示
        [JFAuthorizationStatusManager authorizationType:JFAuthorizationTypeAlbum target:[self viewController]];
        return ;
    }else{
        NSInteger count = 3;
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:count columnNumber:4 delegate:self pushPhotoPickerVc:YES];
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingGif = NO;
        imagePickerVc.allowTakePicture = NO;
        imagePickerVc.isStatusBarDefault = YES;
        imagePickerVc.naviBgColor = [UIColor whiteColor];
        imagePickerVc.naviTitleColor = [UIColor blackColor];
        imagePickerVc.navLeftBarButtonSettingBlock = ^(UIButton *leftButton) {
            [leftButton setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
            [leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 0)];
            [leftButton sizeToFit];
        };
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            NSMutableArray *tempPhotos = [NSMutableArray arrayWithArray:photos];
            if (_selectedAssets.count) {
                NSMutableArray *tempAssets = [NSMutableArray arrayWithArray:assets];
                
                [tempAssets enumerateObjectsUsingBlock:^(PHAsset *asset, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([_selectedAssets containsObject:asset]) {
                        [tempPhotos removeObjectAtIndex:[tempAssets indexOfObject:asset]];
                        [tempAssets removeObject:asset];
                    }
                }];
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
            }else{
                _selectedAssets = [NSMutableArray arrayWithArray:assets];
            }
            [MHReportRepairNewModel share].images = [NSMutableArray arrayWithArray:photos];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pictureView.pictureArr = [MHReportRepairNewModel share].images;
            });
        }];
        
        [[self viewController] presentViewController:imagePickerVc animated:YES completion:nil];

    }
}


- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        [JFAuthorizationStatusManager authorizationType:JFAuthorizationTypeVideo target:[self viewController]];
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
        [JFAuthorizationStatusManager authorizationType:JFAuthorizationTypeAlbum target:[self viewController]];
    } else if ([TZImageManager authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}


- (void)pushImagePickerController {

    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        weakSelf.location = location;
    } failureBlock:^(NSError *error) {
        weakSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [[self viewController] presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = [self viewController].navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = [self viewController].navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}


#pragma mark - 相机代理
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        @weakify(self)
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            @strongify(self)
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        [self.selectedAssets addObject:assetModel.asset];
                        [[MHReportRepairNewModel share].images addObject:image];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.pictureView.pictureArr = [MHReportRepairNewModel share].images;
                        });
                    }];
                }];
            }
        }];
    }
}



- (void)mh_configCellWithInfor:(id)model {
    NSDictionary *dic_item = model;
    NSString *content = dic_item[@"content"];
    if (content.length > 0 ) {
        self.textView.text = dic_item[@"content"];
    }
}

//获取控制器
- (UIViewController *)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


- (UITableView *)tableView
{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
