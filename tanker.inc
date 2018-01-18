;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TAKE_INP MACRO P   ;PLAYER 1: P=0.....PLAYER 2: P=2 
    
    local DONOTDRAWCLOUDS ,sendah,chats,LOll,RL,PRINTNULLL,AGAINPPL,CHECKINPL,CHKPPL,loa,checkup,checkdown ,checkright,checkleft,checkhit,final,SpeedAboveFourty,AfterSelectSpeed,SpeedAboveFiFty,END,CHECKSPEEDDOWN,CHECKSPEEDUP,CHECK_EXIT
    
   MOV CurrentPlayer, P 
    
loa:    
     
    cmp LevelNumber,2
    JNE DONOTDRAWCLOUDS 
    CALL MOV_CLOUDS
    DONOTDRAWCLOUDS:
     MOV AH, 01 ; ZF =0 if key pressed, else ZF=1
    INT 16H  
    JZ PRINTNULLL
    
    MOV AH, 00 ; AL: ASCII Code, AH: Scancode
    INT 16H 
    
    JMP RL
    PRINTNULLL:
    MOV AX,0   
    RL: 
    PUSH AX
    
    
     

           
    mov dx , 3FDH		; Line Status Register
    AGAINPPL: 
    In al , dx 			;Read Line Status
    AND al , 00100000b
    JZ AGAINPPL 

     
    mov dx , 3F8H
    POP AX	 
    cmp AL,0
    je sendah
    mov ah,al 
    sendah:
	MOV MYINP, AH
    MOV AL,AH	; Transmit data registe   
    MOV CX,AX
    out dx , al  
    
    cmp al, 27
    je esc3
      
        
   CHECKINPL:  
     mov dx , 3FDH		; Line Status Register
   CHKPPL: in al , dx 
        AND al , 1
        JZ CHKPPL
    
        
    mov dx , 03F8H
    in al , dx   
    cmp al, 27
    je esc3
    MOV AH,AL ;HAVEE IN AH THE USER KEY 
	MOV USERINP,AH

      MOV DX,0
     MOV DL, MYNUM
    CMP CURRENTPLAYER, DX
    JNE LOll
    
    MOV AX,CX  
    
 
    
 
    
 
    
  
LOll:
    ;
    cmp aH,0 
    call innerchat  
    je loa
    ;
    ;CHECK FOR UP KEY TO INCREMENT GUN ANGLE
    CHECKUP: 
    CMP AH,UP+P
    JNE CHECKDOWN 
    ;STOP WHEN ANGLE = MAX= 90
    CMP ANGLE+P,9 
    JE LOA 
    ;REMOVE OLD GUN
    MOV BL,BackgroundColor
    mov DrawingColor, BL
    DrawGun P 
    INC ANGLE+P  
    ;DRAW GUN IN NEW POSITION
    MOV BL,Color1
    mov DrawingColor, BL
    DrawGun P 
    JMP LOA  
    ;
    ;
    ;CHECK FOR DOWN KEY TO DECREMENT GUN ANGLE
    CHECKDOWN:
    CMP AH,DOWN+P
    JNE CHECKRIGHT
    ;STOP WHEN ANGLE = MIN= 0
    CMP ANGLE+P,0 
    JE LOA
    ;REMOVE OLD GUN 
    MOV BL, BackgroundColor
    mov DrawingColor, BL
    DrawGun P 
    DEC ANGLE+P 
    ;DRAW GUN IN NEW POSITION
    MOV BL,  Color1
    mov DrawingColor, BL
    DrawGun P
    JMP LOA
    ;
    ;
    ;CHECK FOR RIGHT KEY TO MOVE TANK RIGHT
    CHECKRIGHT:
    CMP AH,RIGHT+P
    JNE CHECKLEFT
    call movetank
    JMP LOA
    ;
    ;
    ;CHECK FOR LEFT KEY TO MOVE TANK LEFT  
    CHECKLEFT:
    CMP AH, LEFT+P
    JNE CHECKSPEEDUP
    call movetank
    JMP LOA 
    ;
    ;
    ;CHECK FOR U KEY TO INCREASE SPEED OF PROJECTION
    CHECKSPEEDUP:
    CMP AH,SPEEDUP+P
    JNE CHECKSPEEDDOWN
    CALL INCREMENTSPEED
    JMP LOA
    ;
    ;
    ;CHECK FOR Y KEY TO DECREASE SPEED OF PROJECTION
    CHECKSPEEDDOWN:
    CMP AH,SPEEDDOWN+P
    JNE CHECKHIT
    CALL DECREMENTSPEED
    JMP LOA  
    ;
    ;
    ;CHECK FOR SPACE KEY FOR PLAYER TO HIT
    CHECKHIT:
    CMP Ah,HIT+P
    jne CHECK_EXIT
    ;GET STARTING POINT OF PROJECTION
    MOV BX,GX1+P 
    MOV DX,200  
    SUB DX, GY1+P
    ;DECIDE ON PROJECTION SPEED V TO CHOOSE VCOS(THETA)/VSIN(THETA) 
    cmp CurrentSpeed,40
    JNE SpeedAboveFourty
    MOV SI,OFFSET 40Cos 
    MOV DI,OFFSET 40Sin
    jmp AfterSelectSpeed
    SpeedAboveFourty:
    cmp CurrentSpeed,50
    JNE SpeedAboveFiFty
    MOV SI,OFFSET 50Cos 
    MOV DI,OFFSET 50Sin
    jmp AfterSelectSpeed
    SpeedAboveFiFty:       
    MOV SI,OFFSET 60Cos 
    MOV DI,OFFSET 60Sin
    AfterSelectSpeed: 
    ;CHOOSE CORRECT THETA
    MOV AX,ANGLE+P
    ADD SI,AX
    ADD DI,AX
    CALL DRAWPROJ
    JMP END 
    CHECK_EXIT:
    CMP AH,1
    JNE CHATS
    MOV MODE,3 
	JMP END 
   chats:
    
	JMP LOA
END:
TAKE_INP ENDM  
;TAKE_INP MACRO P   ;PLAYER 1: P=0.....PLAYER 2: P=2 
;    
;    local loa,checkup,checkdown ,checkright,checkleft,checkhit,final,SpeedAboveFourty,AfterSelectSpeed,SpeedAboveFiFty,END,CHECKSPEEDDOWN,CHECKSPEEDUP,CHECK_EXIT
;    
;    MOV CurrentPlayer, P
;    ; this is used as if player  press by wrong button (during projectile movement)
;    ;EMPTY THE BUFFER 
;    MOV AL,0 
;    mov ah,0Ch              
;    int 21h
;  
;LOA:
;    ;
;    ;
;    ;GET INPUT KEY 
;    MOV AH, 00 
;    INT 16H 
;    ;
;    ;
;    ;CHECK FOR UP KEY TO INCREMENT GUN ANGLE
;    CHECKUP: 
;    CMP AH,UP+P
;    JNE CHECKDOWN 
;    ;STOP WHEN ANGLE = MAX= 90
;    CMP ANGLE+P,9 
;    JE LOA 
;    ;REMOVE OLD GUN
;    MOV BL,BackgroundColor
;    mov DrawingColor, BL
;    DrawGun P 
;    INC ANGLE+P  
;    ;DRAW GUN IN NEW POSITION
;    MOV BL,Color1
;    mov DrawingColor, BL
;    DrawGun P 
;    JMP LOA  
;    ;
;    ;
;    ;CHECK FOR DOWN KEY TO DECREMENT GUN ANGLE
;    CHECKDOWN:
;    CMP AH,DOWN+P
;    JNE CHECKRIGHT
;    ;STOP WHEN ANGLE = MIN= 0
;    CMP ANGLE+P,0 
;    JE LOA
;    ;REMOVE OLD GUN 
;    MOV BL, BackgroundColor
;    mov DrawingColor, BL
;    DrawGun P 
;    DEC ANGLE+P 
;    ;DRAW GUN IN NEW POSITION
;    MOV BL,  Color1
;    mov DrawingColor, BL
;    DrawGun P
;    JMP LOA
;    ;
;    ;
;    ;CHECK FOR RIGHT KEY TO MOVE TANK RIGHT
;    CHECKRIGHT:
;    CMP AH,RIGHT+P
;    JNE CHECKLEFT
;    call movetank
;    JMP LOA
;    ;
;    ;
;    ;CHECK FOR LEFT KEY TO MOVE TANK LEFT  
;    CHECKLEFT:
;    CMP AH, LEFT+P
;    JNE CHECKSPEEDUP
;    call movetank
;    JMP LOA 
;    ;
;    ;
;    ;CHECK FOR U KEY TO INCREASE SPEED OF PROJECTION
;    CHECKSPEEDUP:
;    CMP AH,SPEEDUP+P
;    JNE CHECKSPEEDDOWN
;    CALL INCREMENTSPEED
;    JMP LOA
;    ;
;    ;
;    ;CHECK FOR Y KEY TO DECREASE SPEED OF PROJECTION
;    CHECKSPEEDDOWN:
;    CMP AH,SPEEDDOWN+P
;    JNE CHECKHIT
;    CALL DECREMENTSPEED
;    JMP LOA  
;    ;
;    ;
;    ;CHECK FOR SPACE KEY FOR PLAYER TO HIT
;    CHECKHIT:
;    CMP Ah,HIT+P
;    jne CHECK_EXIT
;    ;GET STARTING POINT OF PROJECTION
;    MOV BX,GX1+P 
;    MOV DX,200  
;    SUB DX, GY1+P
;    ;DECIDE ON PROJECTION SPEED V TO CHOOSE VCOS(THETA)/VSIN(THETA) 
;    cmp CurrentSpeed,40
;    JNE SpeedAboveFourty
;    MOV SI,OFFSET 40Cos 
;    MOV DI,OFFSET 40Sin
;    jmp AfterSelectSpeed
;    SpeedAboveFourty:
;    cmp CurrentSpeed,50
;    JNE SpeedAboveFiFty
;    MOV SI,OFFSET 50Cos 
;    MOV DI,OFFSET 50Sin
;    jmp AfterSelectSpeed
;    SpeedAboveFiFty:       
;    MOV SI,OFFSET 60Cos 
;    MOV DI,OFFSET 60Sin
;    AfterSelectSpeed: 
;    ;CHOOSE CORRECT THETA
;    MOV AX,ANGLE+P
;    ADD SI,AX
;    ADD DI,AX
;    CALL DRAWPROJ
;    
;    JMP END  
;    CHECK_EXIT:
;    CMP AL,27
;    JNE LOA
;    MOV MODE,3  
;    
;END:
;TAKE_INP ENDM  
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
DRAW_QUAD MACRO  LENGTH,XSTART,YSTART,WIDTH,COLOR
    LOCAL QUAD    
    
   ; SETTING VARIABLES TO START DRAWING 
   MOV AX,XSTART
   MOV X1,AX
   MOV AX,YSTART
   MOV Y1,AX
   MOV AX,LENGTH
   MOV L1,AX
   MOV AL,COLOR
   MOV DRAWINGCOLOR,AL  ; SET DRAWINGCOLOR 
   MOV AX,YSTART
   SUB AX,WIDTH
 
 QUAD:   
   CALL DRAWHLINE  
   INC X1
   DEC Y1
   SUB L1,2
   CMP Y1,AX
   JGE QUAD 
     
    
DRAW_QUAD ENDM  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Draw Tank's Gun using line algorithm
DrawGun MACRO P  
    
    LOCAL comp, comp1,MoveGunForPlayer2,SameX,PlotPoint2, SlopeGreaterThan1,BresenhamsmGreaterThan1 ,StartMovingGun1,slopeGreaterThan1,Bresenhamsmlessthan1,SameY,PlotPoint,ENDDrawGun
    pusha
    push X3+P 
    ;X3,Y3 are first(lower) point of gun
    ;compute last point component in x
    mov bx,offset LCos
    add bX,angle+P
    mov cx,[bx] 
    mov ch,0
    mov gx1+P,cx 
    ;compute last point component in y
    mov bx,offset LSin
    add bX,angle+P
    mov cx,[bx]
    mov ch,0
    mov gy1+P,cx
    ;tanslate last point as first point of gun is the origin of new axes
    mov cx,x3+P
    add gx1+P,cx ;Gx1=Gx1+X3
    mov si,gx1+P ;save Gx1 in si
    mov cx,y3+P
    sub cx,gy1+P
    mov gy1+P,cx ;Gy1=Gy1-y3
    
    ;Compute Xdiff between first and last point of gun
    mov cx,gx1+P
    sub cx,x3+P
    mov Xdiff,cx ;Xdiff=gx1-x3
    ;Compute Ydiff between first and last point of gun
    mov cx,y3+P
    sub cx,gy1+P
    mov Ydiff,cx ;Ydiff=y3-gy1 as y3 always greater than gy1
    ;Compute 2*Ydiff
    mov cl,2
    mov ax,Ydiff
    mul cl
    mov 2Ydiff,ax
    ;Compute 2*Xdiff
    mov cx,0
    mov cl,2
    mov ax,Xdiff
    mul cl 
    mov ah,0
    mov 2Xdiff,ax;calculate 2*Xdiff
    ;Now all Parameters of line algorithm is ready
    mov di,1 
    ;Start with intial point (first point of gun)
    mov cx,x3+P ;Column
    mov dx,y3+P ;Row
    mov al,DrawingColor ;Pixel color
    mov ah,0ch ;Draw Pixel Command
    int 10h    ;Draw first point

    cmp angle+P,4
    JA slopeGreaterThan1
    ;if angle less than 45 , slope < 1 --> begin with intial point and every loop --> increment x and calculate y
    ;Assuming that bx register is the fraction of algorithm
    mov bx,2Ydiff ;bx=2Ydiff
    sub bx,Xdiff ;bx=2Ydiff-Xdiff
    Bresenhamsmlessthan1:
    cmp bx,0
    JNG SameY     
    ;if bx(fraction) >=0 --> y=y-1 
    dec dx 
    add bx,2Ydiff ; fraction=fraction+2Ydiff
    sub bx,2Xdiff ; fraction=fraction-2Xidff
    push cx
    jmp PlotPoint
    SameY:
    ;if bx(fraction) <0 --> y stays same
    add bx,2Ydiff ;Fraction=Fraction+2Xdiff
    push cx
    PlotPoint:
        CMP CurrentPlayer, 2
        JNE COMP
        ;if CurrentPlayer is Player2 --> reflect point on vertical line x=X3 
        ;Y stay the same y computed in dx but cx changes from reflection
        SUB CX, X3+2 ;x=x-x3
        MOV AX,0
        SUB AX,CX ;make x negative as 0-x=-x
        MOV CX, AX 
        ADD CX, X3+2 ;x=X3-x
        
    COMP:
    ;Draw pixel computed in cx,dx either for player1 or player2    
    mov al,DrawingColor ;Pixel color
    mov ah,0ch ;Draw Pixel Command
    int 10h 
    ;if this is the last point , save x in GX1 as last point in gun      
    mov GX1+p,cx 
    ;return cx to its value (if player2 is the current player --> cx is changed ) 
    ;so we push it before to complete drawing line     
    pop cx
    ;increment x to go to the next point to calculate y for it
    inc cx
    cmp cx,si
    ;if Drawing x is still not the last point of gun si(gx1) --> continue in algorithm 
    JNE Bresenhamsmlessthan1
    ;if Drawing x is equal to last point of gun then the algorithm will stop
    jmp ENDDrawGun  
    
    SlopeGreaterThan1:
    ;if angle Greater than 45 , slope > 1 --> begin with intial point and every loop --> increment y and calculate x
    ;Assuming that bx register is the fraction of algorithm
    mov bx,2Xdiff ;bx=2Xdiff
    sub bx,Ydiff ;bx=2Ydiff-Xdiff
    BresenhamsmGreaterThan1:
    cmp bx,0
    JNG SameX
    ;if bx(Fraction) >=0 --> x=x+1
    inc cx
    add bx,2Xdiff ;Fraction=Fraction+2Xdiff
    sub bx,2Ydiff ;Fraction=Fraction-2Ydiff
    push cx
    jmp PlotPoint2
    SameX:
    ;if bx(fraction) <0 --> x stays same
    add bx,2Xdiff ;Fraction=Fraction+2Xdiff
    push cx
    PlotPoint2:
      ;if CurrentPlayer is Player2 --> reflect point on vertical line x=X3 
      ;Y stay the same y computed in dx but cx changes from reflection 
      CMP CurrentPlayer, 2
      JNE COMP1
      SUB CX, X3+2 ;x=x-x3
      MOV AX,0
      SUB AX,CX    ;make x negative as 0-x=-x
      MOV CX, AX 
      ADD CX, X3+2 ;x=X3-x 
        
    COMP1:
    ;Draw pixel computed in cx,dx either for player1 or player2
    mov al,DrawingColor ;Pixel color
    mov ah,0ch ;Draw Pixel Command
    int 10h 
    ;if this is the last point , save x in GX1 as last point in gun
    mov gx1+P,cx
    ;return cx to its value (if player2 is the current player --> cx is changed )
    ;so we push it before to complete drawing line
    pop cx
    ;decrement y to go to the next point to calculate y for it
    dec dx 
    cmp dx,gy1+P 
    ;if Drawing y is still not the last point of gun gy1 --> continue in algorithm
    JNE BresenhamsmGreaterThan1 
    ;if Drawing y is equal to last point of gun then the algorithm will stop
    
    ENDDrawGun:
    pop x3+P    
    popa
DrawGun ENDM 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TANKHIT MACRO P
       
    LOCAL LOOOP  
    
    ;SAVE CURR PLAYER SINCE PLAYER COULD HITHIMSELF OR OPONENT
    push CurrentPlayer
    mov CurrentPlayer,p
    
    ;SHUDDER NUMBER
    MOV BX,4 
    ;SOUND OF IMPACT
    CALL DISPLAY_SOUND
    
looop:
    PUSH BX  
    
    ;REMOVE TANK 
    mov bx,x0+P
    mov x1,bx
    mov bx,y0+P
    mov y1,bx
    mov L1,30 
    call cleartank  
    ;PAUSE
    CALL PAUSE
    ;DRAW TANK AGAIN   
    mov bx,x0+P
    mov x1,bx
    mov bx,y0+P
    mov y1,bx
    mov L1,30 
    call drawtank  
    ;PAUSE
    CALL PAUSE  
    
    POP BX 
    DEC BX
    JNZ looop    
    
    pop CurrentPlayer
    
TANKHIT ENDM    
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CALCDAMAGE MACRO P 
    ;r^2=y^2+x^2   
    
    LOCAL NODAM,YOOH,YOOH1,YOOH3,YOOH4 ,START_AGAINE,  AGAINPPL ,COMP11 ,CHKPPL,CHECKINPL

    
    PUSH DX     ;WHICH HAS Y
    sub cx,x0+P ;X-CENTER OF TANK
    sub cx,20   ; - 20 TO GET EXACT CENTER
    MOV AX,CX 
    IMUL CX      ;X^2  
    
    MOV BX,AX
    POP AX 
    sub ax,y0+P  ;Y-CENTER OF TANK
    ADD ax,10    ;+ 10 TO GET EXACT CENTER
    IMUL AX      ;Y^2
    ADD BX,AX
    
    CMP BX, 2500 ; R=50
    JAE NODAM    ;NO DAMAGE IF PROJECTILE IS MORE THAN 50PIXELS AWAY FROM CENTER
    MOV AX,2500   
    SUB AX,BX
    mov bl,80    ;CALCULATE DAMAGE 
    IDIV bl  

    ;DECIDE ON PLAYER HEALTH TO DECREASE
    MOV BX, P
    CMP BX,0 
    JNE YOOH  
    ;COMPARE DAMAGE TO CURRENT HEALTH
    CMP AL, PLAYERSHEALTH
    JB YOOH3 
    MOV AL,PLAYERSHEALTH
    YOOH3: 
    ;IF MORE, HEALTH=0 BUT SUBTRACTING IT FROM ITSELF
    SUB PLAYERSHEALTH,Al 
    JMP YOOH1
    YOOH:
    CMP AL, PLAYERSHEALTH+1
    JB YOOH4 
    MOV AL,PLAYERSHEALTH+1
    YOOH4:  
    SUB PLAYERSHEALTH+1,Al
    YOOH1:
    ;REDRAW HEALTHBARS 
    call DecreaseHealth 
    ;TANK HIT EFFECT 
    TANKHIT P
    
    NODAM: 
    
CALCDAMAGE ENDM



GAMEINSTRUCTION MACRO 
    

mov x1,3    
mov y1,35
push l1
push w 
mov l1,315
mov w,145
mov bordercolor,0dH
mov fillcolor,0000b
call drawrectangle 
   
mov CursorPositionX,9
mov CursorPositionY,4    

call movecursor


MOV AH, 02 ; Output Char
MOV DL,4 ; Char to Display
INT 21H    


MOV AH,9H
MOV DX, OFFSET INSTRUCTION    
INT 21H   
    
mov CursorPositionX,1
mov CursorPositionY,6    

call movecursor
    
MOV AH,9H
MOV DX, OFFSET INSTRUCTION1    
INT 21H     
    
    
mov CursorPositionX,4
mov CursorPositionY,8    

call movecursor
        
    
    
MOV AH,9H
MOV DX, OFFSET INSTRUCTION2    
INT 21H     
    
    
mov CursorPositionX,4
mov CursorPositionY,10    

call movecursor
        
    
MOV AH,9H
MOV DX, OFFSET INSTRUCTION3    
INT 21H     
    
    
mov CursorPositionX,4
mov CursorPositionY,12    

call movecursor
        
    
MOV AH,9H
MOV DX, OFFSET INSTRUCTION4    
INT 21H     
      
mov CursorPositionX,4
mov CursorPositionY,14    

call movecursor
        
    
MOV AH,9H
MOV DX, OFFSET INSTRUCTION5    
INT 21H     

    
mov CursorPositionX,4
mov CursorPositionY,16    

call movecursor
        
    
MOV AH,9H
MOV DX, OFFSET INSTRUCTION6    
INT 21H 
mov CursorPositionX,4
mov CursorPositionY,18    

call movecursor
        
    
MOV AH,9H
MOV DX, OFFSET INSTRUCTION7    
INT 21H     

    
mov CursorPositionX,4
mov CursorPositionY,20    

call movecursor
        
    
MOV AH,9H
MOV DX, OFFSET INSTRUCTION8    
INT 21H   

mov CursorPositionX,4
mov CursorPositionY,22    

call movecursor

MOV AH, 02 ; Output Char
MOV DL,4 ; Char to Display
INT 21H        
    
MOV AH,9H
MOV DX, OFFSET INSTRUCTION9    
INT 21H    
         
        


START_AGAINE:  
; MOV AH, 01 ; ZF =0 if key pressed, else ZF=1
;    INT 16H  
;    JZ PRINTNULLLe
;    
;    MOV AH, 00 ; AL: ASCII Code, AH: Scancode
;    INT 16H 
;    
;    JMP RLe
;    PRINTNULLLe:
;    MOV AL,0
;    RLe: 

   
     MOV AH, 01 ; ZF =0 if key pressed, else ZF=1
    INT 16H  
    JZ PRINTNULLL
    
    MOV AH, 00 ; AL: ASCII Code, AH: Scancode
    INT 16H 
    
    JMP RL
    PRINTNULLL:
    MOV AX,0   
    RL: 
    PUSH AX
    
     

           
    mov dx , 3FDH		; Line Status Register
    AGAINPPL: 
    In al , dx 			;Read Line Status
    AND al , 00100000b
    JZ AGAINPPL 

     
    mov dx , 3F8H
    POP AX	; Transmit data register
    out dx , al 
    CMP AL, 13
    JNE COMP11 
    CMP REEM,1
    JE ENDI
    MOV REEM,1 
    COMP11:    
   CHECKINPL:  
     mov dx , 3FDH		; Line Status Register
   CHKPPL: in al , dx 
        AND al , 1
        JZ CHKPPL
    mov dx , 03F8H
    in al , dx  
    CMP AL,13
    JNE START_AGAINE
    CMP REEM,1
    JE ENDI
    MOV REEM,1
    JMP START_AGAINE 
       
ESC3: 
   MOV MODE,3
  JMP ENDIT
endi:  
 
 CMP MYNUM,0
 JNE LOADINNG 
  DELETE_SCREEN 0,25
  CALL SELECTLEVEL
 LOADINNG: 
 CMP MYNUM,0
 JNE RECIEVEL 
 mov dx , 3FDH		; Line Status Register
    AGAINPPPL: 
    In al , dx 			;Read Line Status
    AND al , 00100000b
    JZ AGAINPPPL 

     
    mov dx , 3F8H
    MOV AL,LevelNumber	; Transmit data register
    out dx , al  
    JMP ENDIT
 RECIEVEL:  
     mov dx , 3FDH		; Line Status Register
   CHKPPPL: in al , dx 
        AND al , 1
        JZ CHKPPPL
    mov dx , 03F8H
    in al , dx  
    
    CMP AL, 0
    JE RECIEVEL 
    MOV LevelNumber,AL
ENDIT:   
pop w
pop l1      
    
GAMEINSTRUCTION ENDM 

MACRO DELETE_SCREEN T,O  
    PUSHA
     ; MOVE CURSOR TO SPECIFIC POSITION
    MOV AH, 7
    MOV Cl, 0
    mov ch, t; X coordinate
    MOV Dl, 80
    mov dh, O  ; Y coordinate 
    MOV BH, 00  ; If Mode supports more than 1 page, else it is ignored
    MOV AL, 0  ;    Pixel Color
    int 10h    

    POPA
 
 DELETE_SCREEN ENDM                 



MACRO DELETE_LINE  T1 
    LOCAL S
    PUSHA
    MOV AH, 0CH
    MOV CL,0 ; X coordinate
    MOV CH,T1
    MOV DL,0  ; Y coordinate
    MOV DH,T1 
    MOV BH, 00  ; If Mode supports more than 1 page, else it is ignored
    MOV AL, 0  ; 
        
    S:
    
    INT 10H
    INC CX
    
    CMP CX,320
    JNZ S  
    
    POPA
 
 DELETE_LINE ENDM                 
