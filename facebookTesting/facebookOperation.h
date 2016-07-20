//
//  facebookOperation.h
//  facebookTesting
//
//  Created by Low Wai Hong on 19/07/2016.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define userEmailPermission @{@"key":@"email",@"value":@"email"}
#define userBirthdayPermission @{@"key":@"user_birthday",@"value":@"birthday"}
#define userLocationPermission @{@"key":@"user_location",@"value":@"location{location}"}

@interface facebookOperation : NSObject

+(facebookOperation *)sharedInstance;

- (void)loginFacebookWithViewController:(UIViewController *)viewController extraPermission:(NSArray *)permissions andBlock:(void (^)(NSDictionary *, NSError *, NSString *))block;

- (void)logoutFacebook;

- (BOOL)checkAccessTokenWithPermission:(NSArray *)permission;

@end
