
# SNAKE SOLVER - FINAL PROJECT

## Name: <ins> QUEENCY TAN </ins>

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

```
```
add_adj_matrix PROC 
    ; purpose: function used to represent snakes as an invalid vertex in adjacency matrix
    ; args: assumes the offset of the snake position array has been passed into esi
    ; affect: no flags or registers affected
    ; return: modifies adjacency matrix 
        pushad 
        movzx ecx, snakeLength 
          L1:
              mov dl, [esi]
              mov dh, [esi + 1]
              call cord_to_vert  ; given x and y screen cord in dl and dh --> will turn that screen cord into a vert number, result held in al
              mov dl, al
              call turn_off_col  ; given a vert number in dl, will turn off that associated column in the adj matrix
              add esi, 2 
          loop L1
      popad
    ret
add_adj_matrix ENDP
```
```

check_path PROC
    ; purpose: function used to check whether the test path is valid or not. If invalid, call recaculate_path
    ; args: no args
    ; affect: no flags or registers affected
    ; return: modifies the found path arr
    cmp foundTestPath[0], -1 
        je invalidPath 
        jmp validPath
    invalidPath: 
        call revert_adj_matrix 
        call recalculate_path
        call reset_valid_connections_arr  
    validPath:  
    ret
check_path ENDP

```


<br><br>


