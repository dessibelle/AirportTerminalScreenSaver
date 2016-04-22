//
//  ATFlightQueue.h
//  Airport Terminal
//
//  Created by Simon Fransson on 13/04/16.
//  Copyright © 2016 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATFlight;

@interface ATFlightQueue : NSObject

@property (assign) NSUInteger capacity;
@property (readonly, getter=numberOfDepartures) NSUInteger numberOfDepartures;
@property (readonly, getter=getDepartures) NSArray *departures;

- (id)initWithCapacity:(NSUInteger)capacity;
- (void)enqueue:(ATFlight *)flight;
- (void)dequeue:(ATFlight *)flight;
- (NSDate *)earliestDeparture;
- (NSDate *)latestDeparture;

@end
