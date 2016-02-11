//
//  Ads.m
//  Pods
//
//  Created by thanhhaitran on 2/8/16.
//
//

#import "Ads.h"

#import "NSObject+Category.h"

@import GoogleMobileAds;

static Ads * __shareVar;

@interface Ads () <GADInterstitialDelegate, GADBannerViewDelegate>
{
    GADBannerView *mBannerView;
    
    GADInterstitial *interstitial;
    
    AdsCompletion compBanner, compFullBanner;
    
    NSDictionary * fullAdsInfo;
}
@end

@implementation Ads

+ (Ads *)sharedInstance
{
    if (!__shareVar)
    {
        __shareVar = [[Ads alloc] init];
    }
    return __shareVar;
}

- (void)didShowBannerAdsWithInfor:(NSDictionary*)infor andCompletion:(AdsCompletion)completion
{
    compBanner = completion;
    
    mBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    
    mBannerView.delegate = self;
    
    mBannerView.frame = CGRectMake(([infor[@"X"] floatValue] - mBannerView.frame.size.width) / 2, [infor[@"Y"] floatValue], mBannerView.frame.size.width, mBannerView.frame.size.height);
        
    mBannerView.adUnitID = infor[@"adsId"];
    
    mBannerView.rootViewController = infor[@"host"];
    
    [((UIViewController*)infor[@"host"]).view addSubview:mBannerView];
    
    GADRequest *request = [GADRequest request];
    
    if([infor responseForKey:@"device"])
    {
        mBannerView.backgroundColor = [UIColor redColor];

        NSMutableArray * arr = [[NSMutableArray alloc] initWithObjects:kGADSimulatorID, nil];
        
        if(((NSString*)infor[@"device"]).length != 0)
        {
            [arr addObject:infor[@"device"]];
        }
        
        request.testDevices = arr;
    }
    
    [mBannerView loadRequest:request];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    compBanner(AdsDone, nil, bannerView);
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    compBanner(AdsFailed, error, bannerView);
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView
{
    compBanner(AdsWillPresent, nil, bannerView);
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView
{
    compBanner(AdsWillDismiss, nil, bannerView);
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView
{
    compBanner(AdsDidDismiss, nil, bannerView);
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView
{
    compBanner(AdsWillLeave, nil, bannerView);
}

#pragma FullAds

- (void)didShowFullAdsWithInfor:(NSDictionary*)infor andCompletion:(AdsCompletion)completion
{
    compFullBanner = completion;
    
    fullAdsInfo = infor;
    
    [self didCreateFullAds:infor];
}

- (void)didCreateFullAds:(NSDictionary*)infor
{
    interstitial = nil;
    
    interstitial = [[GADInterstitial alloc] initWithAdUnitID:infor[@"adsId"]];
    
    interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    
    if([infor responseForKey:@"device"])
    {
        NSMutableArray * arr = [[NSMutableArray alloc] initWithObjects:kGADSimulatorID, nil];
        
        if(((NSString*)infor[@"device"]).length != 0)
        {
            [arr addObject:infor[@"device"]];
        }
        
        request.testDevices = arr;
    }
    
    [interstitial loadRequest:request];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    compFullBanner(AdsDone, nil, ad);
    
    if(interstitial.isReady)
        [interstitial presentFromRootViewController:fullAdsInfo[@"host"]];
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    compFullBanner(AdsFailed, error, nil);
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    compFullBanner(AdsWillPresent, nil, ad);
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    compFullBanner(AdsWillDismiss, nil, ad);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    compFullBanner(AdsDidDismiss, nil, ad);
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad
{
    compFullBanner(AdsWillLeave, nil, ad);
}

@end
