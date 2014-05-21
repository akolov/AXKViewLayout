//
//  UIView+AXKViewLayout.m
//  Alexander Kolov
//
//  Created by Alexander Kolov on 5/23/13.
//  Copyright (c) 2013 Alexander Kolov. All rights reserved.
//

#import "UIView+AXKViewLayout.h"

@import Darwin.POSIX.libgen;

#ifdef DEBUG
#  define DEBUG_MODE 1
#else
#  define DEBUG_MODE 0
#endif

#ifndef ErrorLog
#define ErrorLog(format, ...) \
  do { \
    if (DEBUG_MODE) { \
      char buf[] = __FILE__; \
      NSLog([@" *** Error (%s:%d:%s): " stringByAppendingString:format], \
        basename(buf), __LINE__, __func__, # __VA_ARGS__); \
    } \
  } while (0)
#endif

@implementation UIView (AXKViewLayout)

+ (instancetype)autolayoutView {
  UIView *view = [[self alloc] init];
  view.translatesAutoresizingMaskIntoConstraints = NO;
  return view;
}

#pragma mark - Pin size

- (NSLayoutConstraint *)pinWidth:(CGFloat)width withRelation:(NSLayoutRelation)relation {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeWidth
                                                                relatedBy:relation
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:width];
  [self.superview addConstraint:constraint];
  return constraint;
}

- (NSLayoutConstraint *)pinHeight:(CGFloat)height withRelation:(NSLayoutRelation)relation {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeHeight
                                                                relatedBy:relation
                                                                   toItem:nil
                                                                attribute:NSLayoutAttributeNotAnAttribute
                                                               multiplier:1.0f
                                                                 constant:height];
  [self.superview addConstraint:constraint];
  return constraint;
}

- (NSArray *)pinSize:(CGSize)size withRelation:(NSLayoutRelation)relation {
  return @[[self pinWidth:size.width withRelation:relation],
           [self pinHeight:size.height withRelation:relation]];
}

#pragma mark - Pin to center

- (NSArray *)pinToCenter {
  return [self pinToCenterOfView:self.superview];
}

- (NSArray *)pinToCenterOfView:(UIView *)superview {
  return @[[self pinToCenterOfView:superview onAxis:UILayoutConstraintAxisHorizontal],
           [self pinToCenterOfView:superview onAxis:UILayoutConstraintAxisVertical]];
}

- (NSLayoutConstraint *)pinToCenterOfView:(UIView *)view onAxis:(UILayoutConstraintAxis)axis {
  NSLayoutAttribute attribute;
  if (axis == UILayoutConstraintAxisHorizontal) {
    attribute = NSLayoutAttributeCenterX;
  }
  else {
    attribute = NSLayoutAttributeCenterY;
  }

  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:attribute
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:view
                                                                attribute:attribute
                                                               multiplier:1.0f
                                                                 constant:0];
  [self.superview addConstraint:constraint];
  return constraint;
}

- (NSLayoutConstraint *)pinToCenterInContainerOnAxis:(UILayoutConstraintAxis)axis {
  return [self pinToCenterOfView:self.superview onAxis:axis];
}

#pragma mark - Pin to edge

- (NSLayoutConstraint *)pinToContainerEdge:(NSLayoutAttribute)edge withRelation:(NSLayoutRelation)relation {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:edge
                                                                relatedBy:relation
                                                                   toItem:self.superview
                                                                attribute:edge
                                                               multiplier:1.0f
                                                                 constant:0];
  [self.superview addConstraint:constraint];
  return constraint;
}

- (NSLayoutConstraint *)pinToContainerEdge:(NSLayoutAttribute)edge {
  return [self pinToContainerEdge:edge withRelation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toView:(UIView *)otherView edge:(NSLayoutAttribute)otherEdge
                   withRelation:(NSLayoutRelation)relation {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:edge
                                                                relatedBy:relation
                                                                   toItem:otherView
                                                                attribute:otherEdge
                                                               multiplier:1.0f
                                                                 constant:0];
  [self.superview addConstraint:constraint];
  return constraint;
}

- (NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toView:(UIView *)otherView edge:(NSLayoutAttribute)otherEdge {
  return [self pinEdge:edge toView:otherView edge:otherEdge withRelation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toView:(UIView *)otherView withRelation:(NSLayoutRelation)relation {
  return [self pinEdge:edge toView:otherView edge:edge withRelation:relation];
}

- (NSLayoutConstraint *)pinEdge:(NSLayoutAttribute)edge toView:(UIView *)otherView {
  return [self pinEdge:edge toView:otherView edge:edge withRelation:NSLayoutRelationEqual];
}

#pragma mark - Fill container

- (NSArray *)pinToFillContainer {
  NSDictionary *const views = NSDictionaryOfVariableBindings(self);
  NSMutableArray *constraints = [NSMutableArray array];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
  [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self]|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views]];
  [self.superview addConstraints:constraints];
  return constraints;
}

- (NSArray *)pinToFillContainerOnAxis:(UILayoutConstraintAxis)axis {
  NSString *expression = @"|[self]|";
  if (axis == UILayoutConstraintAxisHorizontal) {
    expression = [@"H:" stringByAppendingString:expression];
  }
  else {
    expression = [@"V:" stringByAppendingString:expression];
  }

  NSDictionary *const views = NSDictionaryOfVariableBindings(self);
  NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:expression options:0 metrics:nil views:views];
  [self.superview addConstraints:constraints];
  return constraints;
}

#pragma mark - Pin equal

- (NSArray *)pinEqualToView:(UIView *)view {
  NSMutableArray *constraints = [NSMutableArray array];
  [constraints addObject:[self pinEdge:NSLayoutAttributeLeading toView:view]];
  [constraints addObject:[self pinEdge:NSLayoutAttributeTrailing toView:view]];
  [constraints addObject:[self pinEdge:NSLayoutAttributeTop toView:view]];
  [constraints addObject:[self pinEdge:NSLayoutAttributeBottom toView:view]];
  return constraints;
}

- (NSLayoutConstraint *)pinEqualToView:(UIView *)view attribute:(NSLayoutAttribute)attribute {
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:attribute
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:view
                                                                attribute:attribute
                                                               multiplier:1.0f
                                                                 constant:0];
  [self.superview addConstraint:constraint];
  return constraint;
}

#pragma mark - Pin many views

- (void)pin:(NSString *)expression options:(NSLayoutFormatOptions)options owner:(id)owner {
  NSError *error;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[(\\w+).*?\\]"
                                                                         options:0 error:&error];
  if (!regex) {
    ErrorLog(error.localizedDescription);
    return;
  }

  NSMutableDictionary *views = [NSMutableDictionary dictionary];
  [regex
   enumerateMatchesInString:expression options:0 range:NSMakeRange(0, expression.length)
   usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
     for (NSUInteger i = 1; i < result.numberOfRanges; ++i) {
       NSRange range = [result rangeAtIndex:i];
       NSString *key = [expression substringWithRange:range];
       views[key] = [owner valueForKey:key];
     }
   }];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:expression options:options metrics:0 views:views]];
}

@end
