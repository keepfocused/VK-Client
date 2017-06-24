//
//  ViewController.m
//  APITest
//
//  Created by Admin on 15.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.


#import "ViewController.h"
#import "ServerManager.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "ShowFriendDetailController.h"



@interface ViewController ()

@property (strong, nonatomic) NSMutableArray* friendsArray;
@property (strong, nonatomic) NSString* selectedUserId;

@end

@implementation ViewController

static NSInteger friendsInRequest = 20;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.friendsArray = [NSMutableArray array];
    
    [self getfriendsFromServer];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - API

- (void) getfriendsFromServer
{
    [[ServerManager sharedManager]
     getFriendsWithOffset:[self.friendsArray count]
     count:friendsInRequest
     onSuccess:^(NSArray *friends) {
         
         [self.friendsArray addObjectsFromArray:friends];
         
         NSMutableArray* newPaths = [NSMutableArray array];
         
         for (int i = (int)[self.friendsArray count] - (int)[friends count]; i < [self.friendsArray count]; i++) {
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
             
         }
         
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
         [self.tableView endUpdates];
         
         
     }
     onFailure:^(NSError *error, NSInteger statusCode) {
         NSLog(@"error = %@, code = %ld",[error localizedDescription], (long)statusCode);
     }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friendsArray count] + 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == [self.friendsArray count]) {
        cell.textLabel.text = @"LOAD MORE";
        cell.imageView.image = nil;
        
    } else {
    
    
    User* friend = [self.friendsArray objectAtIndex:indexPath.row];
    
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",friend.firstName,friend.lastName];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:friend.imageURL];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
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
             
         }];    }
    
    
    return cell;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.friendsArray count] ) {
        [self getfriendsFromServer];
        

        
    } else {
        
        self.selectedUserId =  [[self.friendsArray objectAtIndex:indexPath.row] userId];
        
        [self performSegueWithIdentifier:@"showFriendDetail" sender:nil];
    }
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ShowFriendDetailController* vc = segue.destinationViewController;
    vc.user_id = self.selectedUserId;
}

- (void) dealloc
{
    NSLog(@"ViewController deallocated");
}


@end
