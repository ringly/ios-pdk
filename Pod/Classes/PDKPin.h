//  Copyright (c) 2015 Pinterest. All rights reserved.
//  Created by Ricky Cancro on 1/28/15.

@import Foundation;

/**
 *  Error codes when creating a pin without authorization
 */
typedef NS_ENUM(NSUInteger, PDKPinError){
    PDKPinErrorNone = 0,
    PDKPinErrorCanceled,
    PDKPinErrorUnknown,
};

/**
 *  Block signature when the unauthorized pin creation succeeds
 */
typedef void (^PDKUnauthPinCreationSuccess)();
/**
 *  Block signature when the unauthorized pin creation fails
 *
 *  @param error Error that caused pin creation to fail
 */
typedef void (^PDKUnauthPinCreationFailure)(NSError *error);


/**
 *  A class that represents a pin.
 */
@interface PDKPin : NSObject

/**
 *  Creates a pin without obtaining an oauth token
 *
 *  @param imageURL           The URL of the image to pin
 *  @param sourceURL          The URL to the source of the pin
 *  @param suggestedBoardName A suggested name of a board to pin to
 *  @param pinDescription     The description of the pin
 *  @param successBlock Called when the API call succeeds
 *  @param failureBlock Called when the API call fails
 */
+ (void)pinWithAppID:(NSString*)appID
            imageURL:(NSURL *)imageURL
                link:(NSURL *)sourceURL
  suggestedBoardName:(NSString *)suggestedBoardName
                note:(NSString *)pinDescription
         withSuccess:(PDKUnauthPinCreationSuccess)pinSuccessBlock
          andFailure:(PDKUnauthPinCreationFailure)pinFailureBlock;

/**
 *  Used internally in PDKClient's handleURL: to handle the unauth flow.
 */
+ (void)callUnauthSuccess;
+ (void)callUnauthFailureWithError:(NSString *)error;

@end

