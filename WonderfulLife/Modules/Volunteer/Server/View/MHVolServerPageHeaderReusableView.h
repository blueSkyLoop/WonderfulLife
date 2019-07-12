//
//  MHVolServerPageHeaderReusableView.h
//  WonderfulLife
//
//  Created by lgh on 2017/10/10.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHVolServerPageHeaderReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, copy) void(^comeinMyScoreBlock)();
@property (nonatomic, copy) void(^cancelNotifyBlock)();
@property (nonatomic, copy) void(^reviewedPersonnelNotifyBlock)();

- (void)loadApprovingProjects:(NSArray *)approvingProjects;

@end
