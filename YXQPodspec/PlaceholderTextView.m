//
//  PlaceholderTextView.m
//  YouGouApp
//
//  Created by iyan on 2017/9/4.
//  Copyright © 2017年 iyan. All rights reserved.
//

#import "PlaceholderTextView.h"
#import "UIView+Extension.h"
#import "UIColor+Hex.h"

@interface PlaceholderTextView ()
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation PlaceholderTextView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.font = [UIFont systemFontOfSize:14];
        
        UILabel *placehoderLabel = [[UILabel alloc] init];
        placehoderLabel.numberOfLines = 0;
        placehoderLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:placehoderLabel];
        self.placeholderLabel = placehoderLabel;
        self.placeholderColor = [UIColor hexColor:@"#999999"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewOnClick)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)textViewOnClick {
    [self becomeFirstResponder];
}

- (void)textDidChange {
    self.placeholderLabel.hidden = self.hasText;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self textDidChange];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self setNeedsLayout];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = placeholderColor;
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.placeholderLabel.top = 8;
    self.placeholderLabel.left = 5;
    self.placeholderLabel.width = self.width - 2 * self.placeholderLabel.left;
    
    NSDictionary *dict = @{NSFontAttributeName: self.placeholderLabel.font};
    CGSize maxSize = CGSizeMake(self.placeholderLabel.width, MAXFLOAT);
    CGSize textSize = [self.placeholder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    self.placeholderLabel.height = textSize.height;
}

@end
