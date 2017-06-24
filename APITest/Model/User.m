//
//  User.m
//  APITest
//
//  Created by Admin on 22.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import "User.h"

@implementation User

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        
        self.firstName  = [responseObject objectForKey:@"first_name"];
        self.lastName   = [responseObject objectForKey:@"last_name"];
        self.userId     = [responseObject objectForKey:@"user_id"];
        
        NSString* urlString = [responseObject objectForKey:@"photo_50"];
        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }

    }
    return self;
}

@end
