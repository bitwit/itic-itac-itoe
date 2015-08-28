//
//  State.m
//  tice tac toe
//
//  Created by Kyle Newsome on 2015-08-26.
//  Copyright (c) 2015 Kyle Newsome. All rights reserved.
//

#import "State.h"

#import "config.h"

static NSMutableArray *lines;

@implementation State

/*
* static lines
* We build the valid game lines once when it is called the first time
*/
+(NSArray *)lines {
    if (lines == nil) {
        lines = [[NSMutableArray alloc] init];
        NSMutableArray *diagonalTopLeft = [NSMutableArray new];
        NSMutableArray *diagonalBottomLeft = [NSMutableArray new];
        for(int i = 0; i < GRID_SIZE; i++) {
            NSMutableArray *rowLine = [NSMutableArray new];
            NSMutableArray *colLine = [NSMutableArray new];
            for(int j = 0; j < GRID_SIZE; j++) {
                [rowLine addObjectsFromArray:@[@(i), @(j)]];
                [colLine addObjectsFromArray:@[@(j), @(i)]];
            }
            [lines addObjectsFromArray: @[rowLine, colLine]];
            [diagonalTopLeft addObjectsFromArray:@[@(i), @(i)]];
            [diagonalBottomLeft addObjectsFromArray:@[@(GRID_SIZE - 1 - i), @(i)]];
        }
        [lines addObjectsFromArray: @[diagonalTopLeft, diagonalBottomLeft]];
    }
    return lines;
}

/**
 * Init
 * @description Calculate our valid winning line possibilities based on grid size
 *              Line combinations are stored in the format of:
 *              winningCombination = [r,c, r,c, r,c]
 */
-(id)init {
    if ( (self = [super init]) ) {
        self.playerTurn = 0; // 0 will represent 'O' and 1 will represent 'X'
        self.remainingMoves = 9;
        self.grid = [[NSMutableArray alloc] initWithCapacity:GRID_SIZE];
        self.winner = EMPTY;
        
        for (int r = 0; r < GRID_SIZE; r++) {
            NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity:GRID_SIZE];
            for (int c = 0; c < GRID_SIZE; c++) {
                [row addObject:@(EMPTY)];
            }
            [_grid addObject:row];
        }
    }
    return self;
}

/**
 * @public State.copy
 * @description Creates a new state and copies all current property values
 * @returns newState - A completely new state
 */
-(State *)copy {
    State *newState = [State new];
    newState.playerTurn = _playerTurn;
    newState.remainingMoves = _remainingMoves;
    for(int r = 0; r < GRID_SIZE; r++) {
        for(int c = 0; c < GRID_SIZE; c++) {
            NSInteger cellValue = [(NSNumber *)[[_grid objectAtIndex:r] objectAtIndex:c] integerValue];
            [[newState.grid objectAtIndex:r] replaceObjectAtIndex:c withObject:@(cellValue)];
        }
    }
    return newState;
}

/**
 * @public State.reset
 * @description Resets the state to its original 'new game' property values
 */
-(void)reset {
    for(int r = 0; r < GRID_SIZE; r++) {
        for(int c = 0; c < GRID_SIZE; c++) {
            [[_grid objectAtIndex:r] replaceObjectAtIndex:c  withObject:@(EMPTY)];
        }
    }
    self.playerTurn = 0;
    self.lastMarker = nil;
    self.remainingMoves = GRID_SIZE * GRID_SIZE;
    self.winner = EMPTY;
    self.winningLine = nil;
}

/**
 * @public State.switchTurn
 * @description toggles the player turn between 0 and 1
 */
-(void)switchTurn {
    self.playerTurn = 1 - _playerTurn;
}

/**
 * @public State.addMarkerAtRowColumn
 * @description Adds a new marker, changes the turn and checks for end game state
 */
-(void)addMarkerAtRow:(NSInteger)row column:(NSInteger)col {
    [_grid[row] replaceObjectAtIndex:col withObject:@(_playerTurn)];
    self.lastMarker = @[@(row), @(col)];
    self.remainingMoves--;
    [self switchTurn];
    [self checkForWinner];
}

/**
 * @public State.checkForWinner
 * @description Iterates over all line combination possiblities and sets a winner/endGame if one is found
 */
-(void)checkForWinner {
    for(NSUInteger i = 0; i < State.lines.count; i++) {
        NSArray *l = State.lines[i];
        NSInteger numCells = l.count / 2;
        BOOL isWinner = true;
        NSInteger lastCell = EMPTY;
        for(int j = 0; j < numCells; j++) {
            int idx = (j * 2); //we are iterating over 2 coordinates at a time
            if(j == 0) {
                if([_grid[[l[0] integerValue]][[l[1] integerValue]] integerValue] == EMPTY) {
                    isWinner = false;
                    break;
                }
            } else if(lastCell != [_grid[[l[idx] integerValue]][[l[idx + 1] integerValue]] integerValue] ) {
                isWinner = false;
                break;
            }
            lastCell = [_grid[[l[idx] integerValue]][[l[idx + 1] integerValue]] integerValue];
        }
        if(isWinner) {
            self.winner = lastCell;
            self.winningLine = l;
            self.remainingMoves = 0;
            break;
        }
    }
}


@end
