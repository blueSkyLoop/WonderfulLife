//
//  MHCalendarTimePickCell.h
//  WonderfulLife
//
//  Created by zz on 12/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHCalendarTimePickCell : UIView
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
+ (instancetype)cellWithRow:(NSInteger)row;
@end
