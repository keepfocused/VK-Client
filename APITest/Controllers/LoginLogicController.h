//
//  LoginViewController.h
//  APITest
//
//  Created by Admin on 01.11.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccessToken;

typedef void(^LoginCompletionBlock)(AccessToken* token);

@interface LoginLogicController : UIViewController


- (id) initWithCompletionBlock:(LoginCompletionBlock) completionBlock;

@end
