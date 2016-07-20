# facebookOperation
It's a singleton NSObject that wrapped the standard Facebook Operation.

For me, I'm just too lazy to write the same Facebook code over and over again.

FacebookOperation provides some simple method to retrieve user basic profile:-

- (BOOL)checkAccessTokenWithPermission:(NSArray *)permission
*Check and see if there's an existing token and if the token contains the permission needed

- (void)loginFacebookWithViewController:(UIViewController *)viewController extraPermission:(NSArray *)permissions andBlock:(void (^)(NSDictionary *, NSError *, NSString *))block
*Perform Login Operation and get the user basic profile, with any extra info requested.
