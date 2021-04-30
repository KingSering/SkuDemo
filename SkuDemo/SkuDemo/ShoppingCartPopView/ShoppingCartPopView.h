//
//  ShoppingCartPopView.h
//  DengTeng
//
//  Created by 刘大维 on 2020/12/4.
//  Copyright © 2020 刘大维. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark+++++++++++  SpecsModel  +++++++
@interface SpecsModel :NSObject
/**
 *规格类名
 */
@property(nonatomic,copy)NSString*specsName;
/**
 *当前规格类规格明细列表--规格名称
 */
@property(nonatomic,strong)NSArray*specsList;
/**
 *当前规格类规格商品图片明细列表--规格名称对应的商品图片
 */
@property(nonatomic,strong)NSArray*specsImgList;
/**
 *当前规格类规格明细列表--元数据
 */
@property(nonatomic,strong)NSArray*specsListData;
/**
 *已选中的规格的下标
 */
@property(nonatomic,assign)NSInteger selectSpecsIndex;

@end
 
#pragma mark+++++++++++  ShoppingCartPopView  +++++++
//确定按钮回调
typedef void(^ShoppingCartPopViewBlock)(NSArray* data);
//选规格回调 skuItemIds 规格选项id数组,用英文逗号隔开
typedef void(^ShoppingCartPopViewSkuBlock)(NSString* skuItemIds);

@interface ShoppingCartPopView : UIView
/**
 确定回调
 */
@property(nonatomic,copy)ShoppingCartPopViewBlock shoppingCartPopViewBlock;
/**
    sku选择齐全回调
 */
@property(nonatomic,copy)ShoppingCartPopViewSkuBlock shoppingCartPopViewSkuBlock;
/**
  默认勾选一个规格
 */
-(void)selectFirst;
/**
  默认勾选一个系列的规格
 */
-(void)selectFirst2;
/**
 *半透明层
 */
@property (weak, nonatomic) IBOutlet UIView *backView;

/**
 *商品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (copy, nonatomic)   NSString *goodsImgValue;
@property (copy, nonatomic)   NSString *deftGoodsImgValue;

/**
 *更新商品图片
 */
-(void)upGoodsImg:(NSString*)value;
/**
 *商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLb;
@property (copy, nonatomic)   NSString *goodsTitleValue;

/**
 *商品价格
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;
@property (copy, nonatomic)   NSString *goodsPriceValue;
/**
 *更新商品价格
 */
-(void)upPrice:(NSString*)value;
/**
 *商品库存UILabel
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsStoreCountLb;
/**
 *更新商品库存
 */
-(void)upGoodsStoreCount:(NSString*)value;
/**
 *商品库存数量
 */
@property(nonatomic,assign)NSInteger goodsStore;
/**
 *规格列表
 */
@property (strong, nonatomic) IBOutlet UICollectionView *baseCollect;

/**
 *取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/**
 *确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
/**
 *商品购买数量输入框
 */
@property (weak, nonatomic) IBOutlet UITextField *buyCountTextField;
/**
 *商品购买数量添加按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buyCountAddBtn;
/**
 *商品购买数量减少按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *buyCountCancelBtn;
@property (weak, nonatomic) IBOutlet UIView *buyCountView;
@property (weak, nonatomic) IBOutlet UILabel *buyCountTipLb;
/**
 *商品购买数量
 */
@property(nonatomic,assign)NSInteger buyCount;
/**
 *更新购买的商品数量
 */
-(void)upBuyGoodsCount:(NSInteger)value;
 
/**
 类型：0-登腾币商品，1-积分商品，2-赠品 ( 限购一件 无价格显示)
 */
@property(nonatomic,copy)NSString* coinType;

#pragma mark++++++++  alertView +++++++++
+(instancetype)showAlert;
/**
 *商品规格数组<SpecsModel*>*
 */
@property (nonatomic,strong) NSMutableArray<SpecsModel*>*data;

/**
 *临时数组
 */
@property(nonatomic,strong)NSMutableArray*skuTemArr;
/**
 *所有规格sku图片 二维数组
 *[[34.png,35.png],[61.png,62.png],[66.png,67.png],[68.png,70.png]]
 */
@property(nonatomic,strong)NSArray*skuImgListArr;
/**
 *所有规格sku 二维数组
 *[[34,35],[61,62],[66,67],[68,70]]
 */
@property(nonatomic,strong)NSArray*skuListArr;
/**
 *所有规格sku组合情况
 *a= [
 34;61;66;68,
 34;61;66;70,
 34;61;67;68,
 34;61;67;70,
 34;62;66;68,
 34;62;66;70,]
 */
@property(nonatomic,strong)NSArray*skuArr;
/**
 *所有有库存规格sku组合情况
 *a= [
 34;61;66;68,
 34;61;66;70,
 34;61;67;68,]
 */
@property(nonatomic,strong)NSArray*storeSkuArr;
/**
 *所有可选规格sku ID 集合[34,35,61,62,68,70...]
 */
@property(nonatomic,strong)NSArray*storeSkuNeedClickArr;
/**
 *计算sku组合情况 --用于刷新可选sku
 */
-(void)calculateSku;
/*
  @param  sku二维数组 排列组合 [[34,35],[61,62],[66,67],[68,70]]
   result  获取所有sku组合 a= [
 34;61;66;68,
 34;61;66;70,
 34;61;67;68,
 34;61;67;70,
 34;62;66;68,
 34;62;66;70,]
 */
-(NSArray*)zheheArr:(NSMutableArray*)array;
//多数组元素组合排列
- (NSMutableArray *)mergeArray:(NSMutableArray *)array;



@end

 
