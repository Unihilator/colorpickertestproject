//
//  MDColorSliderView.m
//  ColorPickerTestProject
//
//  Created by Nikolay Rybalko on 2/3/14.
//  Copyright (c) 2014 Nickolay Rybalko. All rights reserved.
//

#import "MDColorSliderView.h"

@interface MDColorSliderView ()

@property (nonatomic, strong) UIWindow *parentWindow;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (nonatomic, assign) CGFloat bottom;

@end

@implementation MDColorSliderView

static __weak MDColorSliderView *sharedSlider;

+ (instancetype)colorSliderViewWithBottomPosition:(CGFloat)bottomPosition {
	UINib *nib = [UINib nibWithNibName:NSStringFromClass(self.class) bundle:nil];
	NSArray *views = [nib instantiateWithOwner:nil options:nil];
	MDColorSliderView *colorSlider = views.firstObject;
	colorSlider.bottom = bottomPosition;
	return colorSlider;
}

- (void)dismiss {
	[self removeFromSuperview];
	self.parentWindow = nil;
}

- (void)setX:(CGFloat)x withColor:(UIColor*)color {
	CGRect frame = self.parentWindow.frame;
	frame.origin.x = x;
	[self.parentWindow setFrame:frame];
	self.colorView.backgroundColor = color;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	[self initializeColorSliderView];
}

#pragma mark - initialize section

- (void)initializeColorSliderView {
	[self configureParent];
	[self configureColorView];
}

- (void)configureParent {
	self.parentWindow = [[UIWindow alloc] initWithFrame:self.bounds];
	self.parentWindow.windowLevel = (UIWindowLevelAlert + UIWindowLevelStatusBar)/2.0;
	[self.parentWindow makeKeyAndVisible];
	self.parentWindow.backgroundColor = [UIColor clearColor];
	[self.parentWindow addSubview:self];
}

- (void)configureColorView {
	self.colorView.layer.cornerRadius = self.colorView.frame.size.width/2.0;
	self.colorView.layer.masksToBounds = YES;
}

@dynamic bottom;
- (void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = bottom - frame.size.height;
	self.frame = frame;
}

- (CGFloat)bottom {
	CGRect frame = self.frame;
	return frame.origin.y + frame.size.height;
}

@end
