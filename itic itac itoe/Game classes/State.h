/**
 * Game State
 *
 * @description Stores all information about the game state at any given time
 *              It can be easily copied to spawn all possible states for AI decisions making
 */

#import <Foundation/Foundation.h>

@interface State : NSObject

@property(nonatomic, strong) NSMutableArray *grid;

@property(nonatomic) NSInteger playerTurn; // 0 will represent 'O' and 1 will represent 'X'
@property(nonatomic) NSInteger remainingMoves;
@property(nonatomic) NSInteger winner;
@property(nonatomic, strong) NSArray *lastMarker;
@property(nonatomic, strong) NSArray *winningLine;

/**
 * @public State.copy
 * @description Creates a new state and copies all current property values
 * @returns newState - A completely new state
 */
-(State *)copy;

-(void)reset;

-(void)switchTurn;

-(void)addMarkerAtRow:(NSInteger)row column:(NSInteger)col;

-(void)checkForWinner;

@end

