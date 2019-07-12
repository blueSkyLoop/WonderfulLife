//
//  MHVoSeMainHeaderView.h
//  WonderfulLife
//
//  Created by Beelin on 17/7/15.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MHVoSeMainHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *myCardBtn;
@property (weak, nonatomic) IBOutlet UIButton *numBtn;
@property (weak, nonatomic) IBOutlet UILabel *loveScoreTitleLabel;

@property (nonatomic, strong) NSArray *approvingProjects;

@property (nonatomic, copy) void(^comeinMyScoreBlock)();
@property (nonatomic, copy) void(^cancelNotifyBlock)();
@property (nonatomic, copy) void(^reviewedPersonnelNotifyBlock)();

+ (instancetype)voseMainHeaderView;

- (void)stopTimer;

- (void)changeColorWithDisplacement:(CGFloat)offsetY ;
@end
