//
//  facebookOperation.m
//  facebookTesting
//
//  Created by Low Wai Hong on 19/07/2016.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

#import "facebookOperation.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface facebookOperation (){
    NSMutableArray *permissionArray;
}
@end

@implementation facebookOperation

+ (facebookOperation *)sharedInstance {
    static facebookOperation *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if(self != nil) {
        permissionArray = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Get Basic Profile
- (void)loginFacebookWithViewController:(UIViewController *)viewController extraPermission:(NSArray *)permissions andBlock:(void (^)(NSDictionary *, NSError *, NSString *))block{
    if(permissions!=nil){
        [self setPermissionArray:permissions];
    }
    
    [self getPermissionWithViewController:viewController andBlock:^(NSError *error, NSString *errorMessage, BOOL isUserCancel) {
        if(error){
            block([NSDictionary dictionary],nil,error.localizedDescription);
        }else if(isUserCancel){
            block([NSDictionary dictionary],nil,@"You have cancelled the operation.");
        }
        else{
            [self getUserProfileAndReturnBlock:^(NSDictionary *returnData, NSError *error, NSString *errorMessage) {
                if(error){
                    block([NSDictionary dictionary],error,@"error");
                }else{
                    
                    BOOL isAllPermissionAvailable = true;
                    
                    for(int i=0; i<[permissionArray count]; i++){
                        
                        BOOL isPermissionAvailable = false;
                        
                        if([[FBSDKAccessToken currentAccessToken].permissions containsObject:[[permissionArray objectAtIndex:i] objectForKey:@"key"]]){
                            isPermissionAvailable = true;
                        }

                        if(!isPermissionAvailable){
                            isAllPermissionAvailable = false;
                            break;
                        }
                    }
                    
                    if(isAllPermissionAvailable){
                        block((NSDictionary *)returnData,nil,nil);
                    }else{
                        block([NSDictionary dictionary],nil,@"Please allow for the permissions required.");
                    }
                }
            }];
        }
    }];
}

- (void)getUserProfileAndReturnBlock:(void(^)(NSDictionary *returnData, NSError * error, NSString *errorMessage))block{
    
    NSString *graphRequestString = @"id,first_name,last_name,picture,gender";
    
    for(int i=0; i<[permissionArray count]; i++){
        graphRequestString = [graphRequestString stringByAppendingString:[NSString stringWithFormat:@",%@",[[permissionArray objectAtIndex:i] objectForKey:@"value"]]];
    }
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":graphRequestString}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if(error){
            NSLog(@"error description - 4 %@",error.localizedDescription);
            block([NSDictionary dictionary],error,@"error");
        }else{
            block((NSDictionary *)result,nil,nil);
        }
    }];
}

#pragma mark - Get Permission
- (void)getPermissionWithViewController:(UIViewController *)viewController andBlock:(void(^)(NSError * error, NSString *errorMessage, BOOL isUserCancel))block{
    
    if([self checkAccessTokenWithPermission:permissionArray]){
        block(nil,nil,false);
    }else{
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:[self getArrayKeyWithPermissionArray:permissionArray] fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if(error){
                NSLog(@"error description - 5 %@",error.localizedDescription);
                block(error,nil,false);
            }else if(result.isCancelled){
                block(nil,@"User Cancel",true);
            }else{
                block(nil,nil,false);
            }
        }];
    }
}

- (NSArray *)getArrayKeyWithPermissionArray:(NSArray *)pArray{
    NSMutableArray *arrayKey = [[NSMutableArray alloc] init];
    
    for(int i=0; i<[pArray count]; i++){
        [arrayKey addObject:[[pArray objectAtIndex:i] objectForKey:@"key"]];
    }
    return arrayKey;
}


- (void)setPermissionArray:(NSArray *)permissions{
    [permissionArray removeAllObjects];
    
    for(int i=0; i<[permissions count]; i++){
        [permissionArray addObject:[permissions objectAtIndex:i]];

    }
}

- (BOOL)checkPermission:(NSString *)permission{
    BOOL isPermissionAvailable = false;
    
    if([FBSDKAccessToken currentAccessToken]){
        if([[FBSDKAccessToken currentAccessToken] hasGranted:permission]){
            isPermissionAvailable = true;
        }
    }
    return isPermissionAvailable;
}

- (BOOL)checkAccessTokenWithPermission:(NSArray *)permission{
    
    BOOL isPermissionAvailable = true;
    
    NSArray *permissionKey = [self getArrayKeyWithPermissionArray:permission];
    
    for(int i=0; i<[permissionKey count]; i++){
        if(![self checkPermission:[permissionKey objectAtIndex:i]]){
            isPermissionAvailable = false;
            break;
        }
    }
    
    return isPermissionAvailable;
}

#pragma mark - Logout
- (void)logoutFacebook{
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    
}

@end
