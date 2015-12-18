//
//  CPFacebookHomePageHeader.h
//  CPFacebookHomePageHeader
//
//  Created by Parsifal on 15/12/18.
//  Copyright © 2015年 Parsifal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol kHeaderProtocol <NSObject>
- (void)itemTapped:(NSInteger)index;
@end

@interface CPFacebookHomePageHeader : UIView
@property (strong, nonatomic) NSArray *images;
@property (weak, nonatomic) id<kHeaderProtocol> delegate;
@end
