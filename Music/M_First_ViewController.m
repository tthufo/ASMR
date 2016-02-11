//
//  M_First_ViewController.m
//  Music
//
//  Created by thanhhaitran on 11/24/15.
//  Copyright © 2015 thanhhaitran. All rights reserved.
//

#import "M_First_ViewController.h"

#import "XCDYouTubeVideoPlayerViewController.h"

#import "M_Detail_ViewController.h"

#import "LMDropdownViewChild.h"

#import "AppDelegate.h"

@interface M_First_ViewController ()<LMDropdownViewDelegate>
{
    IBOutlet UITableView * tableView, *dropTableView;
    LMDropdownViewChild * dropdownView;
    NSMutableArray * dataList, * menuList;
    NSString * nextPage, * currentId;
    int totalResult;
    BOOL isLoadMore;
}

@end

@implementation M_First_ViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[AVHexColor colorWithHexString:@"#136CFA"]}];
    
    dataList = [NSMutableArray new];
    
    menuList = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithContentsOfPlist:@"MenuList"]];
    
    nextPage = @"";
    
    UIBarButtonItem * menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:SYSTEM_VERSION_LESS_THAN(@"7") ? @"menu6" : @"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(didPressMenu)];
    self.navigationItem.leftBarButtonItem = menu;

    UIBarButtonItem * share = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didPressShare)];
    self.navigationItem.rightBarButtonItem = share;

    
    currentId = [menuList firstObject][@"id"];
    
    self.title = [menuList firstObject][@"title"];
    
    [self didRequestData:currentId];
    
    __weak M_First_ViewController * weakSelf  = self;
    
    [tableView addFooterWithBlock:^{
        
        [weakSelf didLoadMore];
        
    } withIndicatorColor:[UIColor grayColor]];
    
    UIRefreshControl * refresh = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    refresh.tag = 6996;
    [refresh addTarget:self action:@selector(didReload) forControlEvents:UIControlEventValueChanged];
    [tableView addSubview:refresh];
}

- (void)didPressShare
{
    [[FB shareInstance] startShareWithInfo:@[@"ASMRTube for your relaxation and more ",@"https://itunes.apple.com/us/developer/thanh-hai-tran/id1073174100",[UIImage imageNamed:@"Icon-76"]] andBase:nil andRoot:self andCompletion:^(NSString *responseString, id object, int errorCode, NSString *description, NSError *error) {
        
    }];
}

- (void)didRequestData:(NSString *)channelId
{
//    NSString * string = @"https://www.googleapis.com/youtube/v3/search?part=snippet&q=katyperry&type=video&maxResults=25&key=AIzaSyB9IuIAwAJQhhSOQY3rn4bc9A2EjpdG_7c";
    
//  https://www.googleapis.com/youtube/v3/channels?part=snippet&id=UCX70sfic86MKcid2n0mmmqg&fields=itemssnippet%2Fthumbnails&key=AIzaSyB9IuIAwAJQhhSOQY3rn4bc9A2EjpdG_7c
    
    NSString * url = [NSString stringWithFormat:@"https://www.googleapis.com/youtube/v3/playlists?part=snippet&channelId=%@&type=video&maxResults=25&key=AIzaSyB9IuIAwAJQhhSOQY3rn4bc9A2EjpdG_7c",channelId];

    if(nextPage.length != 0)
    {
        url = [NSString stringWithFormat:@"%@&pageToken=%@",url,nextPage];
    }
    
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":url,@"method":@"GET",@"host":self,@"overrideError":@(1)} withCache:^(NSString *cacheString) {
        
        [self didSetupData:cacheString];
        
    } andCompletion:^(NSString *responseString, NSError *error, BOOL isValidated) {
        
        [((UIRefreshControl*)[self withView:tableView tag:6996]) endRefreshing];
        
        [tableView performSelector:@selector(footerEndRefreshing) withObject:nil afterDelay:0.5];
        
        if(isValidated)
        {
            [self didSetupData:responseString];
        }
        
    }];
}

- (void)didSetupData:(NSString*)json
{
    NSDictionary * dict = [json objectFromJSONString];
    
    nextPage = dict[@"nextPageToken"];
    
    if(dataList.count >= [dict[@"pageInfo"][@"totalResults"] intValue])
    {
        return ;
    }
    
    if(!isLoadMore)
    {
        [dataList removeAllObjects];
    }
    
    [dataList addObjectsFromArray:dict[@"items"]];
    
    [tableView reloadData];
}

- (void)didPressMenu
{
    if (!dropdownView)
    {
        dropdownView = [[LMDropdownViewChild alloc] init];
        dropdownView.delegate = self;
        dropdownView.menuContentView = dropTableView;
        dropdownView.menuBackgroundColor = [UIColor whiteColor];
        CGRect rect = dropTableView.frame;
        rect.size.height = screenHeight - 64 - 50;
        rect.size.width = screenWidth;
        dropTableView.frame = rect;
    }
    if ([dropdownView isOpen])
    {
        [dropdownView hide];
    }
    else
    {
        [dropdownView showInView:self.view withFrame:CGRectMake(0, SYSTEM_VERSION_LESS_THAN(@"7") ? 0 : 64, screenWidth, screenHeight)];
    }
}

- (void)didReload
{
    isLoadMore = NO;
    [self didRequestData:currentId];
}

- (void)didLoadMore
{
    isLoadMore = YES;
    [self didRequestData:currentId];
}

-(NSInteger)tableView:(UITableView *)_tableView numberOfRowsInSection:(NSInteger)section
{
    return _tableView.tag == 111 ? 10 : dataList.count;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _tableView.tag == 111 ? 70 : 90;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:_tableView.tag == 111 ? @"menuCell" : @"listCell"];
    if(!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil][_tableView.tag == 111 ? 1 : 0];
    }
    
    if(_tableView.tag != 111)
    {
        NSDictionary * dict = dataList[indexPath.row];
        
        [((UIImageView*)[self withView:cell tag:11]) sd_setImageWithURL:[NSURL URLWithString:dict[@"snippet"][@"thumbnails"][@"default"][@"url"]] placeholderImage:kAvatar completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
        
        ((UILabel*)[self withView:cell tag:12]).text = dict[@"snippet"][@"title"];
        
        [((UIView*)[self withView:cell tag:8899]) withShadow:[AVHexColor colorWithHexString:@"#F7F7F7"]];
    }
    else
    {
        [((UIImageView*)[self withView:cell tag:11]) sd_setImageWithURL:[NSURL URLWithString:menuList[indexPath.row][@"image"]] placeholderImage:kAvatar options:SDWebImageCacheMemoryOnly];
        
        ((UILabel*)[self withView:cell tag:12]).text = menuList[indexPath.row][@"title"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(_tableView.tag != 111)
    {
        M_Detail_ViewController * detail = [M_Detail_ViewController new];
        detail.playListId = dataList[indexPath.row][@"id"];
        detail.titleName = self.title;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else
    {
        isLoadMore = NO;
        nextPage = @"";
        [dropdownView hide];
        currentId = menuList[indexPath.row][@"id"];
        self.title = menuList[indexPath.row][@"title"];
        [dataList removeAllObjects];
        [self didRequestData:currentId];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
