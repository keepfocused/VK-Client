//
//  Subscribe.m
//  APITest
//
//  Created by Admin on 27.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import "Subscribe.h"

@implementation Subscribe

- (id) initWithServerResponse:(NSDictionary*) responseObject;
{
    self = [super init];
    if (self) {
        
        self.name = [responseObject objectForKey:@"name"];
    
        NSString* urlString = [responseObject objectForKey:@"photo"];
        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
        
    }
    return self;
}

@end
