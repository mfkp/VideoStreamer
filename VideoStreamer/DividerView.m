//
//  DividerView.m
//  VideoStreamer2
//
//  Created by Kyle Powers on 7/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//
//  Drag handle style adapted from:
//  MGSplitView by Matt Gemmell
//

#import "DividerView.h"

@implementation DividerView

- (void)drawRect:(CGRect)rect {
    // Draw gradient background.
    CGRect bounds = self.bounds;
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = {0, 1};
    CGFloat components[8] = {	0.999, 0.999, 0.999, 1.0,  // light
                                0.666, 0.666, 0.666, 1.0 };// dark
    CGGradientRef gradient = CGGradientCreateWithColorComponents (rgb, components, locations, 2);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint start, end;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        // Light left to dark right.
        start = CGPointMake(CGRectGetMinX(bounds), CGRectGetMidY(bounds));
        end = CGPointMake(CGRectGetMaxX(bounds), CGRectGetMidY(bounds));
    } else {
        // Light top to dark bottom.
        start = CGPointMake(CGRectGetMidX(bounds), CGRectGetMinY(bounds));
        end = CGPointMake(CGRectGetMidX(bounds), CGRectGetMaxY(bounds));
    }
    CGContextDrawLinearGradient(context, gradient, start, end, 0);
    CGColorSpaceRelease(rgb);
    CGGradientRelease(gradient);
    
    // Draw borders.
    float borderThickness = 1.0;
    [[UIColor colorWithWhite:0.7 alpha:1.0] set];
    CGRect borderRect = bounds;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        borderRect.size.width = borderThickness;
        UIRectFill(borderRect);
        borderRect.origin.x = CGRectGetMaxX(bounds) - borderThickness;
        UIRectFill(borderRect);
    } else {
        borderRect.size.height = borderThickness;
        UIRectFill(borderRect);
        borderRect.origin.y = CGRectGetMaxY(bounds) - borderThickness;
        UIRectFill(borderRect);
    }
    
    // Draw grip.
    [self drawGripThumbInRect:bounds];
}

- (void)drawGripThumbInRect:(CGRect)rect {
	float width = 9.0;
	float height;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		height = 30.0;
	} else {
		height = width;
		width = 30.0;
	}
	
	// Draw grip in centred in rect.
	CGRect gripRect = CGRectMake(0, 0, width, height);
	gripRect.origin.x = ((rect.size.width - gripRect.size.width) / 2.0);
	gripRect.origin.y = ((rect.size.height - gripRect.size.height) / 2.0);
	
	float stripThickness = 1.0;
	UIColor *stripColor = [UIColor colorWithWhite:0.35 alpha:1.0];
	UIColor *lightColor = [UIColor colorWithWhite:1.0 alpha:1.0];
	float space = 3.0;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		gripRect.size.width = stripThickness;
		[stripColor set];
		UIRectFill(gripRect);
		
		gripRect.origin.x += stripThickness;
		gripRect.origin.y += 1;
		[lightColor set];
		UIRectFill(gripRect);
		gripRect.origin.x -= stripThickness;
		gripRect.origin.y -= 1;
		
		gripRect.origin.x += space + stripThickness;
		[stripColor set];
		UIRectFill(gripRect);
		
		gripRect.origin.x += stripThickness;
		gripRect.origin.y += 1;
		[lightColor set];
		UIRectFill(gripRect);
		gripRect.origin.x -= stripThickness;
		gripRect.origin.y -= 1;
		
		gripRect.origin.x += space + stripThickness;
		[stripColor set];
		UIRectFill(gripRect);
		
		gripRect.origin.x += stripThickness;
		gripRect.origin.y += 1;
		[lightColor set];
		UIRectFill(gripRect);
		
	} else {
		gripRect.size.height = stripThickness;
		[stripColor set];
		UIRectFill(gripRect);
		
		gripRect.origin.y += stripThickness;
		gripRect.origin.x -= 1;
		[lightColor set];
		UIRectFill(gripRect);
		gripRect.origin.y -= stripThickness;
		gripRect.origin.x += 1;
		
		gripRect.origin.y += space + stripThickness;
		[stripColor set];
		UIRectFill(gripRect);
		
		gripRect.origin.y += stripThickness;
		gripRect.origin.x -= 1;
		[lightColor set];
		UIRectFill(gripRect);
		gripRect.origin.y -= stripThickness;
		gripRect.origin.x += 1;
		
		gripRect.origin.y += space + stripThickness;
		[stripColor set];
		UIRectFill(gripRect);
		
		gripRect.origin.y += stripThickness;
		gripRect.origin.x -= 1;
		[lightColor set];
		UIRectFill(gripRect);
	}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    offset = [aTouch locationInView: self];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *aTouch = [touches anyObject];
    CGPoint location = [aTouch locationInView:self.superview];
    
    [UIView beginAnimations:@"Dragging Divider" context:nil];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat windowHeight = self.window.frame.size.height;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        NSInteger y = location.y - offset.y;
        if (y < 0)
            y = 0;
        if (y > (windowHeight - self.frame.size.height))
            y = (windowHeight - self.frame.size.height);
        self.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
    } else if (UIInterfaceOrientationIsLandscape(orientation)) {
        NSInteger x = location.x - offset.x;
        if (x < 0)
            x = 0;
        if (x > (windowHeight - self.frame.size.width))
            x = (windowHeight - self.frame.size.width);
        self.frame = CGRectMake(x, 0, self.frame.size.width, self.frame.size.height);
    }
    [UIView commitAnimations];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DividerDragged" object:self];
}

@end
