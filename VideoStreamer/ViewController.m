//
//  ViewController.m
//  VideoStreamer2
//
//  Created by Kyle Powers on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>

#import "ViewController.h"

static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *streamURL = [NSURL URLWithString:@"http://www.thumbafon.com/code_examples/video/segment_example/prog_index.m3u8"];
    NSURL *streamURL2 = [NSURL URLWithString:@"http://video.sina.com/v/flvideo/85927_ts/iphone.m3u8"];
    
    playerView1 = [[VideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 230)];
    AVPlayer *player1 = [AVPlayer playerWithURL:streamURL];
    [playerView1 setPlayer:player1];
    [playerView1 setVideoFillMode:AVLayerVideoGravityResizeAspect];
    [view1 addSubview:playerView1];
    
    playerView2 = [[VideoPlayerView alloc] initWithFrame:CGRectMake(0, 0, 320, 230)];
    AVPlayer *player2 = [AVPlayer playerWithURL:streamURL2];
    [playerView2 setPlayer:player2];
    [playerView2 setVideoFillMode:AVLayerVideoGravityResizeAspect];
    [view2 addSubview:playerView2];
    
    dividerView = [[DividerView alloc] initWithFrame:CGRectMake(0, 230, 320, 20)];
    [self.view addSubview:dividerView];
    
    [player1 play];
    [player2 play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:) 
                                                 name:@"DividerDragged"
                                               object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) receiveNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"DividerDragged"]) {
        [self updateViewSizes];
    }
}

- (void) updateViewSizes {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        NSInteger heightView2 = 480 - (dividerView.frame.origin.y + dividerView.frame.size.height);
        view1.frame = CGRectMake(0, 0, 320, dividerView.frame.origin.y);
        playerView1.frame = CGRectMake(0, 0, 320, dividerView.frame.origin.y);
        view2.frame = CGRectMake(0, dividerView.frame.origin.y + dividerView.frame.size.height, 320, heightView2);
        playerView2.frame = CGRectMake(0, 0, 320, heightView2);
    } else if (UIInterfaceOrientationIsLandscape(orientation)) {
        NSInteger widthView2 = 480 - (dividerView.frame.origin.x + dividerView.frame.size.width);
        view1.frame = CGRectMake(0, 0, dividerView.frame.origin.x, 320);
        playerView1.frame = CGRectMake(0, 0, dividerView.frame.origin.x, 320);
        view2.frame = CGRectMake(dividerView.frame.origin.x + dividerView.frame.size.width, 0, widthView2, 320);
        playerView2.frame = CGRectMake(0, 0, widthView2, 320);
    }
}

# pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [UIView setAnimationsEnabled:NO];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [UIView setAnimationsEnabled:YES];
    
    // swap width and height, x and y
    view1.frame = CGRectMake(0, 0, view1.frame.size.height, view1.frame.size.width);
    playerView1.frame = CGRectMake(0, 0, playerView1.frame.size.height, playerView1.frame.size.width);
    dividerView.frame = CGRectMake(dividerView.frame.origin.y, dividerView.frame.origin.x, dividerView.frame.size.height, dividerView.frame.size.width);
    view2.frame = CGRectMake(view2.frame.origin.y, view2.frame.origin.x, view2.frame.size.height, view2.frame.size.width);
    playerView2.frame = CGRectMake(0, 0, playerView2.frame.size.height, playerView2.frame.size.width);
    
    // refresh the divider handles
    [dividerView removeFromSuperview];
    dividerView = [[DividerView alloc] initWithFrame:dividerView.frame];
    [self.view addSubview:dividerView];
}

@end
