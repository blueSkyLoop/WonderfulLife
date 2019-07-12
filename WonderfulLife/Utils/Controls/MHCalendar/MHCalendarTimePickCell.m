//
//  MHCalendarTimePickCell.m
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHCalendarTimePickCell.h"

@implementation MHCalendarTimePickCell

+ (instancetype)cellWithRow:(NSInteger)row{
    MHCalendarTimePickCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MHCalendarTimePickCell" owner:nil options:nil] firstObject];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%.2ld",row];
    
    return cell;
}
@end
