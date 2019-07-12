//
//  UIViewController+UMengShare.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>
@interface UIViewController (UMengShare)

/**
 *  单独调用分享功能
 *
 *  @parma   platformType：此枚举用于区分分享的平台 如：UMSocialPlatformType_Sina、UMSocialPlatformType_WechatSession 等
 *  @parma   conentModel 为后台返回的json内容封装而成
 * 
 */
- (void)mh_umengShareFuncConfigWithShareWebPageToPlatformType:(UMSocialPlatformType)platformType conentModel:(id)conentModel;



/** 
  *  友盟提供的UI面板
  *  @parma   conentModel 为后台返回的json内容封装而成
  */
- (void)mh_umengShareActionWithConentModel:(id)conentModel;


/** 分享图文（新浪支持，微信/QQ仅支持图或文本分享） */
- (void)mh_umengShareImageAndTextToPlatformType:(UMSocialPlatformType)platformType conentModel:(id)conentModel ;


/** 分享网页*/
- (void)mh_umengShareWebPageToPlatformType:(UMSocialPlatformType)platformType conentModel:(id)conentModel;


/** 
 * 注： 因第三方平台的有关 appKey 正在申请中，1030版本只提供 朋友圈分享，微信会话分享功能
 */

@end
