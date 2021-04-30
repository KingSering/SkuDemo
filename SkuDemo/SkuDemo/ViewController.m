//
//  ViewController.m
//  SkuDemo
//
//  Created by King Ser on 2021/4/29.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong)NSMutableDictionary*dictData;//
@property(nonatomic,strong)NSMutableDictionary*goodsSkuData;//

@property(nonatomic,retain)ShoppingCartPopView *shoppingCartPopView;// 规格半弹出框

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (1)
    {
        NSError*error;
          //获取文件路径
          NSString *filePath = [[NSBundle mainBundle]pathForResource:@"goodsdata" ofType:@"json"];
          //根据文件路径读取数据
          NSData *jdata = [[NSData alloc]initWithContentsOfFile:filePath];
          //格式化成json数据    <br>
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"\n-000---jsonObject=%@-----\n",jsonObject);
        self.dictData = [NSMutableDictionary dictionary];
        [self.dictData setObject:@"测试产品名称" forKey:@"goodsName"];
        [self.dictData setObject:@"999" forKey:@"storeCount"];
        [self.dictData setObject:@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=556435844,2843589401&fm=26&gp=0.jpg" forKey:@"imgUrl"];
        [self.dictData setObject:jsonObject forKey:@"goodsSkuVOS"];
    }
    
    if (1)
    {
        NSError*error;
          //获取文件路径
          NSString *filePath = [[NSBundle mainBundle]pathForResource:@"goodsskudata" ofType:@"json"];
          //根据文件路径读取数据
          NSData *jdata = [[NSData alloc]initWithContentsOfFile:filePath];
          //格式化成json数据    <br>
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"\n-000---jsonObject=%@-----\n",jsonObject);
        self.goodsSkuData = [NSMutableDictionary dictionaryWithDictionary:jsonObject];
         
    }
    
    

    
    // Do any additional setup after loading the view.
}
- (IBAction)buyAction:(id)sender {
    
    ShoppingCartPopView*alert=[ShoppingCartPopView showAlert];
    //类型：0-登腾币商品，1-积分商品，2-赠品 ( 限购一件 无价格显示)
    alert.coinType = @"1";
    //商品名称
    alert.goodsTitleLb.text=[NSString stringWithFormat:@"%@",self.dictData[@"goodsName"]];
    alert.goodsTitleValue = [NSString stringWithFormat:@"%@",self.dictData[@"goodsName"]];
    //商品库存
    NSString*storeCount=[NSString stringWithFormat:@"%@",self.dictData[@"storeCount"]];
    [alert upGoodsStoreCount:storeCount];
    //默认购买数量
    [alert upBuyGoodsCount:1];
    //商品价格
    //NSString*marketPrice=[NSString stringWithFormat:@"%@",self.dictData[@"shopPrice"]];
    [alert upPrice:@"0"];
    //商品图片
    NSString*imgUrl=[NSString stringWithFormat:@"%@",self.dictData[@"imgUrl"]];
    [alert upGoodsImg:imgUrl];
    if ([self.dictData objectForKey:@"imgUrl"])
    {
        alert.deftGoodsImgValue = imgUrl;
    }
    
    //规格
    NSMutableArray*skuList=[NSMutableArray array];
    NSArray*goodsSkuVOS=[NSArray arrayWithArray:self.dictData[@"goodsSkuVOS"]];
 
    for (NSDictionary*dict  in goodsSkuVOS)
    {
        SpecsModel*model=[[SpecsModel alloc]init];
        //默认不选择规格
        model.selectSpecsIndex = -1;
        model.specsName = [NSString stringWithFormat:@"%@",dict[@"skuName"]];
        //规格元数据
        model.specsListData =[NSArray arrayWithArray:dict[@"goodsSkuItemVOS"]];
        NSMutableArray*list=[NSMutableArray array];
        NSMutableArray*list2=[NSMutableArray array];
        //
        for (NSDictionary*dt  in model.specsListData)
        {
            [list addObject:[NSString stringWithFormat:@"%@",dt[@"item"]]];
            [list2 addObject:[NSString stringWithFormat:@"%@",dt[@"url"]]];
        }
        //规格名称明细
        model.specsList = list;
        //规格图片明细
        model.specsImgList = list2;
        
        //
        [skuList addObject: model];
    }
    alert.data = skuList;
    //点击确定回调
    alert.shoppingCartPopViewBlock = ^(NSArray* data) {
        //
        if (alert.goodsStore<=0)
        {
           //库存不足
        }
        //
        for (SpecsModel*model in data)
        {
            //已选中的规格的下标
            if (model.selectSpecsIndex<0)
            {
               //请选择规格
                return;
            }
        }
        
        //
        if (alert.buyCount<0)
        {
           //
            return;
        }
        if (data.count>0)
        {
            //有规格
            //查库存
             
        }
        else
        {
            //无规格
            //库存数量
            NSString*storeCount=[NSString stringWithFormat:@"%@",self.dictData[@"storeCount"]];
            if ((self.shoppingCartPopView.buyCount<=[storeCount integerValue])&&self.shoppingCartPopView.buyCount>0)
            {
                //
                //
                [self.shoppingCartPopView removeFromSuperview];
                //
               //进入订单确认页面
            }
            else
            {
                //库存不足
                return;
            }
             
        }
        //
        
        
        
    };
    //全选后查sku库存
    alert.shoppingCartPopViewSkuBlock = ^(NSString *skuItemIds) {
        
         
    };
    [self.view addSubview:alert];
    self.shoppingCartPopView = alert;
    
    if (1)
    {
        //sku图片二维数组集合
        NSMutableArray*aImg=[NSMutableArray array];
        //获取所有sku组合
        NSMutableArray *a =[NSMutableArray array];
        NSArray*goodsSkuVOS=[NSArray arrayWithArray:self.dictData[@"goodsSkuVOS"]];
        for (NSDictionary*d in goodsSkuVOS)
        {
            NSArray*goodsSkuItemVOS=[NSArray arrayWithArray:d[@"goodsSkuItemVOS"]];
            NSMutableArray*b=[NSMutableArray array];
            NSMutableArray*bImg=[NSMutableArray array];
            for (NSDictionary*d2 in goodsSkuItemVOS)
            {
                [b addObject:d2[@"id"]];
                if ([d2 objectForKey:@"url"])
                {
                    [bImg addObject:d2[@"url"]];
                }
                else
                {
                    [bImg addObject:@""];
                }
            }
            [a addObject:b];
            [aImg addObject:bImg];
        }
        
        //
        self.shoppingCartPopView.skuImgListArr = [NSMutableArray arrayWithArray:aImg];

        NSLog(@"获取所有sku组合 a= %@ \n",[self.shoppingCartPopView zheheArr:a]);
        /*
         
         获取所有sku组合 a= [
         34;61;66;68,
         34;61;66;70,
         34;61;67;68,
         34;61;67;70,
         34;62;66;68,
         34;62;66;70,]
         
         */
         self.shoppingCartPopView.skuArr = [self.shoppingCartPopView zheheArr:a];
         
        
        //获取有库存的sku组合
        NSDictionary*productStocks=[NSDictionary dictionaryWithDictionary:self.goodsSkuData[@"productStocks"]];
        NSMutableArray *b =[NSMutableArray arrayWithArray:[productStocks allKeys]];
        NSLog(@"获取有库存的sku组合 b= %@ \n",b);
        /*
        
        获取有库存的sku组合 b= [
        34;67;68;62,
        34;67;68;63,
        35;66;70;62,
        35;66;70;63,]
        
        */
        self.shoppingCartPopView.storeSkuArr = b;

        
       
        
        
        
        //计算sku组合
        [self.shoppingCartPopView calculateSku];
    }
    
  
    //
    
    
}


@end
