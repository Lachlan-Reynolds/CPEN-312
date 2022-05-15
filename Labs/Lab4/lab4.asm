$MODDE0CV

org 0000H
	ljmp main
; necessary constants
NUM_1 equ #0x79
NUM_2 equ #0x24
NUM_3 equ #0x30
NUM_4 equ #0x19
NUM_5 equ #0x12
NUM_6 equ #0x02
NUM_8 equ #0x00
LET_H equ #0x09
LET_E equ #0x06
LET_L equ #0x47
LET_O equ #0x40
LET_C equ #0x46
LET_P equ #0x0C
LET_N equ #0x48`
BLANK equ #0x7F


Wait_Half_Sec:
	mov R6, #90
L3: mov R5, #250
L2:	mov R4, #250
L1: djnz R4, L1
	djnz R5, L2
	djnz R6, L3
	ret
	
Wait_Full_Sec:
	mov R2, #180
L6: mov R1, #250
L5:	mov R0, #250
L4: djnz R0, L4
	djnz R1, L5
	djnz R2, L6
	ret

; Following are all the subroutines for specific 7SD displays
State_Blank:
	mov HEX0, BLANK 
	mov HEX1, BLANK	
	mov HEX2, BLANK	
	mov HEX3, BLANK	
	mov HEX4, BLANK	
	mov HEX5, BLANK	
	ret

State_Start:
	mov HEX0, NUM_6 
	mov HEX1, NUM_1		
	mov HEX2, NUM_1		
	mov HEX3, NUM_5	
	mov HEX4, NUM_4	
	mov HEX5, NUM_1		
	ret

State_Left_1:
	mov HEX0, NUM_3 	
	mov HEX1, NUM_6	
	mov HEX2, NUM_1	
	mov HEX3, NUM_1		
	mov HEX4, NUM_5		
	mov HEX5, NUM_4	
	ret

State_Left_2:
	mov HEX0, NUM_8 	
	mov HEX1, NUM_3		
	mov HEX2, NUM_6		
	mov HEX3, NUM_1	
	mov HEX4, NUM_1	
	mov HEX5, NUM_5	
	ret
	
State_Left_3:
	mov HEX0, NUM_1 
	mov HEX1, NUM_8		
	mov HEX2, NUM_3	
	mov HEX3, NUM_6		
	mov HEX4, NUM_1	
	mov HEX5, NUM_1	
	ret
	
State_Left_4:
	mov HEX0, NUM_4 
	mov HEX1, NUM_1		
	mov HEX2, NUM_8	
	mov HEX3, NUM_3		
	mov HEX4, NUM_6	
	mov HEX5, NUM_1	
	ret
	
State_Left_5:
	mov HEX0, NUM_5 	
	mov HEX1, NUM_4	
	mov HEX2, NUM_1		
	mov HEX3, NUM_8		
	mov HEX4, NUM_3	
	mov HEX5, NUM_6		
	ret
	
State_Left_6:
	mov HEX0, NUM_1 	
	mov HEX1, NUM_5		
	mov HEX2, NUM_4		
	mov HEX3, NUM_1	
	mov HEX4, NUM_8		
	mov HEX5, NUM_3		
	ret

State_Left_7:
	mov HEX0, NUM_1 	
	mov HEX1, NUM_1		
	mov HEX2, NUM_5		
	mov HEX3, NUM_4		
	mov HEX4, NUM_1	
	mov HEX5, NUM_8		
	ret

State_HELLO:
	mov HEX0, LET_O
	mov HEX1, LET_L
	mov HEX2, LET_L
	mov HEX3, LET_E
	mov HEX4, LET_H
	mov HEX5, BLANK
	ret

State_CPN:
	mov HEX0, NUM_2
	mov HEX1, NUM_1
	mov HEX2, NUM_3
	mov HEX3, #48H
	mov HEX4, LET_P
	mov HEX5, LET_C
	ret


; Following are all the cases for each switch input 0000-0111 in order	
case_zero:
	mov 91H, #2H 
	mov 92H, #79H	
	mov 93H, #79H
	mov 94H, #12H	
	mov 8EH, #19H	
	mov 8FH, #79H	
	ljmp main
	
case_one:

	mov 92H, #30H 	
	mov 91H, #0H	
	mov 93H, #0FFH	
	mov 94H, #0FFH	
	mov 8EH, #0FFH	
	mov 8FH, #0FFH	
	ljmp main
; cycles through all left shift subroutines
case_two_half:
	lcall State_Start
	lcall Wait_Half_Sec
	lcall State_Left_1
	lcall Wait_Half_Sec
	lcall State_Left_2
	lcall Wait_Half_Sec
	lcall State_Left_3
	lcall Wait_Half_Sec
	lcall State_Left_4
	lcall Wait_Half_Sec
	lcall State_Left_5
	lcall Wait_Half_Sec
	lcall State_Left_6
	lcall Wait_Half_Sec
	lcall State_Left_7
	lcall Wait_Half_Sec
   
   	mov A, KEY
    jz case_two_half
 	ljmp select

case_two_full:
	lcall State_Start
	lcall Wait_Full_Sec
	lcall State_Left_1
	lcall Wait_Full_Sec
	lcall State_Left_2
	lcall Wait_Full_Sec
	lcall State_Left_3
	lcall Wait_Full_Sec
	lcall State_Left_4
	lcall Wait_Full_Sec
	lcall State_Left_5
	lcall Wait_Full_Sec
	lcall State_Left_6
	lcall Wait_Full_Sec
	lcall State_Left_7
	lcall Wait_Full_Sec
   
   	mov A, KEY
    jz case_two_full
 	ljmp select
; cycles through all left shift subroutines in the opposite order 
; making it looking like right shift cycling
case_three_half:
	lcall State_Start
	lcall Wait_Half_Sec
	lcall State_Left_7
	lcall Wait_Half_Sec
	lcall State_Left_6
	lcall Wait_Half_Sec
	lcall State_Left_5
	lcall Wait_Half_Sec
	lcall State_Left_4
	lcall Wait_Half_Sec
	lcall State_Left_3
	lcall Wait_Half_Sec
	lcall State_Left_2
	lcall Wait_Half_Sec
	lcall State_Left_1
	lcall Wait_Half_Sec
   
   	mov A, KEY
    jz case_three_half
 	ljmp select
 
case_three_full:
	lcall State_Start
	lcall Wait_Full_Sec
	lcall State_Left_7
	lcall Wait_Full_Sec
	lcall State_Left_6
	lcall Wait_Full_Sec
	lcall State_Left_5
	lcall Wait_Full_Sec
	lcall State_Left_4
	lcall Wait_Full_Sec
	lcall State_Left_3
	lcall Wait_Full_Sec
	lcall State_Left_2
	lcall Wait_Full_Sec
	lcall State_Left_1
	lcall Wait_Full_Sec
   
   	mov A, KEY
    jz case_three_half
 	ljmp select

case_four_full:
	lcall Wait_Full_Sec
	lcall State_Left_2
	lcall Wait_Full_Sec
	lcall State_Blank

   	mov A, KEY
    jz case_four_full
 	ljmp select
 
case_four_half:
	lcall Wait_Half_Sec
	lcall State_Left_2
	lcall Wait_Half_Sec
	lcall State_Blank 

   	mov A, KEY
    jz case_four_half
 	ljmp select
 	
case_five_full:
	lcall Wait_Full_Sec
	lcall State_Blank
	lcall Wait_Full_Sec
	mov HEX5, NUM_1
	lcall Wait_Full_Sec
	mov HEX4, NUM_4
	lcall Wait_Full_Sec
	mov HEX3, NUM_5
	lcall Wait_Full_Sec
	mov HEX2, NUM_1
	lcall Wait_Full_Sec
	mov HEX1, NUM_1
	lcall Wait_Full_Sec
	mov HEX0, NUM_6
	
   	mov A, KEY
    jz case_five_full
 	ljmp select	


case_five_half:
	lcall Wait_Half_Sec
	lcall State_Blank
	lcall Wait_Half_Sec
	mov HEX5, NUM_1
	lcall Wait_Half_Sec
	mov HEX4, NUM_4
	lcall Wait_Half_Sec
	mov HEX3, NUM_5
	lcall Wait_Half_Sec
	mov HEX2, NUM_1
	lcall Wait_Half_Sec
	mov HEX1, NUM_1
	lcall Wait_Half_Sec
	mov HEX0, NUM_6
	
   	mov A, KEY
    jz case_five_full
 	ljmp select	
 
case_six_full:
	lcall Wait_Full_Sec
	lcall State_HELLO
	lcall Wait_Full_Sec
	lcall State_Start
	lcall Wait_Full_Sec
	lcall State_CPN
	
   	mov A, KEY
    jz case_six_full
 	ljmp select
 
case_six_half:
	lcall Wait_Half_Sec
	lcall State_HELLO
	lcall Wait_Half_Sec
	lcall State_Start
	lcall Wait_Half_Sec
	lcall State_CPN
	
   	mov A, KEY
    jz case_six_half
 	ljmp select
 
; displays the lowest 6 numbers of my student number 111345
case_seven:
	mov 8FH, #79H 	;HEX 0 (1)
	mov 8EH, #79H	;HEX 1 (1)
	mov 94H, #79H	;HEX 2 (1)
	mov 93H, #30H	;HEX 3 (3)
	mov 92H, #19H	;HEX 4 (4)
	mov 91H, #12H	;HEX 5 (5)
	ljmp main	
	
	

	
	
main:
    ; Mask KEY3 into accumulator
    mov A, KEY
    anl A, #1000b ; A=1111b
    ; Clear button pressed flag if button is no longer pressed
    lcall check_btn_flag
    ; Check for falling edge of button
    orl A, 20H ; RAM at 20H =1111b
    anl A, #1001b	; A=1001b
    ; Jump to selector if first time pressing button
    jz select
    sjmp main

check_btn_flag:
    jz pressed
    mov 20H, #0
pressed:
    ret	

select:
case_zero_pointer:
	clr C
	mov A, SWA
	subb A, #00000000b
	jnz case_one_pointer ; If A=/=0 skip ljmp 
	ljmp case_zero
	
case_one_pointer:	
	clr C	
	mov A, SWA
	subb A, #00000001b
	jnz case_two_half_pointer	
	ljmp case_one
	
case_two_half_pointer: 	
	clr C		
	mov A, SWA
	subb A, #00001010b
	jnz case_two_full_pointer	
	ljmp case_two_half
	
case_two_full_pointer: 
	clr C		
	mov A, SWA
	subb A, #00000010b
	jnz case_three_half_pointer 	
	ljmp case_two_full
	
case_three_half_pointer: 	
	clr C		
	mov A, SWA
	subb A, #0001011b
	jnz case_three_full_pointer	
	ljmp case_three_half
	
case_three_full_pointer: 	
	clr C		
	mov A, SWA
	subb A, #0000011b
	jnz case_four_half_pointer	
	ljmp case_three_full

case_four_half_pointer: 	
	clr C		
	mov A, SWA
	subb A, #0001100b
	jnz case_four_full_pointer	
	ljmp case_four_half
	
case_four_full_pointer: 	
	clr C		
	mov A, SWA
	subb A, #0000100b
	jnz case_five_half_pointer 
	ljmp case_four_full


case_five_half_pointer: 
	
	clr C		
	mov A, SWA
	subb A, #0001101b
	jnz case_five_full_pointer	
	ljmp case_five_half
	
case_five_full_pointer: 	
	clr C		
	mov A, SWA
	subb A, #0000101b
	jnz case_six_half_pointer
	ljmp case_five_full
	
case_six_half_pointer: 
	
	clr C		
	mov A, SWA
	subb A, #0001110b
	jnz case_six_full_pointer	
	ljmp case_six_half
	
case_six_full_pointer: 	
	clr C		
	mov A, SWA
	subb A, #0000110b
	jnz case_seven_pointer
	ljmp case_six_full
	
case_seven_pointer:
	clr C
	mov A, SWA
	subb A, #00000111b
	jnz case_zero_pointer ; jump back to case zer0
	ljmp case_seven	

; display a 3 as a check for incorrect switch inputs (could be something else like UH OH)
case_check:
	mov HEX1, BLANK	
	mov HEX2, BLANK	
	mov HEX3, BLANK		
	mov HEX4, BLANK	
	mov HEX5, BLANK		
	mov HEX0, num_3
	
ljmp main

END	
 
