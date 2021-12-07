//
//  ShowImageItemCollectionViewCell.m
//  TimeClock
//
//  Created by Apple on 2019/12/24.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "ShowImageItemCollectionViewCell.h"

//#import "PhotoModel.h"
@implementation ShowImageItemCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self newView];
    }
    return self;
}
-(void)newView{
    self.headerImage = [LSHControl createImageViewWithImageName:@""];
    self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:self.headerImage];
  
    self.headerImage.clipsToBounds = YES;
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    self.delBtn = [LSHControl createButtonWithFrame:CGRectZero];
    [self.contentView addSubview:self.delBtn];
    //[UIImage imageNamed:@"ico_56"]
      [ self.delBtn setImage:[UIImage imageNamed:@"qn_btn_delete" ] forState:UIControlStateNormal];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(AutoSize(20), AutoSize(20)));
    }];
}
-(void)setCellItemWithData:(id)model{
   // [super setCellItemWithData:model];
    if ([model isKindOfClass:[UIImage class]]) {
        self.headerImage.image = model;
    }else if ([model isKindOfClass:[NSString class]]){
       // [self.headerImage setImageWithURL:[NSURL URLWithString:model] placeholder:squarePlaceholderImage];
    }
    /*else if ([model isKindOfClass:[PhotoModel class]]){
        
         [self.headerImage setImageWithURL:[NSURL URLWithString:[model img]] placeholder:squarePlaceholderImage];
    }*/
    self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
  [self.headerImage roundSize:6];
}
@end
