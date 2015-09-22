//
//  TileSeries.m
//  iOS-Game-15puzzle
//
//  Created by Domenico Vacchiano on 21/09/15.
//  Copyright © 2015 DomenicoVacchiano. All rights reserved.
//

#import "TileSeries.h"

@implementation TileSeries


-(instancetype)init{

    self=[super init];
    if (self) {
        NSMutableArray*tempSeries=[[NSMutableArray alloc] initWithCapacity:15];
        int seriesMax=16;
        
        for (int i=0; i<seriesMax; i++) {
            //generates a random mumber from 0 to 16
            //zero is the empty tile
            int random=arc4random_uniform(seriesMax);
            BOOL exists=[tempSeries containsObject:[NSNumber numberWithInt:random]];
            while (exists) {
                random=arc4random_uniform(seriesMax);
                exists=[tempSeries containsObject:[NSNumber numberWithInt:random]];
            }
            [tempSeries addObject:[NSNumber numberWithInt:random]];

        }
        self=[tempSeries copy];
    }
    return self;

}


@end
