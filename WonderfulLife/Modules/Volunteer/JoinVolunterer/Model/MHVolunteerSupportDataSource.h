//
// MHVolunteerSupportDataSource.h
//  WonderfulLife
//
//  Created by Lo on 2017/7/7.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
typedef void(^VolunteerSupportBlock)(NSMutableArray *results);


@interface MHVolunteerSupportDataSource : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong,readonly) NSMutableArray  *results;

- (void)volunteerSupportDataSourcWithDatas:(NSArray *)datas
                                         volunteerSupportBlock:(VolunteerSupportBlock)complete;

@end
