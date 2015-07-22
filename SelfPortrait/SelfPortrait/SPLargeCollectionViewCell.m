//
//  SPLargeCollectionViewCell.m
//  SelfPortrait
//
//  Created by Romy on 7/22/15.
//  Copyright © 2015 Romy. All rights reserved.
//

#import "SPLargeCollectionViewCell.h"
#import "SPController.h"
#import "Photo.h"
#import "Constants.h"

@implementation SPLargeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.imageLabel.font = [Constants smallCellFont];
    self.imageLabel.numberOfLines = 0;
}

- (void)setPhoto:(Photo *)photo {
    _photo = photo;
    [[SPController shared] imageForPhoto:photo
                                    size:PhotoSizeDefault
                     withCompletionBlock:^(UIImage *image, NSError *error) {
                         if (!error) {
                             self.imageView.image = image;
                         }
                     }];
}

@end
