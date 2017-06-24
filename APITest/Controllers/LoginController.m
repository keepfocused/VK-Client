//
//  APITest
//
//  Created by Admin on 02.11.16.
//  Copyright © 2016 Galiev Danil. All rights reserved.
//

#import "LoginController.h"
#import "ServerManager.h"

@interface LoginController ()
@property (weak, nonatomic) IBOutlet UIButton *loginVKOutket;



@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.loginVKOutket.layer.cornerRadius = 65;
    self.loginVKOutket.layer.masksToBounds = YES;


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginVKButton:(UIButton *)sender {      
    
    
    [[ServerManager sharedManager] authorizeUser:^(User *user) {
        NSLog(@"Authorized user calls");
    }];
    
    

   
    
}



@end
