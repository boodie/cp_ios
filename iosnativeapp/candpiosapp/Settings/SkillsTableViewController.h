//
//  SkillsTableViewController.h
//  candpiosapp
//
//  Created by Stephen Birarda on 5/23/12.
//  Copyright (c) 2012 Coffee and Power Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSettingsTableViewController.h"

@interface SkillsTableViewController : UITableViewController

@property (nonatomic, assign) UserSettingsTableViewController *delegate;
@property (nonatomic, strong) NSMutableArray *skills;

@end