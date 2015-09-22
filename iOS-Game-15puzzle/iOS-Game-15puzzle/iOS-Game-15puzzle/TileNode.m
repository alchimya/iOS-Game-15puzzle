//
//  BlockNumber.m
//  iOS-Game-15puzzle
//
//  Created by Domenico Vacchiano on 21/09/15.
//  Copyright © 2015 DomenicoVacchiano. All rights reserved.
//

#import "TileNode.h"


@implementation TileNode
@synthesize tileNumber;

-(instancetype)initWithNumber:(int)number andPosition:(CGPoint)position andSize:(CGSize)size{
    self=[super init];
    if (self) {
        NSString*tileName=[NSString stringWithFormat:@"tile_%d",number];
        SKSpriteNode*tile=[SKSpriteNode spriteNodeWithImageNamed:tileName];
        tile.position=position;
        tile.size=size;
        tile.name=tileName;
        self.tileNumber=number;
        [self addChild:tile];
    }
    
    return self;

}

@end
