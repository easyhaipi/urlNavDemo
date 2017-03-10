//
//  ViewController.m
//  eeeeee
//
//  Created by hulinEasy on 2017/3/8.
//  Copyright © 2017年 easy. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>




#define MapTypeGaoDe @"高德地图"
#define MapTypeBaidu @"百度地图"
#define MapTypeQQ @"腾讯地图"
#define MapTypeGoogle @"谷歌地图"
//系统版本号是否大于8.0
#define IS_SystemVersionGreaterThanEight  ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0)
@interface ViewController ()<UIActionSheetDelegate>
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.coordinate = CLLocationCoordinate2DMake(39.9105700000, 116.4500610000);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)test:(id)sender {
    
    
    //系统版本高于8.0，使用UIAlertController
    if (IS_SystemVersionGreaterThanEight) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        //自带地图
        [alertController addAction:[UIAlertAction actionWithTitle:@"自带地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 自带地图");
            
            //使用自带地图导航
            MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
            
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil]];
            
            [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                       MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
            
            
        }]];
        
        //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"alertController -- 高德地图");
                NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"测试",@"demoURI://",self.coordinate.latitude, self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlString]];
                
            }]];
        }
        
        //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"alertController -- 百度地图");
                NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
                
            }]];
        }
        
        //判断是否安装了腾讯地图
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSLog(@"alertController -- 腾讯地图");
                NSString *urlsting =[[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord={{我的位置}}&tocoord=%f,%f&coord_type=1&policy=0",self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
                
            }]];
        }
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        {
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"谷歌地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"测试谷歌",@"demoURI://",self.coordinate.latitude, self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSLog(@"%@",urlString);
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
                
            }];
            
            [alertController addAction:action];
        }
        //添加取消选项
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [alertController dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        //显示alertController
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else {  //系统版本低于8.0，则使用UIActionSheet
        
        
        UIActionSheet * actionsheet = [[UIActionSheet alloc] initWithTitle:@"导航到设备" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"自带地图", nil];
        
        //如果安装高德地图，则添加高德地图选项
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
            [actionsheet addButtonWithTitle:MapTypeGaoDe];
            
        }
        //如果安装百度地图，则添加百度地图选项
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
            
            [actionsheet addButtonWithTitle:MapTypeBaidu];
        }
        //如果安装腾讯地图，则添加腾讯地图选项
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
            
            [actionsheet addButtonWithTitle:MapTypeQQ];
            
        }
        //如果安装谷歌地图，则添加谷歌地图选项
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
            
            [actionsheet addButtonWithTitle:MapTypeGoogle];
            
        }
        
        
        [actionsheet showInView:self.view];
        
        
    }
    
}
#pragma mark - UIActionSheetDelegate

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    NSLog(@"ActionSheet - 取消了");
    [actionSheet removeFromSuperview];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 0) {
        
        NSLog(@"自带地图触发了");
        
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:nil]];
        
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        
    }
    
    NSString *actionSheetButtonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([actionSheetButtonTitle isEqualToString:MapTypeGaoDe]) {
        //高德地图
        NSLog(@"actionSheet -- 高德地图");
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",@"测试",@"demoURI://",self.coordinate.latitude, self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }else  if ([actionSheetButtonTitle isEqualToString:MapTypeBaidu]) {
        NSLog(@"actionSheet -- 百度地图");
        NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
        
    }else if ([actionSheetButtonTitle isEqualToString:MapTypeQQ]) {
        NSLog(@"actionSheet -- 腾讯地图");
        NSString *urlsting =[[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord={{我的位置}}&tocoord=%f,%f&coord_type=1&policy=0",self.coordinate.latitude,self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
    }else if ([actionSheetButtonTitle isEqualToString:MapTypeGoogle]) {
        NSLog(@"actionSheet -- 谷歌地图");
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",@"测试谷歌",@"demoURI://",self.coordinate.latitude, self.coordinate.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",urlString);
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
    }
    
    
    
}

@end
