//
//  ATFlightQueue.m
//  Airport Terminal
//
//  Created by Simon Fransson on 13/04/16.
//  Copyright © 2016 Simon Fransson. All rights reserved.
//

#import "ATFlightQueue.h"
#import "ATFlight.h"
#import "Defines.h"

@interface ATFlightQueue ()

@property (strong) NSMutableArray *flights;
@property (strong) NSTimer *timer;

- (NSDate *)departureDateForFlight:(ATFlight *)flight;
- (NSPredicate *)filterPredicate;
- (NSArray *)getDepartures;
- (NSUInteger)numberOfDepartures;
- (void)cleanup;
@end


@implementation ATFlightQueue

- (id)init {
    if (self = [self initWithCapacity:AT_NUM_DEPARTURES]) { }
    return self;
}

- (id)initWithCapacity:(NSUInteger)capacity {
    if (self = [super init]) {
        self.flights = [NSMutableArray arrayWithCapacity:capacity * 2];
        self.capacity = capacity;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:5
                                         target:self
                                       selector:@selector(cleanup)
                                       userInfo:nil
                                        repeats:YES];

    }
    return self;
}

- (void)enqueue:(ATFlight *)flight {
    NSComparator comparator = ^(id obj1, id obj2) {
        return [obj1 compare:obj2];
    };
    
    NSUInteger newIndex = [self.flights indexOfObject:flight
                                        inSortedRange:(NSRange){0, [self.flights count]}
                                              options:NSBinarySearchingInsertionIndex
                                      usingComparator:comparator];
    
    [self willChangeValueForKey:@"departures"];
    [self.flights insertObject:flight atIndex:newIndex];
    [self didChangeValueForKey:@"departures"];
}

- (void)dequeue:(ATFlight *)flight {
    [self willChangeValueForKey:@"departures"];
    [self.flights removeObject:flight];
    [self didChangeValueForKey:@"departures"];
}

- (NSDate *)earliestDeparture {
    return [self departureDateForFlight:[self.flights firstObject]];
}

- (NSDate *)latestDeparture {
    return [self departureDateForFlight:[self.flights lastObject]];
}

- (NSString *)description {
    return [self.departures description];
}

#pragma mark - Private methods

- (NSDate *)departureDateForFlight:(ATFlight *)flight {
    if (flight) {
        return flight.departureDate;
    }
    return [NSDate date];
}

- (NSPredicate *)filterPredicate {
    return [NSPredicate predicateWithFormat:@"(departureDate >= %@)", [NSDate dateWithTimeIntervalSinceNow:45.0]];
}

- (NSArray *)getDepartures {
    return [self.flights filteredArrayUsingPredicate:[self filterPredicate]];
}

- (NSUInteger)numberOfDepartures {
    return [self.getDepartures count];
}

- (void)cleanup {
    [self willChangeValueForKey:@"departures"];
    [self.flights filterUsingPredicate:[self filterPredicate]];
    [self didChangeValueForKey:@"departures"];
}

@end
