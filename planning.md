# Ruby Chess

## LEGAL MOVE CHECK

Have 2 checks for legal move

First check does the regular travail and figures out if it’s possible in one move
If it isn’t, then the move is deemed illegal

The second check will use the path from a valid move, and see if there are any 
pieces in the way, or if there are any to capture
- The move set may have to differ for this travails graph search
- Ex: the first check for a rook can have 1 move be across the entire board,
but the path returned from the method will lack the information necessary to check
the spaces in between the start and target positions. So, we may change the move
set to be limited to one space per turn. That way we are given all the spaces for
the shortest path between the start and the destination.
- The check for if the final position is a capture may need to come before knowing
if there’s a piece in the way. That way we don’t deem it illegal before knowing if
it’s a piece available for capture. We could also make the legal check exclude the
last position and check it after. Not sure which is better code yet though.


OR

We can have it so that during the initial travail , it has checks in place for
interactions with other pieces.

This, however, may introduce difficulties in checking whether a move is legal
or not in the same rook example as above. We would still have to make sure that
we are returned the entire path, and not just a jump across the board. But, given
the entire path, we would still need another check to see if the move is possible
in a single turn. This may be more elegant code, but the complexity in implementation
does not be worth it. Also, the need for some pieces to still need multiple checks
somewhat defeats the purpose of this method’s assumed cleanliness.

## CHECK & CHECKMATE

We need to check for these conditions at the end of every turn.

Check will need to have a toggle so that only legal moves can be made.
Possibly toggles specific to that color.

Might have to check the moves of all the pieces against each other to see what
will stop the check.

Or maybe just allow player to input their move, then check if they’re still in
check and have them redo their turn accordingly.
- Have pieces save their previous spot, or have the hash keys save their previous
values, so that it can go back if the king is still in check.
    - Can possibly just copy the board hash before applying the move (pre-move board)
    so that it can just be reverted to. That way it’s not about specific positions,
    and just becomes a backup of the entire board.

## PIECE BOARD POSITIONS

A piece’s position will be saved in an instance variable.

But to communicate whether or not a piece occupying a specific position,
currently occupied spaces may need to be saved into a data structure and updated every turn.

I would like to be able to just use relation between all the pieces in the “Board” object,
but I’m not sure if there’s a solid way to connect them in a key-value pair dynamic.
The only attributes they would share are color.

But then is the issue of traversing all of the pieces if they don’t have relation to each other.

I think the data structure will have to be built on the “Board” class level of things
{since I’m only creating one instance of each type of piece (tho probably one for each color)
I won’t be able to check every existing piece by using a “next node” approach}.
Maybe the position instance variable won’t be used for this and only for the legal move methods.
I’ll have to use a data structure that will allow me to go through the spaces of the board and
tell me exactly what piece is there if there is one.

I’m thinking maybe I can use a hash that has keys for all the spaces on the board
(in regular notation like e4). When the board is initialized, the piece objects become
the value associated with the corresponding key. When a piece moves, the starting value
is deleted or set to empty (nil), and the new position is updated to represent that piece object.
So the legal move methods are checking against this hash from the Board object

Thus also makes it easy to serialize.

Have the values of the hash be an array that holds the piece, and the array notation of the position.
Ex: { e4 => [knight, [4, 3]] }
When we change the pieces, we only change the zero index of the value. This allows the peices to be
more easily told their place after more complex moves like castling.

Or maybe I need a conversion between the board notation and the array notation.

Or maybe the board data structure should just be a 2D array and the chess notation/conversion only
happens for user input. This could simplify dealing with edge cases.

## MOVING PIECES

Input syntax may be:
e4 > e5

There would then be an identification check on what piece is in the starting position
(the objects must be stored in a data structure that is easy to search and change),
and then the legal move check would commence.

This syntax, combined with the visual of the board, prevents us from having to
implement more traditional notation. I don’t mind this as this is a compromise
on a project that is just an exercise and not a passion project. As long as core
functionality is present, I will be satisfied.
