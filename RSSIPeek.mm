#import <objc/runtime.h>
#import "RSSIPeek.h"

@implementation PRRSSIPeek
+(instancetype) sharedInstance
{
    static PRRSSIPeek *shared = nil;
    if (!shared)
        shared = [[PRRSSIPeek alloc] init];
    return shared;
}

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
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.efrederickson.rssipeek/enableRSSI"), nil, nil, YES);
    _acceptEvent = NO;
}

- (void)hideRSSI
{
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.efrederickson.rssipeek/disableRSSI"), nil, nil, YES);
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

@implementation PRWifiRSSIPeek

+(instancetype) sharedInstance
{
    static PRWifiRSSIPeek *shared = nil;
    if (!shared)
        shared = [[PRWifiRSSIPeek alloc] init];
    return shared;
}

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
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist"];
    plistDict[@"SBShowRSSI"] = @YES;
    [plistDict writeToFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist" atomically:YES];
    GSSendAppPreferencesChanged(CFSTR("com.apple.springboard"), CFSTR("SBShowRSSI"));
    
    _acceptEvent = NO;
}

- (void)hideRSSI
{
    NSMutableDictionary *plistDict = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist"];
    plistDict[@"SBShowRSSI"] = @NO;
    [plistDict writeToFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist" atomically:YES];
    GSSendAppPreferencesChanged(CFSTR("com.apple.springboard"), CFSTR("SBShowRSSI"));

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
        [[NSClassFromString(@"LAActivator") sharedInstance] registerListener:[PRRSSIPeek sharedInstance] forName:@"com.efrederickson.protean.rssipeek"];

        [[NSClassFromString(@"LAActivator") sharedInstance] registerListener:[PRWifiRSSIPeek sharedInstance] forName:@"com.efrederickson.wifirssipeek"];
    }
}
