//
//  OPFLoginViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 02.05.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFLoginViewController.h"
#import "OPFAppState.h"
#import "OPFAppDelegate.h"
#import "OPFProfileContainerController.h"

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
    return 44;
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
        
        UILabel *startLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 90, 25)];
        if (indexPath.row == 0)
            startLabel.text = NSLocalizedString(@"User:", @"Login username table view start label");
        else /*if(indexPath.row == 1)*/ {
            startLabel.text = NSLocalizedString(@"Password:", @"User password table view start label");
        }
        
        startLabel.backgroundColor = [UIColor clearColor];
        
        [cell.contentView addSubview:startLabel];
        
        UITextField *inputField = [[UITextField alloc] initWithFrame:CGRectMake(125, 10, 160, 35)];
        inputField.delegate = self;
        
        if (indexPath.row == 0) {
            inputField.tag = 0;
            
            self.eMailField = inputField;
            self.eMailField.text = @"thomas.j.owens@gmail.com";
            
            [cell.contentView addSubview:inputField];
        } else /*if(indexPath.row == 1)*/ {
            inputField.tag = 1;
            
            self.passwordField = inputField;
            inputField.secureTextEntry = YES;
            
            [cell.contentView addSubview:inputField];
        }
        
        
    }
    return cell;
}

#pragma mark - TabbedViewController methods

// Setting the image of the tab.
- (NSString *)tabImageName
{
    return @"tab-login";
}

// Setting the title of the tab.
- (NSString *)tabTitle
{
    return NSLocalizedString(@"Login", @"Login View Controller tab title");
}

#pragma mark - Container Controller methods

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"%@ %@", self.class, @" WILL move to parent view controller");
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"%@ %@", self.class, @" DID move to parent view controller");
}

@end
