//
//  M_RootViewController.m
//  Music
//
//  Created by thanhhaitran on 1/6/16.
//  Copyright © 2016 thanhhaitran. All rights reserved.
//

#import "M_RootViewController.h"

#import "M_First_ViewController.h"

#import "M_Second_ViewController.h"

@interface M_RootViewController ()

@end

@implementation M_RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initTabBar];
}

- (void)initTabBar
{
    M_First_ViewController * first = [M_First_ViewController new];
    UINavigationController *nav1 = [[UINavigationController alloc]
                                             initWithRootViewController:first];
    nav1.tabBarItem.image = [UIImage imageNamed:@"channel"];

    M_Second_ViewController * second = [M_Second_ViewController new];
    second.title = @"Favourites";
    UINavigationController *nav2 = [[UINavigationController alloc]
                                             initWithRootViewController:second];
    nav2.tabBarItem.image = [UIImage imageNamed:@"favs"];

    self.viewControllers = @[nav1, nav2];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
