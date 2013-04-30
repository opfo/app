//
//  OPFTabbedHomeViewController.m
//  Code Stream
//
//  Created by Tobias Deekens on 30.04.13.
//  Copyright (c) 2013 Opposing Force. All rights reserved.
//

#import "OPFTabbedHomeViewController.h"
#import "OPFQuestionsViewController.h"
#import "OPFProfileSearchViewController.h"
#import "OPFUserProfileViewController.h"
#import "OPFActivityViewController.h"

@interface OPFTabbedHomeViewController ()

@property(strong, nonatomic) OPFQuestionsViewController *questionsViewController;
@property(strong, nonatomic) OPFProfileSearchViewController *profileSearchViewController;
@property(strong, nonatomic) OPFUserProfileViewController *userProfileViewController;
@property(strong, nonatomic) OPFActivityViewController *activityViewController;

- (void)opfSetupView;

@end

@implementation OPFTabbedHomeViewController

const int TabbedBarHeight = 60;

- (id)init
{
    self = [super initWithTabBarHeight:TabbedBarHeight];
    
    if (self) {
        [self opfSetupView];
    }
    
    return self;
}

- (void)opfSetupView
{
    self.questionsViewController = [OPFQuestionsViewController new];
    self.profileSearchViewController = [OPFProfileSearchViewController new];
    self.userProfileViewController = [OPFUserProfileViewController new];
    self.activityViewController = [OPFActivityViewController new];
    
    [self setViewControllers:[NSMutableArray arrayWithObjects:
                              self.questionsViewController,
                              self.activityViewController,
                              self.profileSearchViewController,
                              self.userProfileViewController,
                            nil]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
