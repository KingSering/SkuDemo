//
//  ShoppingCartPopView.m
//  DengTeng
//
//  Created by 刘大维 on 2020/12/4.
//  Copyright © 2020 刘大维. All rights reserved.
//

#import "ShoppingCartPopView.h"

//
 

#pragma mark+++++++++++  SpecsModel  +++++++
@implementation SpecsModel

@end;
#pragma mark+++++++++++  ShoppingCartPopView  +++++++

static NSString *const cellId = @"cellId";
@interface ShoppingCartPopView ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (nonatomic,strong) NSIndexPath*lastIndexPath;//记录上一次选择的下标


@end

@implementation ShoppingCartPopView

#pragma mark++++++++  alertView +++++++++
+(instancetype)showAlert;
{
    ShoppingCartPopView*alertView=(ShoppingCartPopView*)[[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ShoppingCartPopView class]) owner:nil options:nil]objectAtIndex:0];
    alertView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT); 
    return alertView;
}
#pragma mark++++++++  取消 +++++++++
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
    
    
}
#pragma mark++++++++  确定 +++++++++
- (IBAction)sureAction:(id)sender {
    
    self.shoppingCartPopViewBlock(self.data);
    
}
#pragma mark++++++++  减少购买数量 +++++++++
- (IBAction)cutBuyGoodsCountAction:(id)sender {
    
    //类型：0-登腾币商品，1-积分商品，2-赠品 ( 限购一件 无价格显示)
    if ([_coinType isEqualToString:@"2"])
    {
        [self upBuyGoodsCount:1];
        return;
    }
    
    NSString*count =[NSString stringWithFormat:@"%@",self.buyCountTextField.text];
    if ([count integerValue]>1)
    {
        [self upBuyGoodsCount:[count integerValue]-1];
    }
    
}
#pragma mark++++++++  添加购买数量 +++++++++
- (IBAction)addBuyGoodsCountAction:(id)sender {
    
    //类型：0-登腾币商品，1-积分商品，2-赠品 ( 限购一件 无价格显示)
    if ([_coinType isEqualToString:@"2"])
    {
        [self upBuyGoodsCount:1];
        return;
    }
    NSString*count =[NSString stringWithFormat:@"%@",self.buyCountTextField.text];
    
    if ([count integerValue]<self.goodsStore)
    {
        [self upBuyGoodsCount:[count integerValue]+1];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    //类型：0-登腾币商品，1-积分商品，2-赠品 ( 限购一件 无价格显示)
    if ([_coinType isEqualToString:@"2"])
    {
        [self upBuyGoodsCount:1];
        return;
    }
    
    NSString*count =[NSString stringWithFormat:@"%@",textField.text];
    if ([count integerValue]>self.goodsStore)
    {
        [self upBuyGoodsCount:self.goodsStore];
    }
    else if ([count integerValue]<1)
    {
        [self upBuyGoodsCount:1];
    }
     
}
-(void)setCoinType:(NSString *)coinType
{
    _coinType = coinType;

    //类型：0-登腾币商品，1-积分商品，2-赠品 ( 限购一件 无价格显示)
    if ([_coinType isEqualToString:@"2"])
    {
        self.goodsPriceLb.hidden=YES;
    }
}


/**
 *更新购买的商品数量
 */
-(void)upBuyGoodsCount:(NSInteger)value;
{
    
    self.buyCountTextField.text=[NSString stringWithFormat:@"%ld",(long)value];
    //
    self.buyCount = value;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //
    self.backgroundColor=[UIColor clearColor];
    //
    self.backView.backgroundColor=[UIColor colorWithHexString:@"#000000"];
    self.backView.alpha=0.4;
    //
    self.goodsImg.layer.cornerRadius=8*sizeScale;
    self.goodsImg.clipsToBounds=YES;
    self.goodsTitleLb.font=FONT_12;
    self.goodsStoreCountLb.font=FONT_12;
    self.buyCountTipLb.font=FONT_14;
    self.sureBtn.titleLabel.font=FONT_14;
    self.sureBtn.layer.cornerRadius=6*sizeScale;
    self.sureBtn.clipsToBounds=YES;
    self.buyCountView.layer.cornerRadius = 26*sizeScale/2;
    self.buyCountView.clipsToBounds=YES;
    self.buyCountView.layer.borderWidth=1.0f;
    self.buyCountView.layer.borderColor=[UIColor colorWithHexString:@"#D5D5D5"].CGColor;
    ;
    
    self.buyCountTextField.delegate=self;
    
    self.buyCountTipLb.text=@"购买数量";
    
    [self.sureBtn setTitle:@"确定" forState:0];
    
    
    //FBCollectionViewFlowLayout UICollectionViewFlowLayout albumHomeCollectionFlowLayout
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    //layout.left = 15*sizeScale;
    layout.minimumLineSpacing = 10*sizeScale;//滚动方向上item的间距 默认为10
    layout.minimumInteritemSpacing = 10*sizeScale;//与滚动方向相反的两个item之间最小距离 默认为10
    layout.sectionInset = UIEdgeInsetsMake(5*sizeScale, 15*sizeScale, 5*sizeScale, 15*sizeScale);
   [self.baseCollect setCollectionViewLayout:layout];
    self.baseCollect.delegate = self;
    self.baseCollect.dataSource = self;
    [self.baseCollect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    [_baseCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [_baseCollect registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];

}
/**
 *更新商品图片
 */
-(void)upGoodsImg:(NSString*)value;
{
    self.goodsImgValue = value;
    if (!NULLString(value))
    {
        [self.goodsImg sd_setImageWithURL:[NSURL URLWithString:value] placeholderImage:nil]; 
    }
}
/**
 *更新商品价格
 */
-(void)upPrice:(NSString*)value
{
    self.goodsPriceValue = value;
    //
    
    NSString*r1=@"¥";
    //类型：0-登腾币商品，1-积分商品，2-赠品 ( 限购一件 无价格显示)
    if ([_coinType isEqualToString:@"0"])
    {
        r1 = @"登腾币" ;
    }
    else if ([_coinType isEqualToString:@"1"])
    {
        r1 = @"积分";
    }
    
    NSString*r2=[NSString stringWithFormat:@"%@",value];
    NSMutableAttributedString*registerStr=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",r1,r2]];
    NSInteger length1=[r1 length];
    NSInteger length2=[r2 length];;

    [registerStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#EE4936"] range:NSMakeRange(0, length1)];
    [registerStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#EE4936"] range:NSMakeRange(length1, length2)];
    [registerStr addAttribute:NSFontAttributeName value:FONT_12 range:NSMakeRange(0, length1)];
    [registerStr addAttribute:NSFontAttributeName value:FONT_Bold_14 range:NSMakeRange(length1, length2)];
    self.goodsPriceLb.attributedText=registerStr;
}
/**
 *更新商品库存
 */
-(void)upGoodsStoreCount:(NSString*)value;
{
    if (!NULLString(value)) 
    {
        self.goodsStoreCountLb.text=[NSString stringWithFormat:@"%@:%@",@"库存",value];
        self.goodsStore = [value integerValue];
    }
}
-(void)setData:(NSMutableArray<SpecsModel *> *)data
{
    _data = data;
    //UICollectionView刷新时闪屏的解决方法
    [UIView performWithoutAnimation:^{
       //刷新界面
        [self.baseCollect reloadData];
     }];
}
 -(void)selectFirst
{
    //默认选择
    if (_data.count>0)
    {
        SpecsModel*model=(SpecsModel*)self.data[0];
        if (model.specsList.count>0)
        {
            [self collectionView:self.baseCollect didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        }
    }
}
-(void)selectFirst2
{
   //默认选择
   if (_data.count>0)
   {
       for (int i =0; i<self.data.count; i++)
       {
           SpecsModel*model=(SpecsModel*)self.data[i];

           if (model.specsList.count>0)
           {
               [self collectionView:self.baseCollect didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
           }
       }
       
   }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.data.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    SpecsModel*model=(SpecsModel*)self.data[section];
    return model.specsList.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
     return CGSizeMake(SCREEN_WIDTH, 30*sizeScale);
     
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
}
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView*headerReusableView=(UICollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerReusableView.backgroundColor = [UIColor  clearColor];
        for (UIView*vv in headerReusableView.subviews)
        {
            [vv removeFromSuperview];
        }
        
         
            UIView*view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30*sizeScale)];
            [headerReusableView addSubview:view];
            view.backgroundColor=[UIColor whiteColor];
            
            UILabel*titleLb=[[UILabel alloc]init];
            [view addSubview:titleLb];
            [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(view.mas_top).offset(0);
                make.left.mas_equalTo(view.mas_left).offset(15*sizeScale); 
                make.height.mas_equalTo(20*sizeScale);
                make.width.greaterThanOrEqualTo(@(72*sizeScale));
                 
            }];
            titleLb.font=FONT_14;
            titleLb.textColor=[UIColor colorWithHexString:@"#242424"];
            titleLb.textAlignment=NSTextAlignmentLeft;
            SpecsModel*model=(SpecsModel*)self.data[indexPath.section];
            titleLb.text=model.specsName;
 
        
         return headerReusableView;
    }
    else
    {
        UICollectionReusableView*footerReusableView=(UICollectionReusableView*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footerReusableView.backgroundColor = [UIColor  colorWithHexString:@"#F8F8F8"];
     
        return footerReusableView;
    }
}

////滚动方向上item的间距 默认为10
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//   return 5*sizeScale;
//}
////与滚动方向相反的两个item之间最小距离 默认为10
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//  return 5*sizeScale;
//}
////inset
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//     // 上右下左
//        return UIEdgeInsetsMake(5*sizeScale, 15*sizeScale, 5*sizeScale, 15*sizeScale);
//
//}
#pragma mark++++根据文字的大小计算size++++
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};// NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:attrs context:nil].size;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat maxWidth = SCREEN_WIDTH-15*sizeScale*2;
    CGFloat maxHeight = 27*sizeScale;
    SpecsModel*model=(SpecsModel*)self.data[indexPath.section];
    NSString*name=[NSString stringWithFormat:@"%@",model.specsList[indexPath.item]];
    
    CGSize w_size =[self sizeWithText:name font:FONT_16 maxSize:CGSizeMake(MAXFLOAT, maxHeight)];
    w_size.width = w_size.width + 8*sizeScale*2;
    if (w_size.width<60*sizeScale)
    {
        w_size.width = 60*sizeScale;
    }
    if (w_size.width>maxWidth)
    {
        CGSize h_size =[self sizeWithText:name font:FONT_16 maxSize:CGSizeMake(maxWidth, MAXFLOAT)];
        return CGSizeMake(maxWidth, h_size.height);
    }
    else
    {
        return CGSizeMake(w_size.width, maxHeight);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    for (UIView*v  in cell.contentView.subviews)
    {
        [v removeFromSuperview];
    }
    SpecsModel*model=(SpecsModel*)self.data[indexPath.section];

    UIView*bgView =[[UIView alloc]init];
    [cell.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(0, 0*sizeScale, 0, 0*sizeScale));
    }];
    bgView.layer.cornerRadius =27*sizeScale/2;
    bgView.clipsToBounds=YES;
    
    UILabel*nameLb=[[UILabel alloc]init];
    [bgView addSubview:nameLb];
    [nameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsMake(1*sizeScale, 5*sizeScale, 1*sizeScale, 5*sizeScale));
    }];
    nameLb.textAlignment=NSTextAlignmentCenter;
    nameLb.font=FONT_13;
    nameLb.text=model.specsList[indexPath.item];
    nameLb.numberOfLines=0;
    
    if (1)
    {
        CGFloat maxWidth = SCREEN_WIDTH-15*sizeScale*2;
        CGFloat maxHeight = 27*sizeScale;
        SpecsModel*model=(SpecsModel*)self.data[indexPath.section];
        NSString*name=[NSString stringWithFormat:@"%@",model.specsList[indexPath.item]];
        
        CGSize w_size =[self sizeWithText:name font:FONT_16 maxSize:CGSizeMake(MAXFLOAT, maxHeight)];
        w_size.width = w_size.width + 8*sizeScale*2;
        if (w_size.width<60*sizeScale)
        {
            w_size.width = 60*sizeScale;
        }
        if (w_size.width>maxWidth)
        {
            nameLb.textAlignment=NSTextAlignmentLeft;
        }
        else
        {
            nameLb.textAlignment=NSTextAlignmentCenter;
        }
    }
    
    NSDictionary*d=[NSDictionary dictionaryWithDictionary:model.specsListData[indexPath.item]];
    NSString* idd = [NSString stringWithFormat:@"%@",d[@"id"]];
    nameLb.text=idd;

    //判断某个对象是否在某个数组中
    if ([self.storeSkuNeedClickArr containsObject:idd])
    {
        if (indexPath.item==model.selectSpecsIndex)
        {
            nameLb.textColor=[UIColor colorWithHexString:@"#FFFFFF"];
            nameLb.backgroundColor = [UIColor clearColor];
            bgView.layer.borderColor=[UIColor colorWithHexString:@"#A0C130"].CGColor;
            bgView.layer.borderWidth = 1.0f;
            bgView.backgroundColor = [UIColor colorWithHexString:@"#A0C130"];
        }
        else
        {
            nameLb.textColor=[UIColor colorWithHexString:@"#242424"];
            nameLb.backgroundColor = [UIColor clearColor];
            bgView.layer.borderColor=[UIColor colorWithHexString:@"#D5D5D5"].CGColor;
            bgView.layer.borderWidth = 1.0f;
            bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];

        }
    }
    else
    {
        //无库存灰掉
        nameLb.textColor=[UIColor colorWithHexString:@"#D5D5D5"];
        nameLb.backgroundColor = [UIColor clearColor];
        bgView.layer.borderColor=[UIColor colorWithHexString:@"#D5D5D5"].CGColor;
        bgView.layer.borderWidth = 1.0f;
        bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    
    
    
   
    
    
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (1)
    {
        SpecsModel*model=(SpecsModel*)self.data[indexPath.section];
        NSDictionary*d=[NSDictionary dictionaryWithDictionary:model.specsListData[indexPath.item]];
        NSString* idd = [NSString stringWithFormat:@"%@",d[@"id"]];
        //判断某个对象是否在某个数组中
        if ([self.storeSkuNeedClickArr containsObject:idd])
        {
            NSLog(@"self.storeSkuNeedClickArr = %@ \n idd = %@ \n",self.storeSkuNeedClickArr,idd);
            
        }
        else
        {
            NSLog(@"self.storeSkuNeedClickArr = %@ \n idd = %@ \n",self.storeSkuNeedClickArr,idd);
            
            
            //点击灰掉sku反选
            //判断当前点击的sku是否属于有库存的sku；
            BOOL skuHascount = NO;
            for (NSString*s1 in self.storeSkuArr)
            {
                NSSet*set1 =[NSSet setWithArray:@[idd]];
                NSArray*a1=[s1 componentsSeparatedByString:@";"];
                NSSet*set2 =[NSSet setWithArray:a1];
                //比较--判断是否包含已选sku
                 //判断一个数组是否为另一个数组的子集
                if ([set1 isSubsetOfSet:set2])
                {
                    skuHascount = YES;
                }
             }
            if (!skuHascount)
            {
                //无库存灰掉--不能点击
                return;
            }
            //取消所有选中sku，选择当前点击的sku
            NSArray*listA= [NSArray arrayWithArray:self.data];
            NSInteger i = 0;
            for (SpecsModel*model in listA)
            {
                if (model.selectSpecsIndex<0)
                {
                }
                else
                {
                    model.selectSpecsIndex = -1;
                    [self.data replaceObjectAtIndex:i withObject:model];
                }
                i++;
            }
        }
    }
    
    
 
    
    SpecsModel*model=(SpecsModel*)self.data[indexPath.section];
    if (indexPath.item==model.selectSpecsIndex)
    {
        model.selectSpecsIndex = -1;
    }
    else
    {
        model.selectSpecsIndex = indexPath.item;
    }
    
    [self.data replaceObjectAtIndex:indexPath.section withObject:model];
    
    
    //计算展示的sku图片
    if (1)
    {
        NSInteger sCount =0;
        for (SpecsModel*model in self.data)
        {
            if (model.selectSpecsIndex<0)
            {
                 
            }
            else
            {
                sCount++;
            }
        }
        if (sCount>0)
        {
            //有勾选sku
            //----------------------------------------
            
            NSString*img1 = [NSString stringWithFormat:@"%@",self.skuImgListArr[indexPath.section][indexPath.item]];
            if (img1.length>0)
            {
                //更新产品sku图片
                [self upGoodsImg:img1];
            }
            else
            {
                //已选规格选项id数组,用英文;隔开
                NSString*img2;
                for (SpecsModel*model in self.data)
                {
                    if (model.selectSpecsIndex<0)
                    {
                    }
                    else
                    {
                        NSDictionary*dict=[NSDictionary dictionaryWithDictionary:model.specsListData[model.selectSpecsIndex]];
                        NSString*url =  [NSString stringWithFormat:@"%@",dict[@"url"]];
                        if ([dict objectForKey:@"url"])
                        {
                            img2 = url;
                            break;
                        }
                    }
                }
                
                if (img2.length>0)
                {
                    //更新产品sku图片
                    [self upGoodsImg:img1];
                }
                else
                {
                    if (self.deftGoodsImgValue.length>0)
                    {
                        //更新产品sku图片
                        [self upGoodsImg:self.deftGoodsImgValue];
                    }
                }
            }
            
            //----------------------------------------
        }
        else
        {
            //未选择sku
            if (self.deftGoodsImgValue.length>0)
            {
                //更新产品sku图片
                [self upGoodsImg:self.deftGoodsImgValue];
            }
        }
    }
    
     
    
    
    
    //计算可选sku
    [self calculateSku];
    
    //判断sku是否选择齐全
    NSMutableArray*skuItemIds=[NSMutableArray array];
    BOOL isSelectAll = YES;
    for (SpecsModel*model in self.data)
    {
        if (model.selectSpecsIndex<0)
        {
            isSelectAll = NO;
        }
        else
        {
            NSDictionary*dict=[NSDictionary dictionaryWithDictionary:model.specsListData[model.selectSpecsIndex]];
            [skuItemIds addObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
        }
    }
    if (isSelectAll)
    {
        self.shoppingCartPopViewSkuBlock([skuItemIds componentsJoinedByString:@","]);
    }
    
    //UICollectionView刷新时闪屏的解决方法
    [UIView performWithoutAnimation:^{
       //刷新界面
        [self.baseCollect reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]];
     }];
    
    
}
 
#pragma mark+++++++ sku计算  +++++++
-(void)setSkuListArr:(NSArray *)skuListArr
{
    _skuListArr = skuListArr;
}
-(void)setSkuArr:(NSArray *)skuArr
{
    _skuArr = skuArr;
}

-(void)setStoreSkuArr:(NSArray *)storeSkuArr
{
    _storeSkuArr = storeSkuArr;
}



/**
 *计算sku组合情况 --用于刷新可选sku
 */
-(void)calculateSku;
{
    
    //已选规格选项id数组,用英文;隔开
    NSMutableArray*skuItemIds=[NSMutableArray array];
    for (SpecsModel*model in self.data)
    {
        if (model.selectSpecsIndex<0)
        {
            
        }
        else
        {
            NSDictionary*dict=[NSDictionary dictionaryWithDictionary:model.specsListData[model.selectSpecsIndex]];
            [skuItemIds addObject:[NSString stringWithFormat:@"%@",dict[@"id"]]];
        }
    }
    
    if(skuItemIds.count>0)
    {
        NSMutableArray*list =[NSMutableArray array];
            //有库存sku组合中挑选包含已选sku ID 的组合
            for (NSString*s1 in self.storeSkuArr)
            {
                NSArray*a1=[s1 componentsSeparatedByString:@";"];
                NSSet*set1 =[NSSet setWithArray:skuItemIds];
                NSSet*set2 =[NSSet setWithArray:a1];
                //比较--判断是否包含已选sku
                 //判断一个数组是否为另一个数组的子集
                if ([set1 isSubsetOfSet:set2])
                {
                    [list addObject:s1];
                }
             }
         
        
        
        //获取 包含已选sku ID 的有库存组合sku ID 元素【即有库存且包含已选sku ID的组合，里面的sku ID 都为可选项，】
        NSMutableSet *set3 = [NSMutableSet setWithArray:@[]];
        for (NSString*s2 in list)
        {
            NSArray*a2=[s2 componentsSeparatedByString:@";"];
            NSMutableSet *set4 = [NSMutableSet setWithArray:a2];
            //取并集
            [set3 unionSet:set4];
        }
        
        //已选一个sku同一分类下兄弟节点sku ID有库存皆为可选项
        if (skuItemIds.count==1)
        {
            //sku ID二维数组
            NSMutableArray*ar=[NSMutableArray array];
            for (SpecsModel*model in self.data)
            {
                NSMutableArray*ar2=[NSMutableArray array];

                for (NSDictionary*dr in model.specsListData)
                {
                    [ar2 addObject:[NSString stringWithFormat:@"%@",dr[@"id"]]];
                }
                [ar addObject:ar2];
            }
            
            //从sku ID二维数组中选出所有已选sku ID兄弟节点的sku ID
            NSMutableArray*ar3=[NSMutableArray array];
            for (NSString*ss in skuItemIds)
            {
                for (NSArray*a2 in ar)
                {
                    if ([a2 containsObject:ss])
                    {
                        [ar3 addObjectsFromArray:a2];
                    }
                }
            }
            
            //
            //选出所有已选sku ID兄弟节点的有库存sku ID
            NSMutableArray*a4 =[NSMutableArray array];
            for (NSString*skuid in ar3)
            {
                for (NSString*s2 in self.storeSkuArr)
               {
                   NSArray*a2=[s2 componentsSeparatedByString:@";"];
                   if ([a2 containsObject:skuid])
                   {
                       [a4 addObject:skuid];
                   }
               }
            }
            NSMutableSet *skuSet = [NSMutableSet setWithArray:a4];
            ////取并集
            [set3 unionSet:skuSet];
        }
        
        //计算兄弟节点是否可选
        if (skuItemIds.count>=2)
        {
           
            
            //sku ID二维数组
            NSMutableArray*ar=[NSMutableArray array];
            for (SpecsModel*model in self.data)
            {
                NSMutableArray*ar2=[NSMutableArray array];

                for (NSDictionary*dr in model.specsListData)
                {
                    [ar2 addObject:[NSString stringWithFormat:@"%@",dr[@"id"]]];
                }
                [ar addObject:ar2];
            }
            
            //从sku ID二维数组中选出所有已选sku ID兄弟节点的sku ID 二维数组
            NSMutableArray*ar3=[NSMutableArray array];
            for (NSString*ss in skuItemIds)
            {
                for (NSArray*a2 in ar)
                {
                    if ([a2 containsObject:ss])
                    {
                        [ar3 addObject:a2];
                    }
                }
            }
            
            /*
             [1;2,
              3;4
              ...]
             */
            //获取已选sku ID所在兄弟节点sku ID 的组合情况
            NSArray*xdSkuZhuheArr = [self zheheArr:ar3];
            
            //去除没库存的组合
            NSMutableArray*ar4 =[NSMutableArray array];
            for (NSString*xd in xdSkuZhuheArr)
            {
                NSArray*b1 = [xd componentsSeparatedByString:@";"];
                NSSet*bSet1 = [NSSet setWithArray:b1];
                
                for (NSString*s2 in self.storeSkuArr)
               {
                   NSArray*b2=[s2 componentsSeparatedByString:@";"];
                   NSSet*bSet2 = [NSSet setWithArray:b2];

                   //判断一个数组是否为另一个数组的子集
                   if ([bSet1 isSubsetOfSet:bSet2])
                   {
                       [ar4 addObject:xd];
                       break;
                   }
               }
            }
            
            //计算已选sku ID组成的组合的子集
            self.skuTemArr = [NSMutableArray  array];
             NSMutableArray *numbers = [NSMutableArray array];
            for (int i = 0; i < skuItemIds.count; i++) {
              [numbers addObject:[NSNumber numberWithInt:0]];
            }
             [self subElements:skuItemIds numbers:numbers index:0];
            NSLog(@"计算已选sku ID组成的组合的子集  self.skuTemArr = %@ \n", self.skuTemArr);

            //计算包含【已选sku ID总数-1个已选sku ID】的组合子集
            NSMutableArray*ar5=[NSMutableArray array];
            for (NSString*b1 in  self.skuTemArr)
            {
                NSArray*c =[b1 componentsSeparatedByString:@";"];
                if (c.count==(skuItemIds.count-1))
                {
                    [ar5 addObject:b1];
                }
            }
            
            //从兄弟节点sku ID 的组合中找出包含上诉子集的组合
            NSMutableArray*xdZh =[NSMutableArray array];
            for (NSString*b1 in ar4)
            {
                NSArray*b1A=[b1 componentsSeparatedByString:@";"];
                NSSet*b1Set =[NSSet setWithArray:b1A];
                
                for (NSString*c1 in ar5)
                {
                    NSArray*c1A=[c1 componentsSeparatedByString:@";"];
                    NSSet*c1Set =[NSSet setWithArray:c1A];
                    if ([c1Set isSubsetOfSet:b1Set])
                    {
                        [xdZh addObject:b1];
                        break;
                    }
                }
            }
            
            //取出组合里面的元素
            NSMutableArray*xdZhResult =[NSMutableArray array];
            for (NSString*b1 in xdZh)
            {
                NSArray*b1A=[b1 componentsSeparatedByString:@";"];
                [xdZhResult addObjectsFromArray:b1A];
            }
            
            NSMutableSet*xdSet =[NSMutableSet setWithArray:xdZhResult];
            //取并集
            [set3 unionSet:xdSet];
 
        }
        
        
        //所有可选规格sku ID 集合
        self.storeSkuNeedClickArr = [set3 allObjects];
        
        NSLog(@"所有有库存sku 集合 self.storeSkuArr = %@ \n",self.storeSkuArr);
        NSLog(@"所有可选规格sku ID 集合 set3 = %@ \n",set3);
        NSLog(@"所有可选规格sku ID 集合 self.storeSkuNeedClickArr = %@ \n",self.storeSkuNeedClickArr);

    }
    else
    {
        // 取出所有筛选出来符合情况的sku ID
        NSMutableSet *set3 = [NSMutableSet setWithArray:@[]];
        for (NSString*s2 in self.storeSkuArr)
        {
            NSArray*a2=[s2 componentsSeparatedByString:@";"];
            NSMutableSet *set4 = [NSMutableSet setWithArray:a2];

            //取并集
            [set3 unionSet:set4];
        }
        
        //所有可选规格sku ID 集合
        self.storeSkuNeedClickArr = [set3 allObjects];
        NSLog(@"所有有库存sku 集合 self.storeSkuArr = %@ \n",self.storeSkuArr);
        NSLog(@"所有可选规格sku ID 集合 set3 = %@ \n",set3);
        NSLog(@"所有可选规格sku ID 集合 self.storeSkuNeedClickArr = %@ \n",self.storeSkuNeedClickArr);

    }
      
    //UICollectionView刷新时闪屏的解决方法
    [UIView performWithoutAnimation:^{
       //刷新界面
        [self.baseCollect reloadData];
     }];
    
    
    
    
}

/**
 求数组所有子集

 @param array 原始数组
 @param numbers 数字数组 - 用于标识使用
 @param index 索引
 */
- (void)subElements:(NSArray *)array numbers:(NSMutableArray *)numbers index:(int)index {
    if (index == array.count) {
        NSMutableArray *strM = [NSMutableArray array];
        for (int i = 0; i < array.count; i++)
        {
            NSNumber *number = numbers[i];
            if (number.intValue == 1)
            {
                [strM addObject:array[i]];
            }
        }
        if (strM.count > 0)
        {
            NSLog(@"strM %@ \n",[strM componentsJoinedByString:@";"]);
            [self.skuTemArr addObject:[strM componentsJoinedByString:@";"]];
        }
        return;
    }
    numbers[index] = [NSNumber numberWithInt:0];
    [self subElements:array numbers:numbers index:index + 1];
    numbers[index] = [NSNumber numberWithInt:1];
    [self subElements:array numbers:numbers index:index + 1];
}

-(NSArray*)zheheArr:(NSMutableArray*)array
{
    if (array.count>1)
    {
        NSArray*list = [self mergeArray:array];
        NSArray*a = [NSArray arrayWithArray:list[0]];
        NSMutableArray *d = [NSMutableArray array];
        for (NSArray*b in a)
        {
            NSString*c =[b componentsJoinedByString:@";"];
            [d addObject:c];
        }
        
        NSLog(@"dddd = %@ ",d);
        return d;
    }
    else
    {
        if (array.count==0)
        {
            return @[];
        }
        else
        {
            NSMutableArray *d = [NSMutableArray array];
            for (NSArray*b in array)
            {
                NSString*c =[b componentsJoinedByString:@";"];
                [d addObject:c];
            }
            NSLog(@"dddd = %@ ",d);
            return d;
        }
        
    }
   
    
}

//多数组元素组合排列
- (NSMutableArray *)mergeArray:(NSMutableArray *)array
{
    if (array.count > 1) {
        NSMutableArray *resultArray = [NSMutableArray array];
        NSMutableArray *firstArray = array[0];
        NSMutableArray *secondArray = array[1];
        
        for (int i=0; i < firstArray.count;i++) {
            if (![firstArray[i] isKindOfClass:[NSMutableArray class]]) {
                firstArray[i] = [NSMutableArray arrayWithObjects:firstArray[i], nil];
            }
            for (int j = 0; j < secondArray.count; j++) {
                if (j == 0) {
                    [firstArray[i] addObject:secondArray[j]];
                } else {
                    [firstArray[i] replaceObjectAtIndex:((NSArray *)firstArray[i]).count-1 withObject:secondArray[j]];
                }
                NSArray *temArray = [firstArray[i] mutableCopy];
                [resultArray addObject:temArray];
            }
        }
        [array replaceObjectAtIndex:0 withObject:resultArray];
        [array removeObjectAtIndex:1];
        [self mergeArray:array];
    }
    return array;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
