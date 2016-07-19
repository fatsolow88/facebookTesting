//
//  ViewController.m
//  facebookTesting
//
//  Created by Low Wai Hong on 19/07/2016.
//  Copyright © 2016 Low Wai Hong. All rights reserved.
//

#import "ViewController.h"
#import "facebookOperation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[facebookOperation sharedInstance] loginFacebookWithViewController:self extraPermission:@[userEmailPermission,userLocationPermission] andBlock:^(NSDictionary *returnData, NSError *error, NSString *errorMessage) {
        NSLog(@"returnData %@",returnData);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
