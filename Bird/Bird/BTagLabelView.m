//
//  BTagLabelView.m
//  Bird
//
//  Created by 孙永刚 on 15-7-2.
//  Copyright (c) 2015年 孙永刚. All rights reserved.
//

#import "BTagLabelView.h"
#import <CoreText/CoreText.h>

static NSString *const defaultSepStr = @"  |  ";

@interface BTagLabelView ()

@property(nonatomic) NSRange highlightedRange;

@end

@implementation BTagLabelView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)initConfig
{
    self.userInteractionEnabled = YES;
    
    _separateStr = defaultSepStr;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    UILongPressGestureRecognizer *pan = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressAction:)];
    
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:pan];
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point {
    
    ////////
    
    NSMutableAttributedString* optimizedAttributedText = [self.attributedText mutableCopy];
    
    [self.attributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
        
        if ([paragraphStyle lineBreakMode] == kCTLineBreakByTruncatingTail) {
            [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        }
        
        [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
        [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        
    }];
    
    ////////
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = [self textRect];
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    //////
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    //NSLog(@"num lines: %d", numberOfLines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}

- (CGPoint)menuItemPopPointAtPoint:(CGPoint)point {
    
    ////////
    
    CGPoint popPoint = point;
    
    NSMutableAttributedString* optimizedAttributedText = [self.attributedText mutableCopy];
    
    [self.attributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        
        NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
        
        if ([paragraphStyle lineBreakMode] == kCTLineBreakByTruncatingTail) {
            [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        }
        
        [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
        [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        
    }];
    
    ////////
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return point;
    }
    
    CGRect textRect = [self textRect];
    
    if (!CGRectContainsPoint(textRect, point)) {
        return point;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    //////
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CFRelease(path);
        return point;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = self.numberOfLines > 0 ? MIN(self.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    //NSLog(@"num lines: %d", numberOfLines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return point;
    }
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                popPoint = CGPointMake(point.x, yMin);
                popPoint = CGPointMake(popPoint.x - lineOrigin.x,  self.frame.size.height-yMax-textRect.origin.y+5);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return popPoint;
}

- (void)removeHighlight {
    
    if (_highlightedRange.location != NSNotFound) {
        
        //remove highlight from previously selected word
        NSMutableAttributedString* attributedString = [self.attributedText mutableCopy];
        [attributedString removeAttribute:NSBackgroundColorAttributeName range:_highlightedRange];
        self.attributedText = attributedString;
        
        _highlightedRange = NSMakeRange(NSNotFound, 0);
    }
}

- (void)setHighlightedRange:(NSRange)wordRange
{
    if (wordRange.location == _highlightedRange.location && _highlightedRange.length >0) {
        return; //this word is already highlighted
    }
    else {
        [self removeHighlight]; //remove highlight on previously selected word
    }
    
    _highlightedRange = wordRange;
    
    //highlight selected word
    NSMutableAttributedString* attributedString = [self.attributedText mutableCopy];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor redColor] range:wordRange];
    self.attributedText = attributedString;
}

//是否点中了分隔符
- (BOOL)isSeparateStringAtLocation:(NSUInteger)loc
{
    //    NSError *error = NULL;
    //    NSString *expression = [NSString stringWithFormat:@"(%@)", self.separateStr];
    //    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
    //                                                                           options:NSRegularExpressionCaseInsensitive
    //                                                                             error:&error];
    //    __block BOOL isSepStr = NO;
    //    [regex enumerateMatchesInString:self.text
    //                            options:0
    //                              range:NSMakeRange(0, [[self text] length])
    //                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
    //                             NSRange scannedRange = [result range];
    //                             if (NSLocationInRange(loc, scannedRange)) {
    //                                 isSepStr = YES;
    //                                 *stop = YES;
    //                             }
    //                         }];
    
    BOOL isSepStr = YES;
    for (NSString *subStr in self.tagArray) {
        NSRange subRanger = [self.text rangeOfString:subStr];
        if (NSLocationInRange(loc, subRanger)) {
            isSepStr = NO;
            break;
        }
    }
    
    return isSepStr;
}

- (NSRange)getTapedRangeWithIndex:(CFIndex)charIndex
{
    NSString* string = self.text;
    
    //compute the positions of space characters next to the charIndex
    NSRange end = [string rangeOfString:self.separateStr options:0 range:NSMakeRange(charIndex, string.length - charIndex)];
    NSRange front = [string rangeOfString:self.separateStr options:NSBackwardsSearch range:NSMakeRange(0, charIndex)];
    
    if (front.location == NSNotFound) {
        front.location = 0; //first word was selected
    }
    
    if (end.location == NSNotFound) {
        end.location = string.length-1; //last word was selected
    }
    
    NSRange wordRange = NSMakeRange(front.location, end.location-front.location);
    
    if (front.location!=0) { //fix trimming
        
        wordRange.location += [self.separateStr length];
        wordRange.length -= [self.separateStr length];
    }
    
    return wordRange;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(handleDeleteAction) ||
        action == @selector(handleSetAction)) {
        return YES;
    }
    
    return NO;
}

#pragma mark --

- (CGRect)textRect {
    
    CGRect textRect = [self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    textRect.origin.y = (self.bounds.size.height - textRect.size.height)/2;
    
    if (self.textAlignment == NSTextAlignmentCenter) {
        textRect.origin.x = (self.bounds.size.width - textRect.size.width)/2;
    }
    if (self.textAlignment == NSTextAlignmentRight) {
        textRect.origin.x = self.bounds.size.width - textRect.size.width;
    }
    
    return textRect;
}

#pragma mark action

- (void)handleTapAction:(UITapGestureRecognizer *)aTap
{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
    [self resignFirstResponder];
    
    CGPoint point = [aTap locationInView:self];
    
    CFIndex charIndex = [self characterIndexAtPoint:point];
    
    if (charIndex==NSNotFound || [self isSeparateStringAtLocation:charIndex]) {
        //user did nat click on any word
        [self removeHighlight];
        return;
    }
    
    NSRange wordRange = [self getTapedRangeWithIndex:charIndex];
    
    self.highlightedRange = wordRange;
}

- (void)handleLongPressAction:(UIPanGestureRecognizer *)aPan
{
    if (aPan.state == UIGestureRecognizerStateBegan) {
        
        CGPoint point = [aPan locationInView:self];
        
        CFIndex charIndex = [self characterIndexAtPoint:point];
        if (charIndex==NSNotFound || [self isSeparateStringAtLocation:charIndex]) {
            //user did nat click on any word
            [self removeHighlight];
            return;
        }
        NSRange wordRange = [self getTapedRangeWithIndex:charIndex];
        self.highlightedRange = wordRange;
        
        CGPoint popPoint = [self menuItemPopPointAtPoint:point];
        
        UIMenuController *popMenu = [UIMenuController sharedMenuController];
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDeleteAction)];
        UIMenuItem *setIitem = [[UIMenuItem alloc] initWithTitle:@"设置名字" action:@selector(handleSetAction)];
        [popMenu setMenuItems:@[deleteItem, setIitem]];
        [popMenu setArrowDirection:UIMenuControllerArrowDown];
        [popMenu setTargetRect:CGRectMake(popPoint.x,popPoint.y,0,0) inView:self];
        [self becomeFirstResponder];
        [popMenu setMenuVisible:YES animated:YES];
    }
}

- (void)handleDeleteAction
{
    //delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(BTagLabelView:didDeleteTag:)]) {
        NSString *temp = [self.text substringWithRange:self.highlightedRange];
        [self.delegate BTagLabelView:self didDeleteTag:temp];
    }
}

- (void)handleSetAction
{
    //delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(BTagLabelView:didSetTag:)]) {
        NSString *temp = [self.text substringWithRange:self.highlightedRange];
        [self.delegate BTagLabelView:self didSetTag:temp];
    }
}

#pragma mark set

- (void)setTagArray:(NSArray *)aTagArray
{
    if ([aTagArray count]) {
        NSString *newStr = [aTagArray componentsJoinedByString:self.separateStr];
        self.text = newStr;
    }
    
    _tagArray = aTagArray;
}


@end