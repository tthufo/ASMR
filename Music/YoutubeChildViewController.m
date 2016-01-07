//
//  YoutubeChildViewController.m
//  Music
//
//  Created by thanhhaitran on 11/29/15.
//  Copyright © 2015 thanhhaitran. All rights reserved.
//

#import "YoutubeChildViewController.h"

@interface YoutubeChildViewController ()<UIGestureRecognizerDelegate>
{
    NSTimer * timer;
    UIButton * button;
}

@end

@implementation YoutubeChildViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    button = [UIButton buttonWithType:UIButtonTypeContactAdd];
//    button.frame = CGRectMake(screenWidth - 55, screenHeight - 110, 55, 55);
//    [self.view addSubview:button];
//    button.alpha = 0;
//    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
//    UIViewAutoresizingFlexibleTopMargin;
//    [self showSVHUD:@"Loading" andOption:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPressSelf:)];
//    tap.numberOfTapsRequired = 1;
//    tap.delegate = self;
//    [self.view addGestureRecognizer:tap];
//    
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doDoubleTap:)];
//    doubleTap.numberOfTapsRequired = 2;
//    doubleTap.delegate = self;
//    [self.view addGestureRecognizer:doubleTap];
//    
//    [tap requireGestureRecognizerToFail:doubleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(MPMoviePlayerPlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self hideSVHUD];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

- (void)didStartView
{
    //[button fadeView:0.6 andOr:YES];
}

//- (void)didStartTimer:(BOOL)isViewing
//{
//    if(timer)
//    {
//        [timer invalidate];
//        timer = nil;
//    }
//    if(isViewing)
//    {
//        timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(didStartView) userInfo:nil repeats:NO];
//    }
//}

- (void)MPMoviePlayerPlaybackStateDidChange:(NSNotification *)notification
{
    if (self.moviePlayer.playbackState == MPMoviePlaybackStatePlaying)
    {
//        [self didStartTimer:YES];
        [self hideSVHUD];
    }
    if (self.moviePlayer.playbackState == MPMoviePlaybackStateStopped)
    {
        [self hideSVHUD];
    }
    if (self.moviePlayer.playbackState == MPMoviePlaybackStatePaused)
    {
        [self hideSVHUD];
    }
    if (self.moviePlayer.playbackState == MPMoviePlaybackStateInterrupted)
    {
        [self hideSVHUD];
    }
    if (self.moviePlayer.playbackState == MPMoviePlaybackStateSeekingForward)
    {
        
    }
    if (self.moviePlayer.playbackState == MPMoviePlaybackStateSeekingBackward)
    {
        
    }
}

//- (void)didPressSelf:(UITapGestureRecognizer*)gesture
//{
//    BOOL isViewing = [self interfaceViewWithPlayer:(MPMoviePlayerController*)self];
//    [button fadeView:isViewing ? 0.6 : 0 andOr:isViewing];
//    if(isViewing)
//    {
//        [self didStartTimer:isViewing];
//    }
//}
//
//- (void)doDoubleTap:(UITapGestureRecognizer*)gesture
//{
////    BOOL isViewing = [self interfaceViewWithPlayer:(MPMoviePlayerController*)self];
////    [button fadeView:0.5 andOr:isViewing];
////    [self didStartTimer:!isViewing];
//}
//
//- (BOOL)interfaceViewWithPlayer:(MPMoviePlayerController *)player
//{
//    for (UIView *views in [player.view subviews])
//    {
//        for (UIView *subViews in [views subviews])
//        {
//            for (UIView *controlView in [subViews subviews])
//            {
//                if ([controlView isKindOfClass:NSClassFromString(@"MPVideoPlaybackOverlayView")])
//                {
//                    return controlView.isHidden;
//                }
//            }
//        }
//    }
//    return NO;
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognize
//{
//    return YES;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
