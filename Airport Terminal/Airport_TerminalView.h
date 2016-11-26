//
//  Airport_TerminalView.h
//  Airport Terminal
//
//  Created by Simon Fransson on 06/04/16.
//  Copyright © 2016 Simon Fransson. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@class ATFlightQueue, ATFlightQueueController, ATFlightQueueView;

@interface Airport_TerminalView : ScreenSaverView

@property (strong) ATFlightQueue *queue;
@property (strong) ATFlightQueueController *queueController;
@property (strong) ATFlightQueueView *flightQueueView;
@property (strong) NSTextView *headingView;

@end
