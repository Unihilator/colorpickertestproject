//
//  MDGradientColorsView.m
//  ColorPickerTestProject
//
//  Created by Nikolay Rybalko on 2/3/14.
//  Copyright (c) 2014 Nickolay Rybalko. All rights reserved.
//

#import "MDGradientColorsView.h"

@implementation MDGradientColorsView

- (void)drawRect:(CGRect)rect {
	CGContextRef context=UIGraphicsGetCurrentContext();
	CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();

	CGFloat locs[[self.gradientColorsLocs count]];
	for (NSInteger i = 0; i<[self gradientColorsLocs].count; i++) {
		locs[i] = ((NSNumber*)[self gradientColorsLocs][i]).floatValue;
	}

	NSMutableArray *colors = [NSMutableArray new];
	for (UIColor *color in self.gradientColors) {
		[colors addObject:(id)color.CGColor];
	}

	CGGradientRef grad=CGGradientCreateWithColors(colorSpace, (CFArrayRef)(colors.copy), locs);
	CGContextDrawLinearGradient(context, grad, CGPointMake(0, 0),CGPointMake(CGRectGetWidth(self.frame),0), 0);
	CGGradientRelease(grad);

	CGColorSpaceRelease(colorSpace);
}

- (NSArray*)gradientColors {
	static NSArray *gradientColors = nil;
	if (!gradientColors) {
		UIColor *redColor = [UIColor redColor];
		UIColor *yellowColor = [UIColor yellowColor];
		UIColor *greenColor = [UIColor greenColor];
		UIColor *cyanColor = [UIColor cyanColor];
		UIColor *blueColor = [UIColor blueColor];
		UIColor *magentaColor = [UIColor magentaColor];
		UIColor *whiteColor = [UIColor colorWithRed:1.0
		                                      green:1.0
		                                       blue:1.0
		                                      alpha:1.0];
		UIColor *blackColor = [UIColor colorWithRed:0.0
		                                      green:0.0
		                                       blue:0.0
		                                      alpha:1.0];
		gradientColors = @[blackColor, blackColor, redColor,
		                   yellowColor, greenColor, cyanColor, blueColor,
		                   magentaColor, whiteColor,whiteColor];
	}
	return gradientColors;
}

- (NSArray*)gradientColorsLocs {
	static NSArray *gradientColorsLocs = nil;
	if (!gradientColorsLocs) {
		gradientColorsLocs = @[@(.00),@(.02),@(.13),@(.28),@(.43),@(.58),@(.73),@(.88),@(.98),@(1.0)];
	}
	return gradientColorsLocs;
}

@end
