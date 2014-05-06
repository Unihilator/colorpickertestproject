//
//  MDColorPickerView.m
//  ColorPickerTestProject
//
//  Created by Nikolay Rybalko on 2/3/14.
//  Copyright (c) 2014 Nickolay Rybalko. All rights reserved.
//

#import "MDColorPickerView.h"
#import "MDColorSliderView.h"
#import "MDGradientColorsView.h"

@interface MDColorPickerView ()

@property (nonatomic, weak) MDColorSliderView *colorSlider;
@property (nonatomic, weak) MDGradientColorsView *gradientColorsView;
@property (nonatomic, assign) CGFloat xTouchPoint;

@end

@implementation MDColorPickerView

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - lifeCycle

- (id)init {
	self = [super init];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self initialize];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - initialize

- (void)initialize {
	[self initializeInsets];
	[self addGradientColorsView];
}

- (void)initializeInsets {
	self.gradientColorsInsets = UIEdgeInsetsMake(15.0, 15.0, 15.0, 15.0);
	self.colorSliderTopInset = -2.0;
}

- (void)addGradientColorsView {
	MDGradientColorsView *gradientColorsView = [[MDGradientColorsView alloc] init];
	[self addSubview:gradientColorsView];
	self.gradientColorsView = gradientColorsView;
	[self configureGradientColorsViewFrame];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - setters

- (void)setGradientColorsInsets:(UIEdgeInsets)gradientColorsInsets {
	_gradientColorsInsets = gradientColorsInsets;
	[self configureGradientColorsViewFrame];
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self configureGradientColorsViewFrame];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - configure section

- (void)configureGradientColorsViewFrame {
	CGRect frame = self.bounds;
	frame.origin.x = self.gradientColorsInsets.left;
	frame.origin.y = self.gradientColorsInsets.top;
	frame.size.width = frame.size.width - frame.origin.x - self.gradientColorsInsets.right;
	frame.size.height = frame.size.height - frame.origin.y - self.gradientColorsInsets.bottom;
	self.gradientColorsView.frame = frame;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.colorSlider dismiss];
	CGRect gradientColorsViewAbsoluteFrame = [self absoluteFrameToView:self.gradientColorsView];
	self.colorSlider = [MDColorSliderView colorSliderViewWithBottomPosition:gradientColorsViewAbsoluteFrame.origin.y + self.colorSliderTopInset];
	[self parentScrollView].scrollEnabled = NO;
	[self handleTouches:touches];
	[self willChooseColor];
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.colorSlider dismiss];
	[self parentScrollView].scrollEnabled = YES;
	[super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.colorSlider dismiss];
	[self parentScrollView].scrollEnabled = YES;
	[self handleTouches:touches];
	[self didChooseColor:self.currentColor];
	[super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self handleTouches:touches];
	[super touchesMoved:touches withEvent:event];
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - work with color slider

- (void)handleTouches:(NSSet*)touches {
	UITouch *touch = [touches anyObject];
	CGPoint location = [touch locationInView:self.gradientColorsView];
	self.xTouchPoint = location.x;
}

- (void)setXTouchPoint:(CGFloat)xTouchPoint {
	_xTouchPoint = xTouchPoint;
	CGRect absoluteFrame = [self absoluteFrameToView:self.gradientColorsView];
	CGFloat minimumLeftX = absoluteFrame.origin.x;
	CGFloat xLocation = xTouchPoint + minimumLeftX;
	xLocation = MAX(minimumLeftX, xLocation);
	xLocation = MIN(absoluteFrame.size.width + minimumLeftX, xLocation);
	[self.colorSlider setX:xLocation - self.colorSlider.frame.size.width/2.0
	             withColor:self.currentColor];
}

- (UIColor*)currentColor {
	NSInteger touchLocationIndex = self.touchLocationIndex;
	NSArray *gradientColors = self.gradientColorsView.gradientColors;
	if (touchLocationIndex==0) {
		return gradientColors[0];
	}
	if (touchLocationIndex==gradientColors.count) {
		return gradientColors.lastObject;
	}
	return [self mergeLeftColor:self.touchLeftColor
	             withRightColor:self.touchRightColor
	            leftCoefficient:self.leftColorPersent];
}

- (UIColor*)touchLeftColor {
	return [self touchColorAtIndex:self.touchLocationIndex-1];
}

- (UIColor*)touchRightColor {
	return [self touchColorAtIndex:self.touchLocationIndex];
}

- (UIColor*)touchColorAtIndex:(NSUInteger)index {
	return self.gradientColorsView.gradientColors[index];
}

- (NSInteger)touchLocationIndex {
	NSInteger touchLocationIndex = 0;
	NSArray *gradientColorsLocs = self.gradientColorsView.gradientColorsLocs;
	for (touchLocationIndex=0; touchLocationIndex<gradientColorsLocs.count; touchLocationIndex++) {
		NSNumber *currentValue = gradientColorsLocs[touchLocationIndex];
		if (self.touchLocationCoefficient < currentValue.floatValue) {
			break;
		}
	}
	return touchLocationIndex;
}

- (CGFloat)leftColorPersent {
	NSArray *gradientColorsLocs = self.gradientColorsView.gradientColorsLocs;
	NSInteger touchLocationIndex = self.touchLocationIndex;
	CGFloat colorsDiap = ((NSNumber*)gradientColorsLocs[touchLocationIndex]).floatValue - ((NSNumber*)gradientColorsLocs[touchLocationIndex-1]).floatValue;
	CGFloat leftColorPersent = (self.touchLocationCoefficient - ((NSNumber*)gradientColorsLocs[touchLocationIndex-1]).floatValue) /colorsDiap;
	return leftColorPersent;
}

- (CGFloat)touchLocationCoefficient {
	CGFloat coefficient = self.xTouchPoint / self.gradientColorsView.frame.size.width;
	return coefficient;
}

- (CGRect)absoluteFrameToView:(UIView*)view {
	CGRect absoluteFrame = [view convertRect:view.bounds toView:view.window];
	return absoluteFrame;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - work with colors

- (UIColor*)mergeLeftColor:(UIColor*)leftColor
            withRightColor:(UIColor*)rightColor
           leftCoefficient:(CGFloat)coefficient {
	CGFloat const *leftComponents = CGColorGetComponents(leftColor.CGColor);
	CGFloat const *rightComponents = CGColorGetComponents(rightColor.CGColor);
	NSInteger const componentsCounter = 3;
	CGFloat resultRGB[componentsCounter];
	for (NSInteger i=0; i<componentsCounter; i++) {
		resultRGB[i] = leftComponents[i] *(1.0 - coefficient) + rightComponents[i]*coefficient;
	}
	return [UIColor colorWithRed:resultRGB[0] green:resultRGB[1] blue:resultRGB[2] alpha:1.0];
}

- (UIScrollView*)parentScrollView {
	UIView *superView = self.superview;
	while (superView && ![superView isKindOfClass:[UIScrollView class]]) {
		superView = superView.superview;
	}
	return (UIScrollView*)superView;
}

////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - MDColorPickerViewDelegate calls

- (void)didChooseColor:(UIColor*)color {
	if (self.delegate && [self.delegate respondsToSelector:@selector(colorPicker:didChooseColor:)]) {
		[self.delegate colorPicker:self didChooseColor:color];
	}
}

- (void)willChooseColor {
	if (self.delegate && [self.delegate respondsToSelector:@selector(colorPickerWillChooseColor:)]) {
		[self.delegate colorPickerWillChooseColor:self];
	}
}

@end
