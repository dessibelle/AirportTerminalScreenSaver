//
//  ATFlight.h
//  Airport Terminal
//
//  Created by Simon Fransson on 13/04/16.
//  Copyright © 2016 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ATFlightStatus) {
    ATFlightStatusNone,
    ATFlightStatusGoToGate,
    ATFlightStatusBoarding,
    ATFlightStatusGateClosed,
    ATFlightStatusDeparted,
    ATFlightStatusDelayed,
    ATFlightStatusNewTime,
    ATFlightStatusCancelled
};


@interface ATFlight : NSObject

@property (strong) NSDate *departureDate;
@property (copy) NSString *destination;
@property (copy) NSString *flightId;
@property (copy) NSString *gateId;
@property (assign) ATFlightStatus statusCode;
@property (readonly, getter=status) NSString *status;

- (id)initWithDestination:(NSString *)destination flightId:(NSString *)flightId gateId:(NSString *)gateId departureDate:(NSDate *)departureDate;
- (NSComparisonResult)compare:(NSDate *)anotherFlight;

@end
