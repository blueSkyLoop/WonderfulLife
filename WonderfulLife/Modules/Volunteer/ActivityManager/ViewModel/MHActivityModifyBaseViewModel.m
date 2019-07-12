//
//  MHActivityModifyBaseViewModel.m
//  WonderfulLife
//
//  Created by zz on 15/09/2017.
//  Copyright © 2017 WuHanMeiHao. All rights reserved.
//

#import "MHActivityModifyBaseViewModel.h"

@implementation MHActivityModifyBaseViewModel

#pragma mark - Getter

- (RACSubject *)reloadDataSubject {
    if (!_reloadDataSubject) {
        _reloadDataSubject = [RACSubject subject];
    }
    return _reloadDataSubject;
}

- (RACSubject *)modifyIntroduceSubject {
    if (!_modifyIntroduceSubject) {
        _modifyIntroduceSubject = [RACSubject subject];
    }
    return _modifyIntroduceSubject;
}

- (RACSubject *)modifyRulesSubject {
    if (!_modifyRulesSubject) {
        _modifyRulesSubject = [RACSubject subject];
    }
    return _modifyRulesSubject;
}

- (RACSubject *)modifyPeoplesSubject {
    if (!_modifyPeoplesSubject) {
        _modifyPeoplesSubject = [RACSubject subject];
    }
    return _modifyPeoplesSubject;
}


- (NSMutableArray*)dataSources {
    if (!_dataSources) {
        _dataSources = [NSMutableArray array];
    }
    return _dataSources;
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
