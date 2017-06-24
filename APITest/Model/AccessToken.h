//
//  AccessToken.h
//  APITest
//
//  Created by Admin on 01.11.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccessToken : NSObject

@property (strong, nonatomic) NSString* token;
@property (strong, nonatomic) NSDate* expirationDate;
@property (strong, nonatomic) NSString* userID;

@end
