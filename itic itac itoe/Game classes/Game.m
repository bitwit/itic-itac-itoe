//
//  Game.m
//  tice tac toe
//
//  Created by Kyle Newsome on 2015-08-26.
//  Copyright (c) 2015 Kyle Newsome. All rights reserved.
//

#import "Game.h"
#import "config.h"

@interface Game()

@property (nonatomic, strong) AI *ai;

@end

@implementation Game

-(id)init {
    if ((self = [super init])) {
        self.ai = [[AI alloc] initWithPlayerId:1];
        self.state = [[State alloc] init];
        [self reset];
    }
    return self;
}

/**
 * @public Game.newGame
 * @description create a new game state
 */
-(void)newGame {
    [self reset];
}

/**
 * @private Game.reset
 * @description resets the game state and winner state
 */
-(void)reset {
    [_state reset];
}

/**
 * @public Game.addMarkerAtPosition
 * @description Adds a new marker on the game state and checks for gameover
 */
-(BOOL)addMarkerAtRow:(NSUInteger)row column:(NSUInteger)col{
    if(_state.winner != EMPTY) {
        return false;
    } else if ([_state.grid[row][col] integerValue] != EMPTY) {
        return false;
    }
    [_state addMarkerAtRow:row column:col];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stateDidChange" object:nil];
    [self checkGameOver];
    return true;
}

/**
 * @private Game.checkGameOver
 * @description Checks the game state for a winner and notifies accordingly
 */
-(void)checkGameOver {
    if (!_state.remainingMoves) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gameDidEnd" object:nil];
    }
}

/**
 * @public Game.triggerAITurn
 * @description Trigger AI to make a decision for the player
 * @param playerId - the ID of the player to 'think' on behalf of
 */
-(void)triggerAITurnForPlayer:(NSInteger)playerId {
    _ai.playerId = playerId;
    [_ai calculateNextBestMoveForState:_state];
    State *move = _ai.nextMove;
    [self addMarkerAtRow:[move.lastMarker[0] integerValue] column:[move.lastMarker[1] integerValue]];
}

@end
