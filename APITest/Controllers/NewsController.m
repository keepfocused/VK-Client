//
//  NewsController.m
//  APITest
//
//  Created by Admin on 10.11.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import "NewsController.h"
#import "ServerManager.h"
#import "NewsFeedPost.h"
#import "NewsFeedCell.h"
#import "ShowFriendDetailController.h"
#import "UIImageView+AFNetworking.h"

#define DELTA_LABEL 65
#define DELTA_SCALE 0.8f

@interface NewsController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray* newsFeedPostsArray;
@property (strong, nonatomic) NSString* nextFromString;
@property (strong, nonatomic) UIImage* tempImage;
@property (strong, nonatomic) NSMutableArray* heightOfLikeCount;
@property (strong, nonatomic) NSString* myId;
@property (assign, nonatomic) BOOL loadingData;




@end

@implementation NewsController

static NSInteger newsFeedInRequest = 1;

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.newsFeedPostsArray = [NSMutableArray array];
    self.heightOfLikeCount  = [NSMutableArray array];

    self.myId = [[ServerManager sharedManager] userId];


    self.loadingData = YES;
    [self getNewsFeed];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark API

- (void) getNewsFeed
{

    
    [[ServerManager sharedManager]
     getNewsFeed:newsFeedInRequest
     nextFrom:self.nextFromString
     onSuccess:^(NSDictionary *feedPosts) {
         
         NSArray* postsArray = [[NSArray alloc]initWithArray:[feedPosts objectForKey:@"posts"]];

         NSInteger count = [postsArray count];
         
         NSString* nextFromString = [feedPosts objectForKey:@"next_from"];
         
         self.nextFromString = nextFromString;
         
         [self.newsFeedPostsArray addObjectsFromArray:postsArray];
         
         

         //Animation
         

         
         NSMutableArray* newPaths = [NSMutableArray array];
         
         for (int i = (int)[self.newsFeedPostsArray count] - count; i < [self.newsFeedPostsArray count]; i++) {
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
             
         }

         if ([postsArray count] > 0) {
             


             [self.tableView beginUpdates];
             [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
             [self.tableView endUpdates];
             self.loadingData = NO;

         }
         
         [self.tableView reloadData];

     }
     onFailure:^(NSError *error) {
         NSLog(@"News feed getting failure");
     }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    


    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self getNewsFeed];
        }
    }
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {


    
    if (section == 0) {
        return 1;
    }
    
    if (section == 1) {
        
        return [self.newsFeedPostsArray count]; //+ 1;

    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* topSideIdentifier = @"topSideIdentifier";
    static NSString* newsFeedIdentifier  = @"newsFeedIdentifier";
    
    
    
    if (indexPath.section == 0) {
        

        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:topSideIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topSideIdentifier];
        }
        
        return cell;
    }


    
    if (indexPath.section == 1 && indexPath.row < [self.newsFeedPostsArray count]) {



        if ([self.newsFeedPostsArray count] > 0) {


            NewsFeedCell *newsCell = [tableView dequeueReusableCellWithIdentifier:newsFeedIdentifier];
            NSIndexPath* rowToReload = indexPath;
            NSMutableArray* rowsToReload = [NSMutableArray arrayWithObjects:rowToReload, nil];
            


            if (!newsCell) {
                newsCell = [[NewsFeedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:newsFeedIdentifier];
            }
            
            
            NewsFeedPost* singlePost = [self.newsFeedPostsArray objectAtIndex:indexPath.row];
            

            newsCell.postOwnerNameLabel.text = singlePost.ownerPost;
            newsCell.textPostLabel.text = singlePost.textPost;
            
            // Resize post text label
            
            CGSize constrainedSize = CGSizeMake(newsCell.textPostLabel.frame.size.width, 100);
            
            NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:10.0], NSFontAttributeName,nil];
            
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:singlePost.textPost attributes:attributesDictionary];
            CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            
            if (requiredHeight.size.width > newsCell.textPostLabel.frame.size.width) {
                requiredHeight = CGRectMake(0,0, newsCell.textPostLabel.frame.size.width, requiredHeight.size.height);
            }
            CGRect newFrame = newsCell.textPostLabel.frame;
            newFrame.size.height = requiredHeight.size.height;
            
            newsCell.textPostLabel.frame = newFrame;


            // Obtain and handling post image
            
            if (newsCell.imageView == nil) {
                NSLog(@"newsCell imageView nil");
            } else NSLog(@"NOT NIL = %@", newsCell.postImageView);
            
            if (singlePost.postPhoto == nil) {
                NSLog(@"singlePost imageVIew nil");
            } else NSLog(@"Not nil singlePost = %@",singlePost.postPhoto);
            
            

            NSURLRequest* requestPostImage = [NSURLRequest requestWithURL:singlePost.postImageURL];

            NewsFeedCell* weakCell = newsCell;
            newsCell.postImageView.image = nil;
            
            
            
            newsCell.postImageView.image = singlePost.postPhoto.image;
            //newsCell.postImageView.backgroundColor = [UIColor redColor];

            
            NSLog(@"AFTER assignment");
            
            
            if (newsCell.imageView == nil) {
                NSLog(@"newsCell imageView nil");
            } else NSLog(@"NOT NIL = %@", newsCell.postImageView);
            
            if (singlePost.postPhoto == nil) {
                NSLog(@"singlePost imageVIew nil");
            } else NSLog(@"Not nil singlePost = %@",singlePost.postPhoto);
            
            
            /*

            [newsCell.imageView
             setImageWithURLRequest:requestPostImage
             placeholderImage:nil
             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

                 singlePost.postPhoto = image;
                 weakCell.postImageView.image = singlePost.postPhoto;

                 self.tempImage = image;
                 CGRect tempRect = CGRectMake(newFrame.origin.x, newFrame.size.height + DELTA_LABEL, self.tempImage.size.width * DELTA_SCALE, self.tempImage.size.height * DELTA_SCALE);

                 weakCell.postImageView.frame = tempRect;
                 

                 //Calculate like and share label positions

                 CGFloat height = tempRect.origin.y + tempRect.size.height + 10;
                 CGRect likeRect = CGRectMake(21, height, 108, 45);
                 CGRect shareRect = CGRectMake(194, height, 108, 45);

                 if (image == nil) {
                     likeRect = CGRectMake(21, 10, 108, 45);
                     likeRect = CGRectMake(194, 10, 108, 45);

                 }

                 [weakCell.likeContainer setFrame:likeRect];
                 [weakCell.repostContainer setFrame:shareRect];

             }
             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                 
                 NSLog(@"Getting imageView in tableView failure");
                 
             }];
            */


            // Obtain post owner image


            NSURLRequest* requestPostOwnerImage = [NSURLRequest requestWithURL:singlePost.ownerImageURL];
            UIImageView* tempImage =[[UIImageView alloc] init];


            [tempImage
             setImageWithURLRequest:requestPostOwnerImage
             placeholderImage:nil
             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

                 singlePost.ownerPhoto = image;
                 weakCell.userImageView.image = singlePost.ownerPhoto;
                [weakCell layoutSubviews];
                 
             } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                 NSLog(@"Getting postOwner image failed");
             }];



            // Fill like and repost labels with data

            [self setCountAndPicture:newsCell.likeContainer
                         iconOfLabel:@"like.png"
                          countValue:singlePost.likeCount];


            [self setCountAndPicture:newsCell.repostContainer
                         iconOfLabel:@"shared2.png"
                          countValue:singlePost.shareCount];

            
            return newsCell;
        }
    }
    


    return nil;
    
}


#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        
        return 182;
    }
    
    if (indexPath.section == 1 && indexPath.row < [self.newsFeedPostsArray count]) {
        
        if ([self.newsFeedPostsArray count] > 0) {
            
            NewsFeedCell *tempCell = (NewsFeedCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
            CGFloat height = tempCell.textPostLabel.frame.size.height + tempCell.postImageView.frame.size.height + 125;
            
            return height;
        }
    }
    
    if (indexPath.section == 1 && indexPath.row == [self.newsFeedPostsArray count]) {
        return 50;
    }

    return 0;
}

#pragma mark - Actions

- (IBAction)logoutAction:(UIButton *)sender {

    [[ServerManager sharedManager] clearAllCookies];

}


- (void) setCountAndPicture:(UIView *)container iconOfLabel:(NSString *)picture countValue:(NSString *)count
{

    
    for (UIView* view in [container subviews]) {

        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView* tempView = (UIImageView*)view;
            tempView.image = [UIImage imageNamed:picture];

        }

        if ([view isKindOfClass:[UILabel class]]) {
            UILabel* tempLabel = (UILabel *)view;
            tempLabel.text = [NSString stringWithFormat:@"%@", count];
        }
    }
    
    
    
}

#pragma mark - Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"myProfile"]) {

        ShowFriendDetailController* vc = segue.destinationViewController;
        vc.user_id = self.myId;
    }

}

@end
