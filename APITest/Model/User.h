//
//  User.h
//  APITest
//
//  Created by Admin on 22.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSString* userId;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
