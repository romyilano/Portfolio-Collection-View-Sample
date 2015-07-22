//
//  SPCollectionViewCellDelegateProtocol.h
//  SelfPortrait
//
//  Created by Romy on 7/22/15.
//  Copyright © 2015 Romy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPCollectionViewCellDelegateProtocol <NSObject>

- (void)likeTapped:(void(^)(void))completionBlock;

@end