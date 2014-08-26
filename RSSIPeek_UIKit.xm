#import "RSSIPeek.h"

BOOL showRSSI;

%hook UIStatusBarSignalStrengthItemView
- (_UILegibilityImageSet *)contentsImage
{
    if (showRSSI)
    {
		return [self imageWithText:[self _stringForRSSI]];
	}
    
    return %orig;
}
%end

void enableRSSI(CFNotificationCenterRef center,
                    void *observer,
                    CFStringRef name,
                    const void *object,
                    CFDictionaryRef userInfo)
{
    showRSSI = YES;


    [((SBStatusBarStateAggregator*)[objc_getClass("SBStatusBarStateAggregator") sharedInstance]) _setItem:3 enabled:NO];
    [((SBStatusBarStateAggregator*)[objc_getClass("SBStatusBarStateAggregator") sharedInstance]) _updateSignalStrengthItem];
    
}

void disableRSSI(CFNotificationCenterRef center,
                    void *observer,
                    CFStringRef name,
                    const void *object,
                    CFDictionaryRef userInfo)
{
    showRSSI = NO;


    [((SBStatusBarStateAggregator*)[objc_getClass("SBStatusBarStateAggregator") sharedInstance]) _setItem:3 enabled:NO];
    [((SBStatusBarStateAggregator*)[objc_getClass("SBStatusBarStateAggregator") sharedInstance]) _updateSignalStrengthItem];
    
}

%ctor
{
    %init;

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &enableRSSI, CFSTR("com.efrederickson.rssipeek/enableRSSI"), NULL, 0);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &disableRSSI, CFSTR("com.efrederickson.rssipeek/disableRSSI"), NULL, 0);
}