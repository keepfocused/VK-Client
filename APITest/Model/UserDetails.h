//
//  UserDetails.h
//  APITest
//
//  Created by Admin on 23.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImageView.h>
//#import "ShowFriendDetailController.h"

@interface UserDetails : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* city;
@property (assign, nonatomic) NSInteger age;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) UIImageView* imageView;

- (id)initWithServerResponse:(NSDictionary*) responseObject;



@end
