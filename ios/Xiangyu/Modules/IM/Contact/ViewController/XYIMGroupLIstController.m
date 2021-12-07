//
//  XYIMGroupLIstController.m
//  Xiangyu
//
//  Created by dimon on 29/01/2021.
//

#import "XYIMGroupLIstController.h"
#import "TUIGroupConversationListController.h"
#import "ChatViewController.h"

@interface XYIMGroupLIstController ()

@end

@implementation XYIMGroupLIstController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupNavBar];
  
  self.view.backgroundColor = ColorHex(XYThemeColor_B);
  TUIGroupConversationListController *conv = [[TUIGroupConversationListController alloc] init];
  conv.tableView.delaysContentTouches = NO;
  [self addChildViewController:conv];
  conv.view.frame = CGRectMake(0, NAVBAR_HEIGHT, self.view.XY_width, self.view.XY_height - NAVBAR_HEIGHT);
  [self.view addSubview:conv.view];

}

- (void)setupNavBar {
  self.gk_navTitle = @"群聊";
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
}

- (void)didSelectConversation:(TCommonContactCell *)cell {
  TUIConversationCellData *conversationData = [[TUIConversationCellData alloc] init];
  conversationData.groupID = cell.contactData.identifier;
  ChatViewController *chat = [[ChatViewController alloc] init];
  chat.conversationData = conversationData;
  [self cyl_pushViewController:chat animated:YES];
}


@end
