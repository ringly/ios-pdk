//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 1/28/15.

@import UIKit;

#import "PDKCategories.h"
#import "PDKClient.h"
#import "PDKPin.h"

@implementation PDKPin

static NSString *_clientRedirectURLString = nil;
static PDKUnauthPinCreationSuccess _pinSuccessBlock = NULL;
static PDKUnauthPinCreationFailure _pinFailureBlock = NULL;

static NSString * const kPDKPinterestAppPinItURLString = @"pinterestsdk.v1://pinit/";

+ (NSString *)clientRedirectURLString
{
    return _clientRedirectURLString;
}

+ (void)setClientRedirectURLString:(NSString *)clientRedirectURLString
{
    _clientRedirectURLString = clientRedirectURLString;
}

+ (PDKUnauthPinCreationSuccess)pinSuccessBlock
{
    return _pinSuccessBlock;
}

+ (void)setPinSuccessBlock:(PDKUnauthPinCreationSuccess)pinSuccessBlock
{
    _pinSuccessBlock = [pinSuccessBlock copy];
}

+ (PDKUnauthPinCreationFailure)pinFailureBlock
{
    return _pinFailureBlock;
}

+ (void)setPinFailureBlock:(PDKUnauthPinCreationFailure)pinFailureBlock
{
    _pinFailureBlock = [pinFailureBlock copy];
}

+ (void)pinWithImageURL:(NSURL *)imageURL
                   link:(NSURL *)sourceURL
     suggestedBoardName:(NSString *)suggestedBoardName
                   note:(NSString *)pinDescription
            withSuccess:(PDKUnauthPinCreationSuccess)pinSuccessBlock
             andFailure:(PDKUnauthPinCreationFailure)pinFailureBlock
{
    
    self.clientRedirectURLString = [NSString stringWithFormat:@"pdk%@", [PDKClient sharedInstance].appId];
    self.pinSuccessBlock = pinSuccessBlock;
    self.pinFailureBlock = pinFailureBlock;
    
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    NSDictionary *params = @{@"client_id" : [PDKClient sharedInstance].appId,
                             @"image_url" : [imageURL absoluteString],
                             @"source_url" : [sourceURL absoluteString],
                             @"app_name" : appName,
                             @"suggested_board_name" : suggestedBoardName,
                             @"description" : pinDescription,
                             };
    
    // check to see if the Pinterest app is installed
    NSURL *pinitURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", kPDKPinterestAppPinItURLString, [params _PDK_queryStringValue]]];
#if TARGET_OS_IPHONE
    if ([[UIApplication sharedApplication] canOpenURL:pinitURL]) {
        [[UIApplication sharedApplication] openURL:pinitURL];
    } else {
        //open web pinit url
    }
#else
#endif
}

+ (void)callUnauthSuccess
{
    if (self.pinSuccessBlock) {
        self.pinSuccessBlock();
        self.pinSuccessBlock = nil;
    }
}

+ (void)callUnauthFailureWithError:(NSString *)error
{
    if (self.pinSuccessBlock) {
        PDKPinError errorCode = PDKPinErrorUnknown;
        if ([error isEqualToString:@"canceled"]) {
            errorCode = PDKPinErrorCanceled;
        }
        self.pinFailureBlock([NSError errorWithDomain:NSStringFromClass(self) code:errorCode userInfo:nil]);
        self.pinFailureBlock = nil;
    }
}

@end
