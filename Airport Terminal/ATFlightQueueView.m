//
//  ATFlightQueueView.m
//  Airport Terminal
//
//  Created by Simon Fransson on 14/04/16.
//  Copyright © 2016 Simon Fransson. All rights reserved.
//

#import "ATFlightQueueView.h"
#import "ATFlightView.h"
#import "ATFlightQueue.h"
#import "Defines.h"


@interface ATFlightQueueView ()
- (void)setQueue:(ATFlightQueue *)queue;
- (void)setupSubviews;
@end

@implementation ATFlightQueueView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [self initWithFrame:frameRect rows:AT_NUM_DEPARTURES]) { }
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect rows:(NSUInteger)rows {
    if (self = [super initWithFrame:frameRect]) {
        self.flightViews = [NSMutableArray array];
        self.rows = rows;
        
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Private

- (void)setQueue:(ATFlightQueue *)queue {
    _queue = queue;
    [self setNeedsDisplay:YES];
}

- (void)refresh {
    NSUInteger idx = 0;
    for (ATFlightView *flightView in self.flightViews) {
        
        if (idx < self.queue.departures.count) {
            flightView.flight = [self.queue.departures objectAtIndex:idx];
        } else {
            flightView.flight = nil;
        }
        
        [flightView refresh];
        idx++;
    }
}

- (void)setupSubviews {
    CGFloat margin = 10.0,
    headerHeight = 40.0,
    rowWidth = self.frame.size.width - 2 * margin,
    rowHeight = (self.frame.size.height - headerHeight - margin - (self.rows + 1) * margin) / (self.rows);
    
    self.headerView = [[ATFlightView alloc] initWithFrame:NSMakeRect(margin, self.frame.size.height - margin - headerHeight, rowWidth, headerHeight)];
    self.headerView.font = [NSFont boldSystemFontOfSize:self.headerView.frame.size.height * 0.8];
    self.headerView.color = [NSColor whiteColor];
    [self.headerView setValues:[NSDictionary dictionaryWithObjectsAndKeys:
                                @"TIME", @"time",
                                @"DESTINATION", @"destination",
                                @"FLIGHT", @"flightId",
                                @"GATE", @"gateId",
                                @"REMARKS", @"status",
                                nil]];
    [self addSubview:self.headerView];
    
    for (NSUInteger rowIdx = 0; rowIdx < self.rows; rowIdx++) {
        NSRect rect = NSMakeRect(margin, self.frame.size.height - headerHeight - margin - ((rowIdx + 1) * (margin + rowHeight)), rowWidth, rowHeight);
        NSView *rowView = [[ATFlightView alloc] initWithFrame:rect];
        
        [self addSubview:rowView];
        [self.flightViews addObject:rowView];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

@end
