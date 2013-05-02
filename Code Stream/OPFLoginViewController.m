//
//  OPFLoginViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 02.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFLoginViewController.h"
#import "OPFAppState.h"

@interface OPFLoginViewController ()

@end

@implementation OPFLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self opfSetupView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)opfSetupView
{
    self.title = NSLocalizedString(@"Login", @"Login View controller title");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Returning 1 because we only have one section for users
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 59;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *startDtLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 25)];
        if (indexPath.row == 0)
            startDtLbl.text = @"Display name";
        else {
            startDtLbl.text = @"Password";
        }
        
        startDtLbl.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:startDtLbl];
        
        UITextField *passwordTF = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, 200, 35)];
        passwordTF.delegate = self;
        if (indexPath.row == 0)
            passwordTF.tag = 0;
        else {
            passwordTF.tag = 1;
        }
        [cell.contentView addSubview:passwordTF];
    }
    return cell;
}

#pragma mark - TabbedViewController methods

// Setting the image of the tab.
- (NSString *)tabImageName
{
    return [OPFAppState isLoggedIn] ? @"tab-me" : @"tab-login";
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return [OPFAppState isLoggedIn] ? NSLocalizedString(@"My Profile", @"Profile View Controller tab title") : NSLocalizedString(@"Login", @"Login View Controller tab title");
}

@end
