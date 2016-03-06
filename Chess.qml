import QtQuick 2.0
import Ubuntu.Components 0.1
import Ubuntu.Components.Popups 0.1

MainView {
    width: units.gu(70)
    height: units.gu(70)
    applicationName: "com.ubuntu.developer.theo.friberg.chess";
    property bool case_markings: true;
    Page {
        title: "Chess"
        tools: ToolbarItems {

            ToolbarButton {
                action: Action { // Action to be triggered when a player presses the "Turn board" -button
                    text: "Markings"
                    iconSource: Qt.resolvedUrl("Images/markings_icon.svg")
                    onTriggered: case_markings = !case_markings;
                }
            }
            ToolbarButton {
                action: Action { // Action to be triggered when a player presses the "Turn board" -button
                    text: "Rotate"
                    iconSource: Qt.resolvedUrl("Images/return.svg")
                    onTriggered: board.turn_around();
                }
            }
            ToolbarButton {
                action: Action { // Action to be triggered when a player presses the "New game" -button
                    text: "New game"
                    iconSource: Qt.resolvedUrl("/usr/share/icons/ubuntu-mobile/actions/scalable/add.svg")
                    onTriggered: board.reset();
                }
            }
            ToolbarButton {
                action: Action { // Action to be triggered when a player presses the "Undo" -button
                    text: "Undo"
                    iconSource: Qt.resolvedUrl("/usr/share/icons/ubuntu-mobile/actions/scalable/undo.svg")
                    onTriggered: board.undo();
                }
            }
        }
        Rectangle { // Acts as background
            id: rectangle1
            color: "#f1bb93" // ------> Ubuntu Orange (lightened version)
            width: parent.width;
            height: parent.height;
            MouseArea{ // Mouse area that reacts to clicks, for moving pieces on the chessboard
                width: parent.width;
                height: parent.height;
                onClicked: board.click(mouse); // Forwared clicks to the Canvas
                Image { // Image showing the markings at the border of the board
                    id: markings;
                    source: "Images/Markings.svg"
                    function size(){
                        if(board.side_length() === units.gu(50))
                        return board.side_length()+units.gu(6);
                        else
                        return board.side_length()+units.gu(6);
                    }
                    visible: case_markings;

                    sourceSize.width: size();
                    sourceSize.height: size();
                    width: size();
                    height:size();
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    smooth: true;
                }
                Canvas { // Area where the chess pieces are drawn, contains all the logic
                    smooth: true;
                    Component { // Dialog that asks for confirmation when clearing board
                        id: clear_board_dialog
                        Dialog {
                            id: dialogue
                            title: "Clear board"
                            text: "Are you sure that you want to clear the board?"
                            Button {
                                text: "cancel"
                                onClicked: PopupUtils.close(dialogue)
                            }
                            Button {
                                function clear(){ // Function that actually clears the board
                                    board.game = [];
                                    board.turn = "w";
                                    board.selection = null;
                                    board.pieces = [[["r", "b"], ["k", "b"], ["b", "b"], ["q", "b"], ["K", "b"], ["b", "b"], ["k", "b"], ["r", "b"]],
                                                    [["p", "b"], ["p", "b"], ["p", "b"], ["p", "b"], ["p", "b"], ["p", "b"], ["p", "b"], ["p", "b"]],
                                                    [[" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "]],
                                                    [[" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "]],
                                                    [[" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "]],
                                                    [[" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "]],
                                                    [["p", "w"], ["p", "w"], ["p", "w"], ["p", "w"], ["p", "w"], ["p", "w"], ["p", "w"], ["p", "w"]],
                                                    [["r", "w"], ["k", "w"], ["b", "w"], ["q", "w"], ["K", "w"], ["b", "w"], ["k", "w"], ["r", "w"]]
                                            ];
                                    board.turned_around = false;
                                    board.requestPaint();
                                    PopupUtils.close(dialogue)
                                }

                                text: "yes"
                                onClicked: clear();
                            }
                        }
                    }
                    Component { // Dialog that asks what pieces are pawns supposed to be promoted to
                        id: promote_dialog

                        Dialog {
                            id: dialogue
                            title: "Promote pawn to..."
                            text: "One of your pawns reached the other side of the board. You must now promote it to a new..."
                            function promote_to(piece){ // Function that does the promoting
                                board.pieces[board.selection[1]][board.selection[0]][0] = piece;
                                board.selection = null;
                                board.requestPaint();
                                PopupUtils.close(this)
                            }
                            Button {
                                text: "Queen"
                                onClicked: dialogue.promote_to("q");
                            }
                            Button {
                                text: "Rook"
                                onClicked: dialogue.promote_to("r");
                            }
                            Button {
                                text: "Bishop"
                                onClicked: dialogue.promote_to("b");
                            }
                            Button {
                                text: "Knight"
                                onClicked: dialogue.promote_to("k");
                            }
                        }
                    }
                    property var pieces : [[["r", "b"], ["k", "b"], ["b", "b"], ["q", "b"], ["K", "b"], ["b", "b"], ["k", "b"], ["r", "b"]],
                        [["p", "b"], ["p", "b"], ["p", "b"], ["p", "b"], ["p", "b"], ["p", "b"], ["p", "b"], ["p", "b"]],
                        [[" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "]],
                        [[" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "]],
                        [[" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "]],
                        [[" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "], [" ", " "]],
                        [["p", "w"], ["p", "w"], ["p", "w"], ["p", "w"], ["p", "w"], ["p", "w"], ["p", "w"], ["p", "w"]],
                        [["r", "w"], ["k", "w"], ["b", "w"], ["q", "w"], ["K", "w"], ["b", "w"], ["k", "w"], ["r", "w"]]
                    ]; // Var holding position and color of all the pieces

                    property var game: []; // Var holding all the previous moves

                    property var selection : null; // Var holding selection location

                    property var lost_by_black : []; // Var holding pieces lost by the black player

                    property var lost_by_white : []; // Var holding pieces lost by the white player

                    property string turn : "w"; // Var holding whose turn it is

                    property bool turned_around : false; // Var holding wether the board has been turned around

                    function turn_around(){ // Function called to turn the board around
                        if(turned_around){
                            turned_around = false;
                            markings.source = "Images/Markings.svg"; // Markings on the board's sides should be the right way around.
                        }else{
                            turned_around = true;
                            markings.source = "Images/Markings_reversed.svg"; // Markings on the board's sides should be rotated by 180 degrees.
                        }
                        this.requestPaint();
                    }

                    function clone(a){ // Function that clones a 2d array/list
                        var b = []
                        var i = 0;
                        var ii = 0;
                        while(i < a.length){
                            b.push([]);
                            while(ii < a[i].length){
                                b[i][ii] = a[i][ii];
                                ii++;
                            }
                            ii = 0;
                            i++;
                        }
                        return(b);
                    }

                    function reset(){ // Function that resets the board after asking confirmation
                        PopupUtils.open(clear_board_dialog);
                    }

                    function undo(){ // Function, that undoes last move
                        if(game.length > 0){
                            pieces = clone(game[game.length-1]);
                            game.splice(game.length-1, 1);
                            selection = null;
                            if(turn === "w"){
                                turn = "b";
                            }else{
                                turn = "w";
                            }
                            this.requestPaint();
                        }
                    }

                    function click(mouse){ // Function that parses clicks
                        var piece_eaten = null; // Var that stores the content of a case that has been taken
                        var spot = [Math.floor((mouse.x-(parent.width-this.width)/2)*8/this.width), Math.floor((mouse.y-(parent.height-this.height)/2)*8/this.height)]; // Var that stores the coordinates of the case wich has been clicked
                        if(turned_around){ // If the board has been turned around, the click should also be
                            spot[0] = 7 - spot[0];
                            spot[1] = 7 - spot[1];
                        }

                        try{ // This bock is here to prevent errors being thrown when the player clicks outside the board, as the MouseArea is larger than the canvas
                            if(pieces[spot[1]][spot[0]][1] === turn){ // If the player presses a case containing one of his pieces...
                                selection = spot; // ...It is to be interpreted as selecting it
                            }else if(selection !== null){ // If he presses a case not containing one of his pieces, it is to be interpreted as trying to move his selected piece or trying to eat
                                var is_included = false; // Variable storing is the selected case included in his possible moves
                                var possible_moves = get_possible_moves_of(selection[0], selection[1]); // List of moves he can do
                                var i = 0;
                                while(i < possible_moves.length){ // Iterating over the moves...
                                    if(possible_moves[i][0] === spot[1] && possible_moves[i][1] === spot[0]){
                                        is_included = true; // If a move matches the click, is_included should be set to true...
                                        i = possible_moves.length; // ...and the loop should be stopped.
                                    }

                                    i++;
                                }

                                if(is_included){ // If the move is included in the list of possible moves...
                                    game.push(clone(pieces)); // Copy the list of pieces on the board to the list of states of the board
                                    if(pieces[selection[1]][selection[0]][0] === "K"){ // If the player moves his king, he may be castling
                                        if(selection[0] - spot[0] === 2 || selection[0] - spot[0] === -2){ // He is indeed castling
                                            if(spot[0] === 2 && spot[1] === 7){ // White king castling to the left
                                                pieces[7][3] = ["r", "w"];
                                                pieces[7][0] = [" ", " "];
                                            }
                                            if(spot[0] === 6 && spot[1] === 7){ // White king castling to the right
                                                pieces[7][5] = ["r", "w"];
                                                pieces[7][7] = [" ", " "];
                                            }
                                            if(spot[0] === 2 && spot[1] === 0){ // Black king castling to the left
                                                pieces[0][3] = ["r", "b"];
                                                pieces[0][0] = [" ", " "];
                                            }
                                            if(spot[0] === 6 && spot[1] === 0){ // Black king castling to the right
                                                pieces[0][5] = ["r", "b"];
                                                pieces[0][7] = [" ", " "];
                                            }
                                        }
                                    }else if(pieces[selection[1]][selection[0]][0] === "p"){ // If the piece selected is a pawn the player may be eating "en passent"
                                        if(pieces[spot[1]][spot[0]][0] === " " && spot[0] !== selection[0]){ // He is indeed eating "en passent"
                                            if(turn === "w"){ // If it is the white player's turn...
                                                piece_eaten = pieces[spot[1]+1][spot[0]];
                                                pieces[spot[1]+1][spot[0]] = [" ", " "];
                                            }else{ // If it is the black player's turn...
                                                piece_eaten = pieces[spot[1]+1][spot[0]];
                                                pieces[spot[1]-1][spot[0]] = [" ", " "];
                                            }
                                        }
                                    }
                                    if(pieces[spot[1]][spot[0]][0] !== " "){ // General eating
                                        piece_eaten = pieces[spot[1]][spot[0]];
                                    }

                                    pieces[spot[1]][spot[0]] = pieces[selection[1]][selection[0]]; // Putting the piece to the case that was clicked
                                    pieces[selection[1]][selection[0]] = [" ", " "]; // Clearing the case that the piece once occupied
                                    var legal = true; // Variabe storing wether the move just done was legal (would the king be checked beacuse of it / was he allready checked)
                                    var opponent = "b"; // Variable containing the opponent's letter
                                    if(turn === "b")
                                        opponent = "w";
                                    var x = 0; // Case's x-coordinate
                                    var y = 0; // Case's y-coordinate
                                    var i = 0;
                                    var king_x = 0; // King's x-coordinate
                                    var king_y = 0; // King's y-coordinate
                                    var moves_to_check; // Var holding the list of moves to check
                                    while(y < 8){ // Finding the king's location
                                        while(x < 8){

                                            if(pieces[y][x][0] === "K" && pieces[y][x][1] === turn){ // If the case being iterated over contains the king...
                                                king_x = x; // Set king_x...
                                                king_y = y; // ...and king_y to be, respectively x and y
                                            }


                                            x++;

                                        }
                                        x = 0;
                                        y++;
                                    }
                                    y = 0;
                                    x = 0;
                                    while(y < 8){ // Checking is the king is checked
                                        while(x < 8){
                                            if(pieces[y][x][1] === opponent && pieces[y][x][0] !== "K"){ // If the piecce in the case in question is of the color of the opponent (to avoid going through blanc cases -> exceptions being thrown and white cases -> logic not working) and not the king (as he can not threaten the other king, either of them not able of going to a threatened case).
                                                moves_to_check = get_possible_moves_of(x, y); // List of moves to check

                                                while(i < moves_to_check.length){ // Iterating through the moves
                                                    if(moves_to_check[i][0] === king_y && moves_to_check[i][1] === king_x){ // If a move would end up on the king's case...
                                                        legal = false; // ...The move resulting in this board-configuration wouldn't be legal
                                                    }
                                                    i++;
                                                }
                                            }
                                            i = 0;
                                            x++;

                                        }
                                        x = 0;
                                        y++;
                                    }

                                    if(legal){ // If the move was legal...
                                        if(pieces[spot[1]][spot[0]][0] === "p" && (spot[1] === 7 || spot[1] === 0)){ // If the piece moved was a pawn reaching the other side of the board...
                                            selection = spot; // Needed for letting the promote-dialog know where is the pawn in question
                                            PopupUtils.open(promote_dialog); // Open the dialog prompting the user for what the pawn will be promoted to
                                        }else{ // If the piece wasn't a pawn reaching the other side of the board...
                                            selection = null; // ...Set selection to null (will aso be done by promote_dialog)
                                        }
                                        if(turn === "w"){ // If it was white's turn
                                            if(piece_eaten !== null){ // If a piece has been eaten...
                                                lost_by_black.push(piece_eaten); // ...The piece eaten will be pushed to the list of pieces lost by the black player
                                            }

                                            turn = "b" // Now it's black's turn
                                        }else{ // If it was black's turn
                                            if(piece_eaten !== null){ // If a piece has been eaten...
                                                lost_by_white.push(piece_eaten); // ...The piece eaten will be pushed to the list of pieces lost by the white player
                                            }
                                            turn = "w"; // Now it's white's turn
                                        }
                                    }else{ // If the move wasn't legal...
                                        this.undo(); // ...It will be undone
                                        if(turn === "w"){ // ----------------------
                                            turn = "b"
                                        }else{ //      Required as the Undo() function will change whose turn it is
                                            turn = "w";
                                        } // --------------------------------------
                                    }
                                }
                            }
                            this.requestPaint(); // Regardless what happened, the board will have to be re-painted
                        }catch(err){ // End of the try{ ... }catch block required to make outside-of-canvas-but-inside-of-MouseArea-clicks harmless

                        }
                    }

                    function side_length(){ // Function that calculates the length of the side of the Canvas to give it a 3 gu padding and keep it a square, if the size of the window / screen where this app is running is greater than 53gu by 53gu, keep the canvas area 50gu by 50gu
                        if(parent.width < units.gu(56) || parent.height < units.gu(56)){
                            if(case_markings){
                            if(parent.width <= parent.height){
                                return(parent.width-units.gu(6));
                            }else{
                                return(parent.height-units.gu(6));
                            }
                            }else{
                                if(parent.width <= parent.height){
                                    return(parent.width);
                                }else{
                                    return(parent.height);
                                }
                            }
                        }else{
                            return(units.gu(50));
                        }
                    }

                    function load_images(){ // function that loads all images into memory

                        // Black pieces...

                        loadImage("Images/Chess_bdt45.svg")
                        loadImage("Images/Chess_kidt45.svg")
                        loadImage("Images/Chess_kdt45.svg")
                        loadImage("Images/Chess_pdt45.svg")
                        loadImage("Images/Chess_qdt45.svg")
                        loadImage("Images/Chess_rdt45.svg")

                        // White pieces...

                        loadImage("Images/Chess_blt45.svg")
                        loadImage("Images/Chess_kilt45.svg")
                        loadImage("Images/Chess_klt45.svg")
                        loadImage("Images/Chess_plt45.svg")
                        loadImage("Images/Chess_qlt45.svg")
                        loadImage("Images/Chess_rlt45.svg")
                    }

                    function draw_pieces(ctx){ // Function that draws the pieces
                        var x = 0; // Variable holding the x coordinate of the case
                        var y = 0; // Variable holding the y coordinate of the case
                        while(y < 8){
                            while(x < 8){
                                if(this.pieces[y][x][0] !== " "){ // Stop here if the case dosn't contain a piece
                                    var image = "";
                                    if(this.pieces[y][x][0] !== "K"){ // Treat the kings separately
                                        image = "Images/Chess_" + this.pieces[y][x][0]; // Var holding the path of the image to be drawn, inited to what's common to all paths of the images + the letter describing the piece
                                        if(this.pieces[y][x][1] === "b"){// Add in the letter representing the piece's color
                                            image = image + "d";
                                        }else{
                                            image = image + "l";
                                        }
                                    }else{
                                        image = "Images/Chess_ki";
                                        if(this.pieces[y][x][1] === "b"){// Add in the letter representing the piece's color
                                            image = image + "d";
                                        }else{
                                            image = image + "l";
                                        }
                                    }

                                    image = image + "t45.svg"; // Add in the common ending of the names of all pieces
                                    ctx.save(); // Save the canvas transform
                                    ctx.imageSmoothingEnabled = true;
                                    if(turned_around) // If the board has been turned around, the pieces should also be
                                        ctx.translate((7-x)*this.width/8, (7-y)*this.height/8); // Move the context to the right spot
                                    else
                                        ctx.translate(x*this.width/8, y*this.height/8); // Move the context to the right spot
                                    ctx.scale(1/(2100/this.width), 1/(2100/this.height)); // Scale the context in the right way
                                    ctx.drawImage(image, 0, 0); // Draw the piece
                                    ctx.restore(); // Reset the canvas transform
                                }
                                x = x + 1
                            }
                            y = y + 1
                            x = 0;
                        }
                    }

                    // Function that draws the checker patern.
                    function draw_checkers(ctx){
                        ctx.fillStyle = "#f7f6f6"; // ----> Warm Grey
                        ctx.fillRect (0, 0, this.width, this.height); // Draw a rectangle filling the background
                        var x = 0;
                        var y = 0;
                        ctx.fillStyle = "#333333" //  ----> Cool Grey
                        while(y < 8){
                            while(x < 8){
                                ctx.fillRect(x*2*this.width/8+(y+1)%2*this.width/8, y*this.height/8, this.width/8, this.height/8); // Draw a black square
                                x = x + 1;
                            }
                            y = y + 1;
                            x = 0;
                        }
                        // Highlight selection
                        if(selection !== null){
                            ctx.fillStyle = "#DD4814"; // ----> Ubuntu Orange
                            if(turned_around) // If the board is turned around so should be the selection
                                ctx.fillRect((7-selection[0])*this.width/8, (7-selection[1])*this.height/8, this.width/8, this.height/8); // Fill the selected square
                            else
                                ctx.fillRect(selection[0]*this.width/8, selection[1]*this.height/8, this.width/8, this.height/8); // Fill the selected square
                            highlight_moves(ctx); // Highlight squares where the selected piece can move and those where it can't move because it would compromise his kings safety
                        }
                    }
                    function get_possible_moves_of(x, y){ // Function returning possible moves of the piece in the case (x, y)
                        var moves = []; // Variable to store possible moves
                        var opponent = "w"; // Variable to store opponent
                        var Forward = 0; // Var holding wich way is forward, if the pawn is white -1, if black +1
                        var Other_end = 0; // Var holding the y coordinate of the other side of the board
                        var Beginning_rank = 0; // Var holding the rank at wich a pawn begins
                        var Own_side = 0; // Var holding the rank at wich a pawn begins
                        if(pieces[y][x][1] === "w"){
                            Forward = -1;
                            Beginning_rank = 6;
                            Own_side = 7;
                            //Other_end = 0; // Not required, as Other_endher_end is allready set to 0
                        }else{
                            Forward = 1;
                            Other_end = 7;
                            Beginning_rank = 1;
                            // Own_side = 0; // Not required, as Own_side is allready set to 0
                        }
                        if(pieces[y][x][1] === "w")
                            opponent = "b";
                        switch(pieces[y][x][0]){
                        case "p": // If the piece in the case is a pawn

                            try{ // Will throw an exception if at the border of the board
                                if(pieces[y+Forward][x][0] === " "){ //  And there isn't anything in the way...
                                    if(y === Beginning_rank && pieces[Beginning_rank+2*Forward][x][0] === " "){ // That hasn't yet moved and there isn't anything two squares forward...
                                        moves = [[y+Forward, x], [y+2*Forward, x]] // ...are either one or two forward.
                                    }else{ // That has moved...
                                        if(y !== Other_end) // That isn't yet at the other edge of the board...
                                            moves = [[y+Forward, x]] // ...are one up.
                                        //else // That is stuck at the other side of the board...
                                        //moves = [] // ...are none.
                                    }
                                }
                            }catch(err){

                            }
                            if(y !== Other_end){ // If it isn't cornered...
                                // Can it eat right?
                                try{
                                    if(pieces[y+Forward][x+1][1] === opponent)
                                        moves.push([y+Forward, x+1]);
                                }catch(err){

                                }

                                // Can it eat left
                                try{
                                    if(pieces[y+Forward][x-1][1] === opponent)
                                        moves.push([y+Forward, x-1]);
                                }catch(err){

                                }
                            }
                            // En passant

                            try{ // To the left
                                if(pieces[y][x-1][0] === "p" && pieces[y][x-1][1] === opponent){ // There is pawn next to it
                                    if(game[game.length-1][y][x-1][0] === " " && game[game.length-1][y+Forward][x-1][0] === " "){ // There wasn't a pawn next to it last time
                                        try{
                                            moves.push([y+Forward, x-1])
                                        }catch(err){

                                        }
                                    }
                                }

                            }catch(err){

                            }
                            try{ // To the right
                                if(pieces[y][x+1][0] === "p" && pieces[y][x+1][1] === opponent){ // There is pawn next to it
                                    if(game[game.length-1][y][x+1][0] === " " && game[game.length-1][y+Forward][x+1][0] === " "){ // There wasn't a pawn next to it last time
                                        try{
                                            moves.push([y+Forward, x+1])
                                        }catch(err){

                                        }
                                    }
                                }

                            }catch(err){

                            }
                            break;
                        case "r": // Moves of a rook...
                            var x_left = x-1; // Iterator for checking cases on the x-axis left from the rook
                            var x_right = x+1; // Iterator for checking cases on the x-axis right from the rook
                            var y_up = y-1; // Iterator for checking cases on the y-axis up from the rook
                            var y_down = y+1; // Iterator for checking cases on the y-axis down from the rook

                            while(x_left > -1){ // Horizontally to the left
                                moves.push([y, x_left]); // Add move to the list of possible moves
                                try{ // Try{ ... }catch -block for staying on the board
                                    if(pieces[y][x_left][0] !== " "){ // If encountering a piece, halt
                                        x_left = 0;
                                    }
                                }catch(err){

                                }

                                x_left--;
                            }
                            while(x_right < 8){ // Horizontally to the right
                                moves.push([y, x_right]); // Add move to the list of possible moves
                                try{ // Try{ ... }catch -block for staying on the board
                                    if(pieces[y][x_right][0] !== " "){ // If encountering a piece, halt
                                        x_right = 8;
                                    }
                                }catch(err){

                                }

                                x_right++;
                            }
                            while(y_up > -1){ // Vertically up
                                moves.push([y_up, x]); // Add move to the list of possible moves
                                try{ // Try{ ... }catch -block for staying on the board
                                    if(pieces[y_up][x][0] !== " "){ // If encountering a piece, halt
                                        y_up = 0;
                                    }
                                }catch(err){

                                }

                                y_up--;
                            }
                            while(y_down < 8){ // Vertically down
                                moves.push([y_down, x]); // Add move to the list of possible moves
                                try{ // Try{ ... }catch -block for staying on the board
                                    if(pieces[y_down][x][0] !== " "){ // If encountering a piece, halt
                                        y_down = 8;
                                    }
                                }catch(err){

                                }

                                y_down++;
                            }
                            break;
                        case "k": // If it is a knight
                            moves = [[y-2, x-1], [y-1, x-2], [y-2, x+1], [y-1, x+2], [y+2, x-1], [y+1, x-2], [y+2, x+1], [y+1, x+2]]
                            var i = 0;
                            while(i < moves.length){
                                if(moves[i][1] > 7 || moves[i][1] < 0 || moves[i][0] > 7 || moves[i][0] < 0){
                                    moves.splice(i, 1);
                                }else{ // <---- because the list gets one shroter if the move wouldn't end up on the board
                                    i++;
                                }
                            }
                            break;
                        case "b": // If it is a bishop...
                            var upper_left = 1; // All kinds of iterators for going to all kinds of directions
                            var upper_right = 1;
                            var lower_left = 1;
                            var lower_right = 1;
                            var upper_left_tgt = 0; // Targets to stop the four loops when reached
                            var upper_right_tgt = 0;
                            var lower_left_tgt = 0;
                            var lower_right_tgt = 0;
                            if(x <= y){ // Initiating all the targets
                                upper_left_tgt = x;
                            }else{
                                upper_left_tgt = y;
                            }
                            if(7 - x <= y){
                                upper_right_tgt = 7 - x;
                            }else{
                                upper_right_tgt = y;
                            }
                            if(x <=  7 - y){
                                lower_left_tgt = x;
                            }else{
                                lower_left_tgt = 7 - y;
                            }
                            if(7 - x <= 7 - y){
                                lower_right_tgt = 7 - x;
                            }else{
                                lower_right_tgt = 7 - y;
                            }
                            while(upper_left <= upper_left_tgt){ // Towards upper left corner
                                moves.push([y-upper_left, x-upper_left]);
                                try{
                                    if(pieces[y-upper_left][x-upper_left][0] !== " "){
                                        upper_left = 8;
                                    }
                                }catch(err){

                                }
                                upper_left++;
                            }
                            while(upper_right <= upper_right_tgt){ // Towards upper right corner
                                moves.push([y-upper_right, x+upper_right]);
                                try{
                                    if(pieces[y-upper_right][x+upper_right][0] !== " "){
                                        upper_right = 8;
                                    }
                                }catch(err){

                                }
                                upper_right++;
                            }
                            while(lower_left <= lower_left_tgt){ // Towards lower left corner
                                moves.push([y+lower_left, x-lower_left]);
                                try{
                                    if(pieces[y+lower_left][x-lower_left][0] !== " "){
                                        lower_left = 8;
                                    }
                                }catch(err){

                                }
                                lower_left++;
                            }
                            while(lower_right <= lower_right_tgt){ // Towards lower right corner
                                moves.push([y+lower_right, x+lower_right]);
                                try{
                                    if(pieces[y+lower_right][x+lower_right][0] !== " "){
                                        lower_right = 8;
                                    }
                                }catch(err){

                                }
                                lower_right++;
                            }
                            break;
                        case "q":
                            var upper_left = 1; // All kinds of iterators for going to all kinds of directions
                            var upper_right = 1;
                            var lower_left = 1;
                            var lower_right = 1;
                            var upper_left_tgt = 0; // Targets to stop the four loops when reached
                            var upper_right_tgt = 0;
                            var lower_left_tgt = 0;
                            var lower_right_tgt = 0;
                            if(x <= y){ // Initiating all the targets
                                upper_left_tgt = x;
                            }else{
                                upper_left_tgt = y;
                            }
                            if(7 - x <= y){
                                upper_right_tgt = 7 - x;
                            }else{
                                upper_right_tgt = y;
                            }
                            if(x <=  7 - y){
                                lower_left_tgt = x;
                            }else{
                                lower_left_tgt = 7 - y;
                            }
                            if(7 - x <= 7 - y){
                                lower_right_tgt = 7 - x;
                            }else{
                                lower_right_tgt = 7 - y;
                            }
                            while(upper_left <= upper_left_tgt){ // Towards upper left corner
                                moves.push([y-upper_left, x-upper_left]);
                                try{
                                    if(pieces[y-upper_left][x-upper_left][0] !== " "){
                                        upper_left = 8;
                                    }
                                }catch(err){

                                }
                                upper_left++;
                            }
                            while(upper_right <= upper_right_tgt){ // Towards upper right corner
                                moves.push([y-upper_right, x+upper_right]);
                                try{
                                    if(pieces[y-upper_right][x+upper_right][0] !== " "){
                                        upper_right = 8;
                                    }
                                }catch(err){

                                }
                                upper_right++;
                            }
                            while(lower_left <= lower_left_tgt){ // Towards lower left corner
                                moves.push([y+lower_left, x-lower_left]);
                                try{
                                    if(pieces[y+lower_left][x-lower_left][0] !== " "){
                                        lower_left = 8;
                                    }
                                }catch(err){

                                }
                                lower_left++;
                            }
                            while(lower_right <= lower_right_tgt){ // Towards lower right corner
                                moves.push([y+lower_right, x+lower_right]);
                                try{
                                    if(pieces[y+lower_right][x+lower_right][0] !== " "){
                                        lower_right = 8;
                                    }
                                }catch(err){

                                }
                                lower_right++;
                            }
                            var x_left = x-1; // Iterator for checking cases on the x-axis left from the rook
                            var x_right = x+1; // Iterator for checking cases on the x-axis right from the rook
                            var y_up = y-1; // Iterator for checking cases on the y-axis up from the rook
                            var y_down = y+1; // Iterator for checking cases on the y-axis down from the rook

                            while(x_left > -1){ // Horizontally to the left
                                moves.push([y, x_left]); // Add move to the list of possible moves
                                try{ // Try{ ... }catch -block for staying on the board
                                    if(pieces[y][x_left][0] !== " "){ // If encountering a piece, halt
                                        x_left = 0;
                                    }
                                }catch(err){

                                }

                                x_left--;
                            }
                            while(x_right < 8){ // Horizontally to the right
                                moves.push([y, x_right]); // Add move to the list of possible moves
                                try{ // Try{ ... }catch -block for staying on the board
                                    if(pieces[y][x_right][0] !== " "){ // If encountering a piece, halt
                                        x_right = 8;
                                    }
                                }catch(err){

                                }

                                x_right++;
                            }
                            while(y_up > -1){ // Vertically up
                                moves.push([y_up, x]); // Add move to the list of possible moves
                                try{ // Try{ ... }catch -block for staying on the board
                                    if(pieces[y_up][x][0] !== " "){ // If encountering a piece, halt
                                        y_up = 0;
                                    }
                                }catch(err){

                                }

                                y_up--;
                            }
                            while(y_down < 8){ // Vertically down
                                moves.push([y_down, x]); // Add move to the list of possible moves
                                try{ // Try{ ... }catch -block for staying on the board
                                    if(pieces[y_down][x][0] !== " "){ // If encountering a piece, halt
                                        y_down = 8;
                                    }
                                }catch(err){

                                }

                                y_down++;
                            }
                            break;
                        case "k": // If it is a knight
                            moves = [[y-2, x-1], [y-1, x-2], [y-2, x+1], [y-1, x+2], [y+2, x-1], [y+1, x-2], [y+2, x+1], [y+1, x+2]]
                            var i = 0;
                            while(i < moves.length){ // Removing all moves not enging up on the board
                                if(moves[i][1] > 7 || moves[i][1] < 0 || moves[i][0] > 7 || moves[i][0] < 0){
                                    moves.splice(i, 1);
                                }else{ // <---- because the list gets one shroter if the move wouldn't end up on the board
                                    i++;
                                }
                            }
                            break;
                        case "K":
                            moves = [[y-1, x-1], [y-1, x], [y-1, x+1], [y, x+1], [y+1, x+1], [y+1, x], [y+1, x-1], [y, x-1]]
                            var i = 0;
                            while(i < moves.length){
                                if(moves[i][1] > 7 || moves[i][1] < 0 || moves[i][0] > 7 || moves[i][0] < 0){
                                    moves.splice(i, 1);
                                }else{ // <---- because the list gets one shroter if the move wouldnt end up on the board
                                    i++;
                                }
                            }

                            // Castling
                            var king_is_not_checked = true; // One can only castle if the king in question isn't checked
                            var king_has_not_moved = true; // One can only castle if the king in question has not moved
                            var left_rook_has_not_moved = true;
                            var right_rook_has_not_moved = true; // One can only castle if the rook in question has not moved
                            var nothing_in_the_way_to_the_left = true;
                            var nothing_in_the_way_to_the_right = true; // One can only castle if there isn't anything in the way;
                            var can_castle_to_the_left = true; // Can the player rook to the left?
                            var can_castle_to_the_right = true; // Can the player rook to the right?

                            if(pieces[Own_side][5][0] !== " " || pieces[Own_side][6][0] !== " "){ // If there is something to the right
                                nothing_in_the_way_to_the_right = false;
                            }
                            if(pieces[Own_side][1][0] !== " " || pieces[Own_side][2][0] !== " " || pieces[Own_side][3][0] !== " "){ // If there is something to the left
                                nothing_in_the_way_to_the_left = false;
                            }
                            if(nothing_in_the_way_to_the_left || nothing_in_the_way_to_the_right){ // If it has the space to castle atleast one way...
                                i = 0;
                                while(i < game.length){
                                    if(pieces[Own_side][4][0] !== "K"){
                                        king_has_not_moved = false;
                                        i = game.length;
                                    }
                                    i++;
                                }
                                if(king_has_not_moved){ // If the king has not moved...
                                    i = 0;
                                    var ii = 0;
                                    var iii = 0;
                                    var moves_to_check;
                                    while(i < 8){ // Checking is the king or either of the other cases checked
                                        while(ii < 8){

                                            if(pieces[i][ii][1] === opponent && pieces[i][ii][0] !== "K"){ // If the piece in the case can threaten the king or the other cases...
                                                moves_to_check = get_possible_moves_of(ii, i);

                                                while(iii < moves_to_check.length){
                                                    if(moves_to_check[iii][0] === Own_side && moves_to_check[iii][1] === 4){ // It threatens the king
                                                        king_is_not_checked = false;
                                                    }
                                                    if(moves_to_check[iii][0] === Own_side && (moves_to_check[iii][1] === 2 || moves_to_check[iii][1] === 3)){ // It threatens cases to the left
                                                        can_castle_to_the_left = false;
                                                    }
                                                    if(moves_to_check[iii][0] === Own_side && (moves_to_check[iii][1] === 5 || moves_to_check[iii][1] === 6)){ // It threatens cases to the right
                                                        can_castle_to_the_right = false;
                                                    }
                                                    iii++;
                                                }
                                            }
                                            iii = 0;
                                            ii++;

                                        }
                                        ii = 0;
                                        i++;
                                    }

                                    can_castle_to_the_left  = can_castle_to_the_left  && nothing_in_the_way_to_the_left;
                                    can_castle_to_the_right = can_castle_to_the_right && nothing_in_the_way_to_the_right;

                                    if(king_is_not_checked && (can_castle_to_the_left || can_castle_to_the_right)){ // If the king can castle to at least one side
                                        if(can_castle_to_the_left){ // If he can perhaps castle to the left
                                            i = 0;
                                            while(i < game.length){ // Check if the rook has moved
                                                if(pieces[Own_side][0][0] !== "r"){
                                                    left_rook_has_not_moved = false;
                                                    i = game.length;
                                                }
                                                i++;
                                            }
                                            if(left_rook_has_not_moved){ // If not...
                                                try{
                                                    moves.push([Own_side, 2]);
                                                }catch(err){
                                                    moves = [Own_side, 2];

                                                }
                                            }
                                        }
                                        if(can_castle_to_the_right){ // If he can perhaps castle to the right
                                            i = 0;
                                            while(i < game.length){ // Check if the rook has moved
                                                if(pieces[Own_side][7][0] !== "r"){
                                                    right_rook_has_not_moved = false;
                                                    i = game.length;
                                                }
                                                i++;
                                            }
                                            if(right_rook_has_not_moved){ // If not...
                                                try{
                                                    moves.push([Own_side, 6]);
                                                }catch(err){
                                                    moves = [Own_side, 6];

                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            break;

                        }

                        // What moves can actually be done...

                        var i = 0;
                        while(i < moves.length){
                            if(pieces[moves[i][0]][moves[i][1]][1] === pieces[y][x][1]){
                                moves.splice(i, 1);
                            }else{ // <---- because the list gets one shroter if the colors match
                                i++;
                            }
                        }
                        return moves;
                    }

                    // Highlight possible moves
                    function highlight_moves(ctx){
                        ctx.fillStyle = "rgba(119, 33, 111, 0.7)"; // ----> Light Aubergine
                        var i = 0;
                        var moves = get_possible_moves_of(selection[0], selection[1]);
                        if(moves !== null){
                            while(i < moves.length){
                                if(turned_around) // If the board is turned around, so should be the representation of possible moves
                                    ctx.fillRect((7-moves[i][1])*this.width/8, (7-moves[i][0])*this.height/8, this.width/8, this.height/8); // Fill the case representing the move with 50% Light Aubergine
                                else
                                    ctx.fillRect(moves[i][1]*this.width/8, moves[i][0]*this.height/8, this.width/8, this.height/8); // Fill the case representing the move with 50% Light Aubergine
                                i++;
                            }
                        }
                    }

                    onPaint: {
                        var ctx = this.getContext('2d');
                        ctx.clearRect(0, 0, this.width, this.height);
                        draw_checkers(ctx);
                        draw_pieces(ctx);

                    }
                    id: board
                    width: side_length();
                    height: side_length();
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    Component.onCompleted: {load_images()}
                }
            }
        }
    }
}
