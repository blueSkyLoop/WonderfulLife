//
//  UIViewController+UMengShare.m
//  WonderfulLife
//
//  Created by Lol on 2017/10/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "UIViewController+UMengShare.h"

#import <UShareUI/UShareUI.h>
#import "MHHUDManager.h"
#import "MHMineShare.h"

@implementation UIViewController (UMengShare)


- (void)mh_umengShareFuncConfigWithShareWebPageToPlatformType:(UMSocialPlatformType)platformType conentModel:(MHMineShare *)conentModel{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:conentModel.title descr:conentModel.summary thumImage:conentModel.logoImage];
    //设置网页地址
    shareObject.webpageUrl = conentModel.url;
    
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            [MHHUDManager showErrorText:@"分享失败，请稍后再试"];
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
                [MHHUDManager showText:resp.message];
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}


- (void)mh_umengShareImageAndTextToPlatformType:(UMSocialPlatformType)platformType conentModel:(MHMineShare *)conentModel{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //设置文本
    messageObject.text = conentModel.title;
    
    //创建图片内容对象
    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图
    shareObject.thumbImage = conentModel.logoImage;
    [shareObject setShareImage:shareObject.thumbImage];

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}


- (void)mh_umengShareWebPageToPlatformType:(UMSocialPlatformType)platformType conentModel:(MHMineShare *)conentModel{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    NSString *text = [NSString stringWithFormat:@"%@%@%@",conentModel.title,conentModel.summary,conentModel.url];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:text descr:text thumImage:conentModel.logoImage];
    //设置网页地址
    shareObject.webpageUrl =conentModel.url;

    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}




- (void)mh_umengShareActionWithConentModel:(id)conentModel{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self mh_umengShareFuncConfigWithShareWebPageToPlatformType:platformType conentModel:conentModel];
    }];
}

@end
