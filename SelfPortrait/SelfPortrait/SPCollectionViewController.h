//
//  SPCollectionViewController.h
//  SelfPortrait
//
//  Created by Romy on 7/21/15.
//  Copyright © 2015 Romy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCollectionViewCell.h"

@interface SPCollectionViewController : UICollectionViewController <SPCollectionViewCellDelegateProtocol>
@property (strong, nonatomic) NSArray *photos;

@end
