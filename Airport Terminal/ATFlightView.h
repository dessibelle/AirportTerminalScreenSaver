//
//  ATFlightView.h
//  Airport Terminal
//
//  Created by Simon Fransson on 14/04/16.
//  Copyright © 2016 Simon Fransson. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ATFlight;

@interface ATFlightView : NSView

@property (strong) ATFlight *flight;

@property (strong) NSCell *time;
@property (strong) NSCell *destination;
@property (strong) NSCell *flightId;
@property (strong) NSCell *gateId;
@property (strong) NSCell *status;

@property (strong) NSFont *font;
@property (strong) NSColor *color;

- (void)refresh;
- (void)setValues:(NSDictionary *)values;

@end
