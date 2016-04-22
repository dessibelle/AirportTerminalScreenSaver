//
//  ATFlightQueueController.h
//  Airport Terminal
//
//  Created by Simon Fransson on 13/04/16.
//  Copyright © 2016 Simon Fransson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ATFlightQueue;

@interface ATFlightQueueController : NSObject

@property (strong) ATFlightQueue *queue;
@property (strong) NSTimer *statusTimer;

- (id)initWithFlightQueue:(ATFlightQueue *)queue;
- (void)start;
- (void)stop;

@end
