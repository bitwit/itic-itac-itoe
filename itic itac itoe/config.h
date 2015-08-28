//
//  config.h
//  tice tac toe
//
//  Created by Kyle Newsome on 2015-08-26.
//  Copyright (c) 2015 Kyle Newsome. All rights reserved.
//

#ifndef tice_tac_toe_config_h
#define tice_tac_toe_config_h

/**
* Grid Size
* @description Number of rows and columns in our Tic Tac Toe grid.
*/
#define GRID_SIZE 3
/**
* Score Bounds
* @description This is the upper/lower limit of the scoring
*              to be used during minimax AI calulations
*/
#define SCORE_BOUNDS 10

/**
* Empty
* @description Our value to represent empty cells
*/
#define EMPTY -1

/**
* Marker size
* @description The width and height of the grid cells
*/
#define MARKER_SIZE 82

/**
* Separator Size
* @description The space between cells
*/
#define SEPARATOR_SIZE 8

#endif
