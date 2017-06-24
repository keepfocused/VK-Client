//
//  WallPostCell.h
//  APITest
//
//  Created by Admin on 07.10.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textPostLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *postOwnerNameLabel;

@end
