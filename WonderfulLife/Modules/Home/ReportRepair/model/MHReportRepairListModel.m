//
//  MHReportRepairListModel.m
//  WonderfulLife
//
//  Created by lgh on 2017/10/16.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import "MHReportRepairListModel.h"
#import "MHMacros.h"

@implementation MHReportRepairListModel

- (UIColor *)statusUIColor{
    UIColor *acolor;
    switch (self.repairment_status) {
        case 0:
            acolor = MRGBColor(32, 160,255);
            break;
        case 1:
            acolor = MRGBColor(32, 160,255);
            break;
        case 2:
            acolor = MRGBColor(71, 86, 105);
            break;
        case 3:
            acolor = MRGBColor(71, 86, 105);
            break;
        case 4:
            acolor = MRGBColor(32, 160,255);
            break;
            
        default:
            break;
    }
    return acolor;
}

@end
