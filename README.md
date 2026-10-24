
# SNAKE SOLVER

An autonomous Snake game solver developed in x86 Assembly, featuring Dijkstra's shortest-path algorithm and custom simulation-based path validation to reduce the risk of self-trapping.

##Overview 
Snake Solver is an autonomous Snake game solver developed in x86 Assembly using the Irvine32 library. Its primary objective is to complete the game in the fewest possible moves while avoiding collisions and self-trapping.

The solver uses Dijkstra's shortest-path algorithm to identify efficient routes toward apples. However, because the shortest path does not necessarily guarantee the snake's continued survival, a custom simulation-based path validation algorithm evaluates candidate routes by simulating future movement and checking tail reachability.

By combining shortest-path calculations with predictive safety checks, the solver is able to minimize unnecessary movement while ensuring the snake's continued survival to obtain more apples.

## Showcase:

https://github.com/barkeshli-CS066-classroom/99-final-project-snake-solver-QueencyT/assets/122432408/b38922fa-058f-4dec-9aef-afa2dfbbf461


<br><br>

## FULL PRESENTATION VIDEO: 
  - https://youtu.be/OIwKVs11p5E
    
<br><br>

## LIST OF FUNCTIONS:
```
 allign_cursor_left PROC
    ; purpose: function to move cursor to the left edge of grid 
    ; args: assumes dh has already been filled with appropriate "row" number 
    ; affect: no flags or registers affected
    ; return: no return
allign_cursor_left ENDP 

allign_cursor_right PROC
    ; purpose: function used to move cursor to the right edge of grid
    ; args: assumes dh has already been filled with appropriate "row number" 
    ; affect: no flags or registers affected
    ; return: no return
allign_cursor_right ENDP

draw_border_piece PROC
    ; purpose: function to draw border piece aka "X"
    ; args: assumes call GOTOXY has been called with the appropriate dh and dl values 
    ; affect: no flags or registers affected
    ; return: no return
    ret 
draw_border_piece ENDP 

draw_horiz_border PROC
    ; purpose: function used to draw the horizontal border "XXXXXXX" length determined by our grid length
    ; args: assumes call GOTOXY has been called with the appropriate dh and dl values 
    ; affect: no flags or registers affected
    ; return: no return
draw_horiz_border ENDP
   
draw_top_horiz_border PROC
    ; purpose: function used to draw the top horizontal border "XXXXXXX" length determined by our grid length,
      call lower level draw_horiz_border function in order to do so 
    ; args: none  
    ; affect: dx affected
    ; return: no return
draw_top_horiz_border ENDP
  
draw_bot_horiz_border PROC 
    ; purpose: function used to draw the bot horizontal border "XXXXXXX" length determined by our grid length,
      call lower level draw_horiz_border function in order to do so 
    ; args: none  
    ; affect: dx register affected
    ; return: no return
draw_bot_horiz_border ENDP

draw_right_border PROC
    ; purpose: function used to draw the right vertical border piece "X"
      calls lower level draw_border_piece and allign_cursor_right
    ; args: none  
    ; affect: no flags or registers affected
    ; return: no return
    ret
draw_right_border ENDP

draw_left_border PROC 
     ; purpose: function used to draw the left vertical border piece "X"
      calls lower level draw_border_piece and allign_cursor_left
    ; args: none  
    ; affect: no flags or registers affected
    ; return: no return
     ret 
draw_left_border ENDP

draw_borders PROC
    ; purpose: function used to draw the right and left vertical border piece "X          X"
      calls lower level draw_left_border and draw_right_border
    ; args: none  
    ; affect: no flags or registers affected
    ; return: no return
draw_borders ENDP 

draw_apple PROC
    ; purpose: function used to draw the apple "*"
      calls lower level draw_obj to do so
    ; args: none  
    ; affect: affects ax register and edx
    ; return: no return
draw_apple ENDP

turn_on_snake_matrix PROC
    ; purpose: function used to turn on specific position in snake matrix --> puts a 1 
    ; args: assumes dh and dl have been filled with the correct row and col   
    ; affect: no registers or flags affected
    ; return: modifies snakeMatrix 
turn_on_snake_matrix ENDP 

turn_off_snake_matrix PROC 
    ; purpose: function used to turn off specific position in snake matrix --> puts a 0
    ; args: assumes dh and dl have been filled with the correct row and col   
    ; affect: no registers or flags affected
    ; return: modifies snakeMatrix 
turn_off_snake_matrix ENDP

draw_snake PROC 
    ; purpose: function used to draw the snake in the game board, also updates snakeMatrix using turn_on and turn_off snake matrix 
    ; args: assumes dh has  been filled with the correct row 
    ; affect: no registers or flags affected
    ; return: modifies snakeMatrix 
draw_snake ENDP  

draw_grid PROC
    ; purpose: function used to draw the entire game board situation
    ; args: assumes grid width and height are already known, assumes apple position already known, assumes snake positions already known
    ; affect: none 
    ; return: none  
draw_grid ENDP

draw_obj PROC  ; draw the row ; loop in here to draw the rest of snake body --> maybe ?
    ; purpose: low level function used to draw an object  
    ; args: assumes dh and al have been filled with the correct row and col, and that esi is filled with offset of obj    
    ; affect: no registers or flags affected
    ; return: none 
draw_obj ENDP

get_last_snake_pos PROC USES esi
    ; purpose: function to get the last snake X and Y pos 
    ; args: assumes snakePositions arr already updated accordingly   
    ; affect: affect dx
    ; return: modifies lastSnakeXPos and lastSnakeYPos
get_last_snake_pos ENDP

get_last_snake_vert PROC USES esi edx
    ; purpose: function to get the last snake vert   
    ; args: assumes snakePositions arr already updated accordingly  
    ; affect: affect dx, al 
    ; return: returns vert number in al 
get_last_snake_vert ENDP


update_positions PROC 
    ; purpose: function to update the snake's positions 
    ; args: assumes replaced is given the correct value to replace
    ; affect: none
    ; return: modifies snake positions arr
update_positions ENDP 

get_apple_cords PROC
    ; purpose: function to get random x pos and y pos of apple (apple generation)
    ; args: none other than knowing what is grid width and grid height
    ; affect: none
    ; return: modifies apple x pos and apple y pos
get_apple_cords ENDP

check_apple PROC
    ; purpose: function to check if apple has been eaten yet. If so, generate new apple
    ; args: none other than knowing what is grid width and grid height
    ; affect: none
    ; return: increases snakeLength and playerScore by one when apple is eatem 
check_apple ENDP

get_top_connection PROC 
    ; purpose: function to get top connection 
    ; args: assumes vert number that you want to get the top connection of is in vertNum
    ; affect: none
    ; return: updates topConnection variable 
get_top_connection ENDP 

get_bot_connection PROC
    ; purpose: fuction to get bot connection
    ; args: assumes vert number that you want to get the bot connection of is in vertNum
    ; affect: none
    ; return: updates botConnection variable 
get_bot_connection ENDP

get_right_connection PROC    ;inc vertNum ; don't do this, might mess it up
    ; purpose: fuction to get right connection
    ; args: assumes vert number that you want to get the right connection of is in vertNum
    ; affect: none
    ; return: updates rightConnection variable 
get_right_connection ENDP 

get_left_connection PROC
    ; purpose: fuction to get left connection
    ; args: assumes vert number that you want to get the left connection of is in vertNum
    ; affect: none
    ; return: updates leftConnection variable 
get_left_connection ENDP

go_to_position_matrix PROC USES ecx eax edx
    ; purpose: fuction to go to specific position in matrix 
    ; args: assumes dh has row and al has col number
    ; affect: esi register
    ; return: esi register that has value at that position  
go_to_position_matrix ENDP


initialize_adj_matrix PROC USES eax dx 
    ; purpose: fuction to go to initialize adj matrix
    ; args: none other knowing the max number of verts the grid has 
    ; affect: none
    ; return: modifies adj matrix 
initialize_adj_matrix ENDP

add_adj_matrix PROC 
    ; purpose: function used to represent snakes as an invalid vertex in adjacency matrix
    ; args: assumes the offset of the snake position array has been passed into esi
    ; affect: no flags or registers affected
    ; return: modifies adjacency matrix 
add_adj_matrix ENDP


clear_b_array PROC ; assuming the offset is already in esi, ecx has the amount of items to clear, assuming dh is the fill var
    ; purpose: clears the given arr 
    ; args: esi has offset of arr, ecx has amount of items to clear, dh has the "fill" variable (0,-1 etc)
    ; affect: no flags or registers affected
    ; return: modifies the given arr in esi 
clear_b_array ENDP

search_arr PROC ; arr in esi, put item you want to search for in dh, if found return truth value in al , size in ecx 
   ; purpose: searches the given arr for item
   ; args: esi has offset of arr, ecx has size, dh has the item you want to search for 
   ; affect: al affected
   ; return: truth value in al 
search_arr ENDP

append_arr PROC 
    ; purpose: appends an item to the end of arr
    ; args: esi has offset of arr, eax has size, dh has item to append
    ; affect: eax affected
    ; return: new increased size in eax
append_arr ENDP

pop_front PROC
    ; purpose: clears the given arr 
    ; args: esi has offset of arr, size in eax
    ; affect: dl affected 
    ; return: modifies arr, dl holds popped item
pop_front ENDP

pop_end PROC ; dh holds what to fill with, and size in eax and arr given in esi  --> update new size with eax
    ; purpose: clears the given arr 
    ; args: esi has offset of arr, eax has size, dh has the "fill" variable (0,-1 etc)
    ; affect: eax affected
    ; return: modifies the given arr in esi and the eax size
pop_end ENDP

check_path PROC
    ; purpose: function used to check whether the test path is valid or not. If invalid, call recaculate_path
    ; args: no args
    ; affect: no flags or registers affected
    ; return: modifies the found path arr
check_path ENDP

djikstra_algo PROC
    ; purpose: function used to find the shortest path from a starting vert
    ; args: start vert in startVert and dest vert in destVert, assumes pathArr and distArr have been updated accordinly
    ; affect: none 
    ; return: modifies the path arr and dist arr
djikstra_algo ENDP

find_path PROC 
    ; purpose: function used to construct the shortest path between dest and start vert 
    ; args: dest and start vert passed accordingly, foundPath arr in esi
    ; affect: no flags or registers affected
    ; return: modifies the found path arr
find_path ENDP

recalculate_path PROC 
    ; purpose: function called to find alternate paths to apple
    ; args: assumes validConnectionsArr has been updated accordingly with verts adj to head
    ; affect: none
    ; return: modifies foundPath arr  
recalculate_path ENDP

test_path PROC 
    ; purpose: function called to test the found path and see if its vali, simulates test situation accordingly, 
    ; args: assumes foundPath arr has been updated with the path you want to test
    ; affect: none
    ; return: modifies foundTestPath arr and foundPath arr 
test_path ENDP

move_func PROC
    ; purpose: function to move snake, low level function 
    ; args: assumes esi has been given beforehand --> esi stands for which position to start interpreting at in foundPath
    ; affect: eax register
    ; return: none
move_func ENDP

special_move PROC
    ; purpose: function to move snake --> but in the specified alternate path found by recalculate not djikstra
    ; args: none other than a correct foundPath arr 
    ; affect: none
    ; return: none
special_move ENDP

follow_tail PROC  
    ; purpose: function to follow tail --> in the case no valid alternate path was found and djikstra path was invalid  
    ; args: none 
    ; affect: none 
    ; return: modifies foundPath arr 
follow_tail ENDP

normal_move PROC  
    ; purpose: function to move normally 
    ; args: none other than a correct foundPath arr
    ; affect: none 
    ; return: none
normal_move ENDP

move_decider PROC  
    ; purpose: function to decide which move function to call (follow tail, special move, or normal move)
    ; args: none 
    ; affect: none 
    ; return: modifies foundPath arr 
move_decider ENDP

```


<br><br>


