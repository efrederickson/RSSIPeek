#import <UIKit/UIKit.h>
#import <libactivator/libactivator.h>
#define PROTEAN_PLIST_NAME @"/var/mobile/Library/Preferences/com.efrederickson.protean.settings.plist"

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