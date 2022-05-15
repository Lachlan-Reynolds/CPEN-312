$modde0cv

	CSEG at 0
	ljmp mycode

dseg at 30h
x: ds 4 ; 32-bits for variable �x�
y: ds 4 ; 32-bits for variable �y�
z: ds 4 ; 32-bits for variable �z�

bcd: ds 5 ; 10-digit packed BCD (each byte stores 2 digits)
bseg
mf: dbit 1 ; Math functions flag
$include(math32.asm)
	CSEG

; Look-up table for 7-seg displays
myLUT:
    DB 0C0H, 0F9H, 0A4H, 0B0H, 099H        ; 0 TO 4
    DB 092H, 082H, 0F8H, 080H, 090H        ; 4 TO 9

showBCD MAC
	; Display LSD
    mov A, %0
    anl a, #0fh
    movc A, @A+dptr
    mov %1, A
	; Display MSD
    mov A, %0
    swap a
    anl a, #0fh
    movc A, @A+dptr
    mov %2, A
ENDMAC

Display:
	mov dptr, #myLUT
	showBCD(bcd+0, HEX0, HEX1)
	showBCD(bcd+1, HEX2, HEX3)
	showBCD(bcd+2, HEX4, HEX5)
    ret

MYRLC MAC
	mov a, %0
	rlc a
	mov %0, a
ENDMAC

Shift_Digits:
	mov R0, #4 ; shift left four bits
Shift_Digits_L0:
	clr c
	MYRLC(bcd+0)
	MYRLC(bcd+1)
	MYRLC(bcd+2)
	MYRLC(bcd+3)
	MYRLC(bcd+4)
	djnz R0, Shift_Digits_L0
	; R7 has the new bcd digit	
	mov a, R7
	orl a, bcd+0
	mov bcd+0, a
	; bcd+3 and bcd+4 don't fit in the 7-segment displays so make them zero
	clr a
	mov bcd+4, a
	ret

Wait50ms:
;33.33MHz, 1 clk per cycle: 0.03us
	mov R0, #30
L3: mov R1, #74
L2: mov R2, #250
L1: djnz R2, L1 ;3*250*0.03us=22.5us
    djnz R1, L2 ;74*22.5us=1.665ms
    djnz R0, L3 ;1.665ms*30=50ms
    ret

; Check if SW0 to SW9 are toggled up.  Returns the toggled switch in
; R7.  If the carry is not set, no toggling switches were detected.
ReadNumber:
	mov r4, SWA ; Read switches 0 to 7
	mov a, SWB ; Read switches 8 to 9
	anl a, #00000011B ; Only two bits of SWB available
	mov r5, a
	mov a, r4
	orl a, r5
	jz ReadNumber_no_number
	lcall Wait50ms ; debounce
	mov a, SWA
	clr c
	subb a, r4
	jnz ReadNumber_no_number ; it was a bounce
	mov a, SWB
	anl a, #00000011B
	clr c
	subb a, r5
	jnz ReadNumber_no_number ; it was a bounce
	mov r7, #16 ; Loop counter
ReadNumber_L0:
	clr c
	mov a, r4
	rlc a
	mov r4, a
	mov a, r5
	rlc a
	mov r5, a
	jc ReadNumber_decode
	djnz r7, ReadNumber_L0
	sjmp ReadNumber_no_number	
ReadNumber_decode:
	dec r7
	setb c
ReadNumber_L1:
	mov a, SWA
	jnz ReadNumber_L1
ReadNumber_L2:
	mov a, SWB
	jnz ReadNumber_L2
	ret
ReadNumber_no_number:
	clr c
	ret

copy_xz:
	mov z+0, x+0
	mov z+1, x+1
	mov z+2, x+2
	mov z+3, x+3
	ret	

copy_zx:
	mov x+0, z+0
	mov x+1, z+1
	mov x+2, z+2
	mov x+3, z+3
	ret	

xchg_xz:
	mov a, x+0
	xch a, z+0
	mov x+0, a
	mov a, x+1
	xch a, z+1
	mov x+1, a
	mov a, x+2
	xch a, z+2
	mov x+2, a
	mov a, x+3
	xch a, z+3
	mov x+3, a
	ret


forever_inter:
	ljmp forever

rem:
	lcall x_lt_y
	jb mf, forever_inter
remainder_loop:
	lcall sub32
	lcall x_lt_y
	jnb mf, remainder_loop
	ret
	
isqrt: 	
	mov LEDRA, #0b
	setb LEDRA.5
	
	push acc
	push psw
	push b
	push AR0
	push AR1
	push AR2
	push AR3
	
	clr mf
	
	mov x+0, #5
	mov x+1, #0
	mov x+2, #0
	mov x+3, #0
	
	lcall mul32
	
	mov y+0, #5
	mov y+1, #0
	mov y+2, #0
	mov y+3, #0	
		
sqrtloop:		
	lcall x_lt_y ; lt and jb are same as gteq and jnb
	jb mf, end_cond			
	lcall sub32
	
	mov R0, x+0
	mov R1, x+1
	mov R2, x+2
	mov R3, x+3
	
	mov x+0, #10
	mov x+1, #0
	mov x+2, #0
	mov x+3, #0	

	lcall add32
	lcall xchg_xy
	
	mov x+0, R0
	mov x+1, R1
	mov x+2, R2
	mov x+3, R3	
	
	sjmp sqrtloop	
	
end_cond:
	lcall xchg_xy
	
	mov y+0, #10
	mov y+1, #0
	mov y+2, #0
	mov y+3, #0
	
	lcall div32
	
	pop AR3
	pop AR2
	pop AR1
	pop AR0
	pop b
	pop psw
	pop acc	
	ret
	
mycode:
	mov SP, #7FH
	clr a
	mov LEDRA, a
	mov LEDRB, a
	mov bcd+0, a
	mov bcd+1, a
	mov bcd+2, a
	mov bcd+3, a
	mov bcd+4, a
	lcall Display


	mov b, #0 ; b=0:addition, b=1:subtraction, etc.
	setb LEDRA.0 ; Turn LEDR0 on to indicate addition

	
forever: ; This is a good spot to set the LEDs for each operation...
	jb KEY.3, no_funct ; If 'Function' key not pressed, skip
	jnb KEY.3, $ ; Wait for release of 'Function' key
	inc b ; 'b' is used as function select
 	mov a, b ; make sure b is not larger than 5
	cjne a, #6, forever ; ^
 	mov b, #0 ; ^
	ljmp forever ; Go check for more input
	
no_funct:
	jb KEY.2, no_load ; If 'Load' key not pressed, skip
	jnb KEY.2, $ ; Wait for user to release 'Load' key
	lcall bcd2hex ; Convert the BCD number to hex in x
	lcall copy_xy ; Copy x to y
	Load_X(0) ; Clear x (this is a macro)
	lcall hex2bcd ; Convert result in x to BCD
	lcall Display ; Display the new BCD number
	ljmp forever ; Go check for more input

no_equal_inter:
	ljmp no_equal
	

no_load:
	jb KEY.1, no_equal_inter ; If 'equal' key not pressed, skip
	jnb KEY.1, $ ; Wait for user to release 'equal' key
	lcall bcd2hex ; Convert the BCD number to hex in x
	mov a, b ; Check if we are doing addition
	cjne a, #0, no_add ; ^ (sub)
	lcall add32 ; Perform x+y
	lcall hex2bcd ; Convert result in x to BCD
	lcall Display ; Display the new BCD number
	ljmp forever ; Go check for more input





no_add: ; Other operations maybe coded here, start here
	cjne a, #1, no_sub ; jump to no_sub (mul)
	mov LEDRA, #0b
	setb LEDRA.1
	lcall xchg_xy
	lcall sub32 ; x-y
	lcall hex2bcd ; Convert result in x to BCD
	lcall Display ; Display the new BCD number
	ljmp forever ; Go check for more input

no_sub:
	cjne a, #2, no_mul; jump to no_mul (div)
	mov LEDRA, #0b
	setb LEDRA.2
	lcall mul32 ; x*y
	lcall hex2bcd ; Convert result in x to BCD
	lcall Display ; Display the new BCD number
	ljmp forever ; Go check for more input
	
no_mul:
	cjne a, #3, no_div; jump to no_div (rem)
	mov LEDRA, #0b
	setb LEDRA.3
	lcall xchg_xy
	lcall div32 ; x/y
	lcall hex2bcd ; Convert result in x to BCD
	lcall Display ; Display the new BCD number
	ljmp forever ; Go check for more input
	
no_div:
	cjne a, #4, no_rem ;jump to no_rem (isqrt)
	mov LEDRA, #0b
	setb LEDRA.4
	lcall xchg_xy
	lcall rem ; x % y
	lcall hex2bcd ; Convert result in x to BCD
	lcall Display ; Display the new BCD number
	ljmp forever ; Go check for more input


no_rem:
	cjne a, #5, check
	mov LEDRA, #0b
	setb LEDRA.5
	lcall isqrt ; isqrt(x)
	lcall hex2bcd ; Convert result in x to BCD
	lcall Display ; Display the new BCD number
	ljmp forever ; Go check for more input
	
check:
	mov LEDRB, #0b
	setb LEDRA.7
	ljmp forever

no_equal:; get more numbers
	lcall ReadNumber
	jnc no_new_digit ; Indirect jump to 'forever'
	lcall Shift_Digits
	lcall Display
	
no_new_digit:
	ljmp forever ; 'forever' is to far away, need to use ljmp
	lcall ReadNumber
	jnc forever_indirect
	lcall Shift_Digits
	lcall Display
	ljmp forever

forever_indirect:
	ljmp forever
	
end
