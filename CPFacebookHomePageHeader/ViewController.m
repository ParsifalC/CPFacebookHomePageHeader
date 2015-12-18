//
//  ViewController.m
//  CPFacebookHomePageHeader
//
//  Created by Parsifal on 15/12/18.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "CPFacebookHomePageHeader.h"

@interface ViewController ()<kHeaderProtocol>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CPFacebookHomePageHeader *header = [CPFacebookHomePageHeader new];
    header.delegate = self;
    [self.view addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.and.right.mas_equalTo(self.view);
        make.height.mas_equalTo(header.mas_width);
    }];
    
    NSMutableArray *images = @[].mutableCopy;
    for (int i = 1; i < 5; i++) {
        NSString *imageName = [NSString stringWithFormat:@"image%@.jpeg", @(i)];
        [images addObject:[UIImage imageNamed:imageName]];
    }
    header.images = images;
}

#pragma mark - kHeaderProtocol methods
- (void)itemTapped:(NSInteger)index
{
    NSLog(@"item index:%@ tapped!", @(index));
}
@end
