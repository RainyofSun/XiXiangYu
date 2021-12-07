//
//  XYBlindDateViewController.m
//  Xiangyu
//
//  Created by Kang on 2021/6/26.
//
//------made in china-------
/**   The code comes frome breakfly
 *
 *       ┏┓　　 ┏┓
 *     ┏━┛┻━━━━┛┻┓
 * 　　┃　  　━　 ┃
 * 　　┃ 　 ^    ^ ┃
 * 　　┃　　　 ┻　 ┃
 * 　　┗━━━━━━━━━┛
 *
 * --------萌萌哒-------
 */
#import "XYBlindDateViewController.h"
#import "XYBlindDateCollectionViewCell.h"
#import "XYBlindAdCollectionViewCell.h"
#import "WSLWaterFlowLayout.h"
#import "XYRefreshHeader.h"
#import "XYRefreshFooter.h"
#import "XYNormalScreeningView.h"
#import "XYLocationService.h"
#import "XYBlindDataGetListAPI.h"
#import "XYBlindProfileController.h"
#import "XYRNBaseViewController.h"

#import "XYSendHeartBeatView.h"
#import "XYWalletQueryBillAPI.h"

#import "XYProfessConfManager.h"
#import "XYGiftPaymentController.h"
#import "XYHeartBeatNumberBuyView.h"
#import "XYGeneralAPI.h"

#import "XYGetBannerListAPI.h"
#import "WebViewController.h"
#import "ChatViewController.h"
#import "XYPlatformService.h"
#import "UIScrollView+EmptyDataSet.h"

#import "XYPerfectInformationPopView.h"

@interface XYBlindDateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,WSLWaterFlowLayoutDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
  //dispatch_group_t group;
}
@property(nonatomic,strong)WSLWaterFlowLayout *flowLayout;
@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger page;

@property(nonatomic,strong)XYFriendDataReq *reqParams;

@property(nonatomic,strong)UIButton *releaseBtn;

@property(nonatomic,strong)XYProfessConfManager *manager;

@property(nonatomic,strong)NSMutableArray *bannerArray;
@end

@implementation XYBlindDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self newNav];
    [self newView];

  
   
    [self location];
}
-(void)location{
  @weakify(self);
  [[XYLocationService sharedService] requestCachedLocationWithBlock:^(XYFormattedArea *model) {
//    self.area = model; decimalNumberHandlerWithRoundingMode:NSRoundPlain
//    if (block) block(model ? YES : NO);
    @strongify(self);
    NSDecimalNumberHandler *hea = [[NSDecimalNumberHandler alloc]initWithRoundingMode:NSRoundPlain scale:6 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
   
    self.reqParams.latitude =  [[[NSDecimalNumber alloc] initWithFloat:model.latitude] decimalNumberByRoundingAccordingToBehavior:hea];
    self.reqParams.longitude= [[[NSDecimalNumber alloc] initWithFloat:model.longitude] decimalNumberByRoundingAccordingToBehavior:hea];
    self.reqParams.dwellCity = model.cityCode;
    
   // dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //self->group = dispatch_group_create();
   // dispatch_group_enter(self->group);
     // dispatch_async(queue, ^{
      
     // });
    if (!self.isMy) {
     // dispatch_group_enter(self->group);
     // dispatch_async(queue, ^{
        [self getBanner];
     // });
    }else{
      [self reshData];
    }
    
    
//    dispatch_group_notify(self->group, queue, ^{
//      if (self.bannerArray.count) {
//        [self.dataSource insertObject:self.bannerArray atIndex:1];
//        [self.collectionView reloadData];
//      }
//      });
    
  }];
}
#pragma mark - 网络请求
-(void)reshData{
  self.page = 0;
  [self getList];
  
 
}
-(void)getList{
  self.page ++;
  
  if (self.isMy) {
    //
    XYBlindDataGetMyListAPI *api = [[XYBlindDataGetMyListAPI alloc]initWithData:[self.reqParams yy_modelToJSONObject] page:self.page];
    @weakify(self);
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
      //XYHiddenLoading;
      @strongify(self);
      [self.collectionView.mj_header endRefreshing];
      [self.collectionView.mj_footer endRefreshing];
      if (self.page == 1) {
        [self.dataSource removeAllObjects];
      }
      XYBlindDataItemListModel *model = [XYBlindDataItemListModel yy_modelWithJSON:data];
      if (model.list.count) {
        [self.dataSource addObjectsFromArray:model.list];
      }
      [self.collectionView reloadData];
      //dispatch_group_leave(self->group);
    };
    [api start];
  }else{
    XYBlindDataGetListAPI *api = [[XYBlindDataGetListAPI alloc]initWithData:[self.reqParams yy_modelToJSONObject] page:self.page];
    @weakify(self);
    api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
      //XYHiddenLoading;
      @strongify(self);
     
      [self.collectionView.mj_header endRefreshing];
      [self.collectionView.mj_footer endRefreshing];
      if (self.page == 1) {
        [self.dataSource removeAllObjects];
      }
      XYBlindDataItemListModel *model = [XYBlindDataItemListModel yy_modelWithJSON:data];
      if (model.list.count) {
        [self.dataSource addObjectsFromArray:model.list];
      }
      if (self.page == 1 && self.bannerArray) {
        if (self.dataSource.count) {
          [self.dataSource insertObject:self.bannerArray atIndex:1];
        }else{
         // [self.dataSource insertObject:self.bannerArray atIndex:0];
        }
           
      }
      [self.collectionView reloadData];
      //dispatch_group_leave(self->group);
    };
    [api start];
  }
}
-(void)getBanner{
  XYGetBannerListAPI *api = [[XYGetBannerListAPI alloc]initWithshowType:@(3)];
  api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
    NSArray *array =data;
    [self.bannerArray removeAllObjects];
    
    for (int i= 0;i< array.count; i++) {
      NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:array[i]];
     [dic setValue:self forKey:@"router"];
      [self.bannerArray addObject:dic];
    }
    
  
  //  dispatch_group_leave(self->group);
    [self reshData];
  };
  [api start];
}


#pragma mark - 界面布局
-(void)newView{
  self.collectionView = [LSHControl createCollectionViewFromFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT) collectionViewLayout:self.flowLayout dataSource:self delegate:self];
  self.collectionView.emptyDataSetSource = self;
  self.collectionView.emptyDataSetDelegate = self;
  self.view.backgroundColor = ColorHex(XYTextColor_FFFFFF);
  self.collectionView.backgroundColor = [UIColor whiteColor];
  [self.collectionView registerClass:NSClassFromString(@"XYBlindDateCollectionViewCell") forCellWithReuseIdentifier:@"XYBlindDateCollectionViewCell"];
  [self.collectionView registerClass:NSClassFromString(@"XYBlindAdCollectionViewCell") forCellWithReuseIdentifier:@"XYBlindAdCollectionViewCell"];
  [self.view addSubview:self.collectionView];
  @weakify(self);
  self.collectionView.mj_header = [XYRefreshHeader headerWithRefreshingBlock:^{
      @strongify(self);
    [self reshData];
  }];
  self.collectionView.mj_footer = [XYRefreshFooter footerWithRefreshingBlock:^{
    @strongify(self);
    [self getList];
  }];
  
  
  [self.view addSubview:self.releaseBtn];
  [self.releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    make.trailing.equalTo(self.view).offset(-AutoSize(16));
    make.bottom.equalTo(self.view).offset(-AutoSize(30)-GK_SAFEAREA_BTM);
    make.width.height.mas_equalTo(AutoSize(58));
  }];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  id obj = [self.dataSource objectAtIndex:indexPath.item];
  if ([obj isKindOfClass:[XYBlindDataItemModel class]]) {
    XYBlindDataItemModel *model = obj;
    XYBlindDateCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"XYBlindDateCollectionViewCell" forIndexPath:indexPath];
    cell.model = model;
    [cell.beatView handleControlEventWithBlock:^(id sender) {
      [self sendHeartBeat:model];
    }];
    return cell;
  }else{
    
    XYHomeBaseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYBlindAdCollectionViewCell" forIndexPath:indexPath];
    cell.item = obj;
    return cell;
    
//    XYBlindAdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"XYBlindAdCollectionViewCell" forIndexPath:indexPath];
//    [cell setItem:obj];
//    return cell;
  }

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  XYBlindDataItemModel *model =  [self.dataSource objectAtIndex:indexPath.item];
  XYBlindProfileController *vc = [[XYBlindProfileController alloc] init];
  vc.blindId = model.id;
  vc.userId = model.userId;
  [self cyl_pushViewController:vc animated:YES];
}




-(void)sendHeartBeat:(XYBlindDataItemModel*)model{
  @weakify(self);
  [[XYPlatformService shareService] fetchOnlineSwitchWithBlock:^(BOOL status) {
    if (!status) {
      
      [self.manager releaseProfessConfWithBlock:^(XYError * _Nonnull error) {
        if (!error) {
            XYSendHeartBeatView *VC = [[XYSendHeartBeatView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            VC.texts =self.manager.texts;
            VC.conf = self.manager.conf;
            VC.heartNum = self.manager.superHeartCount;
            VC.model = model;
            VC.block = ^(XYError * _Nonnull error) {
              
              UIAlertController *actionVC=[UIAlertController alertControllerWithTitle:@"发送成功" message:@"对方已收到你的心动表白，是否开始和TA畅聊？" preferredStyle:UIAlertControllerStyleAlert];
              
              UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再看看" style:UIAlertActionStyleCancel handler:nil];
              UIAlertAction *chatAction = [UIAlertAction actionWithTitle:@"去聊天" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
                data.conversationID = [NSString stringWithFormat:@"c2c_%@",model.userId];
                data.userID = model.userId.stringValue;
                data.title = model.nickName;
                ChatViewController *chat = [[ChatViewController alloc] init];
                chat.conversationData = data;
                [self cyl_pushViewController:chat animated:YES];
              }];
              [chatAction setValue:ColorHex(@"#F92B5E") forKey:@"titleTextColor"];
              [actionVC addAction:chatAction];
             [actionVC addAction:cancelAction];
              [weak_self presentViewController:actionVC animated:YES completion:nil];
            };
            [VC show];
    //      }
          
     
        }else{
          
        }
        
      }];
    }else{
      TUIConversationCellData *data = [[TUIConversationCellData alloc] init];
      data.conversationID = [NSString stringWithFormat:@"c2c_%@",model.userId];
      data.userID = model.userId.stringValue;
      data.title = model.nickName;
      ChatViewController *chat = [[ChatViewController alloc] init];
      chat.conversationData = data;
      [self cyl_pushViewController:chat animated:YES];
    }
      
    }];
  
  
  
  
  
   
 // };
 // [api start];
  
  
  
  
 
  
  
}
-(CGFloat)columnCountInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return 2;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return AutoSize(15);
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
  return AutoSize(10);
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout{
    return UIEdgeInsetsMake(AutoSize(4), AutoSize(16), AutoSize(4), AutoSize(16));
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  id obj = [self.dataSource objectAtIndex:indexPath.item];
  if ([obj isKindOfClass:[XYBlindDataItemModel class]]){
    return CGSizeMake(AutoSize(164), AutoSize(270));
  }
  
  return CGSizeMake(AutoSize(164), AutoSize(140));
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (CGSize)waterFlowLayout:(WSLWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section {
    return CGSizeMake(0, 0);
}
- (void)didClickCycleScrollViewWithParam:(NSDictionary *)param {

  NSNumber *skipType = param[@"skipType"];
  if (![skipType toSafeValueOfClass:[NSNumber class]]) return;
  
  NSString *buParam = param[XYHome_JumpLink];
  if (skipType.integerValue == 1) {
    WebViewController *web = [[WebViewController alloc] init];
    web.urlStr = buParam;
    [self cyl_pushViewController:web animated:YES];
  } else if (skipType.integerValue == 2) {
    TUIConversationCellData *conversationData = [[TUIConversationCellData alloc] init];
    conversationData.groupID = buParam;
    ChatViewController *chat = [[ChatViewController alloc] init];
    chat.conversationData = conversationData;
    [self cyl_pushViewController:chat animated:YES];
  }
}

//-(UICollectionViewCell *)coll


-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"暂无数据";

    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: AdaptedFont(14),
                                 NSForegroundColorAttributeName:ColorHex(XYTextColor_666666),
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

-(XYFriendDataReq *)reqParams{
  if (!_reqParams) {
    _reqParams = [[XYFriendDataReq alloc]init];
   _reqParams.province = [[XYUserService service] fetchLoginUser].province;
    _reqParams.city = [[XYUserService service] fetchLoginUser].city;
  //  _reqParams.area = [[XYUserService service] fetchLoginUser].area;
  }
  return _reqParams;
}
-(NSMutableArray *)dataSource{
  if (!_dataSource) {
    _dataSource = [NSMutableArray new];
  }
  return _dataSource;
}
-(WSLWaterFlowLayout *)flowLayout{
    if (!_flowLayout) {
        _flowLayout = [[WSLWaterFlowLayout alloc] init];
        _flowLayout.delegate=self;
        _flowLayout.flowLayoutStyle = WSLWaterFlowVerticalEqualWidth;
    }
    return _flowLayout;
}
-(UIButton *)releaseBtn{
  if (!_releaseBtn) {
    _releaseBtn = [LSHControl createButtonWithFrame:CGRectMake(0, 0, AutoSize(80), AutoSize(80)) buttonImage:@"icon_58_fabuxiangqin"];
    [_releaseBtn handleControlEventWithBlock:^(id sender) {
      
    
      
      
      
      
//
      XYShowLoading;
      [[XYUserService service] getUserInfoWithUserId:[XYUserService service].fetchLoginUser.userId block:^(BOOL success, NSDictionary *info) {
        XYHiddenLoading;
        XYPerfectProfileModel *model = [XYPerfectProfileModel yy_modelWithJSON:info];
        if (model.birthdate && model.birthdate.length>0 && model.oneIndustry && model.twoIndustry && model.twoIndustry.length>1 && model.height && model.intentionDate  && [model.height integerValue]>1 && [model.intentionDate length]>0) {
          
          NSString *method = @"api/v1/BlindDate/IsAllowRelease";
          XYGeneralAPI *api = [[XYGeneralAPI alloc] initWithRequestMethod:method];
          api.apiRequestMethodType = XYRequestMethodTypePOST;
          api.requestParameters = @{@"userId":[XYUserService service].fetchLoginUser.userId?:@(0)};
          api.filterCompletionHandler = ^(id  _Nullable data, XYError * _Nullable error) {
            if ( [data integerValue] == 0) {
              XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"BlindDateReleaseTwo"}];
              [self cyl_pushViewController:vc animated:YES];
            }else{
              XYToastText(error.msg.length?error.msg:@"已存在您的相亲需求。请先前往“个人中心->我的发布”删除后发布。");
            }
         
          };
          [api start];
          
          
        }else{
          XYPerfectInformationPopView *popV = [[XYPerfectInformationPopView alloc]initWithFrame:CGRectMake(AutoSize(52), (SCREEN_HEIGHT-AutoSize(314))/2.0, SCREEN_WIDTH-AutoSize(105), AutoSize(314))];
          popV.successBlock = ^(id  _Nonnull item) {
            XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"UserInfo"}];
            [self cyl_pushViewController:vc animated:YES];
          };
          [popV show];
        }
        
        
        
        
//         if ([[info objectForKey:@"status"] integerValue]!=2) {
//
//
//           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未实名认证" preferredStyle:UIAlertControllerStyleAlert];
//                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//                    [alert addAction:[UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                      XYRNBaseViewController *vc = [[XYRNBaseViewController alloc] initWithPageName:@"Xiangyu" initialProperty:@{@"page" : @"Auth"}];
//                      [self cyl_pushViewController:vc animated:YES];
//                      //resolve(@{@"type":@"2"});
//                    }]];
//                        // 弹出对话框
//                        [self  presentViewController:alert animated:true completion:nil];
//
//           UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还未完善资料" preferredStyle:UIAlertControllerStyleAlert];
//           [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
//           [alert addAction:[UIAlertAction actionWithTitle:@"去完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//             resolve(@{@"type":@"2"});
//           }]];
               // 弹出对话框
//               [[weakSelf getCurrentVC] presentViewController:alert animated:true completion:nil];
       //  }else {
//           resolve(@{@"type":@"1"});
           
          
       //  }
     }];
      
     
    }];
  }
  return _releaseBtn;
}
#pragma mark - 导航
-(void)newNav{
  self.gk_navTitle = @"相亲";
  UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
  [moreButton setImage:[UIImage imageNamed:@"icon_22_xiangqinsx"] forState:UIControlStateNormal];
  [moreButton addTarget:self action:@selector(rightBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
  self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:moreButton];
  //
  //BlindDateRelease
}
-(void)rightBarButtonClick{
  XYNormalScreeningView *view = [[XYNormalScreeningView alloc]initWithFrame:CGRectMake(AutoSize(75), 0, SCREEN_WIDTH-AutoSize(75), SCREEN_HEIGHT)];
  view.reqParams = self.reqParams;
  @weakify(self);
  view.selectedBlock = ^(NSDictionary * _Nonnull item) {
    @strongify(self);
    [self reshData];
  };
  [view show];
}
-(XYProfessConfManager *)manager{
  if (!_manager) {
    _manager = [[XYProfessConfManager alloc] init];
  }
  return _manager;
}
-(NSMutableArray *)bannerArray{
  if (!_bannerArray) {
    _bannerArray = [NSMutableArray array];
  }
  return _bannerArray;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
