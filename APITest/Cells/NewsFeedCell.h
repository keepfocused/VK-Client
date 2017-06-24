//
//  NewsFeedCell.h
//  APITest
//
//  Created by Admin on 10.01.17.
//  Copyright © 2017 Galiev Danil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textPostLabel;
@property (weak, nonatomic) IBOutlet UILabel *postOwnerNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *repostImageView;
@property (weak, nonatomic) IBOutlet UILabel *repostCountLabel;
@property (weak, nonatomic) IBOutlet UIView *likeContainer;
@property (weak, nonatomic) IBOutlet UIView *repostContainer;

@end
