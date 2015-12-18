//
//  CPFacebookHomePageHeader.m
//  CPFacebookHomePageHeader
//
//  Created by Parsifal on 15/12/18.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import "CPFacebookHomePageHeader.h"
#import <Masonry.h>

@interface CPFacebookHomePageHeader ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) NSMutableArray *holderButtons;
@property (strong, nonatomic) UIButton *uploadButton;
@property (strong, nonatomic) UIView *bgView;
@end

@implementation CPFacebookHomePageHeader
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setImages:(NSArray *)images
{
    if (_images.count == images.count && images.count != 0) {
        _images = images;
        return;
    }
    
    _images = images;
    
    for (UIView *subview in self.containerView.subviews) {
        [subview removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    
    UIButton *lastHolderButton = nil;
    for (int i = 0; i <= images.count; i++) {
        UIButton *button = [self createHolderButton];
        button.tag = i;
        [self.containerView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.scrollView.mas_width);
            make.height.mas_equalTo(self.scrollView.mas_height);
            make.top.mas_equalTo(self.containerView);
            if (lastHolderButton) {
                make.left.mas_equalTo(lastHolderButton.mas_right);
            } else {
                make.left.mas_equalTo(self.containerView);
            }
        }];
        
        if (i < images.count) {
            UIImageView *imageView = [self imageViewWithImage:self.images[i]];
            [self.containerView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(button);
                make.top.and.left.mas_equalTo(button);
            }];
            [self.imageViews addObject:imageView];
            [self.holderButtons addObject:button];
        } else {
            UIView *bgView = [UIView new];
            bgView.backgroundColor = [UIColor clearColor];
            [self.containerView insertSubview:bgView belowSubview:button];
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.and.height.mas_equalTo(button);
                make.top.and.left.mas_equalTo(button);
            }];
            self.bgView = bgView;
            self.uploadButton = button;
            [self.uploadButton setTitle:@"上传更多" forState:UIControlStateNormal];
            [self.uploadButton setTitleColor:[UIColor whiteColor]
                                    forState:UIControlStateNormal];
        }
        
        [self.containerView bringSubviewToFront:button];
        lastHolderButton = button;
    }
    
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.uploadButton.mas_right);
    }];
}

- (void)holderButtonTapped:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(itemTapped:)]) {
        [self.delegate itemTapped:sender.tag];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIImageView *lastImageView = self.imageViews.lastObject;
    UIImageView *firstImageView = self.imageViews.firstObject;
    UIButton *lastHolderButton = self.holderButtons.lastObject;
    UIButton *firstHolderButton = self.holderButtons.firstObject;
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat positionX = CGRectGetWidth(lastImageView.bounds)*MAX(0, (self.images.count-1));
    if (lastImageView && offsetX >= positionX) {
        [lastImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lastHolderButton).with.offset(offsetX - positionX);
        }];
        
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.uploadButton).with.offset(MAX(0, offsetX - positionX - CGRectGetWidth(lastImageView.bounds)));
        }];
        UIColor *bgColor = [UIColor colorWithWhite:0 alpha:(offsetX - positionX)/CGRectGetWidth(lastImageView.bounds)*0.6];
        self.bgView.backgroundColor = bgColor;
        lastHolderButton.backgroundColor = bgColor;
    } else if (offsetX<=0) {
//        [firstImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(firstHolderButton.mas_left).with.offset(offsetX);
//        }];
    } else if (offsetX - CGRectGetMinX(lastImageView.frame)) {
        [lastImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(lastHolderButton);
        }];
    }
}

- (UIImageView *)imageViewWithImage:(UIImage *)image
{
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.image = image;
    return imageView;
}

- (NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = @[].mutableCopy;
    }
    return _imageViews;
}

- (NSMutableArray *)holderButtons
{
    if (!_holderButtons) {
        _holderButtons = @[].mutableCopy;
    }
    return _holderButtons;
}

- (UIButton *)createHolderButton
{
    UIButton *holderButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [holderButton setBackgroundColor:[UIColor clearColor]];
    [holderButton setTitleColor:[UIColor blackColor]
                       forState:UIControlStateNormal];
    [holderButton addTarget:self
                     action:@selector(holderButtonTapped:)
           forControlEvents:UIControlEventTouchUpInside];
    return holderButton;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor lightGrayColor];
        
        _containerView = [UIView new];
        [_scrollView addSubview:_containerView];
        [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_scrollView);
            make.height.mas_equalTo(_scrollView.mas_height).with.priority(250);
        }];
    }
    return _scrollView;
}
@end
