//
//  UITextField+HLSubText.h
//  HLCategory
//
//  Created by hanl on 2017/5/2.
//  Copyright © 2017年 hanl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (HLSubText)

/**
 *  sub text to fix chinese
 */
- (void)hl_subTextToIndex:(NSInteger)index;

/**
 *  delete space text
 */
- (void)hl_resetSpace;

@end
