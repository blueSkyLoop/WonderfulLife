//
//  UIImageView+Category.h
//  WonderfulLife
//
//  Created by Lol on 2017/10/26.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Category)


/**
 *  设置圆角弧度：常用于头像
 *
 *  @parma   value
 *
 */
- (void)mh_imageViewRadius:(CGFloat)value ;


- (void)mh_QRencodeQRImageWithContent:(NSString *)content;

- (void)mh_qrCodeImageWithContent:(NSString *)content
                             logo:(UIImage *)logo;

- (void)mh_barCodeImageWithContent:(NSString *)content;

@end
