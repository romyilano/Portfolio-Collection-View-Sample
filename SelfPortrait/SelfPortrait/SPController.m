//
//  SelfPortraitController.m
//  SelfPortrait
//
//  Created by Romy on 7/21/15.
//  Copyright © 2015 Romy. All rights reserved.
//

#import "SPController.h"
#import <SAMCache/SAMCache.h>
#import <SimpleAuth/SimpleAuth.h>
#import <SSKeyChain/SSKeyChain.h>
#import "Photo.h"
#import "Constants.h"

NSString *SPControllerDomain = @"SPControllerDomain";

@interface SPController()
@property (strong, nonatomic) NSString *accessToken;
@end

@implementation SPController

// singleton
+ (instancetype)shared {
    static id _shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    return _shared;
}

- (NSString *)getAccessToken {
    NSString *currentAccount = @"InstagramUser";
    self.accessToken = [SSKeychain passwordForService:@"instagram" account:currentAccount];
    if (self.accessToken == nil) {
        [SimpleAuth authorize:@"instagram" options:@{@"scope":@[@"likes"]}
                   completion:^(id responseObject, NSError *error) {
                       if (!error && [responseObject isKindOfClass:[NSDictionary class]]) {
                           self.accessToken = responseObject[@"credentials"][@"token"];
                           NSError *keyChainError;
                           [SSKeychain setPassword:self.accessToken forService:@"instagram" account:currentAccount error:&keyChainError];
                           
                       } else if (error) {
                           NSLog(@"No access token \n %@", error.userInfo);
                       } else {
                           // create my own error - it wasn't a dictionary
                           // todo
                       }
                   }];
    }
    return self.accessToken;
}

- (void)imageForPhoto:(Photo *)photo
                 size:(PhotoSize)photoSize
  withCompletionBlock:(void (^)(UIImage *, NSError *))completion {
    if (!completion) {
        @throw [NSException exceptionWithName:@"Bad Array Parameter"
                                       reason:@"Please add completion block"
                                     userInfo:nil];
    }
    
    NSString *photoKey = [self photoKeyString:photo photoSize:photoSize];
    
    __block UIImage *photoImage = [[SAMCache sharedCache] imageForKey:photoKey];
    if (photoImage) {
        completion(photoImage, nil);
    } else {
        // make a network call to download the image
        NSURL *specificURL = [photo urlForPhotoSize:photoSize];
        NSURLRequest *request = [NSURLRequest requestWithURL:specificURL];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * __nullable location, NSURLResponse * __nullable response, NSError * __nullable error) {
            if (!error) {
                NSData *data = [[NSData alloc] initWithContentsOfURL:location];
                photoImage = [[UIImage alloc] initWithData:data];
                if ([photoImage isMemberOfClass:[UIImage class]]) {
                    [[SAMCache sharedCache] setImage:photoImage forKey:photoKey];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(photoImage, nil);
                    });
                } else {
                    NSError *finalError = [NSError errorWithDomain:SPControllerDomain
                                                              code:SPControllerErrorBadJSON
                                                          userInfo:@{NSLocalizedDescriptionKey : @"Network returned data but it's not a UIImage"}];
                    completion(nil, finalError);
                }
            } else {
                completion(nil, error);
            }
        }];
        [downloadTask resume];
    }
}

- (NSString *)photoKeyString:(Photo *)photo photoSize:(PhotoSize)size {
    NSString *sizeString = [Photo sizeStringForPhotosize:size];
    return [[NSString alloc] initWithFormat:@"%@-%@", photo.photoId, sizeString];
}

- (void)loadInstagramPhotosInBackgroundWithTag:(NSString *)tag
                           withCompletionBlock:(void (^)(NSArray *, NSError *))completionBlock {
    if (!completionBlock || !tag) {
        @throw [NSException exceptionWithName:@"Bad Array Parameter"
                                       reason:@"Please add completion block and tag string"
                                     userInfo:nil];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *baseURL = kInstagramBaseURL;
    NSMutableString *finalURL = [[NSMutableString alloc] initWithString:baseURL];
    
    if(tag && tag.length > 0) {
        NSString *tagString = [NSString stringWithFormat:kInstagramTagString, tag];
        [finalURL appendString:tagString];
    }
    
    [finalURL appendString:[NSString stringWithFormat:kInstagramAccessTokenString, self.accessToken]];
    
    NSURL *url = [NSURL URLWithString:[finalURL copy]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * __nullable location, NSURLResponse * __nullable response, NSError * __nullable error) {
        if (!error) {
            NSData *data = [[NSData alloc] initWithContentsOfURL:location];
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                               options:kNilOptions
                                                                                 error:nil];
            NSError *finalError;
            NSArray *photos = [responseDictionary valueForKeyPath:@"data"];
            if (photos) {
                
                NSMutableArray *workingArray = [[NSMutableArray alloc] initWithCapacity:photos.count];
                for (NSDictionary *photoDict in photos) {
                    [workingArray addObject:[MTLJSONAdapter modelOfClass:[Photo class] fromJSONDictionary:photoDict error:&finalError]];
                }
                completionBlock([workingArray copy], finalError);
            } else {
                finalError = [NSError errorWithDomain:SPControllerDomain
                                                 code:SPControllerErrorBadJSON
                                             userInfo:@{NSLocalizedDescriptionKey : @"Network returned data but no photos array"}];
                completionBlock(@[], finalError);
            }
        } else {
            completionBlock(@[], error);
        }
    }];
    [downloadTask resume];
}

@end
