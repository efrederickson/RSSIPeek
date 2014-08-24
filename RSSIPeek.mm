#import <objc/runtime.h>
#import "RSSIPeek.h"

extern BOOL hasProtean;

static PRRSSIPeek *sharedInstance;
static BOOL oldShowRSSI; // Protean

@implementation PRRSSIPeek

- (id)init
{
    self = [super init];
    if (self) {
        _acceptEvent = YES;
    }
    return self;
}

- (void)showRSSI
{
    if (hasProtean)
    {
        oldShowRSSI = [[objc_getClass("Protean") getOrLoadSettings][@"showSignalRSSI"] boolValue];
        NSMutableDictionary *prefs = [[objc_getClass("Protean") getOrLoadSettings] mutableCopy];
        prefs[@"showSignalRSSI"] = @YES;
        [prefs writeToFile:PROTEAN_PLIST_NAME atomically:YES];
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.efrederickson.protean/reloadSettings"), nil, nil, YES);
    }
    else
    {
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.efrederickson.rssipeek/enableRSSI"), nil, nil, YES);
    }
    
    [((SBStatusBarStateAggregator*)[objc_getClass("SBStatusBarStateAggregator") sharedInstance]) _setItem:3 enabled:NO];
    [((SBStatusBarStateAggregator*)[objc_getClass("SBStatusBarStateAggregator") sharedInstance]) _updateSignalStrengthItem];
    
    _acceptEvent = NO;
}

- (void)hideRSSI
{
    if (hasProtean)
    {
        NSMutableDictionary *prefs = [[objc_getClass("Protean") getOrLoadSettings] mutableCopy];
        prefs[@"showSignalRSSI"] = oldShowRSSI ? @YES : @NO;
        [prefs writeToFile:PROTEAN_PLIST_NAME atomically:YES];
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.efrederickson.protean/reloadSettings"), nil, nil, YES);
    }
    else
    { 
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.efrederickson.rssipeek/disableRSSI"), nil, nil, YES);
    }
    
    [((SBStatusBarStateAggregator*)[objc_getClass("SBStatusBarStateAggregator") sharedInstance]) _setItem:3 enabled:NO];
    [((SBStatusBarStateAggregator*)[objc_getClass("SBStatusBarStateAggregator") sharedInstance]) _updateSignalStrengthItem];
    
    _acceptEvent = YES;
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
    if (_acceptEvent)
    {
        [self showRSSI];
        [self performSelector:@selector(hideRSSI) withObject:nil afterDelay:2]; // 1.5? 2.5? hmm
    }
    [event setHandled:YES];
}

@end

static __attribute__((constructor)) void __rssi_peek_init()
{
    if ([[[NSBundle mainBundle] bundleIdentifier] isEqual:@"com.apple.springboard"])
    {
        sharedInstance = [[PRRSSIPeek alloc] init];
        [[NSClassFromString(@"LAActivator") sharedInstance] registerListener:sharedInstance forName:@"com.efrederickson.protean.rssipeek"];
    }
}
