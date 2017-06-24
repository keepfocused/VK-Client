//
//  ShowFriendDetailController.h
//  APITest
//
//  Created by Admin on 23.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//
#import <UIKit/UIKit.h>



@interface ShowFriendDetailController : UITableViewController

@property (strong, nonatomic) NSString* user_id;

+ (NSInteger)age:(NSDate *)dateOfBirth;


@end


