;please copy from here;

VARS:  
;main program        
counter dw 00h
rcounter db 00h,00h,00h,00h,00h,00h 
gate db 0 
strlen DB 0
empty DB 'EMPTY'
full DB 'FULL'

;8255-0
porta0 equ 00h
portb0 equ 02h
portc0 equ 04h
command_address0 equ 06h

;8255-1  

inputs EQU 0Ah
lcd_data EQU 08h
lcd_motor_control EQU 0Ch
creg_io EQU 0Eh

jmp     st1 
db     1001 dup(0)         



st1:  
; intialize ds, es,ss to start of RAM
mov       ax,02000h
mov       ds,ax
mov       es,ax
mov       ss,ax
mov       sp,02FFEH

;intialise porta and portb as input & portc as output for 8255-0
mov     al,92h
out     command_address0,al 

;initialise porta as output for lcd and portc upper as input and portc lower as output

MOV AL,10000000b
OUT creg_io,AL 
mov al,00h  
out 04h,al

;initialise hardware
; initialise the lcd
; check for busy status
; clear the screen
; display 'empty'
;writing on the command register for initialization


startup:    
LCD_initialization 
CALL update_the_LCD 
call DELAY_1S
call DELAY_1S 
;stopping_the_motor
;CALL update_the_LCD 
;CALL DELAY_1S
;calling lcd initialization 

;;check for entry to door which triggers opening of door
x1: in al,02h
    and al,80H
    cmp al,80H   
    jnz x2
y1: in al,02h
    and al,40h
    cmp al,40h  
    jnz y1
    add counter,1    
    mov gate,1
    motor_clockwise 
    call DELAY_1S
    stopping_the_motor     
    call DELAY_1S
    call DELAY_1S 

;;check for exit from door which triggers closing of door
x2: in al,02h
    and al,40h
    cmp al,40h 
    jnz x3
y2: in al,02h
    and al,80H
    cmp al,80H
    jnz y2
    sub counter,1
    mov gate,0
     motor_anticlockwise 
     call DELAY_1S
     stopping_the_motor
     call DELAY_1S
    call DELAY_1S
call DELAY  

;;check for entry on other side of door which triggers closing of door
x3: in al,02h
    and al,20h
    cmp al,20h
    jnz x4
y3: in al,02h
    and al,10h
    cmp al,10h
    jnz y3 
    mov gate,0 
     motor_anticlockwise 
     call DELAY_1S
     stopping_the_motor  
     call DELAY_1S
    call DELAY_1S
;;check for exit on other side of door which triggers opening of door
x4: in al,02h
    and al,10h
    cmp al,10h
    jnz x5
y4: in al,02h
    and al,20h
    cmp al,20h
    jnz y4   
    mov gate,1 
     motor_clockwise 
     call DELAY_1S
     stopping_the_motor 
     call DELAY_1S
    call DELAY_1S
call DELAY          
;;check for entry in row1
x5: in al,02h
    and al,08h
    cmp al,08h
    jnz x6
y5: in al,02h
    and al,04h
    cmp al,04h 
    jnz y5
    add rcounter,1 
 
call DELAY_1S
call DELAY_1S
;;check for exit from row1
x6: in al,02h
    and al,04h
    cmp al,04h
    jnz x7
y6: in al,02h
    and al,08h
    cmp al,08h
    jnz y6     
    sub rcounter,1
call DELAY_1S
call DELAY_1S
;;check for entry in row2
x7: in al,02h
    and al,02h
    cmp al,02h
    jnz x8
y7: in al,02h
    and al,01h
    cmp al,01h
    jnz y7  
    add rcounter+1,1 
  
call DELAY_1S
call DELAY_1S
;;check for exit from row3
x8: in al,02h
    and al,01h
    cmp al,01h
    jnz x9
y8: in al,02h
    and al,02h
    cmp al,02h
    jnz y8 
    sub rcounter+1,1
call DELAY_1S
call DELAY_1S
;;check for entry in row3
x9: in al,00h
    and al,80H
    cmp al,80H
    jnz x10
y9: in al,00h
    and al,40h
    cmp al,40h
    jnz y9  
    add rcounter+2,1
call DELAY_1S
call DELAY_1S
;;check for exit from row3
x10: in al,00h
    and al,40H
    cmp al,40H
    jnz x11
y10: in al,00h
    and al,80h
    cmp al,80h
    jnz y10
    sub rcounter+2,1
call DELAY_1S
call DELAY_1S
;;check for entry in row4
x11: in al,00h
    and al,20h
    cmp al,20h
    jnz x12
y11: in al,00h
    and al,10h
    cmp al,10h
    jnz y11    
    add rcounter+3,1 
call DELAY_1S
call DELAY_1S
;;check for exit from row4
x12: in al,00h
    and al,10H
    cmp al,10H
    jnz x13
y12: in al,00h
    and al,20h
    cmp al,20h
    jnz y12 
    sub rcounter+3,1 
call DELAY_1S
call DELAY_1S
;;check for entry in row5
x13: in al,00h
    and al,08h
    cmp al,08h
    jnz x14
y13: in al,00h
    and al,04h
    cmp al,04h
    jnz y13 
    add rcounter+4,1  
call DELAY_1S
call DELAY_1S
;;check for exit from row5
x14: in al,00h
    and al,04H
    cmp al,04H
    jnz x15
y14: in al,00h
    and al,08h
    cmp al,08h
    jnz y14
    sub rcounter+4,1 
call DELAY_1S
call DELAY_1S
;;check for entry in row6
x15: in al,00h
    and al,02h
    cmp al,02h
    jnz x16
y15: in al,00h
    and al,01h
    cmp al,01h
    jnz y15 
    add rcounter+5,1
call DELAY_1S
call DELAY_1S
;;check for exit from row6
x16: in al,00h
    and al,01H
    cmp al,01H
    jnz x
y16: in al,00h
    and al,02h
    cmp al,02h
    jnz y16
    sub rcounter+5,1
call DELAY_1S
call DELAY_1S
;;output for leds is made 1 wherever rcounter is 1

x:  mov al,00000000b
    mov bl,00000001b
    mov cx,06h
    lea si,rcounter
y:  mov dl,[si]
    cmp dl,00H
    jnz z
    jmp w
z:  or al,bl 

w:  rol bl,1 
    add si,1
    dec cx
    cmp cx,00h
    jnz y 
    out 04h,al 
    call DELAY_1S
    call DELAY_1S
    call DELAY_1S
    call DELAY_1S
    call DELAY_1S
    call DELAY_1S
    call DELAY_1S
    call DELAY_1S
    call DELAY_1S
    

disp: CALL update_the_LCD 
      jmp x1

;;;;;UPTIL HERE ALL LEDS IN THE ROWS WITH NON ZERO COUNT WILL GLOW
DELAY_1S PROC
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    CALL DELAY
    ret
DELAY_1s endp

DELAY PROC
    MOV CX, 1325 ;1325*15.085 usec = 20 msec
    W1: 
        NOP
        NOP
        NOP
        NOP
        NOP
    LOOP W1
    RET
DELAY ENDP

macros:  

motor_anticlockwise MACRO
IN AL, lcd_motor_control
AND AL, 11111100b
OR AL, 00000010b
OUT lcd_motor_control, AL
ENDM        

motor_clockwise MACRO
IN AL, lcd_motor_control
AND AL, 11111100b
OR AL, 00000001b
OUT lcd_motor_control, AL 
ENDM

stopping_the_motor MACRO
IN AL, lcd_motor_control
AND AL, 11111100b
OR AL, 00000000b
OUT lcd_motor_control, AL 
ENDM  

set_the_LCD_mode MACRO
		IN AL, lcd_motor_control
		AND AL, 00011111b
		OR AL, BL
		OUT lcd_motor_control, AL
ENDM

LCD_initialization MACRO
		MOV AL, 00001111b
		OUT lcd_data, AL
		MOV BL, 00100000b
set_the_LCD_mode
		MOV BL, 00000000b
set_the_LCD_mode
ENDM

lcd_clear MACRO
		MOV AL, 00000001b
OUT lcd_data, AL 
		MOV BL,00100000b
set_the_LCD_mode  
		MOV BL,00000000b
set_the_LCD_mode
ENDM

lcd_putch MACRO
		PUSH AX
		OUT lcd_data,AL  
		;call DELAY_1S
		MOV BL,10100000b
set_the_LCD_mode
		MOV BL,10000000b
set_the_LCD_mode
		POP AX
		ENDM

putstring_on_LCD MACRO
		MOV CH,00H
		MOV CL, strlen
putting:
		MOV AL, [DI]
lcd_putch
		INC DI
		LOOP putting
ENDM

lcd_bcd MACRO
		MOV AX, counter
		MOV CX, 0
converting:
		MOV BL, 10
		DIV BL
		ADD AH, '0'
		MOV BL, AH
		MOV BH, 0
		PUSH BX
		INC CX
		MOV AH, 0
		CMP AX, 0
JNE converting
printing:
POP AX
lcd_putch
LOOP printing
ENDM

procs:
		update_the_LCD PROC NEAR
		lcd_clear
		MOV AL, ' '
		lcd_putch
		CMP counter,00h
		JNZ notempty
		LEA DI, empty
		MOV strlen, 05H
		JMP loaded
		notempty:
		CMP counter,200
		JL notfull
		LEA DI, full
		MOV strlen, 04H
		JMP loaded
		notfull:
		lcd_bcd
		RET
		loaded: 
		;call DELAY_1S
		putstring_on_LCD 
		call DELAY_1S
			; call DELAY_1S
		RET
		update_the_LCD ENDP  




