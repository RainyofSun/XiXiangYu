//
//  XYDynamicsCell.h
//  Xiangyu
//
//  Created by dimon on 08/02/2021.
//

#import <UIKit/UIKit.h>
#import "XYDynamicLayout.h"
#import "XYPhotoContainerView.h"
#import "XYDefaultButton.h"
#import "XYHotTopicView.h"
@class XYDynamicsCell;
@protocol XYDynamicsCellDelegate <NSObject>
@optional
/**
 点击了用户头像或名称

 @param userId 用户ID
 */
- (void)DynamicsCell:(XYDynamicsCell *)cell didClickUser:(NSString *)userId;

/**
 点击了内容

 */
- (void)DidClickTextInDynamicsCell:(XYDynamicsCell *)cell;

/**
 点击了全文/收回

 */
- (void)DidClickMoreLessInDynamicsCell:(XYDynamicsCell *)cell;

/**
 关注

 */
- (void)DidClickAttentionInDynamicsCell:(XYDynamicsCell *)cell;

/**
 取消关注

 */
- (void)DidClickCancelAttentionInDynamicsCell:(XYDynamicsCell *)cell;

/**
 点赞

 */
- (void)DidClickThunmbInDynamicsCell:(XYDynamicsCell *)cell;

/**
 取消点赞

 */
- (void)DidClickCancelThunmbInDynamicsCell:(XYDynamicsCell *)cell;

/**
 评论

 */
- (void)DidClickCommentInDynamicsCell:(XYDynamicsCell *)cell;

/**
 点击了图片或者视频

 */
- (void)DidClickImageOrVideoInDynamicsCell:(XYDynamicsCell *)cell;

/**
 点击电话或者url

 */
- (void)DynamicsCell:(XYDynamicsCell *)cell didClickUrl:(NSString *)url PhoneNum:(NSString *)phoneNum;

/**
 删除

 */
- (void)DidClickDeleteInDynamicsCell:(XYDynamicsCell *)cell;

/**
 点击话题
 */
- (void)DidClickTopicInDynamicsCell:(XYDynamicsCell *)cell;
@end

@interface XYDynamicsCell : UITableViewCell

@property(nonatomic,strong)XYDynamicLayout * layout;

@property(nonatomic,strong)UIImageView * portrait;

@property(nonatomic,strong)YYLabel * nameLabel;

//@property(nonatomic,strong)YYLabel * ageLabel;

@property(nonatomic,strong)UIImageView * sexView;

@property(nonatomic,strong)XYDefaultButton * attentionBtn;

@property(nonatomic,strong)YYLabel * locationLabel;

@property(nonatomic,strong)YYLabel * hometownLable;

@property(nonatomic,strong)YYLabel * detailLabel;

@property(nonatomic,strong)UIButton * moreLessDetailBtn;

@property(nonatomic,strong)XYPhotoContainerView *picContainerView;

@property(nonatomic,strong)YYLabel * topicLabel;

@property(nonatomic,strong)YYLabel * dateLabel;

@property(nonatomic,strong)YYLabel * likeBtn;

@property(nonatomic,strong)YYLabel * evaluateBtn;

@property(nonatomic,strong)UIView * dividingLine;

@property(nonatomic,assign)id<XYDynamicsCellDelegate>delegate;

@end
