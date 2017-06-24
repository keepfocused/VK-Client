//
//  Wall.h
//  APITest
//
//  Created by Admin on 07.10.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

@interface Wall : NSObject

@property (strong,nonatomic) NSString *text;
@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSURL *postImageURL;
@property (strong,nonatomic) UIImage *userPhoto;
@property (strong,nonatomic) UIImage *postPhoto;


- (id)initWithServerResponse:(NSDictionary *) responseObject;

@end
