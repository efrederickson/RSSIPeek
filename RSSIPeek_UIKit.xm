#import "RSSIPeek.h"

BOOL showRSSI;
BOOL hasProtean;

%hook UIStatusBarSignalStrengthItemView
- (_UILegibilityImageSet *)contentsImage
{
    if (hasProtean)
        return %orig;
    
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
}

void disableRSSI(CFNotificationCenterRef center,
                    void *observer,
                    CFStringRef name,
                    const void *object,
                    CFDictionaryRef userInfo)
{
    showRSSI = NO;
}

%ctor
{
    %init;

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &enableRSSI, CFSTR("com.efrederickson.rssipeek/enableRSSI"), NULL, 0);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &disableRSSI, CFSTR("com.efrederickson.rssipeek/disableRSSI"), NULL, 0);

    hasProtean = [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Protean.dylib"];

}