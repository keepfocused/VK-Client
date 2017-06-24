//
//  UserDetailCell.h
//  APITest
//
//  Created by Admin on 06.10.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *firstNameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *lastNameOutlet;
@property (weak, nonatomic) IBOutlet UILabel *cityOutlet;
@property (weak, nonatomic) IBOutlet UILabel *ageOutlet;
@property (weak, nonatomic) IBOutlet UIImageView *photoOutlet;

@end
