//
//  ShowFriendDetailController.m
//  APITest
//
//  Created by Admin on 23.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import "ShowFriendDetailController.h"
#import  "QuartzCore/QuartzCore.h"
#import "UserDetails.h"
#import "ServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "ShowFollowersController.h"
#import "ShowSubscribtionController.h"
#import "UserDetailCell.h"
#import "Wall.h"
#import "WallPostCell.h"



#define DELTA_LABEL 65
#define DELTA_SCALE 0.8f



@interface ShowFriendDetailController ()
@property (strong, nonatomic) UserDetails* tempUserDetails;
@property (strong, nonatomic) NSMutableArray* wallPostsArray;
@property (strong, nonatomic) UIImage* postOwnerPhoto;
@end

@implementation ShowFriendDetailController

static NSInteger wallPostsInRequest = 10;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wallPostsArray = [NSMutableArray array];
    
    [self getUserDetailsFromServer];
    
    [self getWallPostsFromServer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 //Class method for calculating user Age

+ (NSInteger)age:(NSDate *)dateOfBirth {
    if (dateOfBirth != NULL) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
        NSDateComponents *dateComponentsNow = [calendar components:unitFlags fromDate:[NSDate date]];
        NSDateComponents *dateComponentsBirth = [calendar components:unitFlags fromDate:dateOfBirth];
        
        if (([dateComponentsNow month] < [dateComponentsBirth month]) ||
            (([dateComponentsNow month] == [dateComponentsBirth month]) && ([dateComponentsNow day] < [dateComponentsBirth day]))) {
            return [dateComponentsNow year] - [dateComponentsBirth year] - 1;
        } else {
            return [dateComponentsNow year] - [dateComponentsBirth year];
        }
    }
    return 0;
}


- (NSString *) stringByStrippingHTML:(NSString *)string {
    
    NSRange r;
    while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
        
        string = [string stringByReplacingCharactersInRange:r withString:@""];
    }
    
    return string;
}




#pragma mark API

- (void)getUserDetailsFromServer
{
    
    [[ServerManager sharedManager]
     getUserDetails:self.user_id
     onSuccess:^(UserDetails* respondUserDetails) {
         
         self.tempUserDetails = respondUserDetails;

         
         [self.tableView reloadData];
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"Detailed user failed");
     }];
    

}

- (void) getWallPostsFromServer
{
    
    [[ServerManager sharedManager]
     getWallPostWithUserIds:self.user_id
     count:wallPostsInRequest
     offset:[self.wallPostsArray count]
     onSuccess:^(NSArray *wallPost) {
         
         if ([wallPost count] > 0) {
             
             [self.wallPostsArray addObjectsFromArray:wallPost];
             
             NSMutableArray* newPaths = [NSMutableArray array];
             
             for (int i = (int)[self.wallPostsArray count] - (int)[wallPost count]; i < [self.wallPostsArray count]; i++) {
                 [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                 
             }
             
             [self.tableView beginUpdates];
             [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
             [self.tableView endUpdates];

         }
 
    } onFailure:^(NSError *error) {
        
        NSLog(@"Getting wall post error");
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else {
        return [self.wallPostsArray count] + 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* detailedInfoIdentifier = @"detailInfoIdentifier";
    NSString* twoButtonsIdentifier = @"twoButtonsIdentifier";
    NSString* wallPostsIdentifier  = @"wallPostsIdentifier";
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        UserDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:detailedInfoIdentifier];
        
        if (!cell) {
            cell = [[UserDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailedInfoIdentifier];
        }
        
        cell.firstNameOutlet.text = self.tempUserDetails.firstName;
        cell.lastNameOutlet.text = self.tempUserDetails.lastName;
        cell.cityOutlet.text = self.tempUserDetails.city;
        
        
        if (self.tempUserDetails.age != 2016 && self.tempUserDetails.age != 0 ) {
            cell.ageOutlet.text = [NSString stringWithFormat:@"Age: %ld",(long)self.tempUserDetails.age];
        }
        
        NSURLRequest* request = [NSURLRequest requestWithURL:self.tempUserDetails.imageURL];
        
         UserDetailCell* weakCell = cell;

              
        [cell.imageView
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

             weakCell.photoOutlet.image = image;
             self.postOwnerPhoto = image;
             [weakCell layoutSubviews];
         }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             
             NSLog(@"Getting imageView in tableView fail");
             
         }];


        CALayer *imageLayer = cell.photoOutlet.layer;
 
        [imageLayer setBorderWidth:2];
        [imageLayer setBorderColor:[[UIColor grayColor] CGColor]];
        
        cell.photoOutlet.layer.cornerRadius = 65;
        cell.photoOutlet.layer.masksToBounds = YES;

         return  cell;
    }
    
    
     if (indexPath.section == 0 && indexPath.row == 1) {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:twoButtonsIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:twoButtonsIdentifier];
        }
         
         for (UIButton* button in cell.subviews) {
             
             button.layer.cornerRadius = 20;
             button.layer.masksToBounds = YES;
         }

        return  cell;
        
    }
    
    
    if (indexPath.row == [self.wallPostsArray count]) {
        

        WallPostCell* cell = [[WallPostCell alloc] init];
        if (!cell) {
            cell = [[WallPostCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:twoButtonsIdentifier];
        }
        
        
        for (UIView* __strong view in cell.subviews) {
            
            view = nil;
        }

        cell.textLabel.text = @"LOAD MORE";
        cell.backgroundColor = [UIColor colorWithRed:0.19 green:0.71 blue:0.58 alpha:1.0];
        
        return cell;
    }
    
    
    if (indexPath.section == 1 && indexPath.row < [self.wallPostsArray count]) {
        
        WallPostCell *postCell = [tableView dequeueReusableCellWithIdentifier:wallPostsIdentifier];
        
        if (!postCell) {
            postCell = [[WallPostCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:wallPostsIdentifier];
        }
        
        if ([self.wallPostsArray count] > 0) {
            
            
            Wall *wall = [self.wallPostsArray objectAtIndex:indexPath.row];
            
            postCell.userImageView.image = self.postOwnerPhoto;
            
            CALayer *imageLayer = postCell.userImageView.layer;
            [imageLayer setCornerRadius:20];
            [imageLayer setBorderWidth:1];
            [imageLayer setBorderColor:[[UIColor grayColor] CGColor]];
            [imageLayer setMasksToBounds:YES];
            
            postCell.dateLabel.text = wall.date;
            postCell.postOwnerNameLabel.text = [NSString stringWithFormat:@"%@ %@",self.tempUserDetails.lastName,self.tempUserDetails.firstName];
            
            postCell.textPostLabel.text = [self stringByStrippingHTML:wall.text];
            
            
            // Resize post text label
            
            CGSize constrainedSize = CGSizeMake(postCell.textPostLabel.frame.size.width, 100);
            
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:10.0], NSFontAttributeName,nil];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[self stringByStrippingHTML:wall.text] attributes:attributesDictionary];
            
            CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            if (requiredHeight.size.width > postCell.textPostLabel.frame.size.width) {
                requiredHeight = CGRectMake(0,0, postCell.textPostLabel.frame.size.width, requiredHeight.size.height);
            }
            CGRect newFrame = postCell.textPostLabel.frame;
            newFrame.size.height = requiredHeight.size.height;
            
            postCell.textPostLabel.frame = newFrame;
            
            
    
            NSURLRequest* request = [NSURLRequest requestWithURL:wall.postImageURL];
            
            WallPostCell* weakCell = postCell;
            postCell.postImageView.image = nil;
            

            
            [postCell.imageView
             setImageWithURLRequest:request
             placeholderImage:nil
             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                 
                 wall.postPhoto = image;
                 weakCell.postImageView.image = wall.postPhoto;
                 
                 weakCell.postImageView.frame = CGRectMake(newFrame.origin.x, newFrame.size.height + DELTA_LABEL, wall.postPhoto.size.width * DELTA_SCALE, wall.postPhoto.size.height * DELTA_SCALE);
                 
                 [weakCell layoutSubviews];
                 
             }
             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                 
                 NSLog(@"postCell imageView getting reques failed");
                 
             }];

            return  postCell;
            
        }
    }
    
    
    return nil;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.wallPostsArray count] ) {
        [self getWallPostsFromServer];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 199;
    }
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 72;
    }
    if (indexPath.section == 1 && indexPath.row < [self.wallPostsArray count]) {
        
        if ([self.wallPostsArray count] > 0) {
            
            WallPostCell *postCell = (WallPostCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            
            return postCell.textPostLabel.frame.size.height + postCell.postImageView.frame.size.height + 100;
        }
    }
    if (indexPath.section == 1 && indexPath.row == [self.wallPostsArray count]) {
        return 50;
    }
    return 40;
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
   if ([segue.identifier isEqualToString:@"showSubsSegue"]) {
        
        ShowSubscribtionController* vc = segue.destinationViewController;
        vc.user_id = self.user_id;
    }
    
    if ([segue.identifier isEqualToString:@"showFollowersSegue"]) {
        ShowFollowersController* vc = segue.destinationViewController;
        vc.user_id = self.user_id;
    }
    
    
}

@end
