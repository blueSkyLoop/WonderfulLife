//
//  MHAttendancenDetailBottomView.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/8.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHThemeButton.h"

typedef enum : NSUInteger {
    MHAttendancenDetailBottomViewTypeDisableFullUnAudit,
    MHAttendancenDetailBottomViewTypeDisableFullDidAudit,
    MHAttendancenDetailBottomViewTypeDisableFullRejuctAudit,
    
    MHAttendancenDetailBottomViewTypeEnableUnAudit,
    
    MHAttendancenDetailBottomViewTypeReject,
    MHAttendancenDetailBottomViewTypeCommitAttendance,
    MHAttendancenDetailBottomViewTypeDidAudit,
    MHAttendancenDetailBottomViewTypeSave,
    MHAttendancenDetailBottomViewTypeCheck,
    
    
} MHAttendancenDetailBottomViewType;

@protocol MHAttendancenDetailBottomViewDelegate <NSObject>

- (void)bottomButtonDidClick;

@end


@interface MHAttendancenDetailBottomView : UIView

+ (instancetype)bottomView;

@property (nonatomic,assign) MHAttendancenDetailBottomViewType type;
@property (nonatomic,weak) id<MHAttendancenDetailBottomViewDelegate> delegate;
@property (nonatomic,assign) NSInteger crewCount;
@property (weak, nonatomic) IBOutlet MHThemeButton *button;


@end
