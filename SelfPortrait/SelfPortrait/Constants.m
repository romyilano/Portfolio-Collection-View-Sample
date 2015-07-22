#import "Constants.h"
#import "SecretKeys.h"

@implementation Constants

NSString *const kInstagramClientId = kSecretInstragramClientId;
NSString *const kInstagramSimpleAuthRedirectURIKey = kSecretInstagramSimpleAuthRedirectURIKey;

NSString *const kInstagramBaseURL = @"https://api.instagram.com/v1/";
NSString *const kInstagramTagString = @"tags/%@/";
NSString *const kInstagramAccessTokenString = @"media/recent?access_token=%@";

+(UIFont *)smallCellFont {
   return [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0];
}

+ (UIFont*)largeCellFont {
   return [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
}

@end
