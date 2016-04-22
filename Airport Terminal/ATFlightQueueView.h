//
//  ATFlightQueueView.h
//  Airport Terminal
//
//  Created by Simon Fransson on 14/04/16.
//  Copyright © 2016 Simon Fransson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATFlightQueue, ATFlightView;

@interface ATFlightQueueView : NSView

@property (nonatomic, strong, setter=setQueue:) ATFlightQueue *queue;
@property (strong) NSMutableArray *flightViews;
@property (strong) ATFlightView *headerView;
@property (assign) NSUInteger rows;

- (instancetype)initWithFrame:(NSRect)frameRect rows:(NSUInteger)rows;
- (void)refresh;

@end
