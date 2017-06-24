//
//  FeedPost.h
//  APITest
//
//  Created by Admin on 07.11.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>

@interface NewsFeedPost : NSObject


@property (strong, nonatomic) NSString *likeCount;
@property (strong, nonatomic) NSString *shareCount;
@property (strong, nonatomic) NSString *ownerPost;
@property (strong, nonatomic) NSString *textPost;
@property (strong, nonatomic) NSURL *postImageURL;
@property (strong, nonatomic) NSURL *ownerImageURL;
@property (strong, nonatomic) UIImage *ownerPhoto;
@property (strong, nonatomic) UIImage *postPhoto;
@property (strong, nonatomic) NSMutableArray *photosArray;


- (id)initWithServerResponse:(NSArray *) responseObject;

@end
