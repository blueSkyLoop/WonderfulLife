//
//  MHStoreHomeSectionHeaderView.h
//  WonderfulLife
//
//  Created by 梁斌文 on 2017/10/25.
//Copyright © 2017年 WuHanMeiHao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHStoreHomeSectionHeaderViewDelegate <NSObject>
- (void)checkMoreRecommandWithTag:(NSInteger)tag;
@end

@interface MHStoreHomeSectionHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *recommandLabel;
@property (nonatomic,weak) id<MHStoreHomeSectionHeaderViewDelegate> delegate;
@property (nonatomic,assign) BOOL hideMore;

@end

@interface MHStoreHomeSectionFooterView : UITableViewHeaderFooterView

@end
