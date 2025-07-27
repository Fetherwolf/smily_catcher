;***********************************************************************************

;* Name of work: "smily catcher"                                                      *

;*                                                                                 *

;* Student: Ariel Gov                                                              *

;* Yoana Jabotinsky High School,    Yud 5                                          *

;*                                                                                 *

;* Laboratory experience unit: Computer organization and threshold language        *

;* Development environment: TASM compiler                          				   *

;*                                                                      		   *

;*Subject:            you need to catch the falling smily                			   *

;*                                                                   			   *

;* User guide:     press left or right to move, esc to exit game.                                     			   *

;***********************************************************************************

 
.model small

.data  
;Variables
  x    db 40
  y    db 24
  esc  db 27
  vx db 38
  vy db 0
  sx db 0
  ;delay
  fir db 1
  time db 0
  time1 db 0
  doit db 0
  c db 0
  score1 db 0
  highscore db 0
  scoretxt db "Score: $"
  highscoretxt1 db"highest$"
  highscoretxt2 db"score:$"
  
  character db "ออออออออออ$"
  
  fin1 db "ษออออออออออออออออออป$"
  fin2 db "บ   GAME OVER  :(  บ$"
  fin3 db "บPress R to Restartบ$"
  fin4 db "ศออออออออออออออออออผ$"
.stack 100h

.code

start:
  mov ax,@data
  mov ds,ax
  ;reset
  bbbacktostart:
  mov x, 40
  mov y, 24
  mov vx, 38
  mov vy, 0
  mov sx, 0
	;delay
  mov fir, 1
  mov time, 0
  mov time1, 0
  mov doit, 0		
  mov c, 0
  mov score1, 0
  ;Commands
  mov ah,2
;  mov bh,0	;page number
  mov dl, x
  mov dh, y
  int 10h
  call clear
  call clear2
  call hide_cursor
  call start_point ;summon ball
; go to x,y  
  mov dl, x		
  mov dh, y
  int 10h

  mov ah, 2	
  call showcharactar
  
next:
cmp doit, 0
  je skp2
call clear
call clear2
cmp vy, 24
 je rnd
	call print_score
	call print_highscore
call out_ball
call move_ball
skp2:
cmp doit, 0
  je skp
mov ah, 2
  mov dl, x
  mov dh, y
  int 10h
  mov ah, 2
  call showcharactar
  mov doit, 0
skp:
  call delay
; input
  call wait_key
; escape
  cmp al, esc  	;27
  je fin  
  cmp al, 75;  75 - left 77 - right 72 - up 80 - down
  je left
  cmp al, 77
  je right
  
 jmp next
 bbacktostart:
 jmp bbbacktostart
rnd:
mov ah, vx
cmp ah,x
jl fin
mov ah, x
add ah, 10
cmp vx, ah		;HAX
jg fin
add score1, 1		;gives score
mov vy, 0
 call random
 jmp next
 
   
left:
cmp x, 0
je otherside
  mov ah, 2
  sub x, 2
; go to x,y  
  mov dl, x
  mov dh, y
  int 10h
  jmp next
fin:
jmp finn

 right:
 cmp x, 58
 je othersidee
  mov ah, 2
  add x, 2
; go to x,y  
  mov dl, x
  mov dh, y
  int 10h
  jmp next
  backtostart:
 jmp bbacktostart
otherside:		;|<-  <-|
  mov x, 58
  mov ah, 2
  mov dl, x
  mov dh, y
  int 10h
  jmp next

othersidee:		;|->  ->|
  mov x, 0
  mov ah, 2
  mov dl, x
  mov dh, y
  int 10h
  jmp next
 

  
finn:
call clear
mov ah, 2
 mov dl, 30
 mov dh, 10
 int 10h
 mov ah, 9
	mov dx, offset fin1
	int 21h
	mov ah, 2
 mov dl, 30
 mov dh, 11
 int 10h
 mov ah, 9
	mov dx, offset fin2
	int 21h
	mov ah, 2
 mov dl, 30
 mov dh, 12
 int 10h
 mov ah, 9
	mov dx, offset fin3
	int 21h
	mov ah, 2
 mov dl, 30
 mov dh, 13
 int 10h
 mov ah, 9
	mov dx, offset fin4
	int 21h
call print_score
call print_highscore
	finwait:
	call wait_key
	cmp al, 72h	;r
	je backtostart
	cmp al, esc
	jne finwait
	
	
  mov ah,4ch
  int 21h

  hide_cursor	proc
  mov ah,1	;set cursor shape
  mov ch,1	;hides it if ch>cl
  mov cl,0
  int 10h	
  ret
hide_cursor	endp
 
clear	proc
  push ax
  push cx
  push dx
  push bx
  
  mov ah,6	;rectangle shift up
  mov al,25	;lines number for shift
  mov ch,0	;borders:
  mov cl,0
  mov dh,24
  mov dl,68
  mov bh,00011111b	;new attributes
  int 10h

  pop bx
  pop dx
  pop cx
  pop ax
  ret
clear	endp

clear2	proc
  push ax
  push cx
  push dx
  push bx
  
  mov ah,6	;rectangle shift up
  mov al,25	;lines number for shift
  mov ch,0	;borders:
  mov cl,69
  mov dh,24
  mov dl,79
  mov bh,00001111b	;new attributes
  int 10h

  pop bx
  pop dx
  pop cx
  pop ax
  ret
clear2	endp

out_ball proc
  push dx
  mov ah, 2
  mov dh, vy
  mov dl, vx
  int 10h
  mov dx, 1
  int 21h
  pop dx
  ret
out_ball endp

start_point	proc
push dx
  mov ah,2
  mov dh,vy	;line   y	start point
  mov dl,vx	;column  x
  int 10h
pop dx

  ret
start_point	endp

move_ball 	proc
push dx
  add vy, 1
  mov ah, 2
  mov dh, vy	;new point - y = y + vy
  mov dl, vx	;	     x = x + vx
  int 10h	;go-go
pop dx
  ret
move_ball	endp

wait_key	proc
;  push ax
  push cx
  push dx
  push bx
  	mov ah, 6	;check without stop
  	mov dl, 0ffh
  	int 21h
  pop bx
  pop dx
  pop cx
;  pop ax
  	ret
wait_key	endp

delay	proc
  push dx
  push ax
  push bx
  push cx
  cmp fir, 1
    je leback
  jmp repeat
leback:
  mov fir, 0
  mov ah,0
  int 1ah	;dx<-ticks
  mov bx,dx	;save old tick
  add bx ,1	;set bx/18 sec of delay
  mov time, bl
  mov time1, bh
  mov doit, 1
repeat:
  mov ah, 0
  int 1ah
  mov bl, time
  mov bh, time1
  cmp dx,bx
    jge leback
  
  pop cx 
  pop bx 
  pop ax
  pop dx
  ret
delay	endp

random 	proc
  push dx
  push ax
  push bx
  push cx
  
	mov ah,0
	int 1ah ; move random num dx
	
	mov  ax, dx
   mov  dx, 0
   mov  cx, 60
   div  cx       ; here dx contains the remainder of the division - from 0 to 68
   add dl, 4
   mov vx, dl

  pop cx 
  pop bx 
  pop ax
  pop dx
  ret
random	endp

showcharactar 	proc
  push dx
  push ax
  push bx
  push cx
  
	mov ah, 9
	mov dx, offset character
	int 21h
  
  pop cx 
  pop bx 
  pop ax
  pop dx 
  ret
showcharactar	endp

print_score 	proc
  push dx
  push ax
  push bx
  push cx
  
  mov ah, 2
 mov dl, 70
 mov dh, 1
 int 10h
  mov ah, 9
	mov dx, offset scoretxt
	int 21h
	mov sx, 78
	
	mov al, score1
	mov ah, 0
	
	again:
	push ax
	mov ah, 2
	mov dl, sx
	mov dh, 1
	int 10h
	pop ax
	
	mov dx, 0
	mov ax, ax
	mov cx, 10
	div cx  	;ax=/  dx=%
	
	push ax
	mov ah, 2
	add dx, '0'
	int 21h
	pop ax
	
	cmp ax, 0
	je fi
	sub sx, 1
	jmp again
	
	fi:
	
  pop cx 
  pop bx 
  pop ax
  pop dx   
  ret
print_score	endp

print_highscore 	proc
  push dx
  push ax
  push bx
  push cx
  ;checks if high score is high
  mov al, highscore
  cmp al, score1
  jge sskp
  mov al, score1
  mov highscore, al
  sskp:  
  mov ah, 2
 mov dl, 70
 mov dh, 4
 int 10h
  mov ah, 9
	mov dx, offset highscoretxt1
	int 21h
	mov ah, 2
 mov dl, 70
 mov dh, 5
 int 10h
  mov ah, 9
	mov dx, offset highscoretxt2
	int 21h
	mov sx, 78
	
	mov al, highscore
	mov ah, 0
	
	aagain:
	push ax
	mov ah, 2
	mov dl, sx
	mov dh, 5
	int 10h
	pop ax
	
	mov dx, 0
	mov ax, ax
	mov cx, 10
	div cx  	;ax=/  dx=%
	
	push ax
	mov ah, 2
	add dx, '0'
	int 21h
	pop ax
	
	cmp ax, 0
	je fii
	sub sx, 1
	jmp aagain
	
	fii:
	
  pop cx 
  pop bx 
  pop ax
  pop dx   
  ret
print_highscore	endp
  
end start