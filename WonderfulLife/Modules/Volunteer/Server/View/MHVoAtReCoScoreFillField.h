//
//  MHMHVoAtReCoScoreFillField.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/9/19.
//  Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHVoAtReCoScoreFillFieldDelegate <NSObject>

- (void)voAtReCoScoreFillFieldbecomeFirstResponder:(CGFloat)score;
- (void)voAtReCoScoreFillFieldResignFirstResponder:(CGFloat)score IndexPath:(NSIndexPath *)indexPath;
@end

@interface MHVoAtReCoScoreFillField : UITextField
@property (nonatomic,weak) id<MHVoAtReCoScoreFillFieldDelegate> fiReDelegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
