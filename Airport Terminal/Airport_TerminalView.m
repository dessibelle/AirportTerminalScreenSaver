//
//  Airport_TerminalView.m
//  Airport Terminal
//
//  Created by Simon Fransson on 06/04/16.
//  Copyright © 2016 Simon Fransson. All rights reserved.
//

#import "Airport_TerminalView.h"
#import "ATFlightQueue.h"
#import "ATFlightQueueController.h"
#import "ATFlightQueueView.h"
#import "Defines.h"


@implementation Airport_TerminalView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        NSUInteger rows = AT_NUM_DEPARTURES;
        [self loadFonts];
        
        self.queue = [[ATFlightQueue alloc] init];
        self.queueController = [[ATFlightQueueController alloc] initWithFlightQueue:self.queue];
        
        CGFloat headingHeight = 80.0,
                margin = 20.0;
        
        NSRect flightsFrame = NSMakeRect(self.frame.origin.x + margin,
                                         self.frame.origin.y + margin ,
                                         self.frame.size.width - 2 * margin,
                                         self.frame.size.height - headingHeight - 2 * margin);
        
        NSRect headingFrame = NSMakeRect(self.frame.origin.x + margin,
                                         self.frame.size.height - headingHeight - margin,
                                         self.frame.size.width,
                                         headingHeight);
        
        self.headingView = [[NSText alloc] initWithFrame:headingFrame];
        self.headingView.textColor = [NSColor whiteColor];
        self.headingView.backgroundColor = [NSColor clearColor];
        self.headingView.font = [NSFont boldSystemFontOfSize:0.8 * headingHeight];
        self.headingView.string = @"DEPARTURES";
        self.headingView.alignment = NSCenterTextAlignment;
        [self addSubview:self.headingView];
        
        self.flightQueueView = [[ATFlightQueueView alloc] initWithFrame:flightsFrame rows:rows];
        self.flightQueueView.queue = self.queue;
        
        [self addSubview:self.flightQueueView];
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation
{
    [self.queueController start];
    [self.queue addObserver:self
                 forKeyPath:@"departures"
                    options:(NSKeyValueObservingOptionNew |
                             NSKeyValueObservingOptionOld)
                    context:NULL];
    
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
    [self.queue removeObserver:self forKeyPath:@"departures"];
    [self.queueController stop];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow *)configureSheet
{
    return nil;
}

- (void)viewWillMoveToSuperview:(NSView *)newSuperview {
    if (newSuperview) {
        [self.flightQueueView refresh];
        [self setNeedsDisplay:YES];
    }
}

#pragma mark - Key-Value observation

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"departures"]) {
        [self.flightQueueView refresh];
        [self setNeedsDisplay:YES];
    }
}

#pragma mark - Private

- (void)loadFonts {
    NSString *bundleIdentifier = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleIdentifier"];

    CFErrorRef error;
    
    NSURL *fontURL = [[[[NSBundle bundleWithIdentifier:bundleIdentifier] resourceURL] URLByAppendingPathComponent:@"advanced_led_board-7"] URLByAppendingPathExtension:@"ttf"];
    
    if (!CTFontManagerRegisterFontsForURL((__bridge CFURLRef)fontURL, kCTFontManagerScopeProcess, &error)) {
        CFShow(error);
    }
}

@end
