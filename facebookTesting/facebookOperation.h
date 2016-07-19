//
//  facebookOperation.h
//  Solat
//
//  Created by Low Wai Hong on 06/05/2016.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define userEmailPermission @"email"
#define userBirthdayPermission @"user_birthday"
#define userLocationPermission @"user_location"

@interface facebookOperation : NSObject

+(facebookOperation *)sharedInstance;

- (void)loginFacebookWithViewController:(UIViewController *)viewController extraPermission:(NSArray *)permissions andBlock:(void (^)(NSDictionary *, NSError *, NSString *))block;

- (void)logoutFacebook;
@end
