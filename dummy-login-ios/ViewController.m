//
//  ViewController.m
//  dummy-login-ios
//
//  Created by Sumin Byeon on 4/11/13.
//  Copyright (c) 2013 Sumin Byeon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize data;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) loginButtonTouched
{
    flag = 1;
    [self makeHttpPostRequest:@"http://sandbox.smartrekmobile.com/welcome/default/user/login?_next=/welcome/default/index" withData:@"email=john.doe@test.com&password=qwerasdf"];
}

- (IBAction) accessMemberPageButtonTouched
{
    flag = 2;
    [self makeHttpPostRequest:@"http://sandbox.smartrekmobile.com/welcome/v1/member" withData:@""];
}

- (IBAction) logoutButtonTouched
{
    flag = 3;
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [cookieStorage deleteCookie:authCookie];
}

- (void) makeHttpPostRequest:(NSString*)url withData:(NSString*)data
{
    NSData *postData = [data dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    [request setHTTPShouldHandleCookies:YES];
    
    NSDictionary *cookieProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"http://sandbox.smartrekmobile.com/", NSHTTPCookieDomain,
                                      @"/", NSHTTPCookiePath,
                                      @"session_id_welcome", NSHTTPCookieName,
                                      @"68.230.90.123-3f2b16b4-74bd-40bf-a440-24cf32bf8600", NSHTTPCookieValue,
                                      nil];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    NSArray *cookieArray = [NSArray arrayWithObjects: cookie, nil];
    NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookieArray];
    
    [request setAllHTTPHeaderFields:headers];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

//
// Copied from http://stackoverflow.com/questions/5537297/ios-how-to-perform-a-http-post-request
//
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"status code = %d", httpResponse.statusCode);

    NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:httpResponse.allHeaderFields forURL:httpResponse.URL];
    for (int i = 0; i < cookies.count; i++) {
        NSHTTPCookie *cookie = [cookies objectAtIndex:i];
        NSLog(@"%@ for %@", [cookie name], [cookie domain]);
        
        if ([[cookie name] isEqualToString:@"session_id_welcome"]) {
            NSLog(@"Auth cookie has been saved");
            authCookie = cookie;
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    NSLog(@"response = %@", [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"")
                                 message:[error localizedDescription]
                                delegate:nil
                       cancelButtonTitle:NSLocalizedString(@"OK", @"")
                       otherButtonTitles:nil] show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *responseText = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
    
}

// Handle basic authentication challenge if needed
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"didReceiveAuthenticationChallenge");
    
    NSString *username = @"username";
    NSString *password = @"password";
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:username
                                                             password:password
                                                          persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
}

@end
