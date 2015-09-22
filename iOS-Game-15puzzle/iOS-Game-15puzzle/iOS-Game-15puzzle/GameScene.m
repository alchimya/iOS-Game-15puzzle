//
//  GameScene.m
//  iOS-Game-15puzzle
//
//  Created by Domenico Vacchiano on 21/09/15.
//  Copyright (c) 2015 DomenicoVacchiano. All rights reserved.
//

#import "GameScene.h"
#import "TileSeries.h"

@interface GameScene ()
-(void)addTiles;
-(void)invertPositionNode:(SKNode*)node1 withNode:(SKNode*)node2;
-(void)handleSwipe:(UISwipeGestureRecognizer *)sender;
-(SKSpriteNode*)getTileNodeWithNumber:(int)number andPosition:(CGPoint)position andSize:(CGSize)size;
-(NSArray*)getTrainTilesFromNode:(SKSpriteNode*)node onDirection:(UISwipeGestureRecognizerDirection) direction;
@property (nonatomic,strong)NSArray*tilesTrain;
@property (nonatomic,strong)SKAction*swipeActionSound;
@end
@implementation GameScene

-(instancetype)initWithSize:(CGSize)size{

    self=[super initWithSize:size];
    if (self) {
        //add tiles on scene
        [self addTiles];
        //init sounds
        self.swipeActionSound=[SKAction playSoundFileNamed:@"swipe.mp3" waitForCompletion:NO];
    }
    return self;

}
-(void)addTiles{
    
    //NOTE: we have to imagine the game as a grid of 4 cols and 4 rows (matrix 4x4)
    
    //creates an instance of the TileSeries object that defines a random series of 16 numbers from 0 to 15
    //0 is the empty tile
    TileSeries*tileSeries=[[TileSeries alloc]init];
    
    //we assume a margin on the right and left side of the screen, equal to the 10% of the total width
    int marginX=self.size.width*0.1;
    
    //we have that
    //size.width=(margin*2)+(tileSide*4) => tileSide=(side.width-(margin*2))/4
    int tileSide=(self.size.width-(marginX*2))/4;
    
    //defines start x and y
    int startX=marginX+tileSide/2;
    int startY=self.size.height/2 +  (tileSide + tileSide/2);
    
    //init current y and y
    int currentX=startX;
    int currentY=startY;
    
    //init curren row and col
    int currentRow=1;
    int currentCol=1;
    
    for (int i=0; i<[tileSeries count]; i++) {

        //makes a tile position
        CGPoint tilePosition=CGPointMake(currentX, currentY);
        
        //add the tileNode on the scene
        [self addChild:
                [self getTileNodeWithNumber:[[tileSeries objectAtIndex:i] intValue]
                                andPosition:tilePosition
                                andSize:CGSizeMake(tileSide, tileSide)
                 ]
        ];
        
        if (currentCol==4) {
            //if current column is equal to 4 we have to reset currentCol to 1 and the move to next row
            currentY=startY - (currentRow*tileSide);
            currentRow++;
            //reset current col
            currentCol=1;
            //reset x to start point
            currentX=startX;
        }else{
            //move to next col
            currentX= startX+(currentCol*tileSide);
            currentCol++;
        }
       
    }

}
-(SKSpriteNode*)getTileNodeWithNumber:(int)number andPosition:(CGPoint)position andSize:(CGSize)size{
    //creates a sprite node with an image formated as tile_number
    //and with a node name as number
    //NOTE: the number 0 corresponds to the empry tile
    NSString*tileName=[NSString stringWithFormat:@"tile_%d",number];
    SKSpriteNode*tile=[SKSpriteNode spriteNodeWithImageNamed:tileName];
    tile.position=position;
    tile.size=size;
    tile.name=[NSString stringWithFormat:@"%d",number];
    return tile;

}

-(void)update:(NSTimeInterval)currentTime{
 
    if ([self.tilesTrain count]==0) {
        return;
    }
    //The logic of the game is very simple.
    //The empty tile move from its position to the position of the first tile of the tile train collection
    
    u_long count=[self.tilesTrain count]-1;
    SKNode*emptyTileNode=(SKNode*)[self.tilesTrain objectAtIndex:count];
    
    for (int i=0; i<[self.tilesTrain count]; i++) {
        if (count==0) {
            break;
        }
        SKNode*tileNode=(SKNode*)[self.tilesTrain objectAtIndex:count-1];
        [self invertPositionNode:emptyTileNode withNode:tileNode];
        count--;
    }
    //play sound action
    [self runAction:self.swipeActionSound];
    
    self.tilesTrain=nil;
}
-(void)invertPositionNode:(SKNode*)node1 withNode:(SKNode*)node2{
  
    //this method invert the position of two nodes with an action
    SKAction*moveNode1=[SKAction moveTo:node2.position duration:0.1];
    SKAction*moveNode2=[SKAction moveTo:node1.position duration:0.1];

    [node1 runAction:moveNode1];
    [node2 runAction:moveNode2];
    
    node1.position=node2.position;


}

- (void)didMoveToView:(SKView *)view
{
    //defines the swip direction on view
    UISwipeGestureRecognizer *recognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
    
    UISwipeGestureRecognizer *recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerDown.direction = UISwipeGestureRecognizerDirectionDown;

    UISwipeGestureRecognizer *recognizerRigth= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerRigth.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *recognizerLeft= [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    recognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [[self view] addGestureRecognizer:recognizerUp];
    [[self view] addGestureRecognizer:recognizerDown];
    [[self view] addGestureRecognizer:recognizerRigth];
    [[self view] addGestureRecognizer:recognizerLeft];
    
}
- (void)handleSwipe:(UISwipeGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateEnded){
        CGPoint touchLocation = [sender locationInView:sender.view];
        touchLocation = [self convertPointFromView:touchLocation];
        SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
        self.tilesTrain=[self getTrainTilesFromNode:touchedNode onDirection:sender.direction];
    }
}
-(NSArray*)getTrainTilesFromNode:(SKSpriteNode*)node onDirection:(UISwipeGestureRecognizerDirection) direction  {

    //this method will find all the tiles placed before the empty tile
    //I defined this collection of tile as "train of tiles"
    
    BOOL found=NO;
    NSMutableArray*alongsideNodes=[[NSMutableArray alloc]initWithCapacity:10];
    
    [alongsideNodes addObject:node];
    //at most we will have other three tiles from starting node
    for (int i=0; i<3; i++) {
        SKNode*alongsideNode;
        switch (direction) {
            case UISwipeGestureRecognizerDirectionLeft:
                alongsideNode=(SKNode *)[self nodeAtPoint:CGPointMake(node.position.x - node.size.width*(i+1) , node.position.y)];
                break;
            case UISwipeGestureRecognizerDirectionRight:
                alongsideNode=(SKNode *)[self nodeAtPoint:CGPointMake(node.position.x + node.size.width*(i+1) , node.position.y)];
                break;
            case UISwipeGestureRecognizerDirectionUp:
                alongsideNode=(SKNode *)[self nodeAtPoint:CGPointMake(node.position.x  , node.position.y+node.size.height*(i+1))];
                break;
            case UISwipeGestureRecognizerDirectionDown:
                alongsideNode=(SKNode *)[self nodeAtPoint:CGPointMake(node.position.x  , node.position.y-node.size.height*(i+1))];
                break;
            default:
                break;
        }
        if (alongsideNode) {
            [alongsideNodes addObject:alongsideNode];
            if([alongsideNode.name isEqualToString:@"0"]){
                found=YES;
                break;
            }
        }
    }
    if (!found) {
        [alongsideNodes removeAllObjects];
    }
    
    return [alongsideNodes copy];
}

@end
