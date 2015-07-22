//
//  SPCollectionViewCell.m
//  SelfPortrait
//
//  Created by Romy on 7/21/15.
//  Copyright © 2015 Romy. All rights reserved.
//

#import "SPCollectionViewCell.h"
#import "SPController.h"
#import "Constants.h"
#import "Photo.h"

@implementation SPCollectionViewCell

- (void)setPhoto:(Photo *)photo {
    _photo = photo;
    [[SPController shared] imageForPhoto:photo
                                    size:PhotoSizeThumbnail
                     withCompletionBlock:^(UIImage *image, NSError *error) {
                                        if (!error) {
                                            self.imageView.image = image;
                                        }
                                    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor whiteColor];
    self.imageLabel.textColor = [UIColor lightGrayColor];
    self.imageLabel.font = [Constants smallCellFont];
    self.imageLabel.numberOfLines = 2;
}

@end
