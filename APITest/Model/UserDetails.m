//
//  UserDetails.m
//  APITest
//
//  Created by Admin on 23.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import "UserDetails.h"
#import "ShowFriendDetailController.h"

@implementation UserDetails

- (id)initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super init];
    if (self) {
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName  = [responseObject objectForKey:@"last_name"];
        
        NSDictionary* tempCity =[responseObject objectForKey:@"city"];
        self.city = [tempCity objectForKey:@"title"];
        
        if ([responseObject objectForKey:@"bdate"]) {
            
            // Calculating Age
            
            NSString *dateString = [responseObject objectForKey:@"bdate"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd-MM-yyyy"];
            NSDate *dateFromString = [[NSDate alloc] init];
            dateFromString = [dateFormatter dateFromString:dateString];
            
            NSInteger age = [ShowFriendDetailController age:dateFromString];
            // 0 = error data
            if (age != 1) {
                self.age = age;
            }
        }
        
        NSString* urlString = [responseObject objectForKey:@"photo_200"];


        if (urlString == nil) {
            urlString = [responseObject objectForKey:@"photo_100"];
        }

        
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
        
    }
    return self;
}


@end



//
//[[ServerManager sharedManager]
// getUserDetails:@"24592084"
// onSuccess:^(NSArray* fields) {
//     NSLog(@"Users.get success");
// }
// onFailure:^(NSError *error, NSInteger statusCode) {
//     NSLog(@"error = %@, code = %ld",[error localizedDescription], (long)statusCode);
// }];