//
//  ATFlightView.m
//  Airport Terminal
//
//  Created by Simon Fransson on 14/04/16.
//  Copyright © 2016 Simon Fransson. All rights reserved.
//

#import "ATFlightView.h"
#import "ATFlight.h"

@interface ATFlightView ()
@property (strong) NSDateFormatter *timeFormatter;
@property (strong) NSFont *statusFont;
@property (nonatomic, strong, readonly, getter=stringAttributes) NSDictionary *stringAttributes;
- (NSAttributedString *)attributedString:(NSString *)string overridingAttributes:(NSDictionary *)overrides;
@end


@implementation ATFlightView

- (instancetype)initWithFrame:(NSRect)frameRect {
    if (self = [super initWithFrame:frameRect]) {
        
        self.time = [[NSCell alloc] initTextCell:@""];
        self.destination = [[NSCell alloc] initTextCell:@""];
        self.flightId = [[NSCell alloc] initTextCell:@""];
        self.gateId = [[NSCell alloc] initTextCell:@""];
        self.status = [[NSCell alloc] initTextCell:@""];
        
        self.timeFormatter = [[NSDateFormatter alloc] init];;
        [self.timeFormatter setDateFormat:@"HH:mm"];
        
        self.color = [NSColor yellowColor];
        self.font = [NSFont fontWithName:@"AdvancedLEDBoard-7" size:self.frame.size.height * 0.8];
//        self.statusFont = [NSFont fontWithName:@"AdvancedLEDBoard-7" size:self.frame.size.height * 0.4];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    [self.time drawInteriorWithFrame:NSMakeRect(0.0 * self.frame.size.width, 0.0, 0.15 * self.frame.size.width, self.frame.size.height) inView:self];
    [self.destination drawInteriorWithFrame:NSMakeRect(0.15 * self.frame.size.width, 0.0, 0.35 * self.frame.size.width, self.frame.size.height) inView:self];
    [self.flightId drawInteriorWithFrame:NSMakeRect(0.5 * self.frame.size.width, 0.0, 0.15 * self.frame.size.width, self.frame.size.height) inView:self];
    [self.gateId drawInteriorWithFrame:NSMakeRect(0.65 * self.frame.size.width, 0.0, 0.1 * self.frame.size.width, self.frame.size.height) inView:self];
    [self.status drawInteriorWithFrame:NSMakeRect(0.75 * self.frame.size.width, 0.0, 0.25 * self.frame.size.width, self.frame.size.height) inView:self];
}

- (void)refresh {
    NSMutableDictionary *values = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"", @"time",
                                   @"", @"destination",
                                   @"", @"flightId",
                                   @"", @"gateId",
                                   @"", @"status",
                                   nil];
    
    if (self.flight) {
        [values setObject:[self.timeFormatter stringFromDate:self.flight.departureDate] forKey:@"time"];
        
        [values setObject:self.flight.destination forKey:@"destination"];
        [values setObject:self.flight.flightId forKey:@"flightId"];
        [values setObject:self.flight.gateId forKey:@"gateId"];
        [values setObject:self.flight.status forKey:@"status"];
    }
    
    [self setValues:values];
    [self setNeedsDisplay:YES];
}

- (void)setValues:(NSDictionary *)values {
//    NSDictionary *statusAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
//                                      self.statusFont, NSFontAttributeName,
//                                      [NSNumber numberWithFloat:0.0], NSBaselineOffsetAttributeName,
//                                      nil];
    
    self.time.attributedStringValue = [self attributedString:[values objectForKey:@"time"] overridingAttributes:nil];
    self.destination.attributedStringValue = [self attributedString:[values objectForKey:@"destination"] overridingAttributes:nil];
    self.flightId.attributedStringValue = [self attributedString:[values objectForKey:@"flightId"] overridingAttributes:nil];
    self.gateId.attributedStringValue = [self attributedString:[values objectForKey:@"gateId"] overridingAttributes:nil];
    self.status.attributedStringValue = [self attributedString:[values objectForKey:@"status"] overridingAttributes:nil];
}

#pragma mark - Private

- (NSAttributedString *)attributedString:(NSString *)string overridingAttributes:(NSDictionary *)overrides {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:self.stringAttributes];
    
    if (overrides != nil) {
        [attributes addEntriesFromDictionary:overrides];
    }
    
    return [[NSAttributedString alloc] initWithString:string attributes:attributes];
}

- (NSDictionary *)stringAttributes {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            self.font, NSFontAttributeName,
            self.color, NSForegroundColorAttributeName,
            nil];
}

@end
