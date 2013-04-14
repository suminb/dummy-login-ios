//
//  ViewController.h
//  dummy-login-ios
//
//  Created by Sumin Byeon on 4/11/13.
//  Copyright (c) 2013 Sumin Byeon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    NSData *data;
    NSInteger flag;
    NSHTTPCookie *authCookie;
}

@property () NSData *data;

- (IBAction) loginButtonTouched;
- (IBAction) accessMemberPageButtonTouched;
- (IBAction) logoutButtonTouched;
- (void) makeHttpPostRequest:(NSString*)url withData:(NSString*)data;
@end
