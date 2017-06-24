//
//  Follower.m
//  APITest
//
//  Created by Admin on 27.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import "Follower.h"

@implementation Follower

- (id) initWithServerResponse:(NSDictionary*) responseObject;
{
    self = [super init];
    if (self) {
        NSString* firstName = [responseObject objectForKey:@"first_name"];
        NSString* lastName  = [responseObject objectForKey:@"last_name"];
        NSString* fullName  = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
        NSString* userID    = [responseObject objectForKey:@"uid"];
        
        self.userID = userID;
        self.name   = fullName;
        NSString* urlString = [responseObject objectForKey:@"photo_50"];
        
    
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
  
        }
    }
    return self;
}

@end
