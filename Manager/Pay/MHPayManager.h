//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@protocol MHPayManagerDelegate <NSObject>

@optional

- (void)managerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)managerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)managerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)managerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)managerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

- (void)weChatPaySuccess:(BOOL)success;
@end

@interface MHPayManager : NSObject<WXApiDelegate>

@property (nonatomic, assign) id<MHPayManagerDelegate> delegate;

+ (instancetype)sharedManager;
+ (void)jumpToBizPayWithDic:(NSDictionary *)dict;
+ (void)doAlipayPayWithOrderString:(NSString *)orderString Callback:(void(^)(BOOL succcess))callback;
@end
