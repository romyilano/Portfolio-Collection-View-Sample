//
//  SPCollectionViewCell.h
//  SelfPortrait
//
//  Created by Romy on 7/21/15.
//  Copyright © 2015 Romy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPCollectionViewCellDelegateProtocol.h"
@class Photo;
@interface SPCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) Photo *photo;
@property (weak, nonatomic) id <SPCollectionViewCellDelegateProtocol> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;

@end
