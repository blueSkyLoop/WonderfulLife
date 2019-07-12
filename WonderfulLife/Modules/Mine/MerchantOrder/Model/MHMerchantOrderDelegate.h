//
//  MHMerchantOrderDelegate.h
//  WonderfulLife
//
//  Created by zz on 07/11/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MHMerchantOrderDelegate <NSObject>

@optional

- (void)mh_touchedMerchantShopName:(id)merchantID;
- (void)mh_touchedGoodsBaseView:(id)goodID;
- (void)mh_touchedMerchantReviewLevelStars:(id)level;
- (void)mh_touchedGoodsReviewLevelStars:(id)level;

- (void)mh_touchedReviewContent:(id)content;
//- (void)mh_touchedReviewContent:(id)content;
- (void)mh_touchedReviewPictures:(id)pictures asserts:(id)asserts;

@end


@interface NSString(MHMerchant)
@property (nonatomic,copy,readonly)NSString* (^format)(NSString* string);
@end
@implementation NSString(MHMerchant)
- (NSString *(^)(NSString *))format{
    return ^id(NSString *string){
        return [self stringByAppendingString:string];
    };
}
@end
