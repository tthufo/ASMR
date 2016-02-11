//
//  Ads.h
//  Pods
//
//  Created by thanhhaitran on 2/8/16.
//
//

#import <Foundation/Foundation.h>

typedef enum __bannerEvent
{
    AdsDone,
    AdsFailed,
    AdsWillPresent,
    AdsWillDismiss,
    AdsDidDismiss,
    AdsWillLeave
}BannerEvent;

typedef void (^AdsCompletion)(BannerEvent event, NSError * error, id bannerAd);

@interface Ads : NSObject

+ (Ads *)sharedInstance;

- (void)didShowBannerAdsWithInfor:(NSDictionary*)infor andCompletion:(AdsCompletion)completion;

- (void)didShowFullAdsWithInfor:(NSDictionary*)infor andCompletion:(AdsCompletion)completion;

@end
