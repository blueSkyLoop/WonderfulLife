//
//  MHMerchantOrderDetailPicturesCell.m
//  WonderfulLife
//
//  Created by ikrulala on 2017/11/9.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMerchantOrderDetailPicturesCell.h"
#import "MHReportRepairPictureView.h"
#import "ReactiveObjC.h"
#import "TZImageManager.h"

#import "MHMacros.h"
#import <AVFoundation/AVFoundation.h>

#import "TZImagePickerController.h"
#import "MHReportRepairPhotoPreViewController.h"
#import "TZLocationManager.h"

#import "MHMerchantOrderDetailModel.h"

@interface MHMerchantOrderDetailPicturesCell ()<TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet MHReportRepairPictureView *pictureView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureViewHeightConstraint;
@property (strong, nonatomic) NSMutableArray *selectedImages;

@end

@implementation MHMerchantOrderDetailPicturesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    CGFloat itemWidth = (MScreenW - 80.f)/3.f;
    self.pictureView.itemGap  = 16.f;
    self.pictureView.needShowCloseButton = NO;
    self.pictureView.needShowTakePhoto = NO;
    self.pictureView.limitNum = 9;
    self.pictureView.itemSize = CGSizeMake(itemWidth, itemWidth);
    @weakify(self)
    self.pictureView.pictreCollectionViewDidSelectBlock = ^(NSIndexPath *indexPath, MHReportRepairPictureModel *cellModel) {
        @strongify(self);

        //跳到预览图
        MHReportRepairPhotoPreViewController *controller = [MHReportRepairPhotoPreViewController new];
        NSMutableArray *preArray = [NSMutableArray array];
        [self.pictureView.pictureArr  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MHReportRepairPhotoPreViewModel *model = [MHReportRepairPhotoPreViewModel new];
            model.bigPicUrl = obj;
            model.type = 1;
            [preArray addObject:model];
        }];
        controller.dataArr = preArray;
        controller.showDeleteButton = NO;
        controller.clickNum = indexPath.row;
        [[self viewController].navigationController pushViewController:controller animated:YES];
    };
    
}

//获取控制器
- (UIViewController *)viewController{
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)mh_configCellWithInfor:(MHMerchantOrderDetailModel*)model {
    NSMutableArray *array = [NSMutableArray array];
    if (model.comment_img_details) {
        for (NSDictionary *imgDic in model.comment_img_details) {
            [array addObject:imgDic[@"url"]];
        }
    }else if (model.comment_imgs) {
        for (NSDictionary *imgDic in model.comment_imgs) {
            [array addObject:imgDic[@"url"]];
        }
    }
   
    self.pictureView.pictureArr = array;
    CGFloat height = ceilf(array.count/3.f) * 124;
    self.pictureViewHeightConstraint.constant = height;
}


@end
