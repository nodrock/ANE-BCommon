//
//  NotificationController.m
//  BCommon
//
//  Created by Ján Horváth on 23/05/2017.
//
//

#import "NotificationController.h"

#import "BCommon.h"

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface NotificationController () <UNUserNotificationCenterDelegate>
@end
#endif

@implementation NotificationController

- (NSString *)FCMToken {
    return [FIRMessaging messaging].FCMToken;
}

- (void)registerForRemoteNotifications {
    [BCommon log:@"registerForRemoteNotifications"];
    
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [BCommon log:@"<=NSFoundationVersionNumber_iOS_7_1"];
        // iOS 7.1 or earlier. Disable the deprecation warnings.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
                (UIRemoteNotificationTypeSound |
                        UIRemoteNotificationTypeAlert |
                        UIRemoteNotificationTypeBadge);
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:allNotificationTypes];
#pragma clang diagnostic pop
    } else {
        [BCommon log:@">NSFoundationVersionNumber_iOS_7_1"];
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            [BCommon log:@"<=NSFoundationVersionNumber_iOS_9_x_Max"];
            UIUserNotificationType allNotificationTypes =
                    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
                    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            [BCommon log:@">NSFoundationVersionNumber_iOS_9_x_Max"];
            // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            // For iOS 10 display notification (sent via APNS)
      [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      UNAuthorizationOptions authOptions =
          UNAuthorizationOptionAlert
          | UNAuthorizationOptionSound
          | UNAuthorizationOptionBadge;
      [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
          }];
#endif
        }

        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
    }

    [BCommon log:@"setting delegate"];
    // [START set_messaging_delegate]
    [FIRMessaging messaging].delegate = self;
    // [END set_messaging_delegate]
}

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken {
    [BCommon log:@"didRefreshRegistrationToken fcmToken: %@", fcmToken];
    [[BCommon sharedInstance] dispatchEvent:@"FCM_TOKEN" withMessage:fcmToken];
}


@end
