//
//  ViewController.m
//  facebookTesting
//
//  Created by Low Wai Hong on 19/07/2016.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

#import "ViewController.h"
#import "facebookOperation.h"

@interface ViewController (){
    NSArray *permissionArray;
}

@end

@implementation ViewController

@synthesize facebookButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [facebookButton setTitle:@"Login" forState:UIControlStateNormal];
    [facebookButton setTitle:@"Logout" forState:UIControlStateSelected];
    
    permissionArray = @[userEmailPermission,userLocationPermission];
    if([[facebookOperation sharedInstance] checkAccessTokenWithPermission:permissionArray]){
        [self facebookButtonPressed];
    }
}

- (IBAction)facebookButtonPressed{
    
    if([facebookButton isSelected]){
        [[facebookOperation sharedInstance] logoutFacebook];
        [facebookButton setSelected:NO];
    }else{
        [[facebookOperation sharedInstance] loginFacebookWithViewController:self extraPermission:permissionArray andBlock:^(NSDictionary *returnData, NSError *error, NSString *errorMessage) {
            if(!error){
                NSLog(@"return data %@",returnData);
                [facebookButton setSelected:YES];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
