//
//  ShowSubscribtionController.m
//  APITest
//
//  Created by Admin on 27.09.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import "ShowSubscribtionController.h"
#import "ServerManager.h"
#import "Subscribe.h"
#import "UIImageView+AFNetworking.h"

@interface ShowSubscribtionController ()

@property (strong, nonatomic) NSMutableArray* subscribtionsArray;

@end

@implementation ShowSubscribtionController

static NSInteger subsInRequest = 20;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.subscribtionsArray = [NSMutableArray array];
    
    [self getSubscribtionsFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void)getSubscribtionsFromServer
{
    [[ServerManager sharedManager]
     getSubscribtions:self.user_id
     offset:[self.subscribtionsArray count]
     count:subsInRequest
     onSuccess:^(NSArray* subs) {
         
         [self.subscribtionsArray addObjectsFromArray:subs];
         
         NSMutableArray* newPaths = [NSMutableArray array];
         
         for (int i = (int)[self.subscribtionsArray count] - (int)[subs count]; i < [self.subscribtionsArray count]; i++) {
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
    return [self.subscribtionsArray count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString* identifier = @"Cell";

    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    
    if (indexPath.row == [self.subscribtionsArray count]) {
        cell.textLabel.text = @"LOAD MORE";
        cell.imageView.image = nil;
        
    } else {
    
        Subscribe* subscribe = [self.subscribtionsArray objectAtIndex:indexPath.row];
    
        cell.textLabel.text = subscribe.name;
        
        NSURLRequest* request = [NSURLRequest requestWithURL:subscribe.imageURL];
        
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
             
         }];
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.subscribtionsArray count] ) {
        [self getSubscribtionsFromServer];
    }
}

@end
