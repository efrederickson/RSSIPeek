#import <objc/runtime.h>
#import "RSSIPeek.h"

extern BOOL hasProtean;

static PRRSSIPeek *sharedInstance;

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

static __attribute__((constructor)) void __rssi_peek_init()
{
    if ([[[NSBundle mainBundle] bundleIdentifier] isEqual:@"com.apple.springboard"])
    {
        sharedInstance = [[PRRSSIPeek alloc] init];
        [[NSClassFromString(@"LAActivator") sharedInstance] registerListener:sharedInstance forName:@"com.efrederickson.protean.rssipeek"];
    }
}
