//
//  ServerManager.h
//  APITest
//
//  Created by Admin on 15.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "User.h"
#import "UserDetails.h"
#import "LoginLogicController.h"

@interface ServerManager : NSObject

@property (strong, nonatomic, readonly) User* currentUser;
@property (strong, nonatomic) NSString* userId;


+ (ServerManager*) sharedManager;

- (void) getFriendsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends))success
                    onFailure:(void(^)(NSError* error,NSInteger statusCide)) failure;

- (void) getUserDetails:(NSString*)user_ids
              onSuccess:(void (^)(UserDetails *))success
              onFailure:(void (^)(NSError* error, NSInteger statusCode))failure;

- (void) getCityFromId:(NSString*)cityID
             onSuccess:(void (^)(NSString *))success
             onFailure:(void (^)(NSError* error, NSInteger statusCode))failure;

- (void) getSubscribtions:(NSString*)userId
                   offset:(NSInteger)offset
                    count:(NSInteger)count
                onSuccess:(void(^)(NSArray *))success
                onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void) getFollowers:(NSString*)userId
               offset:(NSInteger)offset
                count:(NSInteger)count
            onSuccess:(void(^)(NSArray *))success
            onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)getWallPostWithUserIds:(NSString *)userId
                         count:(NSInteger)count
                        offset:(NSInteger)offset
                     onSuccess:(void (^) (NSArray *wallPost)) success
                     onFailure:(void (^) (NSError *error)) failure;

- (void) authorizeUser:(void(^)(User* user)) completion;

- (void) getNewsFeed:(NSInteger)count
            nextFrom:(NSString*)nextFromArgument
           onSuccess:(void (^) (NSDictionary *feedPosts)) success
           onFailure:(void (^) (NSError *error)) failure;





@end
