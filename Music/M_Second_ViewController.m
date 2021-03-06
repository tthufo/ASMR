//
//  M_Second_ViewController.m
//  Music
//
//  Created by thanhhaitran on 11/25/15.
//  Copyright © 2015 thanhhaitran. All rights reserved.
//

#import "M_Second_ViewController.h"

#import "YoutubeChildViewController.h"

@interface M_Second_ViewController () <UISearchBarDelegate, PlayerDelegate>
{
    IBOutlet UITableView * tableView;
    NSMutableArray * dataList;
    IBOutlet UISearchBar * searchBar;
    BOOL isSearch;
    IBOutlet UITextField * search;
    float height;
}

@end

@implementation M_Second_ViewController

- (void)playerDidFinish:(NSDictionary*)dict
{
    if(![self getValue:@"fav"])
    {
        [self addValue:@"1" andKey:@"fav"];
    }
    else
    {
        int count = [[self getValue:@"fav"] intValue] + 1 ;
        
        [self addValue:[NSString stringWithFormat:@"%i", count] andKey:@"fav"];
    }
    
    if([[self getValue:@"fav"] intValue] % 3 == 0) //&& self.interstitial.isReady)
    {
        [self performSelector:@selector(presentAds) withObject:nil afterDelay:2];
    }
}

- (void)presentAds
{
    if([[self infoPlist][@"showAds"] boolValue])
    {
        if(![[self getObject:@"adsInfo"][@"adsMob"] boolValue])
        {
            [[Ads sharedInstance] S_didShowFullAdsWithInfor:@{} andCompletion:^(BannerEvent event, NSError *error, id bannerAd) {
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
        else
        {
            if([self getObject:@"adsInfo"][@"fullBanner"])
            {
                [[Ads sharedInstance] G_didShowFullAdsWithInfor:@{@"host":self,@"adsId":[self getObject:@"adsInfo"][@"fullBanner"]/*,@"device":@""*/} andCompletion:^(BannerEvent event, NSError *error, id banner) {
                    
                    switch (event)
                    {
                        case AdsDone:
                            
                            break;
                        case AdsFailed:
                            
                            break;
                        default:
                            break;
                    }
                }];
            }
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self registerForKeyboardNotifications:NO andSelector:@[@"keyboardWasShown:",@"keyboardWillBeHidden:"]];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect f = tableView.frame;
    f.size.height -= keyboardSize.height - 50;
    tableView.frame = f;
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect f = tableView.frame;
    f.size.height += keyboardSize.height - 50;
    tableView.frame = f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[AVHexColor colorWithHexString:@"#136CFA"]}];
    
//    [self createAndLoadInterstitial];
    
    dataList = [NSMutableArray new];
    
    UIBarButtonItem * seachBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(didPressSearch)];
    
    self.navigationItem.rightBarButtonItem = seachBar;
    
    searchBar.frame = CGRectMake(0, SYSTEM_VERSION_LESS_THAN(@"7") ? 2 : 66, screenWidth, 35);
    
    searchBar.delegate = self;
    
//    search.frame = CGRectMake(0, 66, screenWidth, 35);
    
    tableView.frame = CGRectMake(0, SYSTEM_VERSION_LESS_THAN(@"7") ? 0.1 : 0, screenWidth, screenHeight - (SYSTEM_VERSION_LESS_THAN(@"7") ? 114 : 0));
    
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

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    [dataList removeAllObjects];
//    
//    if(string.length != 0)
//        [dataList addObjectsFromArray:[System getFormat:@"key contains[cd] %@" argument:@[string]]];
//    else
//        [dataList addObjectsFromArray:[System getAll]];
//    
//    [tableView reloadData];
//    
//    return YES;
//}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [dataList removeAllObjects];
    
    if(searchText.length != 0)
        [dataList addObjectsFromArray:[System getFormat:@"key contains[cd] %@" argument:@[searchText]]];
    else
        [dataList addObjectsFromArray:[System getAll]];
    
    [tableView reloadData];
}

- (void)didPressSearch
{
    if(dataList.count == 0) return;
    
    isSearch =! isSearch;
    [tableView reloadDataWithAnimation:YES];
    if(isSearch)
    {
        [self.view addSubview:searchBar];
        
        [searchBar becomeFirstResponder];
    }
    else
    {
        searchBar.text = @"";
        [dataList removeAllObjects];
        [dataList addObjectsFromArray:[System getAll]];
        [tableView reloadData];
        [searchBar resignFirstResponder];
        [searchBar removeFromSuperview];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications:YES andSelector:@[@"keyboardWasShown:",@"keyboardWillBeHidden:"]];
    
    [dataList removeAllObjects];
    
    [dataList addObjectsFromArray:[System getAll]];
    
    [tableView cellVisible];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return isSearch ? 40 : 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count == 0 ? 1 : dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return dataList.count == 0 ? 150 : 134;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(dataList.count == 0)
    {
        return [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil][3];
    }
    
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if(!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil][2];
    }
    
    NSDictionary * dict = [System getValue:((System*)dataList[indexPath.row]).key];
    
    [((UIImageView*)[self withView:cell tag:11]) sd_setImageWithURL:[NSURL URLWithString:dict[@"snippet"][@"thumbnails"][@"default"][@"url"]] placeholderImage:kAvatar completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    
    ((UILabel*)[self withView:cell tag:12]).text = dict[@"snippet"][@"title"];
    
    ((UILabel*)[self withView:cell tag:14]).text = dict[@"snippet"][@"description"];
    
    [((UIView*)[self withView:cell tag:8899]) withShadow:[AVHexColor colorWithHexString:@"#F7F7F7"]];
    
    [((UIButton*)[self withView:cell tag:696]) addTapTarget:self action:@selector(didPressShare:)];
    
    [((UIButton*)[self withView:cell tag:696]) setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    
    [((UIButton*)[self withView:cell tag:697]) addTapTarget:self action:@selector(didPressFavorite:)];
    
    NSString * videoId = [NSString stringWithFormat:@"%@+%@", dict[@"snippet"][@"title"],dict[@"snippet"][@"resourceId"][@"videoId"] ? dict[@"snippet"][@"resourceId"][@"videoId"] : dict[@"id"][@"videoId"]];
    
    NSArray * data = [System getFormat:@"key=%@" argument:@[videoId]];
    
    [((UIButton*)[self withView:cell tag:697]) setImage:[UIImage imageNamed:data.count == 0 ? @"add" : @"remove"] forState:UIControlStateNormal];
    
    ((UIButton*)[self withView:cell tag:697]).alpha = data.count == 0 ? 1 : 0.3;
    
    return cell;
}

- (void)didPressShare:(UIButton*)sender
{
    int indexing = [self inDexOf:sender andTable:tableView];
    
    NSString * url = [NSString stringWithFormat: @"https://www.youtube.com/watch?v=%@",[System getValue:((System*)dataList[indexing]).key][@"snippet"][@"resourceId"][@"videoId"] ? [System getValue:((System*)dataList[indexing]).key][@"snippet"][@"resourceId"][@"videoId"] : [System getValue:((System*)dataList[indexing]).key][@"id"][@"videoId"]];
    
    [[FB shareInstance] startShareWithInfo:@[@"Check out this ASMR video",url] andBase:sender andRoot:self andCompletion:^(NSString *responseString, id object, int errorCode, NSString *description, NSError *error) {
        
        
    }];
}

- (void)didPressFavorite:(UIButton*)sender
{
    int indexing = [self inDexOf:sender andTable:tableView];
    
    NSDictionary * dict = [System getValue:((System*)dataList[indexing]).key];
    
    NSLog(@"%@",dict);
    
    NSString * videoId = [NSString stringWithFormat:@"%@+%@", dict[@"snippet"][@"title"],dict[@"snippet"][@"resourceId"][@"videoId"] ? dict[@"snippet"][@"resourceId"][@"videoId"] : dict[@"id"][@"videoId"]];
    
    [System removeValue:videoId];

    [dataList removeAllObjects];
    
    [dataList addObjectsFromArray:[System getAll]];
    
    [tableView cellVisible];
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
    
    if(dataList.count == 0) return;
    
    NSDictionary * dict = [System getValue:((System*)dataList[indexPath.row]).key];
    
    YoutubeChildViewController *videoPlayerViewController = [[YoutubeChildViewController alloc] initWithVideoIdentifier:dict[@"snippet"][@"resourceId"][@"videoId"] ? dict[@"snippet"][@"resourceId"][@"videoId"] : dict[@"id"][@"videoId"]];
    
    videoPlayerViewController.delegate = self;
    
    [self presentViewController:videoPlayerViewController animated:YES completion:^{
        if(isSearch)
        {
            isSearch = NO;
            [tableView reloadDataWithAnimation:YES];
            searchBar.text = @"";
            [searchBar resignFirstResponder];
            [searchBar removeFromSuperview];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
