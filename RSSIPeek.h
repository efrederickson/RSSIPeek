#import <UIKit/UIKit.h>
#import <libactivator/libactivator.h>

@interface SBStatusBarStateAggregator
+ (SBStatusBarStateAggregator*) sharedInstance;
- (_Bool)_setItem:(int)arg1 enabled:(_Bool)arg2;
- (void)_updateServiceItem;
- (void)_updateSignalStrengthItem;
@end

@class _UILegibilityImageSet;

@interface Protean
+(NSMutableDictionary*) getOrLoadSettings;
@end

@interface PRRSSIPeek : NSObject <LAListener>
@property BOOL acceptEvent;
+(instancetype) sharedInstance;
@end

@interface PRWifiRSSIPeek : NSObject <LAListener>
@property BOOL acceptEvent;
+(instancetype) sharedInstance;
@end

@interface UIStatusBarItemView
-(id) imageWithText:(id)text;
@end

@interface UIStatusBarSignalStrengthItemView : UIStatusBarItemView {
    int _signalStrengthRaw;
    int _signalStrengthBars;
    BOOL _enableRSSI;
    BOOL _showRSSI;
}

- (NSString *)_stringForRSSI;
- (_UILegibilityImageSet *)contentsImage;
- (BOOL)updateForNewData:(id)arg1 actions:(int)arg2;
- (void)touchesEnded:(id)arg1 withEvent:(id)arg2;
@end

@interface UIStatusBarDataNetworkItemView : UIStatusBarItemView {
    int _dataNetworkType;
    BOOL _enableRSSI;
    BOOL _showRSSI;
    int _wifiStrengthBars;
    int _wifiStrengthRaw;
}

- (id)_dataNetworkImage;
- (id)_stringForRSSI;
- (id)contentsImage;
- (float)extraLeftPadding;
- (float)maximumOverlap;
- (void)touchesEnded:(id)arg1 withEvent:(id)arg2;
- (BOOL)updateForNewData:(id)arg1 actions:(int)arg2;

@end