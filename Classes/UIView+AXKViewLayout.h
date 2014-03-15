//
//  UIView+AXKViewLayout.h
//  Alexander Kolov
//
//  Created by Alexander Kolov on 5/23/13.
//  Copyright (c) 2013 Alexander Kolov. All rights reserved.
//

@import UIKit;

@interface UIView (AXKViewLayout)

+ (instancetype)autolayoutView;

- (NSLayoutConstraint *)pinWidth:(CGFloat)width withRelation:(NSLayoutRelation)relation;
- (NSLayoutConstraint *)pinHeight:(CGFloat)height withRelation:(NSLayoutRelation)relation;
- (NSArray *)pinSize:(CGSize)size withRelation:(NSLayoutRelation)relation;

- (NSArray *)pinToCenter;
- (NSArray *)pinToCenterOfView:(UIView *)superview;
- (NSLayoutConstraint *)pinToCenterOfView:(UIView *)view onAxis:(UILayoutConstraintAxis)axis;
- (NSLayoutConstraint *)pinToCenterInContainerOnAxis:(UILayoutConstraintAxis)axis;

- (NSLayoutConstraint *)pinToContainerEdge:(NSLayoutAttribute)edge;
- (NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toView:(UIView *)otherView edge:(NSLayoutAttribute)otherEdge;
- (NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toView:(UIView *)otherView;

- (NSArray *)pinToFillContainer;
- (NSArray *)pinToFillContainerOnAxis:(UILayoutConstraintAxis)axis;
- (NSArray *)pinViews:(NSArray *)views toFillContainerOnAxis:(UILayoutConstraintAxis)axis;

- (NSArray *)pinEqualToView:(UIView *)view;
- (NSLayoutConstraint *)pinEqualToView:(UIView *)view attribute:(NSLayoutAttribute)attribute;

- (NSArray *)pinInContainerWithVisualFormat:(NSString *)format;

- (void)pin:(NSArray *)expressions owner:(id)owner;
- (void)pin:(NSString *)expression options:(NSLayoutFormatOptions)options owner:(id)owner;

@end
