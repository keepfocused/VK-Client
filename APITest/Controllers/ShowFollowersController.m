//
//  ShowFollowersController.m
//  APITest
//
//  Created by Admin on 27.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import "ShowFollowersController.h"
#import "ServerManager.h"
#import "Follower.h"
#import "UIImageView+AFNetworking.h"
#import "ShowFriendDetailController.h"

@interface ShowFollowersController ()

@property (strong, nonatomic) NSMutableArray* followersArray;
@property (strong, nonatomic) NSString* selectedUserId;

@end

@implementation ShowFollowersController

static NSInteger followersInRequest = 20;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.followersArray = [NSMutableArray array];
    
    [self getFollowersFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void) getFollowersFromServer
{
    
    [[ServerManager sharedManager]
     getFollowers:self.user_id
     offset:[self.followersArray count]
     count:followersInRequest
     onSuccess:^(NSArray* followers) {
         
         [self.followersArray addObjectsFromArray:followers];
         
         NSMutableArray* newPaths = [NSMutableArray array];
         
         for (int i = (int)[self.followersArray count] - (int)[followers count]; i < [self.followersArray count]; i++) {
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
         [self.tableView endUpdates];
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"Subs failure");
     }];
    
}

#pragma mark - UITableViewDataSource



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.followersArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    if (indexPath.row == [self.followersArray count]) {
        cell.textLabel.text = @"LOAD MORE";
        cell.imageView.image = nil;
        
    } else {

        Follower* follower = [self.followersArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = follower.name;
        
        NSURLRequest* request = [NSURLRequest requestWithURL:follower.imageURL];
        
        __weak UITableViewCell* weakCell = cell;
        
        cell.imageView.image = nil;
        
        [cell.imageView
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             weakCell.imageView.image = image;
             [weakCell layoutSubviews];
         }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             
              NSLog(@"Subs failure");
             
         }];
    }
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.followersArray count] ) {
        [self getFollowersFromServer];
    
    } else {
        
        self.selectedUserId =  [[self.followersArray objectAtIndex:indexPath.row] userID];
    
        [self performSegueWithIdentifier:@"showUserDetail" sender:nil];
    }
}


#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //NSLog(@"prepareForSegue: %@", segue.identifier);
    
    ShowFriendDetailController* vc = segue.destinationViewController;
    vc.user_id = self.selectedUserId;
}


- (void) dealloc
{
    NSLog(@"ShowFollowersController deallocated");
}


@end
