//
//  ATFlightQueueController.m
//  Airport Terminal
//
//  Created by Simon Fransson on 13/04/16.
//  Copyright © 2016 Simon Fransson. All rights reserved.
//

#import "ATFlightQueueController.h"
#import "ATFlightQueue.h"
#import "ATFlight.h"
#import "Defines.h"

@interface ATFlightQueueController ()

@property (strong) NSArray *destinations;

- (ATFlight *)randomFlightAfterDate:(NSDate *)earliestFlightDate;
- (NSString *)randomDestinationNotInArray:(NSArray *)unavailable;
- (char)randomChar;
- (NSString *)randomFlightId;
- (NSString *)randomGateId;
- (void)setFlightStatus;
- (void)addFlight;
@end

@implementation ATFlightQueueController

- (id)initWithFlightQueue:(ATFlightQueue *)queue {
    if (self = [super init]) {
        self.queue = queue;
        self.destinations = [NSArray arrayWithArray:AT_DESTINATION_NAMES];
        self.statusTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(setFlightStatus) userInfo:nil repeats:YES];
        [self populateQueue];
    }
    return self;
}

- (void)start {
    [self.queue addObserver:self
                 forKeyPath:@"departures"
                    options:(NSKeyValueObservingOptionNew |
                             NSKeyValueObservingOptionOld)
                    context:NULL];
    
    [self addFlight];
}

- (void)stop {
    [self.queue removeObserver:self forKeyPath:@"departures"];
}

#pragma mark - Key-Value observation

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqual:@"departures"]) {
        [self populateQueue];
    }
}

#pragma mark - Private

- (ATFlight *)randomFlightAfterDate:(NSDate *)earliestFlightDate {
    NSUInteger randomOffset = (1 + arc4random() % (5 - 1)) * 90;
    NSDate *flightDate = [earliestFlightDate dateByAddingTimeInterval:randomOffset];
    
    NSString *destination = [self randomDestinationNotInArray:[self.queue.departures valueForKeyPath:@"destination"]];
    NSString *flightId = [self randomFlightId];
    NSString *gateId = [self randomGateId];
    
    ATFlight *flight = [[ATFlight alloc] initWithDestination:destination flightId:flightId gateId:gateId departureDate:flightDate];
    
    return flight;
}

- (void)setFlightStatus {
    for (ATFlight *flight in self.queue.departures) {
        NSDate *now = [NSDate date],
               *gateClosed = [flight.departureDate dateByAddingTimeInterval:-5 * 60.0],
               *boarding = [flight.departureDate dateByAddingTimeInterval:-15 * 60.0],
               *gotoGate = [flight.departureDate dateByAddingTimeInterval:-30 * 60.0];
        
        if (flight.statusCode != ATFlightStatusCancelled) {
            
            if ([now isGreaterThan:gotoGate]) {
                if ([now isGreaterThan:boarding]) {
                    if ([now isGreaterThan:gateClosed]) {
                        if ([now isGreaterThan:flight.departureDate]) {
                            flight.statusCode = ATFlightStatusDeparted;
                        } else {
                            flight.statusCode = ATFlightStatusGateClosed;
                        }
                    } else {
                        flight.statusCode = ATFlightStatusBoarding;
                    }
                } else {
                    flight.statusCode = ATFlightStatusGoToGate;
                }
            }
        }
    }
}

- (NSString *)randomDestinationNotInArray:(NSArray *)unavailable {
    NSMutableArray *available = [NSMutableArray arrayWithArray:self.destinations];
    [available removeObjectsInArray:unavailable];
    
    return [available objectAtIndex:arc4random() % available.count];
}

- (char)randomChar {
    return arc4random_uniform(25) + 'A';
}

- (NSString *)randomFlightId {
    NSUInteger flightNum = arc4random_uniform(899) + 100;
    return [NSString stringWithFormat:@"%c%c%lu", [self randomChar], [self randomChar], (unsigned long)flightNum];
}

- (NSString *)randomGateId {
    NSUInteger gateNum = 1 + arc4random() % (99 - 1);
    return [NSString stringWithFormat:@"%c%lu", [self randomChar], (unsigned long)gateNum];
}

- (void)addFlight {
    ATFlight *flight = [self randomFlightAfterDate:self.queue.latestDeparture];
    [self.queue enqueue:flight];
}

- (void)populateQueue {
    while (self.queue.numberOfDepartures < self.queue.capacity) {
        [self addFlight];
    }
    [self setFlightStatus];
}

@end
