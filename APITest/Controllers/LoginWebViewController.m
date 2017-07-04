//
//  LoginViewController.m
//  APITest
//
//  Created by Admin on 01.11.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import "LoginWebViewController.h"
#import "AccessToken.h"
#import "ServerManager.h"


@interface LoginWebViewController () <UIWebViewDelegate>

@property (copy, nonatomic) LoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView* webView;
@property (assign, nonatomic) BOOL firstLaunchTrigger;

@end

@implementation LoginWebViewController

- (id) initWithCompletionBlock:(LoginCompletionBlock) completionBlock
{
    self = [super init];
    if (self) {
        self.completionBlock = completionBlock;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect r = self.view.bounds;
    r.origin = CGPointZero;
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:r];
    
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    [self.view addSubview:webView];
    
    self.webView = webView;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                          target:self
                                                                          action:@selector(actionCancel:)];
    
    
    [self.navigationItem setRightBarButtonItem:item animated:YES];
    
    self.navigationItem.title = @"Login";
    
    NSString* urlString =
    @"https://oauth.vk.com/authorize?"
    @"client_id=5701441&"
    @"scope=401430&"   //270358& //8214 //8194 
    @"redirect_uri=https://oauth.vk.com/blank.html&"
    @"display=mobile&"
    @"v=5.60&"
    @"response_type=token";
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    webView.delegate = self;
    
    [webView loadRequest:request];

    self.firstLaunchTrigger = YES;
    

}

#pragma mark - Actions

- (void) actionCancel:(UIBarButtonItem*) item
{
    
    
    if (self.completionBlock) {
        self.completionBlock(nil);
    }
    

    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
        if ([[[request URL] description] rangeOfString:@"#access_token"].location != NSNotFound) {
            
            AccessToken* token = [[AccessToken alloc] init];
    
            NSString* query = [[request URL] description];
    
            NSArray* array = [query componentsSeparatedByString:@"#"];
    
            if ([array count] > 1) {
                query = [array lastObject];
            }
    
            NSArray* pairs = [query componentsSeparatedByString:@"&"];
    
            for (NSString* pair in  pairs) {
    
                NSArray* values = [pair componentsSeparatedByString:@"="];
    
                if ([values count] == 2) {
    
                    NSString* key = [values firstObject];
    
                    if ([key isEqualToString:@"access_token"]) {
                        token.token = [values lastObject];
                    } else if ([key isEqualToString:@"expires_in"]) {
    
                        NSTimeInterval interval = [[values lastObject] doubleValue];
    
                        token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                    } else if ([key isEqualToString:@"user_id"]) {
    
                        token.userID = [values lastObject];
                    }
    
                }
            }


        self.webView.delegate = nil;
            

        if (self.completionBlock) {
            self.completionBlock(token);
        }
        
        
       [self dismissViewControllerAnimated:YES
                                 completion:nil];

        
        
 
        NSLog(@"\n @@@@@@@@@ \ntoken userID = %@ \ntoken = %@",token.userID,token.token);
        
        
        return NO;
    }
    
    
    
    NSLog(@" request = = = %@",request);

    

    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    self.webView.delegate = nil;

    NSLog(@"WebViewController dealloceted");
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
