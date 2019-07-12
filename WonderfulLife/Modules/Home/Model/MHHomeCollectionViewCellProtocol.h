//
//  MHHomeCollectionCellProtocol.h
//  WonderfulLife
//
//  Created by zz on 23/11/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MHHomeCollectionViewCellProtocol <NSObject>
- (void)mh_collectionViewCellWithModel:(id)model;
@end


@protocol MHHomeCollectionViewCellDelegate <NSObject>
@optional
- (void)mh_collectionViewCell:(id)cell didSelectedAdsItemAtIndex:(NSInteger)index;
- (void)mh_collectionViewCellDidSelectedComactivitiesHeaderMore;
- (void)mh_collectionViewCellDidSelectedComactivitiesHeaderImage;
@end
