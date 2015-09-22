//
//  BlockNumber.h
//  iOS-Game-15puzzle
//
//  Created by Domenico Vacchiano on 21/09/15.
//  Copyright © 2015 DomenicoVacchiano. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TileNode : SKNode
-(instancetype)initWithNumber:(int)number andPosition:(CGPoint)position andSize:(CGSize)size;
@property (nonatomic,assign) int tileNumber;
@end
