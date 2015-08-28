//
//  AI.m
//  tice tac toe
//
//  Created by Kyle Newsome on 2015-08-26.
//  Copyright (c) 2015 Kyle Newsome. All rights reserved.
//

#import "AI.h"
#import "config.h"

@implementation AI


/**
 * AI.initWithPlayerId
 * @description create a new AI for thinking on behalf of a player
 * @param playerId - An inital playerId. Can be also changed any time to 'think' as a different player
 */
-(id)initWithPlayerId:(NSInteger)playerId {
    if( (self = [super init]) ){
        self.playerId = playerId;
    }
    return self;
}

/**
 * @public AI.calculateNextBestMoveForState
 * @description The entrypoint function that kicks off AI calculations
 *              Since we know that the center point is most optimal, take it first, if available
 *              If not, we begin iterating over possible moves an evaluating with minimax & alpha beta pruning
 * @param state - The game state to evaluate
 */
-(void)calculateNextBestMoveForState:(State *)state {
    self.nextMove = nil;

    if([self takeCenterIfAvailableForState:state]) {
        return; //Top priority is taking the middle, if available
    }
    NSArray *possibleMoves = [self getPossibleNextStatesForState:state];
    NSInteger alpha = -SCORE_BOUNDS;
    NSMutableArray *choices = [NSMutableArray new];

    for(State *move in possibleMoves) {
        NSInteger score = [self minimaxForState:move depth:0 alpha:-SCORE_BOUNDS beta:SCORE_BOUNDS];
        if (score > alpha) {
            alpha = score;
            [choices removeAllObjects];
            [choices addObject: move];
        } else if (score == alpha) {
            [choices addObject: move];
        }
    }
    self.nextMove = choices[0];
}

/**
 * @private AI.takeCenterIfAvailableForState
 * @description a quick check if the center cell is empty, and set it as the next move
 * @param state - The game state to evaluate
 * @returns boolean
 */
-(BOOL)takeCenterIfAvailableForState:(State *)state {
    NSInteger centerPoint = (GRID_SIZE - 1) / 2;
    if ([state.grid[centerPoint][centerPoint] integerValue] == EMPTY) {
        self.nextMove = [state copy];
        [self.nextMove addMarkerAtRow:centerPoint column:centerPoint];
        return true;
    }
    return false;
    
}

/**
 * @private AI.getPossibleNextStates
 * @description Iterates over all possible next moves and retuns an array of cloned states
 * @param state - the game state from which to spawn possiblilities
 */
-(NSArray *)getPossibleNextStatesForState:(State *)state {
    NSMutableArray *possibilities = [NSMutableArray new];
    for(int r = 0; r < GRID_SIZE; r++) {
        for(int c = 0; c < GRID_SIZE; c++) {
            if([state.grid[r][c] integerValue] == EMPTY) {
                State *newState = [state copy];
                [newState addMarkerAtRow:r column:c];
                [possibilities addObject:newState];
            }
        }
    }
    return possibilities;
}

/**
 * @private AI.minimax
 * @description Runs through all possible states and scores them to maximize player benefit and minimize opponent benefit.
 *              Runs recursively with an increasing depth level that lowers the relative strength of states that are
 *              further down the tree of possibilities.
 *              At depth level 0 we amalgamate all possibilities and their score and pick the best scoring option
 *              Uses minimax algorithm with alpha beta pruning.
 *              See: https://en.wikipedia.org/wiki/Alpha-beta_pruning
 * @param state - The game state to evaluate
 * @param depth - How far down the possibility tree we currently are
 * @param alpha - lower boundary in alpha beta pruning
 * @param beta - upper boundary in alpha beta pruning
 * @returns score - a score value for the state
 */
-(NSInteger)minimaxForState:(State *)state depth:(NSInteger)depth alpha:(NSInteger)alpha beta:(NSInteger)beta {
    if(state.remainingMoves == 0) {
        return [self evaluateScoreForState:state depth:depth];
    }
    NSArray *possibleMoves = [self getPossibleNextStatesForState:state];
    for(NSUInteger i = 0; i < possibleMoves.count; i++) {
        State *childState = possibleMoves[i];
        NSInteger score = [self minimaxForState:childState depth:depth + 1 alpha:alpha beta:beta];
        if (state.playerTurn == _playerId) {
            alpha = MAX(alpha, score);
            if(alpha >= beta) {
                return beta;
            }
        } else {
            beta = MIN(beta, score);
            if(beta <= alpha) {
                return alpha;
            }
        }
    }
    return (state.playerTurn == _playerId) ? alpha : beta;
}


/**
 * @private AI.evaluateScore
 * @description Get the value of a final state.
 *              self function can be called with states with no remaining moves to get a score
 * @param state - the game state to evaluate
 * @param depth - how far down the tree of possibilities we are when evaluating
 */
-(NSInteger)evaluateScoreForState:(State *)state depth:(NSInteger)depth {
    NSInteger score;
    if (state.winner != EMPTY) { //there was a winner so it either positively or negatively impacts the AI player
        score = (_playerId == state.winner) ? SCORE_BOUNDS - depth : depth - SCORE_BOUNDS;
    } else {
        score = 0; // it was a draw
    }
    return score;
}

@end
