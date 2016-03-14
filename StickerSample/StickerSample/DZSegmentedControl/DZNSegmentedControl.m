//
//  DZNSegmentedControl.m
//  DZNSegmentedControl
//  https://github.com/dzenbot/DZNSegmentedControl
//
//  Created by Ignacio Romero Zurbuchen on 3/4/14.
//  Copyright (c) 2014 DZN Labs. All rights reserved.
//  Licence: MIT-Licence
//

#import "DZNSegmentedControl.h"

@interface DZNSegmentedControl ()
@property (nonatomic) BOOL initializing;
@property (nonatomic, strong) UIView *selectionIndicator;
@property (nonatomic, strong) UIView *hairline;
@property (nonatomic, strong) NSMutableDictionary *colors;
@property (nonatomic, strong) NSMutableArray *counts; // of NSNumber
@property (nonatomic, getter = isTransitioning) BOOL transitioning;
@end

@implementation DZNSegmentedControl
@synthesize barPosition = _barPosition;
@synthesize height = _height;
@synthesize width = _width;

#pragma mark - Initialize Methods

- (void)commonInit
{
    _initializing = YES;
    
    _showsCount = YES;
    _selectedSegmentIndex = -1;
    _selectionIndicatorHeight = 3.0f;
    _animationDuration = 0.2;
    _autoAdjustSelectionIndicatorWidth = YES;
    _adjustsButtonTopInset = YES;
    _showHairLine = YES;
    
    _titleFont = [UIFont systemFontOfSize:15];
    _countFont = [UIFont systemFontOfSize:15];
    _titleFontHighlight = [UIFont systemFontOfSize:15];
    _countFontHighlight = [UIFont systemFontOfSize:15];
    
    _normalColor = [UIColor lightGrayColor];
    _highlightColor = [UIColor blueColor];

    _selectionIndicator = [UIView new];
    _selectionIndicator.backgroundColor = [UIColor blueColor];;
    [self addSubview:_selectionIndicator];
    
    _hairline = [UIView new];
    _hairline.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_hairline];
    
    _colors = [NSMutableDictionary new];
    _counts = [NSMutableArray array];
    
    _initializing = NO;
}

- (id)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        [self commonInit];
        self.items = items;
    }
    return self;
}

#pragma mark - UIView Methods

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake((self.width ? self.width : self.superview.bounds.size.width), self.height);
}

- (void)sizeToFit
{
    CGRect rect = self.frame;
    rect.size = [self sizeThatFits:rect.size];
    self.frame = rect;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self sizeToFit];
    
    if ([self buttons].count == 0) {
        _selectedSegmentIndex = -1;
    }
    else if (self.selectedSegmentIndex < 0) {
        _selectedSegmentIndex = 0;
    }
    
    [[self buttons] enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        
        CGRect rect = CGRectMake(roundf(self.bounds.size.width/self.numberOfSegments)*idx, 0.0f, roundf(self.bounds.size.width/self.numberOfSegments),
                                 self.bounds.size.height);
        [button setFrame:rect];
        
        if (_adjustsButtonTopInset) {
            CGFloat topInset = (self.barPosition > UIBarPositionBottom) ? -4.0f : 4.0f;
            button.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, topInset, 0.0f);
        }
        else {
            button.titleEdgeInsets = UIEdgeInsetsZero;
        }
        
        if (idx == self.selectedSegmentIndex) {
            button.selected = YES;
        }
    }];
    
    self.selectionIndicator.frame = [self selectionIndicatorRect];
    _hairline.frame = [self hairlineRect];
    
    [self sendSubviewToBack:self.selectionIndicator];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // Only lay out its subviews if a superview is available
    if (newSuperview) {
        [self layoutIfNeeded];
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if (!self.backgroundColor) {
        self.backgroundColor = [UIColor whiteColor];
    }
    
    [self configureSegments];
    
    [self layoutIfNeeded];
}

- (void)layoutIfNeeded
{
    // Only lay out its subviews if a superview is available
    if (!self.superview) {
        return;
    }
    
    [super layoutIfNeeded];
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(self.width, self.height);
}


#pragma mark - Getter Methods

- (CGFloat)height
{
    return (_height ? : self.showsCount ? 56.0f : 30.0f);
}

- (CGFloat)width
{
    return (_width ? : self.superview.bounds.size.width);
}

- (NSUInteger)numberOfSegments
{
    return self.items.count;
}

- (NSArray *)buttons
{
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:self.items.count];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [buttons addObject:view];
        }
    }
    return buttons;
}

- (UIButton *)buttonAtIndex:(NSUInteger)segment
{
    if (self.items.count > 0 && segment < [self buttons].count) {
        return (UIButton *)[[self buttons] objectAtIndex:segment];
    }
    return nil;
}

- (UIButton *)selectedButton
{
    if (self.selectedSegmentIndex >= 0) {
        return [self buttonAtIndex:self.selectedSegmentIndex];
    }
    return nil;
}

- (NSString *)stringForSegmentAtIndex:(NSUInteger)segment
{
    UIButton *button = [self buttonAtIndex:segment];
    return [[button attributedTitleForState:UIControlStateNormal] string];
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment
{
    if (self.showsCount) {
        NSString *title = [self stringForSegmentAtIndex:segment];
        NSArray *components = [title componentsSeparatedByString:@"\n"];
        
        if (components.count == 2) {
            return components[self.inverseTitles ? 0 : 1];
        }
        else return nil;
    }
    return self.items[segment];
}

- (NSNumber *)countForSegmentAtIndex:(NSUInteger)segment
{
    return segment < self.counts.count ? self.counts[segment] : @(0);
}

- (UIColor *)titleColorForState:(UIControlState)state
{
    NSString *key = [NSString stringWithFormat:@"UIControlState%d", (int)state];
    UIColor *color = [self.colors objectForKey:key];
    
    if (!color) {
        switch (state) {
            case UIControlStateNormal:              return [UIColor darkGrayColor];
            case UIControlStateHighlighted:         return self.tintColor;
            case UIControlStateDisabled:            return [UIColor lightGrayColor];
            case UIControlStateSelected:            return self.tintColor;
            default:                                return self.tintColor;
        }
    }
    
    return color;
}

- (CGRect)selectionIndicatorRect
{
    CGRect frame = CGRectZero;
    UIButton *button = [self selectedButton];
    NSString *title = [self titleForSegmentAtIndex:button.tag];
    
    if (title.length == 0) {
        return frame;
    }
    
    frame.origin.y = (_barPosition > UIBarPositionBottom) ? 0.0f : (button.frame.size.height-self.selectionIndicatorHeight);
    
    if (self.autoAdjustSelectionIndicatorWidth) {
        
        id attributes = nil;
        
        if (!self.showsCount) {
            
            NSAttributedString *attributedString = [button attributedTitleForState:UIControlStateSelected];
            
            if (attributedString.string.length == 0) {
                return CGRectZero;
            }
            
            NSRangePointer range = nil;
            attributes = [attributedString attributesAtIndex:0 effectiveRange:range];
        }
        
        frame.size = CGSizeMake([title sizeWithAttributes:attributes].width, self.selectionIndicatorHeight);
        frame.origin.x = (button.frame.size.width*(self.selectedSegmentIndex))+(button.frame.size.width-frame.size.width)/2;
    }
    else {
        frame.size = CGSizeMake(button.frame.size.width, self.selectionIndicatorHeight);
        frame.origin.x = (button.frame.size.width*(self.selectedSegmentIndex));
    }
    
    return frame;
}

- (UIColor *)hairlineColor
{
    return self.hairline.backgroundColor;
}

- (CGRect)hairlineRect
{
    CGRect frame;
    if(self.showHairLine)
        frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 0.5f);
    else
        frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 0.0f);
    frame.origin.y = (self.barPosition > UIBarPositionBottom) ? 0.0f : self.frame.size.height;
    
    return frame;
}

// Calculate the most appropriate font size for a button title
- (CGFloat)appropriateFontSizeForTitle:(NSString *)title
{
    CGFloat fontSize = 14.0f;
    CGFloat minFontSize = 8.0f;
    
    if (!self.adjustsFontSizeToFitWidth) {
        return fontSize;
    }
    
    CGFloat buttonWidth = roundf(self.bounds.size.width/self.numberOfSegments);
    
    CGSize constraintSize = CGSizeMake(buttonWidth, MAXFLOAT);
    
    do {
        // Creates a new font instance with the current font size
        UIFont *font = self.titleFont;
        
        CGRect textRect = [title boundingRectWithSize:constraintSize options:0 attributes:@{NSFontAttributeName:font} context:nil];
        
        // If the new text rect's width matches the constraint width, return the font size
        if (textRect.size.width <= constraintSize.width) {
            return fontSize;
        }
        
        // Decreases the font size and tries again
        fontSize -= 1.0f;
        
    } while (fontSize > minFontSize);
    
    return fontSize;
}


#pragma mark - Setter Methods

- (void)setFrame:(CGRect)frame
{
    _width = CGRectGetWidth(frame);
    _height = CGRectGetHeight(frame);
    
    [super setFrame:frame];
    
    [self layoutIfNeeded];
}

- (void)setHeight:(CGFloat)height
{
    _height = height;
    
    [self layoutSubviews];
}

- (void)setWidth:(CGFloat)width
{
    _width = width;
    
    [self layoutSubviews];
}

- (void)setTintColor:(UIColor *)color
{
    if (!color || !self.items || self.initializing) {
        return;
    }
    
    [super setTintColor:color];
    
    [self setTitleColor:color forState:UIControlStateHighlighted];
    [self setTitleColor:color forState:UIControlStateSelected];
}

- (void)setItems:(NSArray *)items
{
    if (self.items) {
        [self removeAllSegments];
    }

    if (items) {
        _items = [NSArray arrayWithArray:items];
        _counts = [NSMutableArray arrayWithCapacity:items.count];
        
        for (int i = 0; i < items.count; i++) {
            [self.counts addObject:@0];
        }
        
        [self insertAllSegments];
    }
}

- (void)setItemsImageName:(NSArray *)itemsImageName
{
    if (self.itemsImageName) {
        _itemsImageName = nil;
    }
    
    if (itemsImageName) {
        _itemsImageName = [NSArray arrayWithArray:itemsImageName];
    }
}

- (void)setDelegate:(id<DZNSegmentedControlDelegate>)delegate
{
    _delegate = delegate;
    _barPosition = [delegate positionForBar:self];
}

- (void)setScrollOffset:(CGPoint)scrollOffset
{
    _scrollOffset = scrollOffset;
    
    self.autoAdjustSelectionIndicatorWidth = NO;
    self.bouncySelectionIndicator = NO;
    
    CGFloat offset = scrollOffset.x/self.width;
    NSUInteger index = (NSUInteger)offset;
    
    CGFloat buttonWidth = roundf(self.width/self.numberOfSegments);
    CGFloat originX = buttonWidth * offset;

    CGRect indicatorRect = self.selectionIndicator.frame;
    indicatorRect.origin.x = originX;
    self.selectionIndicator.frame = indicatorRect;
    
    if (offset == truncf(offset) && self.selectedSegmentIndex != index) {
        
        [self disableAllButtonsSelection];
        [self.buttons[index] setSelected:YES];
        
        _selectedSegmentIndex = index;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)segment
{
    if (segment > self.numberOfSegments-1) {
        segment = 0;
    }
    
    [self setSelected:YES forSegmentAtIndex:segment];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment
{
    if (!title) {
        return;
    }
    
    NSAssert(segment <= self.numberOfSegments, @"Cannot assign a title to non-existing segment.");
    NSAssert(segment >= 0, @"Cannot assign a title to a negative segment.");
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.items];
    
    if (segment >= self.numberOfSegments) {
        [items insertObject:title atIndex:self.numberOfSegments];
        [self addButtonForSegment:segment];
    }
    else {
        [items replaceObjectAtIndex:segment withObject:title];
        [self setCount:[self countForSegmentAtIndex:segment] forSegmentAtIndex:segment];
    }
    
    _items = items;
}

- (void)setImageName:(NSString *)imageName forSegmentAtIndex:(NSUInteger)segment
{
    if (!imageName) {
        return;
    }
    
    NSAssert(segment <= self.numberOfSegments, @"Cannot assign a title to non-existing segment.");
    NSAssert(segment >= 0, @"Cannot assign a title to a negative segment.");
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.items];
    
    if (segment >= self.numberOfSegments) {
        [items insertObject:imageName atIndex:self.numberOfSegments];
    }
    else {
        [items replaceObjectAtIndex:segment withObject:imageName];
    }
    
    _itemsImageName = items;
    
    [self configureSegments];
}


- (void)setCount:(NSNumber *)count forSegmentAtIndex:(NSUInteger)segment
{
    if (!count || !self.items) {
        return;
    }
    
    NSAssert(segment < self.numberOfSegments, @"Cannot assign a count to non-existing segment.");
    NSAssert(segment >= 0, @"Cannot assign a title to a negative segment.");
    
    self.counts[segment] = count;
        
    [self configureSegments];
}

- (void)setAttributedTitle:(NSAttributedString *)attributedString forSegmentAtIndex:(NSUInteger)segment
{
    UIButton *button = [self buttonAtIndex:segment];
    button.titleLabel.numberOfLines = (self.showsCount) ? 2 : 1;
    
    [button setAttributedTitle:attributedString forState:UIControlStateNormal];
    [button setAttributedTitle:attributedString forState:UIControlStateHighlighted];
    [button setAttributedTitle:attributedString forState:UIControlStateSelected];
    [button setAttributedTitle:attributedString forState:UIControlStateDisabled];
    
    [self setTitleColor:[self titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self setTitleColor:[self titleColorForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [self setTitleColor:[self titleColorForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [self setTitleColor:[self titleColorForState:UIControlStateSelected] forState:UIControlStateSelected];
    
    self.selectionIndicator.frame = [self selectionIndicatorRect];
}

- (void)setTintColor:(UIColor *)tintColor forSegmentAtIndex:(NSUInteger)segment
{
    if (!tintColor) {
        return;
    }
    
    NSAssert(segment < self.numberOfSegments, @"Cannot assign a tint color to non-existing segment.");
    NSAssert(segment >= 0, @"Cannot assign a tint color to a negative segment.");
    
    NSAssert([tintColor isKindOfClass:[UIColor class]], @"Cannot assign a tint color with an unvalid color object.");
    
    UIButton *button = [self buttonAtIndex:segment];
    button.backgroundColor = tintColor;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    NSAssert([color isKindOfClass:[UIColor class]], @"Cannot assign a title color with an unvalid color object.");
    
    for (UIButton *button in [self buttons]) {
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[button attributedTitleForState:state]];
        NSString *string = attributedString.string;
        
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        style.lineBreakMode = (self.showsCount) ? NSLineBreakByWordWrapping : NSLineBreakByTruncatingTail;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.minimumLineHeight = 20.0f;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, string.length)];
        
        if (self.showsCount) {
            
            NSArray *components = [attributedString.string componentsSeparatedByString:@"\n"];
            
            if (components.count < 2) {
                return;
            }
            
            NSString *count = [components objectAtIndex:self.inverseTitles ? 1 : 0];
            NSString *title = [components objectAtIndex:self.inverseTitles ? 0 : 1];
            
            if (state == UIControlStateNormal) {
                
                [attributedString addAttribute:NSFontAttributeName value:self.countFont range:[string rangeOfString:count]];
                [attributedString addAttribute:NSFontAttributeName value:self.titleFont range:[string rangeOfString:title]];
                
                [attributedString addAttribute:NSForegroundColorAttributeName value:_normalColor range:[string rangeOfString:count]];
                [attributedString addAttribute:NSForegroundColorAttributeName value:_normalColor range:[string rangeOfString:title]];
            }
            else {
                [attributedString addAttribute:NSFontAttributeName value:self.countFontHighlight range:[string rangeOfString:count]];
                [attributedString addAttribute:NSFontAttributeName value:self.titleFontHighlight range:[string rangeOfString:title]];
                
                
                [attributedString addAttribute:NSForegroundColorAttributeName value:_highlightColor range:[string rangeOfString:count]];
                [attributedString addAttribute:NSForegroundColorAttributeName value:_highlightColor range:[string rangeOfString:title]];
            }
        } else {
            if (state == UIControlStateNormal)
            {
                [attributedString addAttribute:NSFontAttributeName value:self.titleFont  range:NSMakeRange(0, attributedString.string.length)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:_normalColor range:NSMakeRange(0, attributedString.string.length)];
            }
            else
            {
                
                [attributedString addAttribute:NSFontAttributeName value:self.titleFontHighlight range:NSMakeRange(0, attributedString.string.length)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:_highlightColor range:NSMakeRange(0, attributedString.string.length)];
            }
            
        }
        
        [button setAttributedTitle:attributedString forState:state];
    }
    
    NSString *key = [NSString stringWithFormat:@"UIControlState%d", (int)state];
    [self.colors setObject:color forKey:key];
}

- (void)setSelected:(BOOL)selected forSegmentAtIndex:(NSUInteger)segment
{
    if (self.selectedSegmentIndex == segment || self.isTransitioning) {
        return;
    }
    
    [self disableAllButtonsSelection];
    [self enableAllButtonsInteraction:NO];
    
    CGFloat duration = (self.selectedSegmentIndex < 0.0f) ? 0.0f : self.animationDuration;
    
    _selectedSegmentIndex = segment;
    _transitioning = YES;
    
    UIButton *button = [self buttonAtIndex:segment];
    
    CGFloat damping = !self.bouncySelectionIndicator ? : 0.65f;
    CGFloat velocity = !self.bouncySelectionIndicator ? : 0.5f;

    [UIView animateWithDuration:duration
                          delay:0.0f
         usingSpringWithDamping:damping
          initialSpringVelocity:velocity
                        options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.selectionIndicator.frame = [self selectionIndicatorRect];
                     }
                     completion:^(BOOL finished) {
                         [self enableAllButtonsInteraction:YES];
                         button.userInteractionEnabled = NO;
                         _transitioning = NO;
                     }];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    button.selected = YES;
    [self setButtonImageHighlight];
}

- (void)setDisplayCount:(BOOL)count
{
    if (self.showsCount == count) {
        return;
    }
    
    _showsCount = count;
    
    for (int i = 0; i < [self buttons].count; i++) {
        [self configureButtonForSegment:i];
    }
    
    self.selectionIndicator.frame = [self selectionIndicatorRect];
}

- (void)setTitleFont :(UIFont *)titleFont
{
    if ([self.titleFont.fontName isEqualToString:titleFont.fontName]) {
        return;
    }
    
    _titleFont = titleFont;
    
    for (int i = 0; i < [self buttons].count; i++) {
        [self configureButtonForSegment:i];
    }
    
    self.selectionIndicator.frame = [self selectionIndicatorRect];
}


- (void)setCountFont :(UIFont *)countFont
{
    if ([self.countFont.fontName isEqualToString:countFont.fontName]) {
        return;
    }
    
    _countFont = countFont;
    
    for (int i = 0; i < [self buttons].count; i++) {
        [self configureButtonForSegment:i];
    }
    
    self.selectionIndicator.frame = [self selectionIndicatorRect];
}

- (void)setTitleFontHighlight :(UIFont *)titleFontHighlight
{
    if ([self.titleFontHighlight.fontName isEqualToString:titleFontHighlight.fontName]) {
        return;
    }
    
    _titleFontHighlight = titleFontHighlight;
    
    for (int i = 0; i < [self buttons].count; i++) {
        [self configureButtonForSegment:i];
    }
    
    self.selectionIndicator.frame = [self selectionIndicatorRect];
}

- (void)setCountFontHighlight :(UIFont *)countFontHighlight
{
    if ([self.countFontHighlight.fontName isEqualToString:countFontHighlight.fontName]) {
        return;
    }
    
    _countFontHighlight = countFontHighlight;
    
    for (int i = 0; i < [self buttons].count; i++) {
        [self configureButtonForSegment:i];
    }
    
    self.selectionIndicator.frame = [self selectionIndicatorRect];
}

- (void)setNormalColor:(UIColor*)normalColor
{
    _normalColor = normalColor;
    for (int i = 0; i < [self buttons].count; i++) {
        [self configureButtonForSegment:i];
    }
}

- (void)setHighlightColor:(UIColor*)highlightColor
{
    _highlightColor = highlightColor;
    for (int i = 0; i < [self buttons].count; i++) {
        [self configureButtonForSegment:i];
    }
}


- (void)setShowsGroupingSeparators:(BOOL)showsGroupingSeparators
{
    if (self.showsGroupingSeparators == showsGroupingSeparators) {
        return;
    }
    
    _showsGroupingSeparators = showsGroupingSeparators;
    
    for (int i = 0; i < [self buttons].count; i++) {
        [self configureButtonForSegment:i];
    }
    
    self.selectionIndicator.frame = [self selectionIndicatorRect];
}

- (void)setNumberFormatter:(NSNumberFormatter *)numberFormatter
{
    if ([self.numberFormatter isEqual:numberFormatter]) {
        return;
    }
    
    _numberFormatter = numberFormatter;
    
    for (int i = 0; i < [self buttons].count; i++) {
        [self configureButtonForSegment:i];
    }
    
    self.selectionIndicator.frame = [self selectionIndicatorRect];
}

- (void)setEnabled:(BOOL)enabled forSegmentAtIndex:(NSUInteger)segment
{
    UIButton *button = [self buttonAtIndex:segment];
    button.enabled = enabled;
}

- (void)setHairlineColor:(UIColor *)color
{
    if (self.initializing) {
        return;
    }
    
    self.hairline.backgroundColor = color;
}

- (void)setAdjustsButtonTopInset:(BOOL)adjustsButtonTopInset
{
    _adjustsButtonTopInset = adjustsButtonTopInset;
    
    [self layoutSubviews];
}


#pragma mark - DZNSegmentedControl Methods

- (void)insertAllSegments
{
    for (int i = 0; i < self.numberOfSegments; i++) {
        [self addButtonForSegment:i];
    }
}

- (void)addButtonForSegment:(NSUInteger)segment
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button addTarget:self action:@selector(willSelectedButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchDragOutside|UIControlEventTouchDragInside|UIControlEventTouchDragEnter|UIControlEventTouchDragExit|UIControlEventTouchCancel|UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    button.backgroundColor = nil;
    button.opaque = YES;
    button.clipsToBounds = YES;
    button.adjustsImageWhenHighlighted = NO;
    button.adjustsImageWhenDisabled = NO;
    button.exclusiveTouch = YES;
    button.tag = segment;

    [self addSubview:button];
}

- (void)configureSegments
{
    for (UIButton *button in [self buttons]) {
        [self configureButtonForSegment:button.tag];
    }
    
    self.selectionIndicator.frame = [self selectionIndicatorRect];
    if(_selectionIndicatorBackgroudColor)
    {
        self.selectionIndicator.backgroundColor = _selectionIndicatorBackgroudColor;
    }    
}

- (void)setSelectionIndicatorBackgroudColor:(UIColor*)selectionIndicatorBackgroudColor
{
    _selectionIndicatorBackgroudColor = selectionIndicatorBackgroudColor;
    self.selectionIndicator.backgroundColor = _selectionIndicatorBackgroudColor;
}

- (void)configureButtonForSegment:(NSUInteger)segment
{
    NSAssert(segment < self.numberOfSegments, @"Cannot configure a button for a non-existing segment.");
    NSAssert(segment >= 0, @"Cannot configure a button for a negative segment.");
    
    
    if(self.showsImage)
    {
        if(segment < _itemsImageName.count)
        {
            NSString* imageName = _itemsImageName[segment];
            if(imageName != nil)
            {
                UIImage* image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                [self setButtonImage:image forSegmentAtIndex:segment];
            }
        }
    }
    else
    {
        NSMutableString *title = [NSMutableString stringWithFormat:@"%@", self.items[segment]];
        
        if (self.showsCount) {
            NSNumber *count = [self countForSegmentAtIndex:segment];
            
            NSString *breakString = @"\n";
            NSString *countString;
            
            if (self.numberFormatter) {
                countString = [self.numberFormatter stringFromNumber:count];
            }
            else if (!self.numberFormatter && _showsGroupingSeparators) {
                countString = [[[self class] defaultFormatter] stringFromNumber:count];
            }
            else {
                countString = [NSString stringWithFormat:@"%@", count];
            }
            
            NSString *resultString = self.inverseTitles ? [breakString stringByAppendingString:countString] : [countString stringByAppendingString:breakString];
            
            [title insertString:resultString atIndex:self.inverseTitles ? title.length : 0];
        }
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
        [self setAttributedTitle:attributedString forSegmentAtIndex:segment];
    }
}

- (void)setButtonImage:(UIImage*)image forSegmentAtIndex:(NSUInteger)segment
{
    UIButton *button = [self buttonAtIndex:segment];
    [button setImage:image forState:UIControlStateNormal];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    [self setAttributedTitle:attributedString forSegmentAtIndex:segment];
    [self setButtonImageHighlight];
}

- (void)setButtonImageHighlight
{
    if(self.showsImage)
    {
        for(int i = 0; i < self.items.count; i++)
        {
            UIButton* button = (UIButton *)[[self buttons] objectAtIndex:i];
            if(i == _selectedSegmentIndex)
            {
                [button setTintColor:self.highlightColor];
            }
            else
            {
                [button setTintColor:self.normalColor];
            }
        }
    }
}

- (void)willSelectedButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    if (!self.isTransitioning) {
        self.selectedSegmentIndex = button.tag;
    }
}

- (void)didSelectButton:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    button.highlighted = NO;
    button.selected = YES;
}

- (void)disableAllButtonsSelection
{
    [self.buttons setValue:@NO forKey:@"selected"];
    [self.buttons setValue:@NO forKey:@"highlighted"];
}

- (void)enableAllButtonsInteraction:(BOOL)enable
{
    [self.buttons setValue:@(enable) forKey:@"userInteractionEnabled"];
}

- (void)removeAllSegments
{
    if (self.isTransitioning) {
        return;
    }
    
    // Removes all the buttons
    [[self buttons] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _items = nil;
    _counts = nil;
}

#pragma mark - Class Methods

+ (NSNumberFormatter *)defaultFormatter
{
    static NSNumberFormatter *defaultFormatter;

    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        defaultFormatter = [[NSNumberFormatter alloc] init];
        defaultFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        [defaultFormatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    });

    return defaultFormatter;
}

@end
