//
//  MainViewController.m
//  CYLunarCalendar
//
//  Created by Cyrus on 14-5-23.
//  Copyright (c) 2014年 cyrusleung. All rights reserved.
//


///////////////////////////////////////////////////////////////////
// 此开源基于Apache V2协议，仅供大家学习使用，其中使用到的开源项目版权归他们
// 使用了VRGCalendar和FMDB开源项目
// 部分日期计算代码参考了code4app上“有农历的日历”，且作了优化和补充
// 这个版本不打算继续改进了，准备全新开发基于Swift的万年历
//
// 黄历数据采集于某网站
// 此代码仅供学习，只提供2014年黄历数据（因数据源关系某些日期记录缺失）
// 若需更齐全的数据和字段，请联系QQ:6966999（可付费代采集）
///////////////////////////////////////////////////////////////////


#import "MainViewController.h"

#define IOS6_LATER (floor(NSFoundationVersionNumber)>NSFoundationVersionNumber_iOS_6_1)

@interface MainViewController ()
{
    UIScrollView        *_detailScrollView;
    UILabel             *_lunarLabel;
    UILabel             *_constellationLabel;
    UILabel             *_weekdayLabel;
    UILabel             *_yiLabel;
    UILabel             *_jiLabel;
    UILabel             *_ganZhiLabel;
    UILabel             *_chongShaLabel;
    UILabel             *_wuXingLabel;
}

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    [self.view addSubview:calendar];
    
    // iOS 7 specific
    self.navigationController.navigationBar.translucent = NO;
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        calendar.frame=CGRectMake(0, 20, calendar.frame.size.width, calendar.frame.size.height);
    }
    
    _detailScrollView=[[UIScrollView alloc] init];
    
    [self.view addSubview:_detailScrollView];
    
    _lunarLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    [_lunarLabel setFont:[UIFont systemFontOfSize:14]];
    [_lunarLabel setTextColor:[UIColor blackColor]];
    [_detailScrollView addSubview:_lunarLabel];
    
    _ganZhiLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lunarLabel.frame), 10, 220, 20)];
    [_ganZhiLabel setFont:[UIFont systemFontOfSize:13]];
    [_ganZhiLabel setTextColor:[UIColor blackColor]];
    [_detailScrollView addSubview:_ganZhiLabel];
    
    _constellationLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_lunarLabel.frame), 40, 20)];
    [_constellationLabel setFont:[UIFont systemFontOfSize:12]];
    [_constellationLabel setTextColor:[UIColor blackColor]];
    [_detailScrollView addSubview:_constellationLabel];
    
    _weekdayLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_constellationLabel.frame), CGRectGetMaxY(_lunarLabel.frame), 100, 20)];
    [_weekdayLabel setFont:[UIFont systemFontOfSize:12]];
    [_weekdayLabel setTextColor:[UIColor blackColor]];
    [_detailScrollView addSubview:_weekdayLabel];
    
    _yiLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_constellationLabel.frame), 300, 20)];
    [_yiLabel setFont:[UIFont systemFontOfSize:12]];
    [_yiLabel setTextColor:[UIColor blackColor]];
    [_detailScrollView addSubview:_yiLabel];
    
    _jiLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_yiLabel.frame), 300, 20)];
    [_jiLabel setFont:[UIFont systemFontOfSize:12]];
    [_jiLabel setTextColor:[UIColor blackColor]];
    [_detailScrollView addSubview:_jiLabel];
    
    _chongShaLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_jiLabel.frame), 300, 20)];
    [_chongShaLabel setFont:[UIFont systemFontOfSize:12]];
    [_chongShaLabel setTextColor:[UIColor blackColor]];
    [_detailScrollView addSubview:_chongShaLabel];
    
    _wuXingLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_chongShaLabel.frame), 300, 20)];
    [_wuXingLabel setFont:[UIFont systemFontOfSize:12]];
    [_wuXingLabel setTextColor:[UIColor blackColor]];
    [_detailScrollView addSubview:_wuXingLabel];
    
    [_detailScrollView setContentSize:CGSizeMake(320, 160)];
    
//    [self calendarView:nil dateSelected:[NSDate date]];
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:currentDate]; // Get necessary date components
    
    [components month]; //gives you month
    [components day]; //gives you day
    [components year];
    
    if (month==[components month]) {
        NSArray *dates = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:5], nil];
        [calendarView markDates:dates];
    }
    
    [_detailScrollView setFrame:CGRectMake(0, targetHeight+(IOS6_LATER?20:0), 320, self.view.bounds.size.height-targetHeight)];
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date lunarDict:(NSMutableDictionary*) dict
{
    [_lunarLabel setText:[dict objectForKey:@"LunarDate"]];
    [_constellationLabel setText:[dict objectForKey:@"Constellation"]];
    [_weekdayLabel setText:[dict objectForKey:@"Weekday"]];
    
    [_yiLabel setText:[dict objectForKey:@"Yi"]];
    [_jiLabel setText:[dict objectForKey:@"Ji"]];
    [_ganZhiLabel setText:[dict objectForKey:@"GanZhi"]];
    [_chongShaLabel setText:[dict objectForKey:@"Chong"]];
    [_wuXingLabel setText:[dict objectForKey:@"WuXing"]];
}

-(void)dealloc
{
    [_detailScrollView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
