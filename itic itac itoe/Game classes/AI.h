/**
 * Artificial Intelligence
 *
 * @description The AI Object contains a reference to what player it is
 *              and runs all functions related to making a turn decision from game states

 */

#import <Foundation/Foundation.h>

#import "State.h"

@interface AI : NSObject

@property (nonatomic) NSInteger playerId;
@property (nonatomic, strong) State *nextMove;

-(id)initWithPlayerId:(NSInteger)playerId;
-(void)calculateNextBestMoveForState:(State *)state;


@end
