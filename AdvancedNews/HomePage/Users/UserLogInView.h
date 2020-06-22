//
//  UserLogInView.h
//  党报党刊阅读
//
//  Created by Wangxy on 16/6/15.
//  Copyright (c) 2016年 Software Corperation. All rights reserved.
//

#ifndef UserLogInView_h
#define UserLogInView_h

#import "BasicViewCell.h"

@interface UserLogInView : BasicViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewBottomLayout;

- (IBAction) login:(UIButton *)sender;
- (IBAction) back:(UIButton *)sender;

@end

#endif
