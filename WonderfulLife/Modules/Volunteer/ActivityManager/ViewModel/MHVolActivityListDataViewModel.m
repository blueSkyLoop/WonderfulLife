//
//  MHVolActivityListDataViewModel.m
//  WonderfulLife
//
//  Created by zz on 11/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHVolActivityListDataViewModel.h"
#import "MHVolActivityListModel.h"
#import "MHMacros.h"
#import "NSDate+MHCalendar.h"
#import "MHVolunteerUserInfo.h"
#import "NSObject+isNull.h"

@implementation MHVolActivityListDataViewModel

#pragma mark - Public Method
- (void)handleCaptainList {
    self.activity_team_id               = self.model.team_id;
    self.action_team_ref_id             = self.model.action_team_ref_id;
    self.action_id                      = self.model.action_id;
    self.c_activityTitle                = self.model.title;
    self.c_activityAddress              = self.model.addr;
    self.c_activityState                = [self handleCaptainListActivityStates];
    self.c_startOfActivityTime          = [self handleDateBeginTime];
    self.c_endOfActivityTime            = [self handleDateEndTime];
    self.c_placesOfActivity             = [self handlePlacesOfActivity];
    
    self.c_activityTipsColor            = [self handleTipsViewColor];
    self.c_activityTitleColor           = [self handleTitleColor];
    self.c_isTemporaryActivity          = [self handleActivityType];

    self.c_hasBottomBaseView            = [self handleCaptainListBottomViewShow];
    self.c_temporaryHeight              = [self handleTemporaryHeight];
    self.c_isNeedToAttendance           = [self handleNeedsToAttendance];
    self.c_isShowModifyActivity         = [self handleShowModifyActivity];
    self.c_isShowEnrolling              = [self handleCaptainListShowEnrolling];
    self.c_isShowCancelEnrolling        = [self handleCaptainListShowCancelEnrolling];
    ///行高
    CGFloat bottomHeight                = self.c_hasBottomBaseView?72:0;
    self.rowHeight                      = 234 + bottomHeight + self.c_temporaryHeight;
}

- (void)handleTeammateList {
    self.activity_team_id               = self.model.team_id;
    self.action_team_ref_id             = self.model.action_team_ref_id;
    self.action_id                      = self.model.action_id;
    self.t_activityTitle                = self.model.title;
    self.t_activityAddress              = self.model.addr;
    self.t_activityState                = [self handleTeammateListActivityStates];
    self.t_startOfActivityTime          = [self handleDateBeginTime];
    self.t_endOfActivityTime            = [self handleDateEndTime];
    self.t_placesOfActivity             = [self handlePlacesOfActivity];
    
    self.t_activityTipsColor            = [self handleTipsViewColor];
    self.t_activityTitleColor           = [self handleTitleColor];
    self.t_isTemporaryActivity          = [self handleActivityType];
    ///队友：名额已满||进行中 无底部按钮
    self.t_hasBottomBaseView            = [self handleTeammateListBottomViewShow];
    self.t_temporaryHeight              = [self handleTemporaryHeight];
    self.t_isShowEnrolling              = [self.model.is_apply boolValue];
    ///行高
    CGFloat bottomHeight                = self.t_hasBottomBaseView?72:0;
    self.rowHeight                      = 234 + bottomHeight + self.t_temporaryHeight;
}

- (void)handleEndOfActivityList {
    self.activity_team_id               = self.model.team_id;
    self.action_team_ref_id             = self.model.action_team_ref_id;
    self.action_id                      = self.model.action_id;
    self.e_activityTitle                = self.model.title;
    self.e_activityAddress              = self.model.addr;
    self.e_activityState                = [self handleEndOfActivityListActivityStates];
    self.e_startOfActivityTime          = [self handleDateBeginTime];
    self.e_endOfActivityTime            = [self handleDateEndTime];
    self.e_placesOfActivity             = [self handlePlacesOfActivity];
    
    self.e_activityTipsColor            = [self handleTipsViewColor];
    self.e_activityTitleColor           = [self handleTitleColor];
    self.e_isTemporaryActivity          = [self handleActivityType];
    self.e_hasBottomBaseView            = NO;
    self.e_temporaryHeight              = [self handleTemporaryHeight];
    
    ///行高
    self.rowHeight                      = 234 + self.e_temporaryHeight;
}

#pragma mark - Private Method
- (CGFloat)handleTemporaryHeight {
    BOOL isTemporaryActivity = [self handleActivityType];
    if (isTemporaryActivity) { return 59.f;}
    return .0f;
}

//------------------------- 分 队 长 -----------------------------/

///分队长：开发型活动   不是分队长&&已报名  显示取消报名按钮
- (BOOL)handleCaptainListShowCancelEnrolling {
    if ([self.model.action_type isEqualToNumber:@2]&&[self.model.is_apply boolValue]) {
        return YES;
    }
    if (![self.model.is_captain boolValue]&&[self.model.is_apply boolValue]) {
        return YES;
    }
    return NO;
}

///分队长：开发型活动&&未报名  不是分队长&&未报名   是否显示报名按钮
- (BOOL)handleCaptainListShowEnrolling {
    if ([self.model.action_type isEqualToNumber:@2]&&![self.model.is_apply boolValue]) {
        return YES;
    }
    if (![self.model.is_captain boolValue]&&![self.model.is_apply boolValue]) {
        return YES;
    }
    return NO;
}

///分队长：不是临时活动&&报名中&&是分队长 显示修改活动
- (BOOL)handleShowModifyActivity {
    NSInteger activityState = [self.model.action_state integerValue];
    BOOL isTemporaryActivity = [self handleActivityType];
    if (!isTemporaryActivity && (activityState == 0||activityState == 1)&&[self.model.is_captain boolValue]) { return YES;}
    return NO;
}

///分队长：常规活动&&活动已结束(is_action_end为1)&&是分队长 显示考勤按钮
- (BOOL)handleNeedsToAttendance {
    if (self.model.action_type.integerValue == 0&&[self.model.is_action_end integerValue] == 1&&[self.model.is_captain boolValue]) { return YES;}
    return NO;
}

/**
 分队长：临时活动&&进行中 或 临时活动&&名额已满&&没有报名&&不是队长 或 常规活动&&活动进行中&&活动没结束 无底部按钮
 
 action_type    Integer    0|1|2    活动类型，0表示常规活动，1表示指派型临时活动，2表示开放型临时活动
 action_state    Integer    0|1|2|3    活动状态，0报名中，1名额已满，2进行中，3已结束
 is_action_end    Integer    0|1    当action_state为3时，默认为0，活动时间是否已结束，0未结束，1已结束
 is_apply    Integer    0|1    当action_state为3时，默认为0，是否已报名，0否，1是
 */
- (BOOL)handleCaptainListBottomViewShow{
    //临时活动&&进行中
    BOOL bool1 = (self.model.action_type.integerValue != 0)&&(self.model.action_state.integerValue == 2);
    //临时活动&&名额已满&&没有报名&&不是队长
    BOOL bool2 = (self.model.action_type.integerValue != 0)&&![self.model.is_captain boolValue]&&(self.model.action_state.integerValue == 1)&&![self.model.is_apply boolValue];
    //常规活动 && 活动进行中 && 活动没结束 无底部按钮
    BOOL bool3 = (self.model.action_type.integerValue == 0)&&(self.model.action_state.integerValue == 2)&&(self.model.is_action_end.integerValue == 0);
    
    if (bool1||bool2||bool3) { return NO;}
    return YES;
}

/**
 分队长
 
 活动状态，0报名中，1名额已满，2进行中
 */
- (NSString *)handleCaptainListActivityStates {
    
    NSInteger action_state = [self.model.action_state integerValue];
    switch (action_state) {
        case 0:
            return @"报名中";
            break;
        case 1:
            return @"名额已满";
            break;
        case 2:
            return @"进行中";
            break;
        case 3://已结束
            return @"已结束";
            break;
        default:
            break;
    }
    return @"";
}


//------------------------- 队 员 -----------------------------/

///队友：名额已满&&没有报名||进行中 无底部按钮
- (BOOL)handleTeammateListBottomViewShow{
    NSInteger activityState = [self.model.action_state integerValue];
    if ((activityState == 1&&![self.model.is_apply boolValue])||activityState == 2) { return NO;}
    return YES;
}

/**
 队员
 
 活动状态，0报名中，1名额已满，2进行中
 */
- (NSString*)handleTeammateListActivityStates{
    
    NSInteger action_state = [self.model.action_state integerValue];
    switch (action_state) {
        case 0:
            return @"报名中";
            break;
        case 1:
            return @"名额已满";
            break;
        case 2:
            return @"进行中";
            break;
        case 3://已结束
            return @"已结束";
            break;
        default:
            break;
    }
    return @"";
}


/**
 活动状态     0报名中    1名额已满    2进行中     3已结束         已取消
 
 对应颜色       绿         绿         蓝         灰             橙
 
 对应RGB    0X13CE66   0X13CE66   0X20A0FF   0XC0CCDA     0XFFA848
 */
- (UIColor*)handleTipsViewColor{
    //  已取消  橙  0XFFA848
    if ([self.model.is_cancel boolValue]) {
        return MColorToRGB(0XFFA848);
    }
    //  活动状态，0报名中，1名额已满，2进行中，3已结束
    NSInteger activityState = [self.model.action_state integerValue];
    switch (activityState) {
        case 0:
            return MColorGreen;
            break;
        case 1:
            return MColorGreen;
            break;
        case 2:
            return MColorBlue;
            break;
        case 3:
            return MColorContent;
            break;
        default:
            break;
    }
    return nil;
}

/**
 活动状态     0报名中    1名额已满    2进行中     3已结束       已取消
 
 对应颜色       绿         灰         灰         灰           橙
 
 对应RGB    0X13CE66   0X8492A6   0X20A0FF   0X8492A6     0XFFA848
 */
- (UIColor*)handleTitleColor{
    //  已取消  橙  0XFFA848
    if ([self.model.is_cancel boolValue]) {
        return MColorToRGB(0XFFA848);
    }
    
    NSInteger activityState = [self.model.action_state integerValue];
    switch (activityState) {
        case 0:
            return MColorGreen;
            break;
        case 1:
            return MColorFootnote;
            break;
        case 2:
            return MColorBlue;
            break;
        case 3:
            return MColorFootnote;
            break;
        default:
            break;
    }
    return nil;
}
/**
 活动类型，0表示常规活动，1表示指派型临时活动，2表示开放型临时活动
 */
- (BOOL)handleActivityType{
    NSInteger activityState = [self.model.action_type integerValue];
    
    switch (activityState) {
        case 0:
            return NO;
            break;
        case 1:
            return YES;
            break;
        case 2:
            return YES;
            break;
        default:
            break;
    }
    return NO;
}

//-------------------------活动状态-----------------------------/

/**
 活动结束
 
 活动状态，已取消，已结束
 */
- (NSString*)handleEndOfActivityListActivityStates{

    //  已取消
    if ([self.model.is_cancel boolValue]) {
        return @"已取消";
    }
    NSInteger action_state = [self.model.action_state integerValue];
    switch (action_state) {
        case 0:
            return @"已结束";
            break;
        case 1:
            return @"已结束";
            break;
        case 2:
            return @"已结束";
            break;
        case 3:
            return @"已结束";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString*)handleDateBeginTime{

    return [NSDate getDateDisplayString:self.model.date_begin];
}

- (NSString*)handleDateEndTime{
    return [NSDate getDateDisplayString:self.model.date_end];
}

- (NSString*)handlePlacesOfActivity{
    
    if ([self.model.qty isEqualToNumber:@(0)]||[NSObject isNull:self.model.qty]) {
        return @"不限";
    }
    
    NSString *number = [[self.model.qty stringValue] stringByAppendingString:@"人"];
    return number;
}

@end
