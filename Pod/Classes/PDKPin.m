//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 1/28/15.

@import UIKit;

#import "PDKCategories.h"
#import "PDKClient.h"
#import "PDKPin.h"

@implementation PDKPin

static PDKUnauthPinCreationSuccess _pinSuccessBlock = NULL;
static PDKUnauthPinCreationFailure _pinFailureBlock = NULL;

static NSString * const kPDKPinterestAppPinItURLString = @"pinterestsdk.v1://pinit/";
static NSString * const kPDKPinterestWebPinItURLString = @"http://www.pinterest.com/pin/create/button/";

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
        NSDictionary *webParams = @{@"url": [sourceURL absoluteString],
                                    @"media": [imageURL absoluteString],
                                    @"description": pinDescription};
        NSURL *pinitWebURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", kPDKPinterestWebPinItURLString, [webParams _PDK_queryStringValue]]];
        [[UIApplication sharedApplication] openURL:pinitWebURL];
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
