# iTic iTac iToe

An implementation of tic tac toe in Objective-C with AI.

Notes:
- AI uses minimax algorithm with alpha beta pruning
- Demonstrates a combination of autolayout and manual view drawing.
  - The board is positioned via auto layout to remain at the top center of the view on any sized device in portrait or landscape.
  - The tappable cells and markers are all drawn and animated programatically