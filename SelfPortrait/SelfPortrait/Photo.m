//
//  Photo.m
//  SelfPortrait
//
//  Created by Romy on 7/22/15.
//  Copyright © 2015 Romy. All rights reserved.
//

#import "Photo.h"
#import "SPController.h"
#import "Constants.h"

@implementation Photo

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"captionText" : @"caption.text",
             @"username" : @"user.username",
             @"filter" : @"filter",
             @"photoId" : @"id",
             @"createdTime" : @"created_time",
             @"lowResImageURL" : @"images.low_resolution.url",
             @"standardResImageURL" : @"images.standard_resolution.url",
             @"thumbnailURL" : @"images.thumbnail.url",
             @"photoLinkURL" : @"link"
             };
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"MMM d, yyyy"];
    return dateFormatter;
}

+ (MTLValueTransformer *)createdTimeJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSNumber *unixTimeStamp, BOOL *success, NSError *__autoreleasing *error) {
        NSTimeInterval unixTimeStampDouble = [unixTimeStamp doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:unixTimeStampDouble];
        return date;
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        // return [[Photo dateFormatter] stringFromDate:date];
        NSTimeInterval unixTimeStampDouble = date.timeIntervalSince1970;
        return [NSNumber numberWithDouble:unixTimeStampDouble];
    }];
}

+ (MTLValueTransformer *)lowResImageURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *urlString, BOOL *success, NSError *__autoreleasing *error) {
        return [NSURL URLWithString:urlString];
    } reverseBlock:^id(NSURL *url, BOOL *success, NSError *__autoreleasing *error) {
        return [url absoluteString];
    }];
}

+ (MTLValueTransformer *)standardResImageURLJSONTransformer {
    return [Photo lowResImageURLJSONTransformer];
}

+ (MTLValueTransformer *)thumbnailURLJSONTransformer {
    return [Photo lowResImageURLJSONTransformer];
}

+ (MTLValueTransformer *)photoLinkURLJSONTransformer {
    return [Photo lowResImageURLJSONTransformer];
}

+ (NSString *)sizeStringForPhotosize:(PhotoSize)photoSize {
    NSNumber *photoSizeAsNumber = [NSNumber numberWithInteger:photoSize];
    NSDictionary *photoStringDict = @{
                                      [NSNumber numberWithInteger:PhotoSizeDefault] : @"default",
                                      [NSNumber numberWithInteger:PhotoSizeThumbnail] : @"thumbnail",
                                      [NSNumber numberWithInteger:PhotoSizeLowRes] : @"lowres"
                                      };
    if (photoStringDict[photoSizeAsNumber]) {
        return photoStringDict[photoSizeAsNumber];
    }
    return @"default";
}

- (NSURL *)urlForPhotoSize:(PhotoSize)photoSize {
    NSURL *finalURL = nil;
    switch (photoSize) {
        case PhotoSizeLowRes:
            finalURL = self.lowResImageURL;
            break;
        case PhotoSizeThumbnail:
            finalURL = self.thumbnailURL;
            break;
        case PhotoSizeDefault:
            finalURL = self.standardResImageURL;
            break;
        default:
            finalURL = self.standardResImageURL;
            break;
    }
    return finalURL;
}
@end
