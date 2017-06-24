//
//  Follower.h
//  APITest
//
//  Created by Admin on 27.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Follower : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSString* userID;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
