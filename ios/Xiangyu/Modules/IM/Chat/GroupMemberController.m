//
//  GroupMemberController.m
//  TUIKitDemo
//
//  Created by kennethmiao on 2018/10/18.
//  Copyright © 2018年 Tencent. All rights reserved.
//
/** 腾讯云IM Demo 群成员管理视图
 *  本文件实现了群成员管理视图，在管理员进行群内人员管理时提供UI
 *
 *  本类依赖于腾讯云 TUIKit和IMSDK 实现
 *
 */
#import "GroupMemberController.h"
#import "TUIGroupMemberController.h"
#import "TUIContactSelectController.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "Toast/Toast.h"
#import "THelper.h"
#import <ImSDK/ImSDK.h>

@interface GroupMemberController () <TGroupMemberControllerDelegagte>

@property (nonatomic, weak) TUIGroupMemberController *members;

@end

@implementation GroupMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setupNavigator];
  
    TUIGroupMemberController *members = [[TUIGroupMemberController alloc] init];
    self.members = members;
    members.groupId = _groupId;
    members.delegate = self;
    members.view.frame = self.view.bounds;
    [self addChildViewController:members];
    [self.view addSubview:members.view];
}

- (void)setupNavigator {
  self.gk_navTitle = @"详细资料";
  self.gk_navLineHidden = YES;
  self.gk_navigationBar.layer.shadowColor = ColorHex(XYThemeColor_D).CGColor;
  self.gk_navigationBar.layer.shadowOffset = CGSizeMake(0, 1);
  self.gk_navigationBar.layer.shadowOpacity = 0.06;
  self.gk_navigationBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectInset(self.gk_navigationBar.bounds, -5, -5)].CGPath;
  
  UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [leftBtn setImage:[UIImage imageNamed:@"icon_arrow_back_22"] forState:UIControlStateNormal];
  [leftBtn addTarget:self action:@selector(leftBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
  self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
  
  UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [rightBtn setTitle:@"管理" forState:UIControlStateNormal];
  [rightBtn setTitleColor:ColorHex(XYTextColor_222222) forState:UIControlStateNormal];
  rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
  [rightBtn addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (void)leftBarButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)groupMemberController:(TUIGroupMemberController *)controller didAddMembersInGroup:(NSString *)groupId hasMembers:(NSMutableArray *)members {
    TUIContactSelectController *vc = [[TUIContactSelectController alloc] initWithNibName:nil bundle:nil];
    vc.title = @"添加联系人";
    vc.viewModel.disableFilter = ^BOOL(TCommonContactSelectCellData *data) {
        for (TGroupMemberCellData *cd in members) {
            if ([cd.identifier isEqualToString:data.identifier])
                return YES;
        }
        return NO;
    };
    @weakify(self)
    [self.navigationController pushViewController:vc animated:YES];
    vc.finishBlock = ^(NSArray<TCommonContactSelectCellData *> *selectArray) {
        @strongify(self)
        NSMutableArray *list = @[].mutableCopy;
        for (TCommonContactSelectCellData *data in selectArray) {
            [list addObject:data.identifier];
        }
        [self.navigationController popToViewController:self animated:YES];
        [self addGroupId:groupId memebers:list controller:controller];
    };
}

- (void)groupMemberController:(TUIGroupMemberController *)controller didDeleteMembersInGroup:(NSString *)groupId hasMembers:(NSMutableArray *)members {
    TUIContactSelectController *vc = [[TUIContactSelectController alloc] initWithNibName:nil bundle:nil];
    vc.title = @"删除联系人";
    vc.viewModel.avaliableFilter = ^BOOL(TCommonContactSelectCellData *data) {
        for (TGroupMemberCellData *cd in members) {
            if ([cd.identifier isEqualToString:data.identifier])
                return YES;
        }
        return NO;
    };
    @weakify(self)
    [self.navigationController pushViewController:vc animated:YES];
    vc.finishBlock = ^(NSArray<TCommonContactSelectCellData *> *selectArray) {
        @strongify(self)
        NSMutableArray *list = @[].mutableCopy;
        for (TCommonContactSelectCellData *data in selectArray) {
            [list addObject:data.identifier];
        }
        [self.navigationController popToViewController:self animated:YES];
        [self deleteGroupId:groupId memebers:list controller:controller];
    };
}

- (void)addGroupId:(NSString *)groupId memebers:(NSArray *)members controller:(TUIGroupMemberController *)controller {
    [[V2TIMManager sharedInstance] inviteUserToGroup:_groupId userList:members succ:^(NSArray<V2TIMGroupMemberOperationResult *> *resultList) {
        [THelper makeToast:@"添加成功"];
        [controller updateData];
    } fail:^(int code, NSString *desc) {
        [THelper makeToastError:code msg:desc];
    }];
}

- (void)deleteGroupId:(NSString *)groupId memebers:(NSArray *)members controller:(TUIGroupMemberController *)controller {
    [[V2TIMManager sharedInstance] kickGroupMember:groupId memberList:members reason:@"" succ:^(NSArray<V2TIMGroupMemberOperationResult *> *resultList) {
        [THelper makeToast:@"删除成功"];
        [controller updateData];
    } fail:^(int code, NSString *desc) {
        [THelper makeToastError:code msg:desc];
    }];
}

- (void)rightBarButtonClick {
    
  [self.members rightBarButtonClick];
  
}
@end
