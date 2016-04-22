//
//  ATFlight.m
//  Airport Terminal
//
//  Created by Simon Fransson on 13/04/16.
//  Copyright © 2016 Simon Fransson. All rights reserved.
//

#import "ATFlight.h"

@implementation ATFlight


- (id)init {
    if (self = [super init]) {
        self.statusCode = ATFlightStatusNone;
    }
    return self;
}

- (id)initWithDestination:(NSString *)destination flightId:(NSString *)flightId gateId:(NSString *)gateId departureDate:(NSDate *)departureDate {
    if (self = [self init]) {
        self.destination = destination;
        self.flightId = flightId;
        self.gateId = gateId;
        self.departureDate = departureDate;
    }
    return self;
}

- (NSComparisonResult)compare:(ATFlight *)anotherFlight {
    return [self.departureDate compare:anotherFlight.departureDate];
}

- (NSString *)status {
    switch (self.statusCode) {
        case ATFlightStatusGoToGate:
            return @"Go to gate";
            break;
        case ATFlightStatusBoarding:
            return @"Boarding";
            break;
        case ATFlightStatusGateClosed:
            return @"Gate closed";
            break;
        case ATFlightStatusDeparted:
            return @"Departed";
            break;
        case ATFlightStatusDelayed:
            return @"Delayed";
            break;
        case ATFlightStatusNewTime:
            return @"New time";
            break;
        case ATFlightStatusCancelled:
            return @"Cancelled";
            break;
        default:
            return @"";
            break;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ - %@ - %@ - %@ - %@", self.departureDate, self.destination, self.flightId, self.gateId, self.status];
}

@end
