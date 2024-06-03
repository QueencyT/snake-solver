
# SNAKE SOLVER - FINAL PROJECT

## Name: <ins> QUEENCY TAN </ins>

## Showcase:

https://github.com/barkeshli-CS066-classroom/99-final-project-snake-solver-QueencyT/assets/122432408/b38922fa-058f-4dec-9aef-afa2dfbbf461


<br><br>

- LIST OF FUNCTIONS:
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
    ; purpose: function used to check whether the test path is valid or not. If invalid, it call recaculate_path
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

- Partly implemented:
  - what features have not been implemented

<br><br>

- Bugs
  - Known bugs

<br><br>

# Reflections:

- Any thoughts you may have and would like to share.

# **output**
<pre>
<br/><br/><br/><br/>
## Delete this line and paste the output of your basic test and then testB here
</pre>


<br/><br/>

# basic_test.cpp output:
<pre>
<br/><br/><br/><br/>
</pre>
# testB.cpp output:
<pre>
<br/><br/><br/><br/>
</pre>


