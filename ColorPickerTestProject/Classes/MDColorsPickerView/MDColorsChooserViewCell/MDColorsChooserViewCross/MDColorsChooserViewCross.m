//
//  MDColorsChooserViewCross.m
//  ColorPickerTestProject
//
//  Created by Nikolay Rybalko on 2/10/14.
//  Copyright (c) 2014 Nickolay Rybalko. All rights reserved.
//

#import "MDColorsChooserViewCross.h"

@interface MDColorsChooserViewCross ()

@property (nonatomic, strong) UIColor *inversColor;

@end

@implementation MDColorsChooserViewCross

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];

	CGContextRef context = UIGraphicsGetCurrentContext();

	CGContextSetStrokeColorWithColor(context, self.inversColor.CGColor);
	CGContextSetLineWidth(context, 2.0);
	CGFloat pointsOffsets = 7.0;
	CGContextMoveToPoint(context, pointsOffsets,pointsOffsets);
	CGContextAddLineToPoint(context, rect.size.width-pointsOffsets, rect.size.height-pointsOffsets);
	CGContextMoveToPoint(context, rect.size.width-pointsOffsets, pointsOffsets);
	CGContextAddLineToPoint(context, pointsOffsets, rect.size.height-pointsOffsets);

	CGContextStrokePath(context);
}

- (void)setCrossColor:(UIColor *)crossColor {
	_crossColor = crossColor;
	[self configureInverceColor];
}


- (void)configureInverceColor {
	const CGFloat* components = CGColorGetComponents(self.crossColor.CGColor);
	UIColor *inverseColor = [UIColor colorWithRed:[self inverseColorComponentFromComponent:components[0]]
	                                        green:[self inverseColorComponentFromComponent:components[1]]
	                                         blue:[self inverseColorComponentFromComponent:components[2]]
	                                        alpha:1.0];
	self.inversColor = inverseColor;
}

- (CGFloat)inverseColorComponentFromComponent:(CGFloat)colorComponent {
	NSInteger inverseIntComponent = ((NSInteger)((colorComponent +0.5)*255.0+0.5) % 256);
	CGFloat inverseComponent = inverseIntComponent /255.0;
	return inverseComponent;
}

@end
