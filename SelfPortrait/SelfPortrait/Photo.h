//
//  Photo.h
//  SelfPortrait
//
//  Created by Romy on 7/22/15.
//  Copyright © 2015 Romy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>           // used for json parsing, serializing, mapping

typedef NS_ENUM(NSUInteger, PhotoSize) {
    PhotoSizeThumbnail,
    PhotoSizeDefault,
    PhotoSizeLowRes
};

@interface Photo : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSURL *lowResImageURL;
@property (strong, nonatomic) NSURL *standardResImageURL;
@property (strong, nonatomic) NSURL *thumbnailURL;
@property (strong, nonatomic) NSURL *photoLinkURL;

@property (strong, nonatomic) NSDate *createdTime;

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *captionText;
@property (strong, nonatomic) NSString *filter;
@property (strong, nonatomic) NSString *photoId;

+ (NSString *)sizeStringForPhotosize:(PhotoSize)photoSize;

- (NSURL *)urlForPhotoSize:(PhotoSize)photoSize;

@end
