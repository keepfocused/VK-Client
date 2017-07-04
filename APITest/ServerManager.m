//
//  ServerManager.m
//  APITest
//
//  Created by Admin on 15.09.16.


#import "ServerManager.h"
#import "UserDetails.h"
#import "Follower.h"
#import "Subscribe.h"
#import "Wall.h"
#import "AccessToken.h"
#import "NewsFeedPost.h"


@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;
@property (strong, nonatomic) AccessToken* accessToken;
@property (assign, nonatomic) NSInteger tempCount;
@property (assign, nonatomic) BOOL logout;


@end

@implementation ServerManager

+ (ServerManager*) sharedManager
{
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}


- (void) getFriendsWithOffset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void (^)(NSArray *))success
                    onFailure:(void (^)(NSError* error, NSInteger statusCode))failure
{
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
    self.accessToken.userID,  @"user_id",
    @"name",                  @"order",
    @(count),                 @"count",
    @(offset),                @"offset",
    @"photo_50",              @"fields",
    @"nom",                   @"name_case",
    self.accessToken.token,   @"access_token", nil];
    
    
    [self.sessionManager
     GET:@"friends.get"
     parameters:params
     progress:nil
     success:^(NSURLSessionTask *task, NSDictionary* responseObject) {
         
         NSArray* dictssArray =  [responseObject objectForKey:@"response"];
         
         NSMutableArray* objectsArray = [NSMutableArray array];
         
         for (NSDictionary* dict in dictssArray ) {
             User* user = [[User alloc] initWithServerResponse:dict];
             [objectsArray addObject:user];
         }
         
         if (success) {
             success(objectsArray);
         }

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        if (failure) {
            NSLog(@"get friends failure");
        }

    }];

}

- (void) getUserDetails:(NSString*)user_ids
              onSuccess:(void (^)(UserDetails *))success
              onFailure:(void (^)(NSError* error, NSInteger statusCode))failure
{
    
    NSArray* fields = [NSArray arrayWithObjects:@"city",@"bdate",@"photo_200",@"photo_100", nil];
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     user_ids,                  @"user_ids",
     fields,                    @"fields",
     @"5.57",                   @"v",
     self.accessToken.token,    @"access_token", nil];

    
    [self.sessionManager
     GET:@"users.get"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         NSArray* dictssArray =  [responseObject objectForKey:@"response"];
         
         UserDetails* userDetail = [UserDetails alloc];
         
         for (NSDictionary* dict in dictssArray ) {
             userDetail = [userDetail initWithServerResponse:dict];
         }

         if (success) {
             success(userDetail);
         }
         
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"Error: %@", error);
         
         if (failure) {
             NSLog(@"get userDetails failure");
         }
     }];
}

- (void) getCityFromId:(NSString*)cityID
              onSuccess:(void (^)(NSString *))success
              onFailure:(void (^)(NSError* error, NSInteger statusCode))failure
{
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:cityID, @"city_ids", nil];
    
    [self.sessionManager
     GET:@"database.getCitiesById"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    
         NSArray *objects = [responseObject objectForKey:@"response"];
         NSString* city =   [[objects firstObject] objectForKey:@"name"];
         success(city);
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"get city from server database failure");
    }];
}

- (void) getSubscribtions:(NSString*)userId
                   offset:(NSInteger)offset
                    count:(NSInteger)count
                onSuccess:(void(^)(NSArray *))success
                onFailure:(void(^)(NSError* error, NSInteger statusCode))failure
{
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userId,           @"user_id",
     @"1",             @"extended",
     @(offset),        @"offset",
     @(count),         @"count", nil];
    
    [self.sessionManager
     GET:@"users.getSubscriptions"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
        NSArray* dictssArray =  [responseObject objectForKey:@"response"];
         
          NSMutableArray* objectsArray = [NSMutableArray array];
         
         for (NSDictionary* dict in dictssArray ) {
             Subscribe* subscribe = [[Subscribe alloc] initWithServerResponse:dict];
             [objectsArray addObject:subscribe];
         }
         
         if (success) {
             success(objectsArray);
         }
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Fail");
        
        if (failure) {
            NSLog(@"get subs from server failure");
        }
    }];

}

- (void) getFollowers:(NSString*)userId
               offset:(NSInteger)offset
                count:(NSInteger)count
            onSuccess:(void(^)(NSArray *))success
            onFailure:(void(^)(NSError* error, NSInteger statusCode))failure
{
     NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userId,        @"user_id",
     @"photo_50",   @"fields" ,
     @(offset),     @"offset",
     @(count),      @"count", nil];
    
    [self.sessionManager
     GET:@"users.getFollowers"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray* dictssArray =  [[responseObject objectForKey:@"response"] objectForKey:@"items"];

        NSMutableArray* objectsArray = [NSMutableArray array];
         
         for (NSDictionary* dict in dictssArray ) {
             
             Follower* follower = [[Follower alloc] initWithServerResponse:dict];

             [objectsArray addObject:follower];
         }
         
         if (success) {
             success(objectsArray);
         }
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            NSLog(@"get followers from serverr failure");
        }
    }];
}

- (void)getWallPostWithUserIds:(NSString *)userId
                         count:(NSInteger)count
                        offset:(NSInteger)offset
                     onSuccess:(void (^) (NSArray *wallPost)) success
                     onFailure:(void (^) (NSError *error)) failure {
    
    
    NSDictionary *params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userId,                    @"owner_id",
     @(count),                  @"count",
     @(offset),                 @"offset",
     @"owner",                  @"filter",
     @"5.60",                   @"v",
     self.accessToken.token,    @"access_token", nil];
    
    [self.sessionManager
     GET:@"wall.get"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *objects = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
        
        NSMutableArray *arrayWithWallPost = [[NSMutableArray alloc]init];
        
        for (int i = 0; i < [objects count]; i++) {
            
            Wall *wall = [[Wall alloc]initWithServerResponse:[objects objectAtIndex:i]];
            [arrayWithWallPost addObject:wall];
        }
         

        success(arrayWithWallPost);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
        failure(error);
    }];

}

- (void) getNewsFeed:(NSInteger)count
            nextFrom:(NSString*)nextFromArgument
           onSuccess:(void (^) (NSDictionary *feedPosts)) success
           onFailure:(void (^) (NSError *error)) failure
{
    
    NSDictionary* params;
    
    
    
    if (nextFromArgument != nil) {
        
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"post",                @"filters",
                                @"0",                   @"return_banned",
                                nextFromArgument,       @"start_from",
                                @(count),               @"count",
                                self.accessToken.token, @"access_token",
                                @"5.60",                @"v", nil];
    } else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"post",                @"filters",
                                @"0",                   @"return_banned",
                                @(count),               @"count",
                                self.accessToken.token, @"access_token",
                                @"5.60",                @"v", nil];
    }
    



    
    [self.sessionManager
     GET:@"newsfeed.get"
     parameters:params
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
         //Первичный парсинг на 3 категории
         
         NSDictionary *tempDict = [responseObject objectForKey:@"response"];
         
         NSArray *items = [tempDict objectForKey:@"items"];
         
         NSArray *groups = [tempDict objectForKey:@"groups"];
         
         NSString *responseNextFrom;
         
         NSMutableArray *tempArrayPreCreatePosts = [[NSMutableArray alloc] init];
         
         NSMutableArray *arrayWithNewsFeedPosts = [[NSMutableArray alloc] init];
         
         if (tempDict != nil) {

           responseNextFrom   = [tempDict objectForKey:@"next_from"];
             
         }
            
         
         
         for (int i = 0; i < [items count]; i++) {
             
             NSDictionary *tempItem = [items objectAtIndex:i];
             
             //Достаю отсюда sourceId для последующей сверки
             
             //NSLog(@" OBJECT AT INDEX %d  = \n %@", i, tempItem);
             
             NSString *sourceId = [tempItem objectForKey:@"source_id"];
             
             

             
             //Удаляю "-" перед sourceID
             
             NSRange range = [[NSString stringWithFormat:@"%@", sourceId] rangeOfString:@"-"];
             
             NSString *indexAccordingGroupOwner;
             
             
            if (range.length > 0)
            {
                indexAccordingGroupOwner = [[NSString stringWithFormat:@"%@",sourceId] substringFromIndex:1];
            }
             

             
             
             //Сравниваю id источника поста с массивом групп и ищу соотвествие, нахожу владельца.
             
             NSMutableArray* newsFeedSinglePostData = [NSMutableArray array];
             
             for (NSDictionary *dict in groups) {
                 
                 NSString *str = [NSString stringWithFormat:@"%@", [dict objectForKey:@"id"]];
                 
                 if (indexAccordingGroupOwner != nil && str != nil) {
                     
                     if ([str isEqual:indexAccordingGroupOwner]) {
                         
                         [newsFeedSinglePostData addObject:[items objectAtIndex:i]];
                         [newsFeedSinglePostData addObject:dict];
                         
                         [tempArrayPreCreatePosts addObject:newsFeedSinglePostData];
                         
                         break;
                         
                     }
                 }
             }
         }
         

         
         for (int i = 0; i < [tempArrayPreCreatePosts count]; i++) {
             
             NewsFeedPost * newsFeedPost = [[NewsFeedPost alloc] initWithServerResponse:[tempArrayPreCreatePosts objectAtIndex:i]];
             [arrayWithNewsFeedPosts addObject:newsFeedPost];
         }
         

        
         NSDictionary* exportData = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     arrayWithNewsFeedPosts,  @"posts",
                                     responseNextFrom,        @"next_from", nil];

         self.tempCount++;
         
         success(exportData);
         
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"newsFeed getting failure");
    }];

}


- (void) authorizeUser:(void (^)(User *))completion
{
    LoginWebViewController* vc = [[LoginWebViewController alloc] initWithCompletionBlock:^(AccessToken *token) {
        self.accessToken = token;
        self.userId = token.userID;
        NSLog(@"server manager userID = %@", self.userId);
        
        if (completion) {
            completion(nil);
        }
    }];

    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];

    UIViewController* mainVC = [[[UIApplication sharedApplication]windows] firstObject].rootViewController;

    [mainVC presentViewController:nav
                         animated:YES
                       completion:nil];

}

- (void) clearAllCookies {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
}

@end
