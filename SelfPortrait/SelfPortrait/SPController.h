//
//  SelfPortraitController.h
//  SelfPortrait
//
//  Created by Romy on 7/21/15.
//  Copyright © 2015 Romy. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "Photo.h"

@interface SPController : NSObject

+ (instancetype)shared;

- (NSString *)getAccessToken;

- (NSString *)photoKeyString:(Photo *)photo photoSize:(PhotoSize)size;

- (void)imageForPhoto:(Photo *)photo size:(PhotoSize)photoSize withCompletionBlock:(void(^)(UIImage *image, NSError *error))completion;

- (void)loadInstagramPhotosInBackgroundWithTag:(NSString *)tag withCompletionBlock:(void(^)(NSArray *photos, NSError *error))completionBlock;


// todo add version using AFNetworking

@end

extern NSString *SPControllerDomain;

typedef NS_ENUM(NSUInteger, SPControllerError) {
    SPControllerErrorBadParameter,
    SPControllerErrorBadJSON,
    SPControllerErrorNetworkError
};