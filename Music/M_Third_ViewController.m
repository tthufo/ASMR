//
//  M_Third_ViewController.m
//  ASMR
//
//  Created by thanhhaitran on 2/7/16.
//  Copyright © 2016 thanhhaitran. All rights reserved.
//

#import "M_Third_ViewController.h"

#import "YoutubeChildViewController.h"

@interface M_Third_ViewController ()<PlayerDelegate>
{
    IBOutlet UITableView * tableView;
    
    NSMutableArray * dataList;
    
    NSString * nextPage;
    
    int totalResult;
    
    BOOL isLoadMore, isSearchMode;
    
    IBOutlet UISearchBar * searchBar;
}
@end

@implementation M_Third_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[AVHexColor colorWithHexString:@"#136CFA"]}];
    
    nextPage = @"";
    
    __block M_Third_ViewController * weakSelf  = self;
    
    [tableView addFooterWithBlock:^{
        
        [weakSelf didLoadMore];
        
    } withIndicatorColor:[UIColor grayColor]];
    
    /*
    [[Ads sharedInstance] didShowBannerAdsWithInfor:@{@"host":self,@"X":@(screenWidth),@"Y":@(screenHeight - (SYSTEM_VERSION_LESS_THAN(@"7") ? 164 : 100)),@"adsId":bannerAPI,@"":@"d9024897b1d27634898743a5431cc4a6"} andCompletion:^(BannerEvent event, NSError *error, id banner) {
        
        switch (event)
        {
            case AdsDone:
            {
                tableView.contentInset = UIEdgeInsetsMake(SYSTEM_VERSION_LESS_THAN(@"7") ? 0 : 64, 0, SYSTEM_VERSION_LESS_THAN(@"7") ? 50 : 100, 0);
            }
                break;
            case AdsFailed:

                break;
            case AdsWillPresent:
                
                
                break;
            case AdsWillDismiss:
                
                
                break;
            case AdsDidDismiss:
                
                
                break;
            case AdsWillLeave:
                
                break;
            default:
                break;
        }
    }];
    */
    
    [[StartAds sharedInstance] didShowBannerAdsWithInfor:@{@"host":self,@"Y":@(screenHeight - (SYSTEM_VERSION_LESS_THAN(@"7") ? 164 : 100))} andCompletion:^(BannerEvent event, NSError *error, id bannerAd) {
        switch (event)
        {
            case AdsDone:
            {
                tableView.contentInset = UIEdgeInsetsMake(SYSTEM_VERSION_LESS_THAN(@"7") ? 0 : 64, 0, SYSTEM_VERSION_LESS_THAN(@"7") ? 50 : 100, 0);
            }
                break;
            case AdsFailed:
            {
                
            }
                break;
            case AdsWillPresent:
            {
                
            }
                break;
            case AdsWillLeave:
            {
                
            }
                break;
            default:
                break;
        }
    }];
    
    dataList = [NSMutableArray new];
    
    for (id object in [[[searchBar subviews] firstObject] subviews])
    {
        if (object && [object isKindOfClass:[UITextField class]])
        {
            UITextField *textFieldObject = (UITextField *)object;
            textFieldObject.borderStyle = UITextBorderStyleNone;
            textFieldObject.textColor = [UIColor whiteColor];
            [textFieldObject withBorder:@{@"Bcorner":@(3),@"Bground":[AVHexColor colorWithHexString:@"#A9CEFC"]}];
            [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
            [textFieldObject setClearButtonMode:UITextFieldViewModeNever];
            break;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)didLoadMore
{
    isLoadMore = YES;
    
    [self didRequestData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
    isLoadMore = NO;
    
    nextPage = @"";
    
    [self didRequestData];
}

- (void)playerDidFinish:(NSDictionary*)dict
{
    if(![self getValue:@"search"])
    {
        [self addValue:@"1" andKey:@"search"];
    }
    else
    {
        int count = [[self getValue:@"search"] intValue] + 1 ;
        
        [self addValue:[NSString stringWithFormat:@"%i", count] andKey:@"search"];
    }
    
    if([[self getValue:@"search"] intValue] % 3 == 0)
    {
        [self performSelector:@selector(showAds) withObject:nil afterDelay:2];
    }
}

- (void)showAds
{
//    [[Ads sharedInstance] didShowFullAdsWithInfor:@{@"host":self,@"adsId":searchAdAPI,@"":@""} andCompletion:^(BannerEvent event, NSError *error, id banner) {
//        
//        switch (event)
//        {
//            case AdsDone:
//                
//                break;
//            case AdsFailed:
//                
//                break;
//            default:
//                break;
//        }
//    }];
    [[StartAds sharedInstance] didShowFullAdsWithInfor:@{} andCompletion:^(BannerEvent event, NSError *error, id bannerAd) {
        switch (event)
        {
            case AdsDone:
            {
                
            }
                break;
            case AdsFailed:
            {
                
            }
                break;
            case AdsWillPresent:
            {
                
            }
                break;
            case AdsWillLeave:
            {
                
            }
                break;
            default:
                break;
        }
    }];
}

- (void)didRequestData
{
    NSString * url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/search?part=snippet&q=%@|asmr -music&type=video&maxResults=25&key=AIzaSyB9IuIAwAJQhhSOQY3rn4bc9A2EjpdG_7c",searchBar.text];
    
    if(nextPage.length != 0)
    {
        url = [NSString stringWithFormat:@"%@&pageToken=%@",url,nextPage];
    }
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":[url stringByAddingPercentEscapesUsingEncoding:
    NSUTF8StringEncoding],@"method":@"GET",@"host":self,@"overrideLoading":@(1),@"overrideError":@(1)} withCache:^(NSString *cacheString) {
    } andCompletion:^(NSString *responseString, NSError *error, BOOL isValidated) {
        
        [tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:0.5];
        
        if(isValidated)
        {
            NSDictionary * dict = [responseString objectFromJSONString];
            
            nextPage = dict[@"nextPageToken"];
            
            if(dataList.count >= [dict[@"pageInfo"][@"totalResults"] intValue])
            {
                return ;
            }
            
            if(!isLoadMore)
            
                [dataList removeAllObjects];
            
            [dataList addObjectsFromArray:dict[@"items"]];
            
            NSMutableArray * arr = [NSMutableArray new];
            
            for(NSDictionary * dict in dataList)
            {
                if([dict[@"snippet"][@"title"] isEqualToString:@"Private video"])
                {
                    [arr addObject:dict];
                }
            }
            
            [dataList removeObjectsInArray:arr];
            
            [tableView reloadData];
            
            if(!isLoadMore)
            
                [tableView setContentOffset:CGPointMake(0, SYSTEM_VERSION_LESS_THAN(@"7") ? 0 : -64) animated:YES];
        }
        
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return searchBar;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count == 0 ? 1 : dataList.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return dataList.count == 0 ? 44 : 134;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dataList.count == 0)
    {
        return [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil][4];
    }
    
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    
    if(!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil][2];
    }
    
    NSDictionary * dict = dataList[indexPath.row];
    
    [((UIImageView*)[self withView:cell tag:11]) sd_setImageWithURL:[NSURL URLWithString:dict[@"snippet"][@"thumbnails"][@"default"][@"url"]] placeholderImage:kAvatar completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    ((UILabel*)[self withView:cell tag:12]).text = dict[@"snippet"][@"title"];
    
    ((UILabel*)[self withView:cell tag:14]).text = dict[@"snippet"][@"description"];
    
    [((UIView*)[self withView:cell tag:8899]) withShadow:[AVHexColor colorWithHexString:@"#F7F7F7"]];
    
    [((UIButton*)[self withView:cell tag:696]) addTapTarget:self action:@selector(didPressShare:)];
    
    [((UIButton*)[self withView:cell tag:696]) setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    
    [((UIButton*)[self withView:cell tag:697]) addTapTarget:self action:@selector(didPressFavorite:)];
    
    NSString * videoId = [NSString stringWithFormat:@"%@+%@", dataList[indexPath.row][@"snippet"][@"title"],dataList[indexPath.row][@"id"][@"videoId"]];
    
    NSArray * data = [System getFormat:@"key=%@" argument:@[videoId]];
    
    [((UIButton*)[self withView:cell tag:697]) setImage:[UIImage imageNamed:data.count == 0 ? @"add" : @"remove"] forState:UIControlStateNormal];
    
    ((UIButton*)[self withView:cell tag:697]).alpha = data.count == 0 ? 1 : 0.3;
    
    return cell;
}

- (void)didPressShare:(UIButton*)sender
{
    int indexing = [self inDexOf:sender andTable:tableView];
    
    NSString * url = [NSString stringWithFormat: @"https://www.youtube.com/watch?v=%@",dataList[indexing][@"id"][@"videoId"]];
    
    [[FB shareInstance] startShareWithInfo:@[@"Check out this ASMR video",url] andBase:sender andRoot:self andCompletion:^(NSString *responseString, id object, int errorCode, NSString *description, NSError *error) {
        
        //        NSLog(@"%i",errorCode);
        
    }];
}

- (void)didPressFavorite:(UIButton*)sender
{
    int indexing = [self inDexOf:sender andTable:tableView];
    
    NSString * videoId = [NSString stringWithFormat:@"%@+%@", dataList[indexing][@"snippet"][@"title"],dataList[indexing][@"id"][@"videoId"]];
    
    NSArray * data = [System getFormat:@"key=%@" argument:@[videoId]];
    
    if(data.count > 0)
    {
        [System removeValue:videoId];
    }
    else
    {
        [System addValue:dataList[indexing] andKey:videoId];
    }
    
    [tableView reloadData];
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
        
    YoutubeChildViewController *videoPlayerViewController = [[YoutubeChildViewController alloc] initWithVideoIdentifier:dataList[indexPath.row][@"id"][@"videoId"]];
    
    videoPlayerViewController.delegate = self;
    
    [self presentViewController:videoPlayerViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
