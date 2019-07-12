//
//  MHMiShowMsgNotiController.m
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/7/20.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHMiShowMsgNotiController.h"

@interface MHMiShowMsgNotiController ()
@property (weak, nonatomic) IBOutlet UILabel *messageStateLB;

@end

@implementation MHMiShowMsgNotiController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshAlertLB];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAlertLB) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)refreshAlertLB {
    BOOL isRemoteNotify;
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone == setting.types) {
        isRemoteNotify = NO;
    }else{
        isRemoteNotify = YES;
    }
    if (isRemoteNotify) {
        self.messageStateLB.text = @"已开启";
    }else {
        self.messageStateLB.text = @"已关闭";
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
@end









