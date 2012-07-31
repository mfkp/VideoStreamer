//
//  ViewController.h
//  VideoStreamer2
//
//  Created by Kyle Powers on 7/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "VideoPlayerView.h"
#import "DividerView.h"

@interface ViewController : UIViewController {
    IBOutlet UIView *view1;
    IBOutlet UIView *view2;
    IBOutlet DividerView *dividerView;
    VideoPlayerView *playerView1;
    VideoPlayerView *playerView2;
}

@end
