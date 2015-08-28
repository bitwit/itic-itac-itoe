//
//  ViewController.m
//  tice tac toe
//
//  Created by Kyle Newsome on 15-08-21.
//  Copyright (c) 2015 Kyle Newsome. All rights reserved.
//


#import "ViewController.h"

#import "config.h"
#import "Game.h"


@interface ViewController ()

@property (nonatomic, strong) Game *game;
@property (nonatomic, strong) NSMutableArray *markers; //maintain a reference for clearing and highlighting
@property (nonatomic) NSUInteger aiPlayer;

@end

@implementation ViewController


/**
* viewDidLoad
*
* Set up initial variable
* Draw our cell controls manually
* Listen for events from the Game object
*/
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.game = [Game new];
    self.markers = [[NSMutableArray alloc] initWithCapacity:GRID_SIZE * GRID_SIZE];
    self.aiPlayer = 1;
    
    for (int r = 0; r < GRID_SIZE; r++) {
        for (int c = 0; c < GRID_SIZE; c++) {
            UIControl *marker = [[UIControl alloc] init];
            [_boardView addSubview:marker];
            int x = c * MARKER_SIZE + c * SEPARATOR_SIZE;
            int y = r * MARKER_SIZE + r * SEPARATOR_SIZE;
            marker.frame = CGRectMake(x, y, MARKER_SIZE, MARKER_SIZE);
            marker.backgroundColor = [UIColor colorWithRed:97.0f/255.0f green:245.0f/255.0f blue:1.0f alpha:1.0f];
            marker.tag = (r * GRID_SIZE) + c;
            [marker addTarget:self action:@selector(markerWasSelected:) forControlEvents:UIControlEventTouchUpInside];
            [_markers addObject:marker];
        }
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange:) name:@"stateDidChange" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameDidEnd:) name:@"gameDidEnd" object:nil];
}

/*
 Remove listeners on dealloc
 */
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
* playerFirst & aiFirst
* Our Reset buttons exposed to the storyboard
* One for player first, the other for AI plays first
*/
-(IBAction) playerFirst:(id)sender {
    [self reset];
    _aiPlayer = 1;
    _youLabel.text = @"You: O";
}

-(IBAction) aiFirst:(id)sender {
    [self reset];
    _aiPlayer = 0;
    _youLabel.text = @"You: X";
    [self performSelector:@selector(triggerAI) withObject:nil afterDelay:1.0f];
}

/**
* reset
* @description Trigger a game reset and visually animate all the markers disappearing
*/
-(void)reset {
    [_game reset];
    __block int labelCount = 0;
    [_markers enumerateObjectsUsingBlock:^(id obj, NSUInteger markerIdx, BOOL *stop) {
        UIView *marker = (UIView *)obj;
        marker.backgroundColor = [UIColor colorWithRed:97.0f/255.0f green:245.0f/255.0f blue:1.0f alpha:1.0f];
        [marker.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            int direction = labelCount % 2; //alternate the rotation direction of every other label
            [UIView animateWithDuration:0.35f
                                  delay: (labelCount * 0.05f)
                                options: UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 UILabel *label = (UILabel *)obj;
                                 label.alpha = 0.0f;
                                 CGAffineTransform t = label.transform;
                                 t = CGAffineTransformScale(t, 2.0f, 2.0f);
                                 t = CGAffineTransformRotate(t, (direction) ? 45.0f : -45.0f);
                                 t = CGAffineTransformTranslate(t, 0, -20.0f);
                                 label.transform = t;
                             } completion:^(BOOL completed){
                        [obj removeFromSuperview];
                    }];
            labelCount++;
        }];
    }];
    _turnLabel.text = [NSString stringWithFormat:@"Turn: %@", (_game.state.playerTurn) ? @"X" : @"O"];
}

/*
* triggerAI
* Function to call AI if the game is still going
*/
-(void)triggerAI {
    if(_game.state.remainingMoves > 0) {
        [_game triggerAITurnForPlayer:_aiPlayer];
    }
}

/**
* markerWasSelected
* Our event callback from taps on cells in the grid
* If it is the player's turn and the cell is available, it will be added
* and we can trigger the AI on a small delay for aesthetic purposes
*/
-(void)markerWasSelected:(UIControl *)marker {
    if(_game.state.playerTurn == _aiPlayer) {
        return;
    }
    NSUInteger row = (NSUInteger)floor(marker.tag / GRID_SIZE);
    NSUInteger col = (NSUInteger)marker.tag % GRID_SIZE;
    if([_game addMarkerAtRow:row column:col]){
        [self performSelector:@selector(triggerAI) withObject:nil afterDelay:1.0f];
    }
}

#pragma mark - Notifications

/*
* stateDidChange
* When the state changes we need to evaluate what happened and update the UI with a new marker
*/
-(void)stateDidChange:(NSNotification *)notification {
    State *state = _game.state;
    NSArray *lastMarker = state.lastMarker;
    NSUInteger row = (NSUInteger)[lastMarker[0] integerValue];
    NSUInteger col = (NSUInteger)[lastMarker[1] integerValue];
    UIControl *marker = _markers[( (row * GRID_SIZE) + col )];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MARKER_SIZE, MARKER_SIZE)];
    if(state.playerTurn){ //We just incremented the state so we need to mark with the LAST player's turn
        label.textColor = [UIColor colorWithRed:245.0f/255.0f green:122.0f/255.0f blue:130.0f/255.0f alpha:1.0f];
        label.text = @"O";
    } else {
        label.textColor = [UIColor colorWithRed:237.0f/255.0f green:82.0f/255.0f blue:118.0f/255.0f alpha:1.0f];
        label.text = @"X";
    }
    label.font = [UIFont fontWithName:@"Helvetica Neue" size:32.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [marker addSubview:label];
    label.transform = CGAffineTransformMakeScale(4.0f, 4.0f);
    [UIView animateWithDuration:0.6f
                          delay:0
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         label.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                     }
                     completion:nil];
    
    _turnLabel.text = [NSString stringWithFormat:@"Turn: %@", (_game.state.playerTurn) ? @"X" : @"O"];
}

/*
* gameDidEnd
* When the game ends we highlight the cells that form the line
*/
-(void)gameDidEnd:(NSNotification *)notification {
    if(_game.state.winner != EMPTY) {
        NSArray *l = _game.state.winningLine;
        NSUInteger numCells = l.count / 2;
        for(NSUInteger j = 0; j < numCells; j++) {
            NSUInteger idx = (j * 2); //we are iterating over 2 coordinates at a time
            NSUInteger markerIndex = (NSUInteger)([l[idx] integerValue] * GRID_SIZE) + [l[idx + 1] integerValue];
            UIControl *marker = _markers[markerIndex];
            marker.backgroundColor = [UIColor colorWithRed:244.0f/255.0f green:205.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
        }
        _turnLabel.text = [NSString stringWithFormat:@"%@ Wins!", (_game.state.winner) ? @"X" : @"O"];
    } else {
        _turnLabel.text = @"Draw :(";
    }
}


@end