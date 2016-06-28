//
//  ViewController.m
//  GeoCoding
//
//  Created by zhangbin on 16/6/28.
//  Copyright © 2016年 zhangbin. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()
/** 监听地理编码按钮的点击*/
//不要选择Outlet类型的，即@property (weak, nonatomic) IBOutlet UIButton *GeoCodingBtnClick;
// 一定选择Action类型的，并且参数选择None.
- (IBAction)GeoCodingBtnClick;

/** 地址*/
@property (weak, nonatomic) IBOutlet UITextField *Address;
/** 经度*/
@property (weak, nonatomic) IBOutlet UILabel *longitude;
/** 纬度*/
@property (weak, nonatomic) IBOutlet UILabel *latitude;
/** 详情地址*/
@property (weak, nonatomic) IBOutlet UILabel *DetailAddress;

/** 地理编码*/
@property(nonatomic,strong)CLGeocoder *geocoding;
@end

@implementation ViewController
/** 懒加载*/
-(CLGeocoder *)geocoding{
    if (_geocoding == nil) {
        _geocoding = [[CLGeocoder alloc] init];
    }
    return _geocoding;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)GeoCodingBtnClick{
    // 1.获取用户输入的地址
    NSString *address = self.Address.text;
    if (address == nil || address.length == 0) {
        NSLog(@"请输入地址");
        return;
    }
    
    // 2.利用地址编码对象编码
    // 根据传入的地址获取该地址对应的经纬度信息
    [self.geocoding geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0) {
            return;
        }
        // 遍历placemarks地标数数组, 地标数组中存放着地标, 每一个地标包含了该位置的经纬度以及城市/区域/国家代码/邮编等等... 这里我们只打印出其中的name,addressDictionary,latitude，longitude的值.类似AFNetworking的数据请求
        for (CLPlacemark *placemark in placemarks) {
            NSLog(@"%@ %@ %lf %lf",placemark.name,placemark.addressDictionary,placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
        }
         // 获取placemarks地标数组中的第一个地标对象
        CLPlacemark *placemark = [placemarks firstObject];
        // 将纬度显示在控件上
        self.latitude.text = [NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
        // 将经度显示在控件上
        self.longitude.text = [NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
        // 取出"地址"字典中的FormattedAddressLines这个key对应的value
        NSArray *addr = placemark.addressDictionary[@"FormattedAddressLines"];
        // 临时的可变字符串，把拼接的详细的地址放到strM中存储
        NSMutableString *strM = [NSMutableString string];
        // 取出addr数组中的每一个对象，然后拼接到strM中
        for (NSString *str in addr) {
            // 拼接"地址”
            [strM appendString:str];
        }
        // 将拼接之后的详细地址显示在控件上
        self.DetailAddress.text = strM;
    }];
    
    
    
}

@end






