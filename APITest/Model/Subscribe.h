//
//  Subscribe.h
//  APITest
//
//  Created by Admin on 27.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subscribe : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSURL* imageURL;

- (id) initWithServerResponse:(NSDictionary*) responseObject;

@end
