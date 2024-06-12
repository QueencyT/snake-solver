include irvine32.inc 

; GAME PLANNING -


;------------------------------------------------------ GAME PLAN - SETTING UP ADJ MATRIX -------------------------------------------------------------------------

;0 0 0 0 0 0 0 0 ------------------> 1  2  3  4  5  6  7  8  ; corners --> 1, 8, 25, 32 (so only two connections max ) 
;0 0 0 0 0 0 0 0                     9 10 11 12 13 14 15 16  ; horiz/vert middle edge stuff (3 connections max)
;0 0 0 0 0 0 0 0                    17 18 19 20 21 22 23 24  ; true middle stuf (4 connections max )
;0 0 0 0 0 0 0 0                    25 26 27 28 29 30 31 32   


; calculating corners --> 1 ; will always be top left corner
;                    --> width ; will always give top right corner 
;                    --> 1 + (max_row - 1)(width) ; max_row in this case is gridHeight (4), gives bottom left corner
;                    --> 32 (aka row * width (gridHeight * playField)) ; will always give us bottom right corner 

; calculating connections  --> top connection: (vert - width) ex(vert 10 - width 8 gives 2 the top connection)
;                          --> bot connection: (vert + width) ex(vert 10 + width 8 gives 18 the bot connection) 
;                          --> right connection: (vert + 1) ex(vert10 + 1 gives 11 the right connection) 
;                          --> left connection: (vert - 1) ex(vert10 - 1 gives 10 the left connection)

; knowing whether a vert is a corner, top edge, bot edge, right edge, or left edge 
;                          --> top edge: check if vert number is less than 8 (top right corner vert) and bigger than 1 
;                          --> bot edge: check if vert number is greater than 25 (bot left corner) and less than 32 (bot right corner) 
;                          --> right edge: cleanly divisible by width --> width +, have a loop add width continuously loop limit is gridHeight, if number doesnt match then not a right edge 
;                          --> left edge: 1 + 8 --> 1 +, have a loop add width continuoulsy loop limit is gridHeight, if number doesn't match than not a left edge  

; types of connections: 
;                        --> top edge: left connection, right connection, bot connection ex) top edge 2 has connection to 1,3,10 --> turn on 1,3,10 on row 2 and everything else 0
;                        --> bot edge: left connection, right connection, top connection 
;                        --> right edge: top connection, bot connection, left connection 
;                        --> left edge: top connection, bot connection, right connection 

; if it's not one of the above, then it has to be a middle vert with 4 connections ; function where it returns the connections given a vert #

; calculating corner connections --> top left connection  ; (1 + width), gives bottom connection. (1 + 1) --> gives right connection // abstract these methods out
;                                --> top right connection ; (top right vert - 1), gives left connection. (top right vert + width) --> gives bottom connection 
;                                --> bottom left connection ; (bot left vert - width) gives top connection. (bot left vert + 1) --> gives right connection 



; SNAKE MATRIX --> if snake is there 0, if snake is not there 1 
;0 0 0 0 0 0 0 0 ------------------> 1  2  3  4  5  6  7  8  ; corners --> 1, 8, 25, 32 (so only two connections max ) 
;0 0 0 0 0 0 0 0                     9 10 11 12 13 14 15 16  ; horiz/vert middle edge stuff (3 connections max)
;1 1 1 0 0 0 0 0                    17 18 19 20 21 22 23 24  ; true middle stuf (4 connections max )
;0 0 0 0 0 0 0 0                    25 26 27 28 29 30 31 32
; starts from 1 not 0 

; knowing which rows are contaminated with snakes --> loop through snake positions 
;                                                  --> take xCord and Ycord 
;                                                  --> ([(yPos - 1) * width] + xPos) = vert# 
;                                                  --> ex) 0301 --> [(3-1) * 8] + 1 = 17 --> which is correct vert number 
;                                                  --> if snake at a vert turn off that row and column (ex: if snake on vert 10, turn off row 10 and column 10)

; changing vert to cords ---> getting xCoord --> ([vert # - 1]/playWidth) + 1 --> ignoring decimal, we will get the xCoord
;                        ---> getting yCoord -->  YES

; Path Interpretation --> 
;                  we know Head Vert # --> 19 --> path 20,21,13 --> find connections, 
;                  if path vert equal to to top move up, if equal to bot move down, if equal to right move right, if equal to left move left 
;                  after move, update head to this new vert position, once xPos = appleXPos, djisktra again

;initialize adj matrix this way every single time, and then modify it with snake positions disabling what needs to be disabled 
;use djikstra to calculate shortest path

; over every apple for now... 
;update_adj_matrix PROC ; updates adj matrix according to snake positions ; updates after move
    ; look at path array -->  turn on all the verts in that path array (old path) ; this --> turn off all the verts in that old path array --> wrong thinking opp
    ; but how turn off? --> have a prev path arr ? --> move 0 at the end of these paths to signify the end
    ;ret
;update_adj_matrix ENDP ; now after this calc new path

;-------------------------------------------------------- DJIKSTRA LOOSE PLANNING ------------------------------------------------------------------------------

; djik every move algo: can reuse initialized matrix, 
;; now, we need to add the snake positions --> turn off that row and column where snake is 
; turn off last snake yPos, last snake xPos, turn on xPos, yPos 
; turn onn not as simple as turn off --> get vert # and determine if it's a corner, or and get connections accordingly --> ok

; current algo --> djik once every apple ; head pos == end very ; now can reuse initialized matrix
; clear what was once in path data --> turn off bytes in path data, reset path array --> set it to max distances loop until we get == 256
; get new path using djikstra 
; turn on adj matrix using new path
; move snake according to this new path (no need to update adj matrix atp)



;0 0 0 0 0 0 0 0 ------------------> 1  2  3  4  5  6  7  8  ; corners --> 1, 8, 25, 32 (so only two connections max ) 
;0 0 0 0 0 0 0 0                     9 10 11 12 13 14 15 16  ; horiz/vert middle edge stuff (3 connections max)
;0 0 0 0 0 0 0 0                    17 18 19 20 21 22 23 24  ; true middle stuf (4 connections max )
;0 0 0 0 0 0 0 0                    25 26 27 28 29 30 31 32   

; RULES --> 1 symbolizes path, 0 symbolizes no path between those two : row --> col / source --> dest  

;    1 2 3 4 5 6 7 8 9  ---> adj martrix of 3 x 3 gameboard  ----->      1 2 3     
;  1 0 1 0 1 0 0 0 0 0                                                   4 5 6
;  2 1 0 1 0 1 0 0 0 0                                                   7 8 9
;  3 0 1 0 0 0 1 0 0 0
;  4 1 0 0 0 1 0 1 0 0
;  5 0 1 0 1 0 1 0 1 0
;  6 0 0 1 0 0 1 0 0 1
;  7 0 0 0 1 0 0 0 1 0
;  8 0 0 0 0 1 0 1 0 1
;  9 0 0 0 0 0 1 0 1 0 

;    1 2 3 4 5 6 7 8 9  ---> adj martrix of 3 x 3 gameboard w/ snakes at 0202 0201  ----->      1 2 3    --> 0202 = vert 5, 0201 = vert 4 
;  1 0 1 0 0 0 0 0 0 0                                                                          4 5 6
;  2 1 0 1 0 0 0 0 0 0                                                                          7 8 9
;  3 0 1 0 0 0 1 0 0 0
;  4 1 0 0 0 0 0 0 0 0
;  5 0 1 0 1 0 1 0 1 0
;  6 0 0 1 0 0 1 0 0 1
;  7 0 0 0 0 0 0 0 1 0
;  8 0 0 0 0 0 0 1 0 1
;  9 0 0 0 0 0 1 0 1 0 

; means we need to puts 0s in row and column 5, row and column 4  --> turn off 
; turn back on --> turn on connections of vert 5, and vert 4 --> not that simple, must turn on all the connections of those verts and their connecting verts 
; maybe make a byte array called connections --> find connections --> put them into that byte array, loop and turn on all those connections 

;---------------------------------------------------------------------------------------------------------------------------------------------------------------

 .data 
    ;-------- DATA FOR GRID--------
    gridHeight BYTE 9       ; has to be one more than theactual grid height you want 
    playFieldWidth BYTE 29
    hBorder BYTE 31 DUP ("X"), 0;  "XXXXXXXXXXXXXXXX", 0 ; has to be two more than actual playField width 
    borderPiece BYTE "X", 0;  
.data 
    ;--------- DATA FOR SNAKE ------ 
    xPos BYTE ? ; keeps track of head of snake
    yPos BYTE ? 
    snakeHead BYTE "o", 0
    snakeLength BYTE 2; --> at least 3 by default usually

    snakePositions WORD 0101h, 0102h, 230 DUP (0)  ; YYXX --> XXYY in mem
    testPositions WORD 0101h, 0102h, 230 DUP (0)

    snakeMatrix BYTE 1,1, 230 DUP(0) 
    lastSnakeXPos BYTE 2 ; WILL NEED TO UPATE THESE IF W CHANGE START POS 
    lastSnakeYPos BYTE 1

    

    replaced WORD ? 
    hasSnake BYTE 0 ; bool for if there is snake in a spot or no, false by default
    
.data 
    ;---------- DATA FOR MOVEMENT ---------
    upCode BYTE 48h 
    downCode BYTE 50h 
    leftCode BYTE 4Bh
    rightCode BYTE 4Dh 
    currDirection BYTE 4Dh ; moves right by defualt 
.data
    ;---------- DATA FOR APPLE ------------- 
    appleXPos BYTE ? 
    appleYPos BYTE ? 
    apple BYTE "*", 0    
    hasApple BYTE 0 ; 0 for false, no apple by default 

    ;----------- DATA FOR SPACE ------------- 
    space BYTE " ", 0  

.data 
   ;---------- DATA FOR SCORE -------------
   playerScore BYTE ? 

.code

;------------------------------------------------------------ HELPER FUNCTIONS FOR DRAW -------------------------------------------------------------------------------------


allign_cursor_left PROC ; perhaps in future we want to change positions of gameboard, will be useful 
    pushad 
    mov dl, 0 ; allign cursor to pos 0 
    call GOTOXY
    popad
    ret 
allign_cursor_left ENDP 

allign_cursor_right PROC 
    pushad
    mov dl, LENGTHOF hBorder ; setting up cords to draw right piece 
    sub dl, 2 ; to allign b/c of spaces 
    call GOTOXY
    popad
    ret 
allign_cursor_right ENDP

draw_border_piece PROC
    pushad
    mov edx, OFFSET borderPiece ; drawing right piece  
    call WriteString
    popad
    ret 
draw_border_piece ENDP 

draw_horiz_border PROC 
    pushad
    mov edx, OFFSET hBorder ; drawing top part of border
    call WriteString
    popad
    ret
draw_horiz_border ENDP
   
draw_top_horiz_border PROC 
    pushad
    mov dl, 0 
    mov dh, 0 
    call GOTOXY 
    call draw_horiz_border 
    popad
    ret
draw_top_horiz_border ENDP

draw_bot_horiz_border PROC 
    pushad
    mov dl, 0 
    mov dh, gridHeight 
    call GOTOXY 
    call draw_horiz_border 
    popad
    ret 
draw_bot_horiz_border ENDP

draw_right_border PROC  
    pushad
    call allign_cursor_right
    call draw_border_piece 
    popad
    ret
draw_right_border ENDP

draw_left_border PROC 
     pushad
     call allign_cursor_left 
     call draw_border_piece 
     popad
     ret 
draw_left_border ENDP

draw_borders PROC 
    pushad
    call draw_left_border
    call draw_right_border
    popad
    ret
draw_borders ENDP 

draw_apple PROC 
    pushad
    mov dh, appleYPos ; 
    mov al, appleXPos ; to prime draw_obj function 
    mov esi, OFFSET apple 
    call draw_obj   
    popad
    ret
draw_apple ENDP 

; mov OFFSET of obj you want to draw into esi, expected that cords are in dh and al, dh for Y, al for X
draw_obj PROC  ; draw the row ; loop in here to draw the rest of snake body --> maybe ? 
        pushad 
        ;drawing obj 
            mov dl, al ; move the x coord into dl ; b/c that's the only thing that is different
            call GOTOXY 
            mov edx, esi
            call WriteString 
        popad
        ret 
draw_obj ENDP
    
draw_both PROC 
    pushad 
    call draw_apple
    call draw_snake
    popad
    ret
draw_both ENDP 


;-------------------------------------------------------------------------------- SNAKE MATRIX FUNCTIONS ---------------------------------------------------------------------

turn_on_snake_matrix PROC  
    pushad 
        mov dl, al 
        call cord_to_vert ; al holds vert num
        dec al 
        movzx esi, al
        mov snakeMatrix[esi], 1
    popad 
    ret
turn_on_snake_matrix ENDP 

turn_off_snake_matrix PROC 
    pushad 
        mov dl, al 
        call cord_to_vert 
        dec al 
        movzx esi, al 
        mov snakeMatrix[esi], 0
    popad
    ret
turn_off_snake_matrix ENDP


;----------------------------------------------------------------- MAJOR DRAWING FUNCTIONS -------------------------------------------------------------------------------------

draw_snake PROC ;we want to loop through snake positions, checking if any of the snake parts are on the current row --> if so draw it
     pushad 
     movzx ecx, snakeLength 
     mov esi, 0 ; this means we're checking from beginning again 

     cmp dh, lastSnakeYPos ; to remove last part of snake --> added b/c no longer using clrscr
        jne checking 
        call remove_last_snake 

        checking:  
            cmp dh, BYTE PTR snakePositions[esi + 1] ; are we on the same row as a part of the snake? ;  if there is no snake there
                je drawSnake
                jmp next 
           drawSnake: 
                mov al, BYTE PTR snakePositions[esi] ; priming draw obj
                call turn_on_snake_matrix
                push esi 
                mov esi, OFFSET snakeHead 
                call draw_obj
                pop esi
            next:
                add esi,2 
        loop checking
        popad 
        ret
draw_snake ENDP  

draw_grid PROC
    pushad 
        call draw_top_horiz_border
        mov dh, 1 ; initializing position ; could make a go to row function to increase readability... hmm
        mov dl, 0 
        movzx ecx, gridHeight

    drawing: ; this loop is to draw the vert borders 
        call GOTOXY 
        push dx ; saving cords 
        call draw_snake ; will draw all the snakes on a certain row 

        cmp dh, yPos ; are we on the same row as the snake?
            je isSnake 
        cmp dh, appleYPos ; are we on the same row as the apple? 
            je drawApple
            jmp next
              
        isSnake: 
            cmp dh, appleYPos ; if apple and snake on same row 
                je both
                jmp next
        drawApple: 
            call draw_apple 
            jmp next
        both:
            call draw_both 
            jmp next 
        next:  ;going to next line -> and basically our "normal" case  
            call draw_borders
            pop dx ; restoring cords 
            inc dh ; move to next row 
    loop drawing 
        call draw_bot_horiz_border
    popad
    ret
draw_grid ENDP

;------------------------------------------------------------------------ LAST SNAKE POS FUNCTIONS ----------------------------------------------------------------------------------------

get_last_snake_pos PROC USES esi 
    movzx esi, snakeLength
    dec esi
    mov dl, BYTE PTR snakePositions[esi * 2] ; YYXX --> XXYY ; XXYY XXYY XXYY 
    mov dh, BYTE PTR snakePositions[esi * 2 + 1]
    mov lastSnakeXPos, dl 
    mov lastSnakeYPos, dh
    ret 
get_last_snake_pos ENDP

get_last_snake_test_vert PROC USES esi edx
    movzx esi, snakeLength 
    dec esi 
    mov dl, BYTE PTR testPositions[esi * 2]
    mov dh, BYTE PTR testPositions[esi * 2 + 1]
    call cord_to_vert  ; AL has vert num
    ret
get_last_snake_test_vert ENDP

get_last_snake_vert PROC  USES dx
    mov dl, lastSnakeXPos 
    mov dh, lastSnakeYPos 
    call cord_to_vert  
    ret
get_last_snake_vert ENDP

remove_last_snake PROC USES edx
    mov dh, lastSnakeYPos 
    mov al, lastSnakeXPos 
    call turn_off_snake_matrix 
    mov dl, al 
    call GOTOXY 
    mov edx, OFFSET space 
    call WriteString
    ret 
remove_last_snake ENDP

;----------------------------------------------------------------------- HAS SNAKE FUNCTIONS --------------------------------------------------------------------------------------------

has_snake PROC ;if has snake, then hasSnake equals 1 ; provided location has been provided... in dh row, in dl col
   push eax 
   call cord_to_vert ; vert in al 
   dec al 
   movzx esi, al 
   mov al, snakeMatrix[esi]
   mov hasSnake, al
   pop eax 
   ret
has_snake ENDP

;------------------------------------------------------------- HELPER FUNCTIONS FOR MOVEMENT ----------------------------------------------------------------------------------- 

check_for_new_key PROC 
    call ReadKey 
        jnz newKey 
        jmp sameKey
    newKey: 
        mov currDirection, ah  
    sameKey: 
    ret 
check_for_new_key ENDP 

;-------------------------------------------------------------------- MOVE SNAKE GAME --------------------------------------------------------------------------------------------------

move_snake PROC ;get new position of snake ; will move right by default
   cmp currDirection, 48h; code for up 
        je upKeyPressed  

   cmp currDirection, 50h ; code for down
        je downKeyPressed  

   cmp currDirection, 4Bh ; code for left
        je leftKeyPressed 

   cmp currDirection, 4Dh ; code for right
        je rightKeyPressed
        jmp next 
   
    upKeyPressed: ; decrease x pos b/c higher yPos means going down rows 
        dec yPos  
        mov currDirection, 48h
        jmp next
    downKeyPressed: 
        inc yPos 
        mov currDirection, 50h 
        jmp next
    rightKeyPressed: 
        inc xPos 
        mov currDirection, 4Dh
        jmp next
    leftKeyPressed:  
        dec xPos 
        mov currDirection, 4Bh
        jmp next
    next:  
        mov bl, xPos
        mov bh, yPos  
        mov replaced, bx  
    ret
move_snake ENDP

;------------------------------------------------------------- UPDATE POSITIONS FUNCTIONS --------------------------------------------------------------------------------------


update_positions PROC ; assuming offset of arr has been moved to esi, assuming ecx has been appropriately set
    mov bx, replaced
    pushad 
                             
    L1: 
        mov bx, [esi] ; move what we're bout to replace into bx
        mov ax, replaced
        mov [esi], ax ; move the replacement into snakePos 
        mov replaced, bx
        add esi, 2 ; 2 b/c word is 2 bytes
    loop L1

    popad
    mov replaced, bx ; restoring the replaced for test pos 
    ret
update_positions ENDP 

update_snake_positions PROC 
    pushad 
        mov esi, OFFSET snakePositions 
        movzx ecx, snakeLength
        call update_positions 
    popad
    ret
update_snake_positions ENDP

update_test_positions PROC 
    pushad 
        mov esi, OFFSET testPositions 
        movzx ecx, snakeLength 
        call update_positions 
    popad
    ret
update_test_positions ENDP


;--------------------------------------------------------------- FUNCTIONS FOR APPLE CORDS ----------------------------------------------------------------------------------- 
get_apple_x_pos PROC 
    movzx eax, playFieldWidth 
    sub eax, 1
    call RandomRange 
    inc eax 
    mov appleXPos, al 
    ret
get_apple_x_pos ENDP 

get_apple_y_pos PROC ; 5 --> 1 to 4
    movzx eax, gridHeight  
    sub eax, 2
    call RandomRange ; produce number from 0 to 7
    inc eax ; produce number from 1 to 3
    mov appleYPos, al 
    ret
get_apple_y_pos ENDP 


get_apple_cords PROC ; may rename to spawn random apple...
   ; call Randomize ;                                                                      NO LONGER SEEDING RAND MUST CHANGE BACK LATER
    call get_apple_x_pos  ;generate a number between 1 to 29 (max playing field width) --> gets x coord
    call get_apple_y_pos  ;generate a number between 1 to (max playing field height) --> gets y coord
    ret 
get_apple_cords ENDP 

;-------------------------------------------------------------------- APPLE CONTROLLER FUNCTIONS -------------------------------------------------------------------------------------------


get_new_apple PROC 
    makeApple: 
        call get_apple_cords
        mov dh, appleYPos 
        mov dl, appleXPos 
        call has_snake ; moves 0 into hasSnake, if there is a snake there  ; checks if snake is at these coords
        cmp hasSnake, 1 ; if snake is there, get a new apple pos
            je makeApple   
        mov hasApple,1 
    ret
get_new_apple ENDP


check_apple PROC 
    pushad
    cmp hasApple, 0 ; if an apple does not exist 
        je makeNewApple 
    mov al, appleXPos 
    cmp al, xPos ; is apple on the same column as snake?
        jne next    
    mov al, appleYPos  
    cmp al, yPos ; is apple on the same row as snake?
        jne next  
    eatApple: ; ate apple so get new cords        
           mov hasApple, 0 ; no more apple
           inc playerScore
           inc snakeLength
           mov pathTested,0 
           jmp makeNewApple 
     makeNewApple:
        call get_new_apple 
    next:
    popad
    ret
check_apple ENDP 
;---------------------------------------------------------------------------- UI FUNCTIONS ------------------------------------------------------------------------------------------

.data 
    gameOverMsg BYTE "GAME OVER!", 0
.code

game_over_screen PROC 
    pushad
    call CLRSCR
    call draw_top_horiz_border
    movzx ecx, gridHeight
    mov dh, 1 
    mov dl, 0

        L1:  
            cmp dh, 4 
                je writeGameOver 
                jmp next
            writeGameOver: 
                mov dl, 10
                call GOTOXY
                mov edx, OFFSET gameOverMsg 
                call WriteString 
            next: 
                call draw_borders 
                inc dh
        loop L1
    call draw_bot_horiz_border 
    popad
    ret
game_over_screen ENDP 

game_over PROC ;1EH --> right edge, ;0 --> left edge ; 0 --> top edge ; 9 --> bottom edge
    cmp XPos, 1EH 
        je gameOver 
    cmp XPos, 0  
        je gameOver 
    cmp YPos, 0 
        je gameOver 
    cmp YPos, 9 
        je gameOver 
        jmp next
    gameOver: 
       call game_over_screen 
       mov ecx, 1
    Next: 
        
    ret
game_over ENDP 

.data 
    scoreMsg BYTE "SCORE: ", 0 
.code 

;---------------------------------------------------------------- SCORE UI FUNCTIONS ------------------------------------------------------------------------------------------
clear_score PROC 
    mov ecx, 3 
    L1: 
        call GOTOXY 
        mov edx, OFFSET space  
        call writeString 
        inc dl 
     loop L1
     ret
clear_score ENDP

write_score PROC 
     pushad

     mov dh, 5 
     mov dl, 33 
     call GOTOXY 
     mov edx, OFFSET scoreMsg 
     call writeString

     add dl, 2
     call clear_score 
     
     mov dl, 35; write new score
     call GOTOXY
     movzx eax, playerScore
     call writeInt
     
     popad 
     ret
write_score ENDP 
;-------------------------------------------------------------------- ADJ MATRIX FUNCTIONS ---------------------------------------------------------------------------------------------


;0 0 0 0 0 0 0 0 ------------------> 1  2  3  4  5  6  7  8  ; corners --> 1, 8, 25, 32 (so only two connections max ) 
;0 0 0 0 0 0 0 0                     9 10 11 12 13 14 15 16  ; horiz/vert middle edge stuff (3 connections max)
;0 0 0 0 0 0 0 0                    17 18 19 20 21 22 23 24  ; true middle stuf (4 connections max )
;0 0 0 0 0 0 0 0                    25 26 27 28 29 30 31 32   


.data
adjMatrix BYTE 53824 DUP (0) ; all invalid by default, ; first row is row 1, not row 0

.data
;--------- CORNER DATA -----------
   
    topLeftCorner BYTE 1 
    topRightCorner BYTE 29 
    botLeftCorner BYTE 204 
    botRightCorner BYTE 232 
    
.data
;--------- VERT DATA/CONNECTION DATA -----------
    vertNum BYTE 1 ; 1 by default
    topConnection BYTE ? 
    botConnection BYTE ? 
    rightConnection BYTE ? 
    leftConnection BYTE  ? 
.data 
;--------- TYPE DATA ------------------------
    isTopEdge BYTE ? ; either 1 or 0 --> 1 for true, 0 for not 
    isBotEdge BYTE ? ; either 1 or 0 
    isRightEdge BYTE ? 
    isLeftEdge BYTE ?
    isCorner BYTE ?

.code

;---------------------------------------------------------- CONNECTION FUNCTIONS -------------------------------------------------------------------------------------------- 
get_top_connection PROC ; mov into vertNum to use 
    push eax
        mov al, vertNum 
        sub al, playFieldWidth 
        mov topConnection, al
    pop eax
    ret
get_top_connection ENDP 

get_bot_connection PROC 
    push eax 
        mov al, vertNum 
        add al, playFieldWidth 
        mov botConnection,al 
    pop eax
    ret 
get_bot_connection ENDP

get_right_connection PROC    ;inc vertNum ; don't do this, might mess it up
    push eax  
        mov al, vertNum 
        inc al 
        mov rightConnection, al 
    pop eax
    ret
get_right_connection ENDP 

get_left_connection PROC 
    push eax 
        mov al, vertNum 
        dec al 
        mov leftConnection, al 
    pop eax
    ret
get_left_connection ENDP

; keep track of vert num, make 
;check shorter and valid functiion

;--------------------------------------------------- EDGES & CORNERS BOOLEAN FUNCTIONS ----------------------------------------------------------- 

is_top_edge PROC ; need to move into vert num
    push dx 
    mov isTopEdge, 0 ; set false by default
    mov dh, topRightCorner
    cmp vertNum, dh
        jb next 
        jmp notTop
    next: 
        cmp vertNum, 1 
            jbe notTop 
        mov isTopEdge, 1
    notTop: 
    pop dx
    ret
is_top_edge ENDP 

is_bot_edge PROC
    push eax 
    mov al, botLeftCorner
    mov isBotEdge, 0 
    cmp vertNum, al  
        ja next 
        jmp notBot
    next: 
        mov al, botRightCorner
        cmp vertNum, al 
            jae notBot 
        mov isBotEdge, 1 
    notBot: 
        pop eax
    ret
is_bot_edge ENDP

is_right_edge PROC ; check if vertNum is the right edge, NEED TO STEP THROUGH TO CHECK --> logic is correct
    push eax 
    push ecx

    mov isRightEdge, 0 

    mov al, topRightCorner 
    cmp vertNum, al 
         je notRight
    mov al, botRightCorner
    cmp vertNum,al
         je notRight
    
    movzx ecx, gridHeight 
    dec ecx; ecx = 4, number of rows 
    mov al, playFieldWidth ; set to 8, the width

    checking: 
        cmp vertNum, al ; will be subject to change with larger graphs
            je isRight  
        add al, playFieldWidth 
    loop checking 
        jmp notRight
    isRight: 
        mov isRightEdge, 1 
    notRight:
        
    pop ecx 
    pop eax
    ret
is_right_edge ENDP

is_left_edge PROC 
    push eax 
    push ecx 

    mov isLeftEdge, 0 

    mov al, topLeftCorner 
    cmp vertNum, al 
        je notLeft 
    mov al, botLeftCorner 
    cmp vertNum, al 
        je notLeft

    movzx ecx, gridHeight 
    dec ecx 
    mov eax, 1 

    checking: 
        cmp vertNum, al ; subject to change from al to eax if bigger playfield  
            je isLeft 
        add al, playFieldWidth 
    loop checking 
        jmp notLeft

    isLeft:
        mov isLeftEdge, 1 
    notLeft: 
        pop ecx 
        pop eax 
    ret
is_left_edge ENDP

is_edge PROC ; given a vertNum, see if that vert is an edge vert or not,truth value in al
    mov al, 0 
    call is_corner
    cmp isCorner, 1 
        je edge
    call is_left_edge 
    cmp isLeftEdge, 1 
        je edge 

    call is_right_edge
    cmp isRightEdge,1 
        je edge 

    call is_bot_edge 
    cmp isBotEdge, 1
        je edge 

    call is_top_edge
    cmp isTopEdge, 1 
        je edge  
        jmp next
    edge:  
        mov al, 1 
    next: 
    ret
is_edge ENDP 

is_corner PROC ; move into vert num
    push eax 

    mov al, vertNum
    mov isCorner, 0 

    cmp al, topLeftCorner        ;corner stuff ;could possibly handle it by itself, make isCorner, if is, skip b/c it will be handled by itself
        je corner
    cmp al, topRightCorner 
        je corner
    cmp al, botLeftCorner 
        je corner
    cmp al, botRightCorner 
        je corner
        jmp notCorner 

    corner: 
        mov isCorner, 1
    notCorner:  
    pop eax 
    ret 
is_corner ENDP

;------------------------------------------------ ADJ MATRIX HELPER FUNCTIONS --------------------------------------------------------------------
go_to_position_matrix PROC USES ecx eax edx  ; given row number in dh, and col number in al, will go to that position and return in esi is now at that pos 
    dec dh      
    dec al

    movzx esi, al; has col 
    add esi, OFFSET adjMatrix  
    
    movzx ecx, verts; 
    movzx eax, dh ; 
    mul ecx
    add esi, eax  ; esi has result
    ret 
go_to_position_matrix ENDP

turn_on PROC  
    mov BYTE PTR[esi], 1 
    ret
turn_on ENDP

turn_off PROC  ; give a pos of a byte 
   mov BYTE PTR [esi], 0
   ret
turn_off ENDP 

turn_on_byte_matrix PROC USES dx eax esi ecx ;condition --> mov cords into dh and al
    call go_to_position_matrix ; going to position specified in dh and al
    call turn_on
    ret
turn_on_byte_matrix ENDP

turn_on_left_connection PROC 
    push eax 
        call get_left_connection 
        mov al, leftConnection 
        call turn_on_byte_matrix 
    pop eax
    ret
turn_on_left_connection ENDP 

turn_on_right_connection PROC
    push eax 
        call get_right_connection 
        mov al, rightConnection 
        call turn_on_byte_matrix 
    pop eax
    ret
turn_on_right_connection ENDP

turn_on_bot_connection PROC 
    push eax 
        call get_bot_connection
        mov al, botConnection 
        call turn_on_byte_matrix
    pop eax 
    ret 
turn_on_bot_connection ENDP

turn_on_top_connection PROC 
    push eax 
        call get_top_connection
        mov al, topConnection 
        call turn_on_byte_matrix 
    pop eax 
    ret
turn_on_top_connection ENDP

get_all_top_edge_connections PROC 
    push eax 
        call turn_on_left_connection
        call turn_on_right_connection
        call turn_on_bot_connection
    pop eax 
    ret
get_all_top_edge_connections ENDP

get_all_bot_edge_connections PROC 
    push eax 
        call turn_on_left_connection  ;move into connections array [0]
        call turn_on_right_connection ;next index
        call turn_on_top_connection ; next index 
    pop eax 
    ret
get_all_bot_edge_connections ENDP

get_all_right_edge_connections PROC 
    push eax
        call turn_on_top_connection 
        call turn_on_bot_connection 
        call turn_on_left_connection
    pop eax 
    ret 
get_all_right_edge_connections ENDP

get_all_left_edge_connections PROC 
    push eax
        call turn_on_top_connection 
        call turn_on_bot_connection 
        call turn_on_right_connection
    pop eax 
    ret
get_all_left_edge_connections ENDP

get_all_top_right_corner_connections PROC  
    push eax 
        call turn_on_left_connection 
        call turn_on_bot_connection
    pop eax 
    ret
get_all_top_right_corner_connections ENDP

get_all_top_left_corner_connections PROC 
     push eax
        call turn_on_right_connection 
        call turn_on_bot_connection 
     pop eax 
     ret 
get_all_top_left_corner_connections ENDP

get_all_bot_right_corner_connections PROC 
    push eax
        call turn_on_left_connection 
        call turn_on_top_connection 
    pop eax 
    ret
get_all_bot_right_corner_connections ENDP

get_all_bot_left_corner_connections PROC 
    push eax
        call turn_on_right_connection 
        call turn_on_top_connection  
    pop eax 
    ret
get_all_bot_left_corner_connections ENDP

get_all_mid_connections PROC 
    push eax  
        call turn_on_top_connection
        call turn_on_bot_connection 
        call turn_on_right_connection 
        call turn_on_left_connection
    pop eax 
    ret
get_all_mid_connections ENDP

get_all_corner_connections PROC   
    mov dh, topRightCorner                          ; initializing the corner stuff
    call get_all_top_right_corner_connections 

    mov dh, topLeftCorner 
    call get_all_top_left_corner_connections

    mov dh, botRightCorner  
    call get_all_bot_right_corner_connections
            
    mov dh, botLeftCorner 
    call get_all_bot_left_corner_connections
    ret
get_all_corner_connections ENDP

turn_on_corner_vert PROC 
    push dx 
    mov dh, vertNum 
    cmp dh, topLeftCorner ; topLeftCorner 
        je topLeft 
    cmp dh, topRightCorner ; topRightCorner
        je topRight 
    cmp dh,  botLeftCorner ; botLeftCorner
        je botLeft
    cmp dh, botRightCorner ;botRightCorner
        je botRight 

    topLeft: 
        call get_all_top_left_corner_connections 
        jmp next
    topRight: 
        call get_all_top_right_corner_connections 
        jmp next 
    botLeft: 
        call get_all_bot_left_corner_connections 
        jmp next 
    botRight: 
        call get_all_bot_right_corner_connections 
        jmp next 
    next: 
    pop dx 
    ret
turn_on_corner_vert ENDP 

turn_on_vert PROC ; given a vertNum, turns that vert's appropriate connections on 
        call is_corner ; checks if vert is a corner vert, if so skip will be handled at end
        cmp isCorner, 1 
            je corner 

        call is_top_edge            ;edge stuff 
            cmp isTopEdge, 1   
                je top
        call is_bot_edge 
            cmp isBotEdge, 1 
                je bot
        call is_right_edge 
            cmp isRightEdge, 1
                je right 
        call is_left_edge 
            cmp isLeftEdge, 1 
                je left 
                jmp mid

        ; eax --> row, connection --> col 
      
        top:  ;get the left,right,bot connections and turn on. (ex. 3 --> connect with 2,4,11 on this row, turn on those bytes)
            call get_all_top_edge_connections 
            jmp next
        bot:  ;top,left,right connections
            call get_all_bot_edge_connections
            jmp next
        right: ;top,bot,left
            call get_all_right_edge_connections
            jmp next
        left: ;top,bot, right 
            call get_all_left_edge_connections
            jmp next 
        corner: 
            call turn_on_corner_vert
            jmp next
        mid: ;all four connnections
            call get_all_mid_connections
            jmp next 
        next: 
        ret 
turn_on_vert ENDP 

;----------------------------------------------------------------------------

; turn on new byte, turn off last byte ? 
; how will we reset matrix ? --> after we create initial matrix it's about turning it off and on for snake --> like snakeMatrix (not remaking it every time)


cord_to_vert PROC ; ([(yPos - 1) * width] + xPos) = vert# ; expecting dh, yPos, dl, xPos
    push esi
    push ecx
    push dx

    dec dh 
    movzx eax, dh 
    movzx ecx, playFieldWidth 
    mul ecx 
    pop dx
    add al, dl 
    mov vertNum, al ; move into vertNum ; al has vert num

    pop ecx 
    pop esi
    ret
cord_to_vert ENDP 

initialize_adj_matrix PROC USES eax dx 
    mov eax, 0 ; our vert counter
    movzx ecx, verts; gives us the max number of verts (32) ; will run this many times  

    L1: 
        inc eax 
        mov dh, al   ; happens right at 7.... ; was turned on correctly at 40

        mov vertNum, al ;need to move into vert num  ; happens some time between 5 and 10

        call turn_on_vert
    loop L1
    ret 
initialize_adj_matrix ENDP 

turn_off_row PROC ; assumes that row # is already given in dh
    pushad 
        mov al, 1 ; al is for col
        call go_to_position_matrix ; going to start of row ; esi holds that pos 
        movzx ecx, botRightCorner ;(32 * 32 matrix) 
    L1:   
        call turn_off 
        inc esi 
    loop L1
    popad 
    ret
turn_off_row ENDP


turn_off_col PROC ; assumes col # has been given to dl in advance 
    pushad 
    mov dh, 1 ; go to first row
    call go_to_position_matrix  ; goes to that first instance of vert in first row  
    movzx ecx, verts
    L1: 
        call turn_off 
        movzx eax, verts
        add esi, eax ; add by width of adj matrix to get the next one down
    loop L1 
    popad
    ret
turn_off_col ENDP

add_adj_matrix PROC ; assuming the OFFSET has been given to esi ; perhaps exit out when dl, dh == 0 ? 
    pushad 
    movzx ecx, snakeLength 
    cmp ecx,0 
    je break 
        L1:
            mov dl, [esi]
            mov dh, [esi + 1] 
            call cord_to_vert  ; at that vert, turn off associated row and collumn
            mov dh, vertNum 
            mov dl, vertNum ; al for col   
            call turn_off_col     
            add esi,2 ; inc b/c WORD array
        loop L1
        jmp break
    break: 
    popad
    ret
add_adj_matrix ENDP 

add_snake_adj_matrix PROC  
    mov esi, OFFSET snakePositions 
    call add_adj_matrix 
    ret
add_snake_adj_matrix ENDP

add_test_adj_matrix PROC 
    mov esi, OFFSET testPositions 
    call add_adj_matrix 
    ret
add_test_adj_matrix ENDP

;-------------------------------------------- ARRAY FUNCTIONS ----------------------------------------------------------------

clear_b_array PROC ; assuming the offset is already in esi, ecx has the amount of items to clear, assuming dh is the fill var
    cmp ecx, 0 
        je next
    L1:
        mov BYTE PTR [esi], dh
        inc esi
    loop L1
    next: 
    ret
clear_b_array ENDP

search_arr PROC ; arr in esi, put item you want to search for in dh, if found return truth value in al , size in ecx 
   push esi ; 
   mov al, 0 
   searching: 
        cmp BYTE PTR[esi], dh  
            jne next 
            mov al, 1 
            jmp found
        next: 
            inc esi
   loop searching 
      found: 
    pop esi 
   ret
search_arr ENDP

append_arr PROC ; increases size, adds to end of arr, 
    ; assumes size is given in eax, assumes arr is given in esi, assumes append value in DH --> new size increased in eax, must update accordingly
    add esi, eax 
    mov BYTE PTR [esi], dh 
    inc eax
    ret
append_arr ENDP

pop_front PROC ; assuming arr given in esi , size in eax, dl holds the popped item ; so something is going wrong here in pop_front
    push esi
    mov ecx, eax
    mov dl, BYTE PTR[esi] ; the popped item
    popping: 
        mov dh, BYTE PTR[esi + 1] 
          mov BYTE PTR[esi], dh 
        inc esi
    loop popping 
    dec eax 
    pop esi
    ret
pop_front ENDP

pop_end PROC ; dh holds what to fill with, and size in eax and arr given in esi  --> update new size with eax
    dec eax
    add esi, eax 
    mov BYTE PTR [esi], dh 
    ret
pop_end ENDP

;-------------------------------------- HELPER FUNCTIONS FOR RESETTING DJIK ARRS --------------------------------------------

reset_found_path_arr PROC  USES ecx esi
    mov esi, OFFSET foundPath
    movzx ecx, verts ; just clear the whole thing, nice and simple
    mov dh, -1
    call clear_b_array
    mov foundPathLength, 0 
    ret
reset_found_path_arr ENDP

reset_visited_arr PROC USES ecx esi 
    mov esi, OFFSET visited 
    movzx ecx, verts 
    mov dh, 0
    call clear_b_array 
    ret
reset_visited_arr ENDP 

reset_path_arr PROC USES ecx esi
    mov esi, OFFSET path
    movzx ecx, verts 
    mov dh, -1
    call clear_b_array
    ret
reset_path_arr ENDP

reset_dist_arr PROC USES ecx esi
    mov esi, OFFSET distArr
    movzx ecx, verts 
    mov dh, 254
    call clear_b_array 
    ret
reset_dist_arr ENDP

; --- test version ---

reset_test_path PROC USES ecx esi 
    mov esi, OFFSET testPath 
    movzx ecx, verts 
    mov dh, -1 
    call clear_b_array
    mov foundTestPathLength, 0 
    ret
reset_test_path ENDP

reset_test_dist_arr PROC USES ecx esi 
    mov esi, OFFSET testDistArr 
    movzx ecx, verts 
    mov dh, 254 
    call clear_b_array  
    ret
reset_test_dist_arr ENDP

reset_found_test_path PROC USES ecx esi
    mov esi, OFFSET foundTestPath 
    movzx ecx, verts 
    mov dh, -1 
    call clear_b_array 
    mov foundTestPathLength, 0 
    ret
reset_found_test_path ENDP

copy_arr PROC ; esi is dest, edi is source, eax is size 
    mov ecx, eax
    copying: 
        mov dh, BYTE PTR[edi] 
        mov BYTE PTR[esi], dh 
        inc edi 
        inc esi
    loop copying
    ret
copy_arr ENDP 

reset_test_positions PROC USES ecx esi
    mov esi, OFFSET testPositions 
    movzx eax, verts ; just clear the max
    mov ecx, 2 
    mul ecx 
    mov ecx, eax 
    mov dh, 0  
    call clear_b_array 
    mov esi, OFFSET testPositions 
    mov edi, OFFSET snakePositions 
    movzx eax, snakeLength
    mov ebx, 2
    mul ebx
    call copy_arr 
    ret
reset_test_positions ENDP

reset_valid_connections_arr PROC USES ecx esi
    mov esi, OFFSET validConnectionsArr 
    movzx ecx, verts
    mov dh, 0 
    call clear_b_array 
    mov valConnectionsNum, 0 
    ret
reset_valid_connections_arr ENDP

reset_alt_dist_arr PROC  USES ecx esi
    mov esi, OFFSET altDistArr 
    movzx ecx, verts 
    mov dh, 254 
    call clear_b_array
    ret
reset_alt_dist_arr ENDP

;---------------------------------------------------- PREPROCESS FUNCTIONS FOR DJIK/FIND -----------------------------------------------------------------

get_apple_vert PROC 
    push dx
    mov dh, appleYPos 
    mov dl, appleXPos 
    call cord_to_vert ; vertNum has newVert, so does al 
    pop dx 
    ret
get_apple_vert ENDP 

get_head_vert PROC 
    push dx
    mov dh, yPos 
    mov dl, xPos
    call cord_to_vert ; al has res, so does vertNum
    pop dx
    ret
get_head_vert ENDP

preprocessor_functions_djik PROC  
    call initialize_adj_matrix  ; everything initialized correctly
    call add_snake_adj_matrix ; ok fixed add_adj so that it exits when reaches 00 --> so working now
    call get_head_vert ; 
    mov startVert, al 
    call reset_arrs 
    ret
preprocessor_functions_djik ENDP
    
reset_arrs PROC 
    push dx 

    call reset_found_path_arr 
    call reset_visited_arr 
    call reset_dist_arr 
    call reset_path_arr

    pop dx 
    ret
reset_arrs ENDP



;-------------------------------------------- PATH FINDING CODE ---------------------------------------------------
.data 
    distArr BYTE 232 DUP (254) ; same number as verts, always need to be reinitialized to max 
    visited BYTE 232 DUP (0) ; 0 for not visited
    path BYTE 232 DUP (-1) ; -1 stands for no path
    foundPath BYTE 232 DUP (-1)
    foundPathLength BYTE 0 

    startVert BYTE ? 
    destVert BYTE ? 
    verts BYTE 232             

    row BYTE ? 
    col BYTE ?
    minDist BYTE ?
    
    newCost BYTE ?
    shorterPathFound BYTE 0 ; false by default
.code
; --> ([(yPos - 1) * width] + xPos) = vert# 
; --> ex) 0301 --> [(3-1) * 8] + 1 = 17 --> which is correct vert number 



new_cost PROC 
    push ebx 
   
    movzx esi, row ; moving row
    dec esi 
    add esi, ebx 
    mov bh, BYTE PTR [esi] ;mov bh, distArr[esi] ; bh --> dist[row] 
    mov dh, row 
    call go_to_position_matrix
    add bh, BYTE PTR [esi] ; bh --> dist[row] + costArr[row][col] ; this is fine, don't change into distArr
    mov newCost, bh

   
    pop ebx 
    ret
new_cost ENDP

update_cost_and_path PROC 
    push ebx 

    movzx esi, ah ; col
    dec esi 
    push esi 
    add esi, ebx 

    mov bh, newCost
    mov BYTE PTR [esi], bh ; bh is newCost 

    pop esi 
    add edi, esi 
    mov BYTE PTR[edi], dh 
    sub edi, esi 

    pop ebx
    ret
update_cost_and_path ENDP


reset PROC 
    mov ah, 1; ah will be our col counter  --> start from 1
    mov col, ah
    mov minDist, 254; resetting minDist 
    mov dh, startVert ; dh is our row ; not cl, cl is not starting from zero
    mov row, dh 
    ret
reset ENDP


is_new_path_shorter PROC
    push ebx
    mov shorterPathFound, 0 ; false 

    movzx esi, col; col 
    dec esi 
    add esi, ebx
    mov bl, BYTE PTR [esi]; bl --> dist[col] ; old cost moved to bl  ; mov bl, distArr[esi]

    cmp bl, newCost; if oldCost is greater than newCost 
        ja newShorter 
        jmp next
    newShorter: 
        mov shorterPathFound, 1 
    next: 
    pop ebx
    ret
is_new_path_shorter ENDP


update_start_vert PROC ; updates min dist and start vert 
    mov startVert, ah ; startVert = co
    mov minDist, bh ; minDist = dist[col]
    ret
update_start_vert ENDP 


;------------------------------------------------------------- DJIKSTRA FUNCTIONS ----------------------------------------------------------------------------------------

run_djikstra_snake PROC ; path is the problem ; somehow someway making it flexible is ruining ; OK IT"S "
    pushad
    mov ebx, OFFSET distArr
    mov edi, OFFSET path
    call djikstra_algo
    popad
    ret
run_djikstra_snake ENDP

run_djikstra_test PROC 
    pushad 
    mov ebx, OFFSET testDistArr
    mov edi, OFFSET testPath  
    call djikstra_algo
    popad
    ret
run_djikstra_test ENDP
 


djikstra_algo PROC  ; needs a start vert, need to reset distance array, path array, visited array! ; making djikstra a partial algo 
        movzx esi, startVert 
        dec esi 

        add esi, ebx 
        mov BYTE PTR [esi], 0 ; mov distArr[esi], 0 ; moving 0 distance for source 

        movzx ecx, verts
        dec ecx ; do it this way 
        
    searching: 
        movzx esi, startVert ; init startVert
        dec esi ; need to sub 1 b/c index 
        mov visited[esi], 1 ; 1 for true it has been visited -> set the node to visited 
            
            
        push ecx 
            call reset ; resets vars
            movzx ecx, verts
            L2:  
                push ebx
                mov col, ah ; col  
                mov al, ah; al is our col, cl is our curr col # 
                call go_to_position_matrix ; value is now in esi 

                cmp BYTE PTR[esi], 0 
                    jne isValid ;jump if valid path
                    jmp check

                isValid: ; dist[col] > dist[row] + costArr[row][col] 
                    pop ebx 
                    call new_cost ; getting dist[row] + costArr[row][col] part --> move to bh
                    call is_new_path_shorter
                    push ebx
                    cmp shorterPathFound, 1 
                        je isShorter
                        jmp check 

                isShorter: 
                    call update_cost_and_path ; new is short so update the cost
                     
                check: 
                movzx esi, ah
                dec esi
                cmp visited[esi], 0 ; has not been visited 
                    je notVisited 
                    jmp next

                notVisited: 
                    pop ebx
                    push ebx 
                    add esi, ebx 
                    mov bh, BYTE PTR [esi] ;mov bh, distArr[esi]
                    cmp bh, minDist ; newCost < minDist
                        jb lowerThanMin 
                        jmp next
                    pop ebx
                lowerThanMin: ; updating min distance, and deciding what will be next startVert
                    call update_start_vert 
                next: 
                    inc ah
                    pop ebx 
            loop L2
        pop ecx 
    loop searching
    done:
     ret
djikstra_algo ENDP

;---------------------------------------------------- FIND PATH BETWEEN TWO PTS FUNCTIONS ---------------------------------------------------------------------------------------

find_path PROC ; gives the shortest path between two points --> in correct order ; need to save value of dest ver ; put it at the cost position
    ; assumes you put the offset of foundPath in EDI and path from djik in EBX
    push ecx
    push esi 
    
    movzx ecx, verts ; shortest path cannot be longer than number of verts 
    mov dh, startVert
    mov dl, destVert
    mov eax, 1 ; our counter for path length --> start at one b/c of the dest vert we input in begin

    push dx
    mov dl, destVert
    mov BYTE PTR [edi], dl ; input destvert at last pos
    dec edi

    cmp BYTE PTR [edi], dh 
        je break 

    L1: ; load to stack 
        cmp destVert, -1 ; NEED TO TWEAK FIND_PATH 
            je break
        movzx esi, destVert
        dec esi
        add esi, ebx
        cmp BYTE PTR[esi], dh ; destVert = startVert ; if vert to input is equal to start
           je break  
        mov dl, BYTE PTR [esi] ; mov dl, path[destVert] 
        mov BYTE PTR [edi], dl ; foundPath = path
        mov destVert, dl ; destVert = path[destVert]
        ;inc edi ; byte arr so just inc
        dec edi
        inc eax
    loop l1
    ; append to_arr 
    break: 
       
        pop dx ; saving dest vert
        mov startVert, dh 
        mov destVert, dl 
        pop esi
        pop ecx
    ret
find_path ENDP


find_snake_path PROC ; put in dest vert at end 
    push esi
    mov ebx, OFFSET path
    movzx esi, destVert ; apple pps 
    dec esi
    movzx edi, distArr[esi] ; the cost to go to apple--> aka pathLength 
    dec edi; to skip first one --> yes 2 
    add edi, OFFSET foundPath ; start inputting there
    call find_path
    mov foundPathLength, al  
    pop esi
    ret
find_snake_path ENDP

find_test_path PROC  
    push esi
    mov ebx, OFFSET testPath
    movzx esi, destVert 
    dec esi 
    movzx edi, testDistArr[esi]
    add edi, OFFSET foundTestPath
    dec edi
    call find_path 
    mov foundTestPathLength, al
    pop esi
    ret
find_test_path ENDP 



; changing vert to cords ---> getting yCoord --> ([vert # - 1]/playWidth) + 1 --> ignoring decimal, we will get the xCoord
;                        ---> getting xCoord -->  ([(yPos - 1) * width] + xPos) = vert#  --> vert# - [(yPos - 1) * width]

vert_to_y_cord PROC 
    push ecx 
    mov edx, 0 ; need to do this for div 
    movzx eax, vertNum  
    dec eax 
    movzx ecx, playFieldWidth
    div ecx 
    inc eax ; gets yCord 

    pop ecx  
    ret
vert_to_y_cord ENDP 

vert_to_x_cord PROC USES eax ecx ; assuming I have yPos in eax 
    dec eax 
    movzx ecx, playFieldWidth
    mul ecx 
    movzx edx, vertNum 
    sub edx, eax ; edx has xCord
    ret
vert_to_x_cord ENDP

vert_to_cord PROC  ; div instruction --> ax hold answer, dx holds remainder 
    call vert_to_y_cord ; moves it to eax --> al
    call vert_to_x_cord ; moves it to edx --> dl
    ret 
vert_to_cord ENDP 

.data
 ;------------------------------------- DATA FOR PATH RECALCULATION -------------------------------------------
    altDistArr BYTE 232 DUP(254)
    validConnectionsArr BYTE 232 DUP(0)
    valConnectionsNum BYTE 0
.code


;---------------------------------------- FINDING VALID CONNECTION FUNCTION -----------------------------------------------------------



add_valid_connection PROC ; assumes connection is moved into dh, assumes arr given in ESI
    push ecx
    
    cmp ah, 1 
        jne invalid
    mov esi, OFFSET validConnectionsArr 
    movzx ecx, verts 

    ; check if it's already in validConnections
        call search_arr ; will search the arr for the connection in dh, if found wil not add
        cmp al, 1
          je invalid 

    ;check if we've already checked this vert num before 
        call already_checked  
        cmp al, 1 
            je invalid

    movzx eax, valConnectionsNum
    call append_arr 
    mov valConnectionsNum, al
    invalid: 
    pop ecx
    ret
add_valid_connection ENDP

is_valid_connection PROC  ; row is our dest vert, col is connection we want to test vert 
    ; assumes our row is in dh, our col in AL,  AH holds our truth value
    push esi
    
    call go_to_position_matrix ; goes to that pos in our adj matrix (already given)
    cmp BYTE PTR [esi], 1 
        je valid 
        mov ah, 0
        jmp next 
    valid:
        mov ah, 1 
        mov dh, al 
    next:
    pop esi
    ret
is_valid_connection ENDP ; checks if valid connection, and appends it to valid connection arr  ; ah tells us if valid or not, 1 or 0 


get_vert_type PROC 
    call is_corner 
    call is_top_edge 
    call is_bot_edge 
    call is_right_edge 
    call is_left_edge 
    ret
get_vert_type ENDP 

check_left_connection PROC  ; assumes correct vertNum has been given to vertNum 
    push esi
    call get_left_connection ;moved intoLeftConnection --> al has our left connection 
    mov al, leftConnection
    mov dh, vertNum 
    call is_valid_connection ; checks if valid connection, if valid --> it appends it to valid connection arr  
    call add_valid_connection
    pop esi
    ret
check_left_connection ENDP

check_right_connection PROC 
    push esi 
    call get_right_connection 
    mov al, rightConnection
    mov dh, vertNum 
    call is_valid_connection  
    call add_valid_connection 
    pop esi
    ret
check_right_connection ENDP

check_top_connection PROC 
    push esi
    call get_top_connection 
    mov al, topConnection
    mov dh, vertNum 
    call is_valid_connection 
    call add_valid_connection
    pop esi
    ret
check_top_connection ENDP

check_bot_connection PROC 
    push esi
    call get_bot_connection 
    mov al, botConnection 
    mov dh, vertNum 
    call is_valid_connection 
    call add_valid_connection
    pop esi
    ret
check_bot_connection ENDP

corner_decider PROC 
    push dx
    mov dh, vertNum
    cmp dh, topLeftCorner ; topLeftCorner 
        je topLeft 
    cmp dh, topRightCorner ; topRightCorner
        je topRight 
    cmp dh, botLeftCorner; botLeftCorner
        je botLeft
    cmp dh, botRightCorner ;botRightCorner
        je botRight 

    topLeft: 
        call check_right_connection 
        call check_bot_connection 
        jmp next 
    topRight: 
        call check_left_connection 
        call check_bot_connection 
        jmp next 
    botLeft: 
        call check_right_connection 
        call check_top_connection 
        jmp next 
    botRight: 
        call check_left_connection 
        call check_top_connection 
        jmp next 
    next: 
    pop dx
    ret
corner_decider ENDP 


find_valid_connections PROC ; given a vert number in vertNum, find its valid connections DOES NOT putt them in validConnectinsArr
 push esi
    call get_vert_type 

    cmp isCorner,1 
        je corner
    cmp isTopEdge,1 
        je top
    cmp isBotEdge,1 
        je bot
    cmp isRightEdge,1 
        je right
    cmp isLeftEdge,1 
        je left
        jmp mid

    top:  ; bot left right
       call check_bot_connection 
       call check_left_connection 
       call check_right_connection
       jmp next
    bot: ; top, left, right
        call check_top_connection 
        call check_left_connection 
        call check_right_connection
        jmp next
    right:  
        call check_top_connection 
        call check_bot_connection 
        call check_left_connection
        jmp next
    left: 
        call check_top_connection 
        call check_bot_connection 
        call check_right_connection 
        jmp next
    corner:  
        call corner_decider
        jmp next
    mid:  
        call check_top_connection 
        call check_bot_connection 
        call check_left_connection 
        call check_right_connection
    next:  
    pop esi
    ret
find_valid_connections ENDP

;--------------------------------------------------- DISTANCE DETERMINER ------------------------------------------------------------------------------------------------------ 

initialize_alt_dist_arr PROC 
    pushad
        mov edi, 0 
        movzx ecx, valConnectionsNum ; just initialize it for however many val connections there are, future iterations will init it 
        cmp ecx, 0 
            je next
        init: 
            movzx esi, validConnectionsArr[edi]
            dec esi
            call get_distance 
            ;dec esi ---------> i think dec twice will problem 
            mov altDistArr[esi], ah
            inc edi
        loop init
        next:
    popad 
    ret
initialize_alt_dist_arr ENDP

get_distance PROC ; given a vertNum index in esi , returns distance to that vert in AH
; look at distArr initialized by djik, go to index and see the cost, use that to initialize alt dist arr 
    mov ah, distArr[esi]
    ret
get_distance ENDP 


find_shortest_alt_vert PROC  ; use path arr to find from  our dest vert (our head) to the shortest vert   ; DL will hold the shortest vert
    ; loop through valid connection for index 
    movzx ecx, valConnectionsNum ; will loop through however many valid connections we have 4,5,6,7 etc  
    movzx esi, validConnectionsArr[0]
    dec esi
    mov dh, altDistArr[esi]
    mov dl, validConnectionsArr[0]
    mov esi, 0
    L1: ; dh will hold our curr min
        movzx edi, validConnectionsArr[esi]
        dec edi
        cmp altDistArr[edi], dh ; dh holds our current min cost
            jb newMin
            jmp next
        newMin: 
            mov dh, altDistArr[edi] 
            mov dl, validConnectionsArr[esi]
        next: 
        inc esi
    loop L1
    ret
find_shortest_alt_vert ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


.data 
    recalcPath BYTE 0 
.code

check_path PROC ; working
    mov esi, 0
    cmp foundTestPath[esi], -1 ; aka was there no path found 
        je invalidPath 
        jmp validPath
    invalidPath: ; invalid path so now recalculate
        call revert_adj_matrix 
        call recalculate_path
        call reset_valid_connections_arr ; if we find a valid path, reset the val connections arr 
    validPath:  
    ret
check_path ENDP 

update_valid_connections_arr PROC 
    movzx ecx, valConnectionsNum 
    popping:  
        push ecx
        movzx eax, valConnectionsNum
        mov esi, OFFSET validConnectionsArr
        call pop_front ; pops the old stuff ; popped is in dl
        mov valConnectionsNum, al
       ; dec valConnectionsNum
        mov vertNum, dl ; popped vert is in dl
        call find_valid_connections ; finds all the valid connections and appends it to valid connections arr
        pop ecx
    loop popping
    ret 
update_valid_connections_arr ENDP

init_valid_connections_arr PROC ; will get the adj verts of the head 
    call reset_alt_dist_arr 
    call get_head_vert ; res in al 
    mov validConnectionsArr[0], al 
    mov valConnectionsNum, 1 
    call update_valid_connections_arr ; will always have the valid connections of head 
    call initialize_alt_dist_arr
    ret
init_valid_connections_arr ENDP


is_invalid_recalculation PROC ; checks if new recalc path includes appleVert and apple vert not at end 
    pushad
    mov esi, 0
    movzx ecx, foundPathLength
    dec ecx ; so it doesnt chec the last
    jz brk
    call get_apple_vert 
    checking: 
        cmp foundPath[esi], al ; apple vert ? 
            jne next  
            mov foundPath[0], -1 
            jmp brk
        next: 
        inc esi
    loop checking
    brk:
    popad 
    ret
is_invalid_recalculation ENDP 

.data 
    pathsChecked BYTE 0
;------------------------------------------------------------- CALCULATED CODE ----------------------------------------------------------------------------------------------

.data 
    alrChecked BYTE 232 DUP (0) 
    checkedSize BYTE 0 
.code

update_checked PROC  ; assumes the vert num that was checked was moved to dh, 
    mov esi, OFFSET alrChecked 
    movzx eax, checkedSize
    call append_arr
    mov checkedSize, al
    ret
update_checked ENDP

already_checked PROC ; item you want to search for is moved into dh, truth value returned into al  
    push esi 
    push ecx
    mov esi, OFFSET alrChecked
    movzx ecx, verts
    call search_arr
    pop ecx
    pop esi 
    ret
already_checked ENDP  

; now change up, add_valid_connection 

; once validConnection is empty, it means all connections have been checked

calculated_all_paths PROC  ; truth value in al  ;; working as expected ! do not question
    mov al, 0
    cmp valConnectionsNum, 0 ; if there are no more valid connections to check, then leave --> put -1 at foundPaht
        jne more  
        mov foundPath[0], -1 ; mark as nothing left
        mov al, 1
    more: 
    ret
calculated_all_paths ENDP 

; assuming the offset is already in esi, ecx has the amount of items to clear, assuming dh is the fill var

reset_calculated_paths PROC  
    pushad
    movzx ecx, verts 
    mov esi, OFFSET alrChecked
    mov dh, 0
    call clear_b_array 
    mov checkedSize, 0
    popad
    ret
reset_calculated_paths ENDP

;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

recalculate_path PROC 

    mov dl, valConnectionsNum 
    cmp dl, pathsChecked 
        je update 
        jmp checking ; continue where we left off checking
    update: 
        call update_valid_connections_arr ; seems to be working so far --> update when we've checked all paths 
        call initialize_alt_dist_arr
        mov ecx, 0  
        mov pathsChecked, 0  
    
   ; check have we calculated all possible paths ? --> leave
       call calculated_all_paths  
        cmp al, 1 
           je finished
       
    
    checking: ; look at Test_Path for calculations
        call reset_found_path_arr ; reset the path again 
        call find_shortest_alt_vert ; finds the vert with the shortest distance from head 
       

        ; puts max distance at that vert --> so we won't recalc it again if its invalid 
            movzx esi, dl 
            dec esi
            mov altDistArr[esi], 254 ; put max at that distance 
            mov dh, dl 
            call update_checked

        ; get path from start to inter vert 
            mov destVert, dl
            call get_head_vert 
            mov startVert, al 
            call find_snake_path ; foundPathLength updated 
        
       ; run djikstra from inter --> to get to apple ; need to add the new test positions  
           call travel_test_path 
           
        ; get inter to apple ; 
            mov startVert, dl 
            call get_apple_vert 
            mov destVert, al
            movzx esi, destVert 
            dec esi
            movzx ebx, foundPathLength
            movzx edi, testDistArr[esi]
            dec edi ; don't touch this --> its needed
            add edi, ebx ; adding foundPathLength
            mov ebx, OFFSET testPath 
            add edi, OFFSET foundPath
         
            call find_path 
            add foundPathLength, al
      
        inc pathsChecked
        inc recalcPath
        mov cl, pathsChecked 
        cmp cl, valConnectionsNum ; if we've checked all the valid connections, just exit
            je goNext
            inc ecx
            movzx esi, foundPathLength 
            dec esi
        cmp foundPath[esi], -1 ; did it even lead to the apple ? 
            je checking 
        cmp foundPath[0], -1 ; while path found still invalid, loop 
            je checking  
        ; seems like it is all working...
    
    goNext: ; now we've either found a valid path, or need to find new verts to find a valid path from

    next: 
    movzx esi, foundPathLength 
    dec esi
    cmp foundPath[esi], -1 ; did it even lead to the apple ? 
        jne cont
        mov foundPath[0], -1 
    cont:
    ; now we need to check this path --> check its valid, if not... recalc path again 
    mov pathTested, 0 
    inc recalcPath
    call reset_test_positions
    call test_path ; break here if it fucks up --> not mucking up any more ? 
     
    finished: 
    ret
recalculate_path ENDP 


.data 
    pathTested BYTE 0 
.code

get_test_head PROC ; res is in al
    mov esi, 0 
    mov dl, BYTE PTR testPositions[esi]
    mov dh, BYTE PTR testPositions[esi + 1]
    call cord_to_vert 
    ret
get_test_head ENDP

turn_off_apple PROC  
    call get_apple_vert ; moves into al 
    mov dl, al 
    call turn_off_col
    ret
turn_off_apple ENDP 

travel_test_path PROC
    pushad 
    call reset_test_positions
    mov esi, 0 
    movzx ecx, verts ; keep it this way 

    ; if our path goes to an apple inc snakelength, if it doesn't (aka tail move, dont)
    move: 
        mov dh, foundPath[esi]
        cmp dh, -1 
            je pathCompleted    

        cont: 
        mov vertNum, dh 
        call vert_to_cord 
        mov dh, al 
        mov replaced, dx

        call update_test_positions ; being update correctled it seems
        inc esi
    loop move

    ; found path is found correctly, test positions updated correctly, arrays have been reset properly too 

    pathCompleted: ; path completed --> now update adj matrix accordingly to new test positions to reflect new situation and prep arrs 
        call initialize_adj_matrix 
        call add_test_adj_matrix 
        call reset_test_arrs
        mov al, startVert 
        push ax 
        call get_test_head  
        mov startVert, al 
        call run_djikstra_test
        pop ax 
        mov startVert, al ; restoring our startvert 
    popad 
    ret
travel_test_path ENDP


travel_tail_test_path PROC
    pushad 
    ;call reset_test_positions ; don't want to reset test positions.. 
    mov esi, 0 
    movzx ecx, verts 

    cmp foundTestPath[0], -1 
        je pathCompleted  

    ; if starting vert is apple vert ! inc snake lengt --> if test_head vert is on an apple ! inc snake length
    call get_test_head ; res in al 
    mov bl, al 
    call get_apple_vert ; res in al
    cmp al, bl 
        jne move 
        inc snakeLength
    move: 
        mov dh, foundTestPath[esi]
        cmp dh, -1 
            je pathCompleted   
        mov vertNum, dh 
        cmp dh, al 
            jne cont 
            inc snakeLength
        cont: 
        call vert_to_cord 
        mov dh, al 
        mov replaced, dx
        call update_test_positions ; being update correctled it seems
        inc esi
    loop move

    ; found path is found correctly, test positions updated correctly, arrays have been reset properly too 

    pathCompleted: ; path completed --> now update adj matrix accordingly to new test positions to reflect new situation and prep arrs ; something wrong with snake Pos

        call initialize_adj_matrix 
        call add_test_adj_matrix 
        call reset_test_path 
        call reset_visited_arr 
        call reset_test_dist_arr 
        call get_test_head 
        mov al, startVert 
        push ax 
        call get_test_head
        mov startVert, al 
        call run_djikstra_test
        pop ax 
        mov startVert, al 
        ;call reset_test_arrs ; tenative, do we need this ? fucking things up 
    popad 
    ret
travel_tail_test_path ENDP


reset_test_arrs PROC 
    push dx 

    call reset_test_path
    call reset_found_test_path
    call reset_visited_arr
    call reset_test_dist_arr ;; was reset dist arr 
    
    pop dx 
    ret
reset_test_arrs ENDP

.data  
    testDistArr BYTE 232 DUP (254)
    testPath BYTE 232 DUP (-1) 
    foundTestPath BYTE 232 DUP (-1)
    foundTestPathLength BYTE 0 
.code


revert_valid_connections_arr PROC 
    deleting: 
        mov esi, OFFSET validConnectionsArr 
        movzx eax, valConnectionsNum
        mov dh, 0
        call pop_end 
        mov valConnectionsNum, al 
    loop deleting
    ret
revert_valid_connections_arr ENDP

test_path PROC ; test point. go to tail
    mov dh, destVert 
    mov dl, startVert 
    push dx 

    cmp foundPath[0], -1 ;if found path is invalid, skip 
        je cont

    mov dl, snakeLength 
    push dx 
   
    call travel_test_path ; at this point, the test situation has been created --> adj matrix updated accordingly 
    
   ; see if there's a valid path to tail 
        call get_test_head 
        mov startVert, al ; head of test snake is new start vert
        call get_last_snake_test_vert ; want to go to old last pos 
        mov destVert, al            ; not getting dest vert corectly --> fixed now getting correctly  --> not getting dest vert c
        mov vertNum, al
        call find_tail_test_path ; finds path correctly 
        mov bl, snakeLength  
        pop dx 
        mov snakeLength, dl
  
   ; testing the found tail path --> to make sure it can follow twice
       cmp foundTestPath[0], -1 ; if a valid path to tail was found, follow it, else continue
            je cont 
       push dx ; pushing old snakeLength value 
       mov snakeLength, bl 
       call travel_tail_test_path ; traveled as expected

   ; now see if there's an available space to tail --> probably will need to revamp this b/c it's not enough to just say that non-zero vert means valid path exists. Must prove no path to each vert 
       call find_test_tail_verts  ; if not 0 then there is still a possible path to tail 
       call check_tail_path_invalid
       pop dx 
       mov snakeLength, dl 
       cmp al, 0 ; if there are no verts... then that means no path
           jne cont 
       mov foundTestPath[0], -1 
       call reset_tail_vert
    cont: 
    call check_path ; see if there is a valid path between these two points, if so, path is valid ; for now...
    mov pathsChecked, 0
    pop dx 
    mov dh, destVert 
    mov dl, startVert 
    
    call revert_adj_matrix ; revert back after testing ; might not need to revert, just need to preserve path and snake pos...
    call reset_test_positions ; this is what's mucking up 
    call reset_tail_vert
  
    next:
    ret
test_path ENDP

check_tail_path_invalid PROC ; assuming tailverts has been found ; truth value in al ? 
    mov ecx, 4 
    mov esi, 0 
    mov al, 0 
    check:
        cmp tailVerts[esi], 0 
            je done 
        movzx edi, tailVerts[esi] 
        dec edi 
        mov dl, testPath[edi] ; see if there is valid path 
        cmp dl, -1 
            jne validPath
        inc esi
    loop check
    validPath: 
        mov al, 1 
    done: 
    ret
check_tail_path_invalid ENDP 


revert_adj_matrix PROC ; reverts adj matrix to what it was before test path
    call initialize_adj_matrix 
    call add_snake_adj_matrix ; reset b/c might need to recalculate ... ? do we ? --> seems like we don;t need to reset ?
    ret
revert_adj_matrix ENDP

interpret_path PROC ; get next path, turn it into cords, move snake, update positions
    pushad 
    notEnd:  ;if not end, get path
        mov dh, foundPath[esi] 
        mov vertNum, dh ; need to move into vertNum
        call vert_to_cord 
        mov dh, al; moving yCord into dh, dl is already x Cord --> al has yCord
        mov yPos, dh ; updating xPos, yPos
        mov xPos, dl
        mov replaced, dx    
    popad
    ret
interpret_path ENDP 


.data 
    snake BYTE "O"
.code

color_head PROC 
    pushad 
    mov dh, yPos 
    mov dl, xPos 
    call GOTOXY 
    mov eax, yellow+(black*16)
    call setTextColor 
    mov edx, OFFSET snake
    call writeString 
    mov eax, white+(black*16)
    call setTextColor
    popad
    ret
color_head ENDP

color_tail PROC
    pushad  
        movzx esi, snakeLength  ;XX YY 
        dec esi 

        mov dh, BYTE PTR snakePositions[esi + 1]
        mov dl, BYTE PTR snakePositions[esi]
        call GOTOXY 
        mov eax, yellow+(black * 16) 
        call setTextColor 
        mov edx, OFFSET snake 
        call writeString 
        mov eax, white+(black*16)
        call setTextColor 
    popad 
    ret
color_tail ENDP 


.data 
    isPaused BYTE 0 
.code 
paused PROC  
    call READKEY
        jnz keyRead 
        jmp noKey  
    keyRead: 
        cmp ah, 57 
        je pauseGame
        jmp noKey
    pauseGame: 
        mov isPaused, 1 
     noKey: 
     ret
paused ENDP 

unpause PROC 
    call READKEY 
        jnz keyRead 
        jmp noKey
    keyRead: 
        cmp ah, 57 
        je noPause  
        jmp noKey
    noPause: 
        mov isPaused, 0 
    noKey: 
    ret
unpause ENDP 


set_dest_start PROC 
    call get_apple_vert 
    mov destVert, al 
    call get_head_vert 
    mov startVert, al
    ret
set_dest_start ENDP

check_vert PROC ; move vertNum you want to check into dh, truth value in al 
    mov al, 0 
    cmp dh, verts ; greater than the max vert ? 
        ja invalid  ;less than the 
    cmp dh, 1 
        jb invalid      
    valid:  
        mov al, 1  
    invalid: 
        ret
check_vert ENDP 

; row is our dest vert, col is connection we want to test vert 

; assumes size is given in eax, assumes arr is given in esi, assumes append value in DH --> new size increased in eax, must update accordingly

.data 
    tailVerts BYTE 4 DUP (0)
    tailVertCount BYTE 0 
.code 

add_if_valid_connection PROC ; , arr given in esi, and size given in eax
; and source vert given in dl ? and connection given in dh instead?
    push esi 
    push eax
        call check_vert ; checks what is in dh 
        cmp al, 1 
            jne invalid  
        push dx
        mov al, dh ; moving connection into al 
        mov dh, dl  
        call is_valid_connection 
        pop dx
        cmp ah, 1 
            jne invalid 
        pop eax 
        pop esi 
        call append_arr 
        push esi 
        push eax 
    invalid: 
    pop eax
    pop esi
    ret
add_if_valid_connection ENDP 

add_left_connection PROC USES esi dx; given arr in esi, adds left connection to that arr if valid, eax in size 
    call get_left_connection
    mov dh, leftConnection 
    call add_if_valid_connection 
    ret
add_left_connection ENDP 

add_right_connection PROC USES esi dx 
    call get_right_connection 
    mov dh, rightConnection 
    call add_if_valid_connection 
    ret
add_right_connection ENDP

add_top_connection PROC USES esi dx 
        call get_top_connection 
        mov dh, topConnection 
        call add_if_valid_connection  
    ret
add_top_connection ENDP

add_bot_connection PROC  USES esi dx 
        call get_bot_connection
        mov dh, botConnection 
        call add_if_valid_connection 
    ret
add_bot_connection ENDP

find_tail_adj PROC 
    mov esi, OFFSET tailVerts 
    movzx eax, tailVertCount 

    call add_left_connection 
    mov tailVertCount, al 

    call add_right_connection 
    mov tailVertCount, al 

    call add_top_connection 
    mov tailVertCount, al 

    call add_bot_connection 
    mov tailVertCount, al 
    ret
find_tail_adj ENDP

find_test_tail_verts PROC 
    call get_last_snake_test_vert 
    mov dl,al 
    call find_tail_adj 
    ret
find_test_tail_verts ENDP

find_tail_verts PROC  
    call get_last_snake_vert 
    mov dl, al 
    call find_tail_adj
    ret
find_tail_verts ENDP  

reset_tail_vert PROC  
    mov esi, OFFSET tailVerts 
    mov ecx, 4 
    mov dh, 0
    call clear_b_array
    mov tailVertCount, 0
    ret
reset_tail_vert ENDP 

search_for_edge_path PROC ; truth value in al if found or not
    mov esi, 0 
    mov al, 0 
    mov ecx, 4 
    L1:  
        mov dh, tailVerts[esi]  
        mov vertNum, dh 
        ;call is_edge 
        call is_corner ; search for corners instead
        cmp isCorner, 1 
            jne next 
        call reset_found_path_arr
        call get_edge_path
        cmp foundPath[0], -1 
            jne found
        next:
        inc esi  
    loop L1
    notFound: 
        mov al, 0 
        jmp cont
    found: 
        mov al, 1 
    cont:
    ret
search_for_edge_path ENDP

get_edge_path PROC  ; assuming a edge vert num has been given in dh 
        mov dh, vertNum 
        mov destVert, dh
        call get_head_vert 
        mov startVert, al 
        call find_snake_path  ; path in foundPath  
    next: 
    ret
get_edge_path ENDP


; need to make a recalculate tail path --> same idea as recalculate_path --> perhaps repurpose
find_tail_path PROC  ; maybe simply avoid apple ?  ; ok can't just avoid apple, need to actually determine  
    mov ecx, 4 
    call get_head_vert 
    mov startVert, al 
    call get_apple_vert ; res in al
    mov esi, 0
    tail: 
        mov dl, tailVerts[esi]
        mov destVert, dl 
        cmp dl, al 
            je recalc
        call find_snake_path  
        cmp foundPath[0], -1 
            jne validPath   
        recalc: 
        inc esi  
        call reset_found_path_arr
    loop tail 
        validPath: 
    ret
find_tail_path ENDP


find_tail_test_path PROC  
    pushad 
    call find_test_tail_verts ; finds all the tail verts --> accomplished  
    mov ecx, 4 
    call get_test_head
    mov startVert, al 
    mov esi, 0
    tail: 
        mov dl, tailVerts[esi]
        mov destVert, dl 
        call find_test_path 
        cmp foundTestPath[0], -1 
            jne validPath 
        inc esi  
        call reset_found_test_path
    loop tail 
        validPath:   
    call reset_tail_vert
    popad
    ret
find_tail_test_path ENDP

;----------------------------------------------------------------------------- SOLVER MOVE FUNCTIONS ----------------------------------------------------------------------------------------
; the three different types of movements and when they should be called 

move_func PROC ;; assumes esi has been given beforehand --> esi stands for which position to start interpreting at
    call interpret_path ; puts next path into replaced
    call update_test_positions 
    call update_snake_positions ; updates snake positions
    call draw_grid   
    call color_head
    call get_last_snake_pos 
    mov eax, 20
    call Delay 
    ret
move_func ENDP

special_move PROC 
    mov esi, 0 
    movzx ecx, foundPathLength 
    moving:  
        push esi 
        call move_func
        pop esi 
        inc esi
    loop moving 
      mov recalcPath, 0   ; FOR NOW
    ret
special_move ENDP


follow_tail PROC  
    call reset_found_path_arr ; at this point we don't need it 
    call get_last_snake_vert 
    mov vertNum, al 
    call find_tail_verts ; finds all the tail verts --> accomplished  ; 
    
    ; get edge path
    call search_for_edge_path
    cmp al, 1
        je edge

    ; get tail path
    call find_tail_path ; find a path to tail, put it in foundPath  ; something wrong with adj matrix

    ; MOVEMENT 
    edge: 
    mov esi, 0  ; necessary 
    call move_func
    call reset_tail_vert 
    ret
follow_tail ENDP

normal_move PROC  
    mov esi, 0  ; necessary 
    call move_func 
    ret
normal_move ENDP

move_decider PROC  
    cmp foundPath[0], -1 
        je tailMove
    cmp recalcPath, 1 
        ja specialMove 
        jmp normalMove  
    specialMove: 
        call special_move
        jmp next
    normalMove: 
        call normal_move  
        jmp next 
    tailMove: 
        call follow_tail 
    next:
    ret
move_decider ENDP
;---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


main proc

mov xPos, 1
mov yPos, 1

.data
    iterCounter BYTE 1 
.code


; in final version it spazzes at 96 --> ok suffering from that problem of eating apple, growing bigger and unable to move
solveRunner: 
    call check_apple ; call initialize_adj_matrix  inside here when apple eaten, call djikstra_algo ; calcs the shortest path call find_path 

    ; calling djikstra at every step 
        call preprocessor_functions_djik  
        call run_djikstra_snake ; calcs the new short path from snake head to apple 

    ; finding path 
        call set_dest_start 
        call find_snake_path ; doesn't include destination .... ?
    
    ; check if no possible path, if so follow tail 
    cmp foundPath[0], -1  ; something going wrong with follow tail, find_tail path 
        je move 

    call init_valid_connections_arr
    call test_path ; once it has been certified to be ok, we will start interpreting it  ; need to check out spawn apple
    call reset_calculated_paths 

    move:
    call move_decider

    mov eax, 20
    call Delay 

    call get_last_snake_pos 
    call write_score
    inc iterCounter
loop solveRunner 

pauseGame: 
    call unpause 
    cmp isPaused, 0 
    jne pauseGame 
    call remove_last_snake 
    jmp solveRunner
    jmp pauseGame

COMMENT $

gameRunner:
    cmp xPos, 29
        je debug 
        jmp next
    debug:  
        cmp yPos, 8
        je break
    

    next: 
    call check_for_new_key ; checks if a new key has been entered, if so it updates currDirection
    call move_snake ; moves the snake
    call update_positions ; we've got the new position so now update all positions 
    call check_apple ;checks if apple is where snake head is --> if so eat it
    call draw_grid
    

    mov eax, 1000
    call Delay 

    call get_last_snake_pos 
    call write_score
loop gameRunner

$ 



INVOKE ExitProcess, 0

main endp
end main

