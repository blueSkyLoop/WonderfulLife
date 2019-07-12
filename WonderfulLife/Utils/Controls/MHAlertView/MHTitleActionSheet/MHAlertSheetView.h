//
//  LAlertSheetView.h
//  AlertDemo
//
//  Created by lgh on 2017/9/21.
//  Copyright © 2017年 lgh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHAlertConfig : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)UIImage *image;

- (id)initWithTitle:(NSString *)atitle image:(UIImage *)aimage;

@end


@interface MHAlertSheetView : UIView

- (instancetype)initWithTitle:(NSString *)title buttons:(NSArray <MHAlertConfig *>*)buttons comple:(void(^)(NSInteger index))comple;

- (void)show;

@end
