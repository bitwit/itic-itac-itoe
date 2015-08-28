/**
 * Game Object
 *
 * @constructor Game
 * @description The game shell object that is exposed globally for interacting with
 */

#import <Foundation/Foundation.h>

#import "AI.h"
#import "State.h"


@interface Game : NSObject

@property (nonatomic, strong) State *state;

-(void)newGame;
-(void)reset;
-(BOOL)addMarkerAtRow:(NSUInteger)row column:(NSUInteger)col;
-(void)checkGameOver;
-(void)triggerAITurnForPlayer:(NSInteger)playerId;

@end
