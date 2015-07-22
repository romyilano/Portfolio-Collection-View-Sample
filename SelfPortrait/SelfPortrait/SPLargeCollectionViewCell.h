//
//  SPLargeCollectionViewCell.h
//  SelfPortrait
//
//  Created by Romy on 7/22/15.
//  Copyright © 2015 Romy. All rights reserved.
//

#import "SPCollectionViewCell.h"
#import "SPCollectionViewCellDelegateProtocol.h"
@class Photo;
@interface SPLargeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id <SPCollectionViewCellDelegateProtocol> delegate;
@property (strong, nonatomic) Photo *photo;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *imageLabel;

@end
