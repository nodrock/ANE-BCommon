//
//  NotificationController.h
//  BCommon
//
//  Created by Ján Horváth on 23/05/2017.
//
//

#import <Foundation/Foundation.h>
@import Firebase;

@interface NotificationController : NSObject<FIRMessagingDelegate>

@property(nonatomic, readonly, nullable) NSString *FCMToken;

- (void)registerForRemoteNotifications;

@end
