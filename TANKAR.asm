    include tanker.inc
;;;;;;;;;;;;;;;;;;;;;;; GAME CONTROLS;;;;;;;;;;;;;;;;;;;;;;;
  ;* EACH PLAYER HAVE THE SAME CONTROLLS IN HIS TURN 
    ;  * RIGHT ARROW TO MOVE RIGHT 
    ;  * LEFT ARROW TO MOVE LEFT
    ;  * UP ARROW TO INCREASE ANGLE
    ;  * DOWN ARROW TO DECREASE ANGLE
    ;  * "+" BUTTON TO INCREASE SPEED
    ;  * "-" BUTTON TO DECREASE SPEED
    ;  * SPACE BUTTON TO FIRE 
  ;;;;;;;;;;;;;;;;;;;;;;; ANY OTHER INSTRUCTION WILL DIPLAYED  ON THE SCREEN;;;;;;;;
.model small
.stack 64
.Data
    
    ;;;;;; GAME INFO ;;;;;;
    GameName DB 'TANKAR$'
    Level DB 'LEVEL ?$'
    LevelNumber DB 0
    ENDINGMESSAGE DB 'GAME OVER$'
    WINNERPLAYER DB ' WINS$'
    CurrentPlayer Dw 0
    MODE DB 0
    ;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;; Players info ;;;;;;
    P1NAME  DB 17,?,16 DUP('$')  
    P2NAME  DB 17,?,16 DUP('$')
    EMPTYSTR DB 17 DUP('$')
    A_P DB "Enter player Name : $" 
    PlayersHealth DB 80,80  
    ;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;;;;;; COLORS ;;;;;;
    BackgroundColor dB 14 
    DrawingColor dB 5
    FillColor dB 5
    BorderColor dB 12  
    ;;;;;;;;;;;;;;;;;;;   
    
    ;;;;;; CURSOR POSITION ;;;;;;
    CursorPositionX DB 17
    CursorPositionY DB 1
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     
    ;;;;;; TANKS ;;;;;; 
    x0 dw 0,280     ;position of tanks 
    y0 dw 146,146   ;yposition of tanks
    color1 db 1000B ;fill of tank 
    ;;;;;;;;;;;;;;;;;;
     
    ;;;;;; TANKS WHEALS ;;;;;;
    r  dw 5    ; radius of wheals
    x1 dw 0  ;hrozontail line drawing xcoordinate
    y1 dw 0  ; horizontal line drawing ycoorsinate 
    color db 0dh    ;wheals color
    ;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;;;;;; MOUNTAIN ;;;;;;
    MountainCenterX DW 77
    MountainCenterY DW 151
    MountainLenght DW 166
    MountainWidth DW  50
    MountainColor db 211
    ;;;;;;;;;;;;;;;;;;;;;;   
    
    ;;;;;; CLOUDS ;;;;;;;
    CLX1 DW 20
    CLY DW 70 
	CLX2 DW 250
    MOVEDIRECTION2 DW 1  ;0 FOR MOVING RIGHT,1 FOR LEFT 
    MOVEDIRECTION1 DW 0  ;0 FOR MOVING RIGHT,1 FOR LEFT   
    MOVEDELAY DW 10
    MOVEDELAYTIME EQU 10
    ;;;;;;;;;;;;;;;;;;;;
    
    HunSin DB 0,17,34,50,64,77,87,94,98,100   ;v=100
    HunCos DB 100,98,94,87,77,64,50,34,17,0 
    HalfG DB 5
    l1 dw 30   
    W DW 30        
    
    ; sin angles multiply speed "angles from 0 to 90 "  speed =50
                   ;;;;;;;;;;;;;;;;;;;;;; speed =40 ;;;;;;;;;;;;;;;;;;;;;;
    40Sin DB 0,7,14,20,26,31,35,38,39,40
    40Cos DB 40,39,38,35,31,26,20,14,7,0 
                   ;;;;;;;;;;;;;;;;;;;;;; speed =50 ;;;;;;;;;;;;;;;;;;;;;;
    50Sin DB 0,9,17,25,32,39,44,47,49,50
    50Cos DB 50,49,47,44,39,32,25,17,9,0  
                  ;;;;;;;;;;;;;;;;;;;;;; speed = 60;;;;;;;;;;;;;;;;;;;;;   
    60Sin DB 0,10,21,30,39,46,52, 56,59,60
    60Cos DB 60,59,56,52,46,39,30,21,10,0 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;;;;;; Projectile Parameters ;;;;;;
    SavedPixels DW 9 dup (0)

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;;;;;; Gun Parameters ;;;;;; 
    angle DW 5,5    ;angle between gun and horizontal
    CurrentSpeed dB 40 ;intial Speed of Shooting
    ;First point of gun
    x3 dw 0,0  
    y3 dw 0,0
    ;gun last point            
    GX1 DW 0 ,0     
    GY1 DW 0 ,0
    
    ;x,y compontents of Last Point of Gun
    LCos DB 20,20,19,17,15,13,10,7,3,0;L=20
    LSin DB 0,3,7,10,13,15,17,19,20,20;L=20
    
    ;PARAMETERS TO DRAW GUN ALGORITHM
    Xdiff DW 0
    Ydiff DW 0
    2Ydiff DW 0
    2Xdiff DW 0 
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ;;;;;; Buttons ScanCodes ;;;;;;
    LEFT DB 75,0,75
    RIGHT DB 77,0,77
    UP DB  72,0,72  
    DOWN DB 80,0,80   
    HIT DB 13,0, 13  
    SPEEDUP DB '+',0,'+' 
    SPEEDDOWN DB '-',0,'-'
    
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
    ;;;;;;;;; dimensions of screen;;;;;;;;;
    SCREENUPPER DW 40
    SCREENLOWER  DW 152
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;;;;;;;;;;;;; game controlled messages;;;;;;;;;;;
    ESCMESSAGE DB " TO EXIT PRESS ESC $"
    F2MESSAGE DB " TO START TANKER GAME PRESS F2 $"
    F1MESSAGE DB " TO START CHATTING PRESS F1 $"
    RESTARTMESSAGE DB "TO RETURN TO MENUE PRESS R $ " 
    ERROR DB 'Invalid. First Letter must be a Letter. Press ENTER$'
    INSTRUCTION DB  "GAME INSTUCTION CONTROLLS $"
    INSTRUCTION1 DB "PLAYERS EXCHANGE TURNS WITH CONTROLLS $"
    INSTRUCTION2 DB "RIGHT ARROW TO MOVE RIGHT $"
    INSTRUCTION3 DB "LEFT ARROW TO MOVE LEFT $"
    INSTRUCTION4 DB ""+" BUTTON TO INCREASE FIRE'S SPEED$"
    INSTRUCTION5 DB ""-" BUTTON TO DECREASE FIRE'S SPEED$"
    INSTRUCTION6 DB "UP ARROW TO INCREASE ANGLE $"
    INSTRUCTION7 DB "DOWN ARROW TO DECREASE ANGLE $"
    
    INSTRUCTION8 DB "ENTER BUTTON TO FIRE  $"
    INSTRUCTION9 DB "PRESS ENTER TO START GAME  $"
    
     
    F3MESSAGE DB " TO EXIT CHAT PRESS F3 $"
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 
CONNECTIONERROR DB "CONNECTION DROPPED$" 
MYNUM DB 6 ;DEFINES THE PLAYER NUM ON THIS COMP 
OTHNUM DB 0  
CF1 DB 59
CF2 DB 60 
CESC DB 1  
PF1 DB 0 
INV DB " YOU SENT A GAME INVITATION TO $"
RINV DB " SENT YOU A GAME INVITATION , PRESS F2 TO ACCEPT$"
INV1 DB " YOU SENT A CHAT INVITATION TO $"
RINV1 DB " SENT YOU A CHAT INVITATION , PRESS F1 TO ACCEPT$" 

START DB "GAME STARTING$"
REEM DB 0  
;;;;;;;;;;;;;;;;;;;;;;CHATTING PARFAMETERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;
XPOS DB  0
YPOS DB  1
XRPOS DB 0
YRPOS DB 13 
;reset after chat   
myx db 2
myy db 21
ux db 2
uy db 20
load DB " LOADING...... $" 
MYINP DB 0
USERINP DB 0  
.Code

main proc FAR
    mov ax,@Data
    mov ds,ax   
    
    CALL CONFIGURE
   CALL CHANGE_MODE
   CALL CONNECTION_CHECK
    ;CALL CHANGE_MODE 
    ;Call DRAW_CLOUDS
    ;READ PLAYER NAMES FROM USER
    call ASK_P 
    DELETE_SCREEN 0,25
     MOV AH,9H
     MOV DX,OFFSET load
     INT 21H 
    CALL SENDNAME 
    MAINMEN: 
    DELETE_SCREEN 0,25
   ; call ASK_P2  
    CALL DRAW_STATUS_BAR
    ;CHECK USER MODE
    
    CALL DETECTING_USER_CHOISE
    ;DETECTING MODE
    CMP MODE,1
        JE CHATTING
    CMP MODE,2
        JE GAMEINST
    CMP MODE,3
        JE ESC 
    ;PREPARE SCENE TO START PLAYING 
    GAMEINST:
      GAMEINSTRUCTION   
        CMP MODE,3
            JE ESC   
            
            
    GAME:
     CALL GAMESTARTUP 
    
    ;;;;;;;;;;;;;;;;;;;;;;; starting logic;;;;;;;;;;;;;;;;;;;;
    ;Main Loop of the game until one of the players is dead
        GameLabel: 
        
            ;TAKE USER INPUT FOR TANKS 
            TAKE_INP 0
            ; CHECK IF USER CHOOSE EXIT MODE 
            CMP MODE,3
            JE ESC
            call ChangePlayers
            ; CHECK IF ANY USER LOSE
            ;;;;;;;;;PLAYER 1;;;;;;;;;;; 
            cmp PlayersHealth,0
            JNE CheckPlayer22
            call PRINTWINNER
            jmp ENDGAME
            ;;;;;;;;;PLAYER 2;;;;;;;;;;;
            CheckPlayer22:
            cmp PlayersHealth+1,0
            JNE LOL
            call PRINTWINNER
            jmp ENDGAME
           
        LOL: 
            
            TAKE_INP 2 
            CMP MODE,3
            JE ESC  
            call ChangePlayers
            
            ;check if player1,2 are both alive to complete game
            ;if one of them health = 0 the game will stop to print winner's name 
            cmp PlayersHealth,0
            JNE CheckPlayer2 
            ;player1 is dead --> print player2name
            call PRINTWINNER
            jmp ENDGAME
            CheckPlayer2:
            cmp PlayersHealth+1,0
            ;jmp to game label if both alive
            JNE GameLabel
            ;player2 is dead --> print player1name
            call PRINTWINNER
            jmp ENDGAME
       ;chatting mode
        CHATTING:
            DELETE_SCREEN 0,25
            CALL CHAT
            JMP MAINMEN
            
        ; CHECK IF UESR WANT TO END GAME OR RESTART IT
        ENDGAME:
          CALL DETECT_CHOISE
          CMP MODE,2
          JE MAINMEN
          ; esc mode
         ESC: 
           MOV AH,4CH
           INT 21H 


main endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Enter Graphical Mode
CHANGE_MODE   PROC 
    MOV AH, 00
    MOV AL, 13H
    INT 10H
    RET
CHANGE_MODE ENDP  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROCEDURE to draw status bar 
DRAW_STATUS_BAR PROC
    
    PUSH L1
    ; SET POSITION TO DRAW BELLOW LINE
    MOV X1,5
    MOV Y1,181 
    MOV L1,300
    MOV DRAWINGCOLOR,0DH      
    CALL DRAWHLINE 
    ; SET CURSOR POSTION TO DISPLAY MESSAGE 
    
    mov CursorPositionX,1
    mov CursorPositionY,23
    
    Call MoveCursor
    

    ; DIPLAYING ESCAPE MESSAGE
    MOV AH ,9H
    MOV DX,OFFSET ESCMESSAGE
    INT 21H
    POP L1  
    

    
    
    RET
DRAW_STATUS_BAR ENDP   
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROCEDURE to reset intial values to restart game
RESTART PROC 
    ;;; clear last position of tanks;;;
    MOV AX,X0
    MOV X1,AX
    MOV AX,Y0
    MOV Y1,AX
    CALL CLEARTANK
    MOV AX,X0[2]
    MOV X1,AX
    MOV AX,Y0[2]
    MOV Y1,AX
    CALL CLEARTANK 
    ; SET HEATH OF EACH PLAYER TO ITS INITIAL STATE
   MOV PlayersHealth,80
   MOV PlayersHealth[1],80  
   ; set position of each tank to its initial one
   MOV X0,0
   MOV X0[2],280
   MOV Y0,146
   MOV Y0[2],146
   ;;;;;;;;;;;;;;; set speed and angle to initial values;;;;;;;;;;;
   mov currentspeed ,40
   mov angle,5
   mov angle[2],5
     
       RET 
RESTART ENDP 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PROSEDURE called to check user enter for ending game or restart it 
DETECT_CHOISE PROC 
 
    mov CursorPositionX,0
    mov CursorPositionY,23
    
    Call MoveCursor
     
; DIPLAYING RESTART MESSEGE 
    MOV AH ,9H
    MOV DX,OFFSET RESTARTMESSAGE
    INT 21H
    
; TAKES USER INPUT    
INPUT2:     
    mov ah,00
    int 16h
    
    cmp ah,13h  ;r to RETURN game again
    je game2
        
     cmp al,27  ;esc to esc game and end it
     je esc2
     
    JMP input2  ; IN CASE USER PRESSED UN REQUIRED BUTTON
    GAME2:
        MOV MODE,2
        JMP restartt
    ESC2:
        MOV MODE,3
        JMP ENDDDD
    RESTARTT:
        CALL RESTART
    ENDDDD:        
    RET 
 DETECT_CHOISE ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DISPLAY OPTIONS OF MODES TO USER AND DETECT HIS CHOICE MODE 
DETECTING_USER_CHOISE PROC 
    
    mov CursorPositionX,5
    mov CursorPositionY,10
    
    Call MoveCursor
     
    MOV AH, 02 ; Output Char
    MOV DL,4 ; Char to Display
    INT 21H

    MOV AH,9H
    MOV DX,OFFSET F1MESSAGE
    INT 21H
    
    mov CursorPositionX,5
    mov CursorPositionY,12
    
    Call MoveCursor  
    
    MOV AH, 02 ; Output Char 
    MOV DL,4 ; Char to Display
    INT 21H 
    
    MOV AH,9H
    MOV DX,OFFSET F2MESSAGE
    INT 21H
    
    mov CursorPositionX,5
    mov CursorPositionY,14
    
    Call MoveCursor
    
    MOV AH, 02 ; Output Char , 7 :Bell SOud
    MOV DL,4 ; Char to Display
    INT 21H  
    
    MOV AH,9H
    MOV DX,OFFSET ESCMESSAGE
    INT 21H
 INPUT: 
    CALL MANAGER
    
    CMP AL,27
    JE END_GAME
    
    CMP AH,CF1
    JE CHATTING_MODE
    
    CMP AH,CF2
    JE START_GAME
    
   JMP INPUT   ; THIS MEANS THAT USER PRESS WRONG BUTTON 
   CHATTING_MODE:
              MOV MODE,1
              JMP ENDDD
   START_GAME:
              MOV MODE,2
              JMP ENDDD
   END_GAME:
              MOV MODE,3
   ENDDD:
   
   RET 
DETECTING_USER_CHOISE ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;    
;Draw Background,Health bar,Tanks mountian and print GameName and Players Name
GAMESTARTUP PROC
    ;clear whole screen to start game or restart it
    mov ax,0600h
    xor al,al
    mov bh,0
    mov cx,0
    mov dx,184FH
    int 10h
    
    CALL DRAW_STATUS_BAR
    
    ;Fill Background with Background Color
    MOV AH, 06h    ; Scroll up function
    XOR AL, AL     ; Clear entire screen
    MOV CX, 500h  ; Upper left corner CH=row, CL=column 
    MOV DX, 124FH  ; lower right corner DH=row, DL=column 
    MOV BH, BackgroundColor
    INT 10H       
           
    Call MainBar ;Draw main bar with player names and health    
    
    ;preparing position of 1st tank
    MOV CurrentPlayer,0 
    mov bx,x0 
    mov x1,bx ;x1 to draw is x0 saved for first tank
    mov bx,y0
    mov y1,bx ;y1 to draw is y0 saved for first tank
    mov L1,30 
    call drawtank  ;CALL DRAWTANK PROC TO DRAW 1st TANK
    
    ;preparing the position of 2nd tank 
    MOV CurrentPlayer,2
    mov bx,x0+2
    mov x1,bx  ;x1 to draw is x0+2 saved for second tank
    mov bx,y0+2
    mov y1,bx  ;y1 to draw is y0+2 saved for second tank
    mov l1,30  
    call drawtank ;CALL DRAWTANK PROC TO DRAW 2nd TANK
    
    ;DRAW THE MOUNTAIN BETWEEN THE TWO TANKS                             
    DRAW_QUAD MountainLenght,MountainCenterX,MountainCenterY,MountainWidth,MountainColor    
    ;Prepare game for Player1 to play
    call changeplayers 
    MOV CURSORPOSITIONX,0
    MOV CURSORPOSITIONY,20
    CALL MOVECURSOR 
    
    MOV AH,2
    MOV Dl,P2NAME[2]
    INT 21H 
    
       
    MOV AH,2
    MOV DX,':'
    INT 21H 
    
    
     MOV CURSORPOSITIONX,0
    MOV CURSORPOSITIONY,21
    CALL MOVECURSOR 
    
    MOV AH,2
    MOV Dl,P1NAME[2]
    INT 21H 
    
     MOV AH,2
    MOV DX,':'
    INT 21H 
     
    RET
GAMESTARTUP ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROSEDURE used to Print statment 'Game Over and winning player name
PRINTWINNER PROC
    
    mov CursorPositionX,16
    mov CursorPositionY,7
    ;Move Cursor to specified x,y cursor position
    Call MoveCursor
    ;Print 'Game Over' Message
    mov ah, 9
    mov dx, offset ENDINGMESSAGE
    int 21h               
    
    mov al,4 
    
    mov CursorPositionX,20
    mov CursorPositionY,9
    
    CMP MYNUM,0
    JNE T
     
    cmp PlayersHealth,0
    JNE CheckifPlayer2dead
    
    ;Print Player2 name as a winner if player1health = 0
    ;compute suitble x so the winner statment is centered
    add al,P2Name[1] ;al=lenght of statment (winner playername + 'Wins')
    mov ah,0
    mov dl,2
    div dl ;divide lenght by 2
    sub CursorPositionX,al
    Call MoveCursor
    
    mov ah, 9
    mov dx, offset P2Name[2]
    int 21h
    jmp PRINTWINS
    CheckifPlayer2dead:
    ;Print Player1 name as a winner if player2health = 0
    cmp PlayersHealth+1,0 
    ;compute suitble x so the winner statment is centered
    add al,P1Name[1] ;al=lenght of statment (winner playername + 'Wins')
    mov ah,0
    mov dl,2
    div dl
    sub CursorPositionX,al
    Call MoveCursor
    
    mov ah, 9
    mov dx, offset P1Name[2]
    int 21h
    JMP PRINTWINS
    T:    
    
      
    cmp PlayersHealth,0
    JNE CheckifPlayer2dead1
    
    ;Print Player2 name as a winner if player1health = 0
    ;compute suitble x so the winner statment is centered
    add al,P1Name[1] ;al=lenght of statment (winner playername + 'Wins')
    mov ah,0
    mov dl,2
    div dl ;divide lenght by 2
    sub CursorPositionX,al
    Call MoveCursor
    
    mov ah, 9
    mov dx, offset P1Name[2]
    int 21h
    jmp PRINTWINS
    CheckifPlayer2dead1:
    ;Print Player1 name as a winner if player2health = 0
    cmp PlayersHealth+1,0 
    ;compute suitble x so the winner statment is centered
    add al,P2Name[1] ;al=lenght of statment (winner playername + 'Wins')
    mov ah,0
    mov dl,2
    div dl
    sub CursorPositionX,al
    Call MoveCursor
    
    mov ah, 9
    mov dx, offset P2Name[2]
    int 21h
    
    PRINTWINS:
    mov ah, 9
    mov dx, offset WINNERPLAYER
    int 21h
    
    ret
PRINTWINNER ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ASK_P PROC  ;ASK PLAYER 1 FOR HIS/HER NAME
    
    ASK1:
    ;FILL NAME OF PLAYER  WITH $    
    MOV AX,DS
    MOV ES,AX 
    MOV CX, 17
    MOV SI,OFFSET EMPTYSTR 
    MOV DI, OFFSET P1NAME+2
    REP MOVSB   
    ;CLEAR PREVIOUSLY WRITTEN TEXT
    call CLEAR_TEXT 
    ;SET CURSOR
    MOV AH, 02 
    MOV BH, 00 
    MOV DL, 6 ;COL 
    MOV DH, 12 ;ROW
    INT 10H      
    ; displaying first player message 
    MOV AH,09 
    MOV DX ,Offset A_P 
    INT 21H   
    ;input first player name
    MOV AH, 0AH 
    MOV DX, Offset P1NAME 
    INT 21H
    ;CHECK FIRST CHARACTER MUST BE A LETTER
    CMP P1NAME+2 , 'Z'
    JL CAPITAL 
    SUB P1NAME[2],32
    CAPITAL:
    CMP P1NAME[2], 'A'
    JB INVALID
    CMP P1NAME[2], 'Z'
    JA INVALID 
    JMP VALID
    ;IF INVALID, PRINT OUT ERROR MESSAGE
    INVALID:
    call CLEAR_TEXT 
    MOV AH, 09 
    MOV DX ,Offset ERROR 
    INT 21H 
    ;WAIT FOR PLAYER TO PRESS ENTER
    PRESSENTER:
    MOV AH, 00 ;
    INT 16H  
    CMP AH ,1CH
    JNZ PRESSENTER 
    ;TAKE INPUT AGAIN     
    JMP ASK1 
    ;IF VALID MOVE ON
    VALID:  
    call clear_text

    
    RET
ASK_P ENDP  
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CLEAR_TEXT PROC   ; H4ELHA W AB3T LL MACRO ISA 
    
    ; MOVE CURSOR TO SPECIFIC POSITION
    MOV AH, 0CH
    MOV CX, 0 ; X coordinate
    MOV DX, 95  ; Y coordinate 
    MOV BH, 00  ; If Mode supports more than 1 page, else it is ignored
    MOV AL, 0  ; Pixel Color   
    
    LOOPROFL: 
    
    LOOPLOL:
    
    INT 10H
    INC CX
    
    CMP CX,320
    JNZ LOOPLOL  
    
    MOV CX,0
    INC DX
    CMP DX, 200
    JNZ LOOPROFL
    
    
    RET 
CLEAR_TEXT ENDP 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRCOEDURE used to move cursor to position saved in CursorPositionX,CursorPositionY
MoveCursor PROC
    pusha
    
    mov ah,2
    mov bh,0
    mov dl,CursorPositionX
    mov dh,CursorPositionY
    int 10h
    
    popa
    ret
MoveCursor endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRCOEDURE used to draw Top Bar of Game
MainBar PROC
    ;Draw two Horizontal lines and GameName between them
    mov Y1,5 ;startingPoint y=5,x=130 with horizontal length=60
    mov X1,130
    mov L1,60
    mov DrawingColor,8
    
    call DrawHLine
    ;shift line 15 pixels down
    mov Y1,20
    call DrawHLine  
    
    mov CursorPositionX,17
    mov CursorPositionY,01
    Call MoveCursor
    ;Print Game Name at new Cursor position
    mov ah, 9
    mov dx, offset GameName
    int 21h
                       
    mov CursorPositionX,17
    mov CursorPositionY,03
    Call MoveCursor
    ;Change in string based on current level number
    mov al,LevelNumber 
    add al,30h
    mov Level+6,al
    ;Print Level at new Cursor position
    mov ah, 9
    mov dx, offset Level
    int 21h
    ;Set fillcolor,borderColor of health rectangle
    mov FillColor,4
    mov BorderColor,15
    
    mov Y1,8
    mov X1,10
    mov ch,0
    mov cl,PlayersHealth
    mov L1,cx
    add L1,2
    mov W,8
    ;Draw Rectangle with horizontal lenght equals intial player health
    call DrawRectangle
    
    mov X1,225
    ;Draw same rectangle for player 2
    call DrawRectangle
    ;Print Health Numbers   
    call PrintHealth
    ;;;;Print Players names;;;;
    ;;;;;;;;;;Player1;;;;;;;;;;
    ;Place '$' at the end of the Name
    cmp mynum,0
    jne play2
    mov ch,0
    mov bx,offset P1Name
    mov cl,P1Name[1]
    add cl,2
    add bx,cx 
    mov [bx],'$'
    ;Place '$' at the end of display limit 
    mov cx,14
    mov bx,offset P1Name
    add bx,cx
    mov [bx],'$'
    
    mov CursorPositionX,2
    mov CursorPositionY,3
    
    Call MoveCursor
    ;Print Player1 Name in new cursor position
    mov ah, 9
    mov dx, offset P1Name[2]
    int 21h   
    ;;;;;;;;;;Player2;;;;;;;;;;              
    ;Place '$' at the end of display limit
    mov cx,14
    mov bx,offset P2Name
    add bx,cx
    mov [bx],'$'
    ;Place '$' at the end of the Name
    mov ch,0
    mov bx,offset P2Name
    mov cl,P2Name[1]
    add cl,2 
    add bx,cx
    mov [bx],'$'
    
    mov CursorPositionY,3
    mov CursorPositionX,40
    
    cmp cl,12
    JB LONGNAME
    sub CursorPositionX,14 ;if the playername > limit --> move cursor to the right position
    JMP PRINTPLAYER2NAME
    LONGNAME:
    sub CursorPositionX,cl
    PRINTPLAYER2NAME: 
    Call MoveCursor
    
    ;Print Player2 Name in new cursor position
    mov ah, 9
    mov dx, offset P2Name[2]
    int 21h 
    jmp fini 
    play2:
    mov ch,0
    mov bx,offset P2Name
    mov cl,P2Name[1]
    add cl,2
    add bx,cx 
    mov [bx],'$'
    ;Place '$' at the end of display limit 
    mov cx,14
    mov bx,offset P2Name
    add bx,cx
    mov [bx],'$'
    
    mov CursorPositionX,2
    mov CursorPositionY,3
    
    Call MoveCursor
    ;Print Player1 Name in new cursor position
    mov ah, 9
    mov dx, offset P2Name[2]
    int 21h   
    ;;;;;;;;;;Player2;;;;;;;;;;              
    ;Place '$' at the end of display limit
    mov cx,14
    mov bx,offset P1Name
    add bx,cx
    mov [bx],'$'
    ;Place '$' at the end of the Name
    mov ch,0
    mov bx,offset P1Name
    mov cl,P1Name[1]
    add cl,2 
    add bx,cx
    mov [bx],'$'
    
    mov CursorPositionY,3
    mov CursorPositionX,40
    
    cmp cl,12
    JB LONGNAME1
    sub CursorPositionX,14 ;if the playername > limit --> move cursor to the right position
    JMP PRINTPLAYER1NAME
    LONGNAME1:
    sub CursorPositionX,cl
    PRINTPLAYER1NAME: 
    Call MoveCursor
    
    ;Print Player2 Name in new cursor position
    mov ah, 9
    mov dx, offset P1Name[2]
    int 21h 
    fini:   
    ret
MainBar endp 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRCOEDURE called every time the turn is over to change the current player to the other one
ChangePlayers proc
        
    mov CursorPositionX,1
    mov CursorPositionY,3
    
    Call MoveCursor
    ;Prepare interrupt to print char
    mov ah, 0eh           ;0eh = 14
    xor bx, bx            ;Page number zero
    mov bl, 10           ;Color is red
    
    cmp CurrentPlayer,0
    Jne CHENGETOPLAYERONE
    ;Change from player1 to player2
    ;print space before player1 name
    mov al,' '
    int 10h
    
    mov CursorPositionY,3
    mov CursorPositionX,38
    Call MoveCursor
    ;print arrow after player2 name
    mov al,17
    int 10h   
    
    ;Clear Speed bar for Player 1
    mov CurrentPlayer,0
    ;Set both fill,border colors to background colors
    mov cl,BackgroundColor
    mov FillColor,cl
    mov BorderColor,cl
    call speedbar
    ;finally set currentplayer to player2
    mov CurrentPlayer,2
    
    JMP CONTINUECHANGING
    CHENGETOPLAYERONE:
    ;Change from player2 to player1
    ;print arrow before player1 name
    mov al,16
    int 10h
    
    mov CursorPositionY,3
    mov CursorPositionX,38
    Call MoveCursor
    ;print space after player2 name
    mov al,' '
    int 10h
    
    ;Clear Speed bar for Player 2
    mov CurrentPlayer,2
    ;Set both fill,border colors to background colors
    mov cl,BackgroundColor
    mov FillColor,cl
    mov BorderColor,cl
    call speedbar
    ;finally set currentplayer to player1
    mov CurrentPlayer,0
    
    CONTINUECHANGING: 
    ;draw speed bar for the new current player
    mov FillColor,0
    mov BorderColor,1
    call speedbar
    
    ret
    
ChangePlayers endp 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROCEDURE called to Draw Speed bar for the current Player
SpeedBar PROC 
    ;Set L,W,X,Y for rectangle that represents Speedbar
    mov L1,10
    mov W,21
    mov Y1,43
    ;Check to know where to draw speed bar (right for player2 or left for player1)   
    cmp CurrentPlayer,0
    Jne RightSpeedBar
    mov X1,10
    jmp DrawSpeedBar
    RightSpeedBar:
    mov X1,300
    ;Draw Rectangle with parameter set
    DrawSpeedBar: 
    call DrawRectangle
    ;Set Parameters to Draw First Speed (as first speed player can shoot wih is 40)
    mov L1,6
    mov W,4
    mov Y1,58
    
    cmp fillColor,0 ;if clearing speed bar
    JNE NOTREMOVING 
    mov cl,0fh
    jmp DRAWSPEEDBARORREMOVE 
    NOTREMOVING:
    mov cl,fillColor
    DRAWSPEEDBARORREMOVE:
    mov FillColor,cl
    mov BorderColor,cl
    ;Check to know where to draw (right for player2 or left for player1)   
    cmp CurrentPlayer,0
    Jne RightBarSpeed
    mov X1,12
    jmp StopFirstTime 
    RightBarSpeed:
    mov X1,302
    ;Draw rectangle that represent first speed
    StopFirstTime: 
    call DrawRectangle
    ;intially set CurrentSpeed for CurrentPlayer to 40
    mov CurrentSpeed,40
       
    ret
SpeedBar Endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROCEDURE called after user request to increse shooting speed     
IncrementSpeed proc
    
    cmp CurrentSpeed,60
    ;if CurrentPlayer Speed = 60 --> cannot increment
    JE  DoneIncrementing
    ;Speed = 50 or speed = 40
    ;Subtract 10 from CurrentSpeed as player can shoot with speed 40,50,60
    add CurrentSpeed,10
    cmp CurrentSpeed,50
    JNE ThirdSpeed
    ;if speed = 50 after addition 
    mov Y1,52
    jmp Incrementing
    ThirdSpeed:
    ;if speed = 50 after addition  
    mov Y1,46
    
    ;Start Drawing Rectangle in speed bar
    ;will be the first(y=46) if speed = 50 --> 60
    ;will be the second(y=52) if speed = 40 --> 50
    Incrementing:             
    mov L1,6  ;horizontal lenght of black rectangle
    mov W,4   ;vertical lenght of black rectangle
    mov cl,0fh
    mov FillColor,cl
    mov BorderColor,cl
       
    cmp CurrentPlayer,0
    Jne RightBarIncrement
    ;if player1 is the current player
    ;the speed bar will be at the left of screen
    mov X1,12
    jmp StopIncrement 
    RightBarIncrement:
    ;if player2 is the current player
    ;the speed bar will be at the right of screen
    mov X1,302
    
    ;Stop Increment Computations and draw rectangle
    ;from start point x1,y1 and with horizontal length l1,vertical W
    StopIncrement: 
    call DrawRectangle

    DoneIncrementing:
    
    ret
IncrementSpeed endp 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROCEDURE called after user request to decrease shooting speed
DecrementSpeed proc
    
    cmp CurrentSpeed,40 
    ;if CurrentPlayer Speed = 40 --> cannot decrment
    JE DoneDecrementingSpeed
    ;Speed = 60 or speed = 50 
    ;Subtract 10 from CurrentSpeed as player can shoot with speed 40,50,60
    sub CurrentSpeed,10 
    cmp CurrentSpeed,50
    Je ThirdSpeedClear
    ;if speed = 40 after subtraction 
    mov Y1,52
    jmp Decrementing
    ThirdSpeedClear:
    ;if speed = 50 after subtraction  
    mov Y1,46
    
    ;Start Drawing Black Rectangle 
    ;will be the first(y=46) if speed = 60 --> 50
    ;will be the second(y=52) if speed = 50 --> 40
    Decrementing:
    ;horizontal lenght of black rectangle             
    mov L1,6
    ;vertical lenght of black rectangle
    mov W,4 
    ;rectangle's colors
    mov FillColor,0
    mov BorderColor,0
    
    ;now set x of starting point    
    cmp CurrentPlayer,0
    Jne RightBarDecrement
    ;if player1 is the current player
    ;the speed bar will be at the left of screen
    mov X1,12
    jmp StopDecrement 
    RightBarDecrement:
    ;if player2 is the current player
    ;the speed bar will be at the right of screen
    mov X1,302
    
    ;Stop Decrement Computations and draw Black rectangle
    ;from start point x1,y1 and with horizontal length l1,vertical W
    StopDecrement: 
    call DrawRectangle
    
    DoneDecrementingSpeed:
    
    ret            
DecrementSpeed endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROCEDURE called to decrease health of the dameged player     
DecreaseHealth proc
    ;Set both border and fill colors to black
    ; as the health bar will look empty after painting damage area with black
    mov FillColor,0
    mov BorderColor,0
    
    ;Draw the black damaged area for player1
    mov cx,80 
    sub cl,PlayersHealth  
    mov L1,cx
    ;Starting from first point in health bar and go to last point of remaning health 
    ;and then start to draw the rest of health with black           
    mov Y1,9
    mov X1,11
    mov ch,0
    mov cl,PlayersHealth
    add X1,cx ;X1=X1+Health
    mov W,6
    call DrawRectangle  
    
    ;Draw the black damaged area for player2
    mov cx,80 
    sub cl,PlayersHealth+1 
  
    mov L1,cx
               
    mov Y1,9
    mov X1,306
    mov ch,0
    mov cl,PlayersHealth+1
    sub X1,cx 
    mov cx,L1
    sub X1,cx 
    mov W,6
    
    call DrawRectangle
    Done: 
    call PrintHealth ;Print new Health in Numbers next to HealthBar
    
    ret
DecreaseHealth endp 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Print Health Number next to health bars of players 
PrintHealth PROC
    
    ;cursor position next to health bar of first player
    mov CursorPositionX,12
    mov CursorPositionY,1
    call MoveCursor ;Move Cursor to specified position

    ;Print Player1 Health
    mov al,PLayersHealth
    mov dl,10
    mov ah,0
    DIV dl    ;devide health by 10
    mov dl,ah ;save reminder in dl
    
    ;Print Quoutient
    mov ah, 0eh           ;0eh = 14 
    add al,30h            ;Compute asci
    xor bx, bx            ;Page number zero
    mov bl, 0ch           ;Color is red
    int 10h 
    ;Print reminder
    mov ah, 0eh           ;0eh = 14
    mov al,dl
    add al,30h
    xor bx, bx            ;Page number zero
    mov bl, 0ch           ;Color is red
    int 10h 
    ;Print Heart after health Number
    mov ah, 0eh           ;0eh = 14
    mov al,3
    xor bx, bx            ;Page number zero
    mov bl, 0ch           ;Color is red
    int 10h 
    
    ;cursor position next to health bar of second player
    mov CursorPositionX,25
    mov CursorPositionY,1
    call MoveCursor  ;Move Cursor to specified position
    
    ;Print Heart first before the health number
    mov ah, 0eh           ;0eh = 14
    mov al,3
    xor bx, bx            ;Page number zero
    mov bl, 0ch           ;Color is red
    int 10h
    
    mov al,PLayersHealth+1
    mov dl,10
    mov ah,0
    DIV dl   ;devide player2 by 10
    mov dl,ah;save reminder in dl
    
    ;Print Player2 Health
    ;Print Quotient
    mov ah, 0eh           ;0eh = 14 
    add al,30h            
    xor bx, bx            ;Page number zero
    mov bl, 0ch           ;Color is red
    int 10h 
    
    ;Print reminder
    mov ah, 0eh           ;0eh = 14
    mov al,dl
    add al,30h
    xor bx, bx            ;Page number zero
    mov bl, 0ch           ;Color is red
    int 10h
    
 
    ret
PrintHealth Endp  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Draw Rectangle filled or not-filled with upper-left point x1,y1 
;Horizontal length = L1 , Vertical lenght = W
DrawRectangle PROC
   pusha
   cmp L1,0
   JE ENDDRAW
   cmp W,0 
   JE ENDDRAW 
   ;Prepare to Draw Rectangle with FillColor
   mov cl,FillColor
   mov DrawingColor,cl 
   MOV Bx,W  ;Vertical lenght of rectangle
   ADD Bx,Y1 ;compute y1 (lower y) of rectangle
   push Y1
   
   DRAW: ;Draw horizontal lines from first point x1,y1 to the lower y   
       call  DRAWHLINE 
       INC Y1
       CMP Y1,Bx
       JNZ DRAW 
       call  DRAWHLINE
        
   pop Y1
       
   mov cl,BorderColor
   cmp FillColor,cl
   JE ENDDRAW
   ;if BorderColor not equal fillColor
   mov DrawingColor,cl
   ;Draw Horizontal and vertical line from x1,y1 with border color
   call DrawHLine
   call DrawVLine
   ;Draw two lines parallel to them to border rectangle
   mov cx,W
   add Y1,cx
   call DrawHLine
   sub Y1,cx
   
   mov cx,L1
   add X1,cx
   call DrawVLine
   sub X1,cx
   
   
   ENDDRAW:
    popa     
    ret
DrawRectangle Endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRCOEDURE used to draw horizontal lines of lenght l1 starting from x1 and at y1
DrawHLine PROC
     pusha  
     push L1 
            ; CHECK IF LINE GO LEFT OR RIGHT
            MOV Cx,X1 
			ADD Cx,L1
			mov L1,Cx
                       
            ;SETTING THE STARTING POINT      
            MOV Cx,X1
            MOV Dx,Y1
            MOV AL,DrawingColor
            MOV AH,0CH 
            
            ;DRAW LINE
 BACK:      INT 10H
            INC Cx
            CMP Cx,L1
            JNZ BACK
            INT 10H
	
	  pop L1
      popa
    ret
DrawHLine Endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;PROCEDURE used to draw vertical lines of lenght w starting from y1 and at x1
DrawVLine PROC
          pusha
          ; CHECK IF LINE GO LEFT OR RIGHT
            MOV Cx,Y1
			ADD Cx,W
			mov W,Cx
           
            ;SETTING THE STARTING POINT      
            MOV CX,X1
            MOV DX,Y1
            MOV AL,DrawingColor
            MOV AH,0CH 
            
            ;DRAW LINE
 BACK1:     INT 10H
            INC DX
            CMP DX,W
            JNZ BACK1
            
            int 10h
            
            MOV Cx,W
			sub Cx,Y1
			mov W,Cx 
			popa
    ret
DrawVLine Endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROCEDURE used to draw lower part of circle 
Drawlcircle PROC
    
    inc x1
    mov ax,r
    mov bx,2
    mul bx
    mov l1,ax
    sub l1,2 
    call drawhline
    inc y1
     
    dec r
dcircle:  
    mov ax,r
    mov bx,2
    mul bx
    mov l1,ax 
    call drawhline
    inc y1
    inc x1
    sub r,1
    cmp r,0
    jg dcircle 
    
        ret
Drawlcircle Endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROCEDURE used to draw upper part of circle
Drawucircle PROC 
    
    
    dec y1
    inc x1
ucircle:
    sub r,1  
    mov ax,r
    mov bx,2
    mul bx
    mov l1,ax  
    call drawhline
    dec y1
    inc x1
    cmp r,1
    jg ucircle
    
        ret
Drawucircle Endp 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROCEDURE used to draw wheals of tank     
Drawwheals PROC
   
    mov al,color
    mov drawingcolor,al
    
    push x1
    push y1
    push r 

    call drawlcircle 
    MOV L1,30
    call drawhline
    pop r
    pop y1
    pop x1
    
    push x1
    push y1
    push r
   
    call drawucircle
    MOV L1,30
    call drawhline

    pop r
    pop y1
    pop x1 
    
    add x1,15
    push x1
    push y1
    push r
    

    call drawlcircle
    pop r
    pop y1
    pop x1
    
    push x1
    push y1
    push r
    call drawucircle 
    pop r
    pop y1
    pop x1
    
      
    add x1,15
    push x1
    push y1
    push r
    
    call drawlcircle
    pop r
    pop y1
    pop x1
    
    call drawucircle
    

      ret
Drawwheals Endp 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;PROCEDURE used to draw tank
Drawtank PROC
    pusha
     
    PUSH L1
    mov al ,drawingcolor
    push ax
    MOV AL,COLOR1
    MOV drawingCOLOR,Al
    mov fillColor,al 
    mov bordercolor,al 
    mov ax,r
    mov bx,2
    mul bx
    mov W,ax
    PUSH Y1
    PUSH X1
    MOV AX,Y1
    SUB AX,r
    MOV Y1,AX
    MOV AX,X1
    ADD AX,R
    MOV X1,AX
    ;Draw lower part of the tank
    call DRAWRECTANGLE 
    ;Draw upper part of the tank
    DRAW_QUAD 30,X1,Y1,10,DRAWINGCOLOR
    ;calculate first point of gun and draw it for the current tank 
    CMP CurrentPlayer,0
    JNE PLAYER22 
    mov cx,x1
    mov x3,cx 
    mov cx,l1
    add x3,cx
    mov cx,y1
    mov y3,cx
    inc y3
    DRAWGUN 0
    JMP COMPL
    PLAYER22:
    mov cx,x1
    mov x3+2,cx 
    mov cx,y1
    mov y3+2,cx
    inc y3+2
    DRAWGUN 2
    
    COMPL:
    
    POP X1
    POP Y1
    
    push x1
    push y1
    push r
    call drawwheals ;Draw Tank's weehls
    
    POP R 
    POP Y1
    POP x1   
  
    pop bx
    mov bordercolor,bl  
    mov fillcolor,bl
    mov drawingcolor,al
    POP L1 
    popa
      
    ret                  
drawtank Endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;PROCEDURE used to move tank
movetank PROC
    
    mov bx,  currentplayer
    ; CHECK USER INPUT RIGHT ARROW OR LEFT ONE
    cmp ah,left
    je decrement
    
    cmp ah,right
    je increment
     
jmp nothing   
increment:
    
    ;CHECK BOUNDARY OF 2ND  TANK DUE TO MOUNTAIIN
    cmp x0[bx],280 
    je nothing
    MOV AX,MountainCenterX
    SUB AX,36 
     
    ;CHECK BOUNDARY OF 1ST  TANK DUE TO MOUNTAIIN
    cmp x0[bx],ax
    je nothing
    ; SET LAST POSITON OF TANK TO CLEAR IT 
    mov ax,x0[bx]
    mov x1,ax
    mov ax,y0[bx]
    mov y1,ax  
    push bx
    call cleartank   

    pop bx
    add x0[bx],1  

    jmp d1
decrement:
     ;CHECK BOUNDARY OF 2ND  TANK DUE TO MOUNTAIIN
    cmp x0[bx],0
    je nothing
    mov ax,MountainCenterX
    ADD AX,MountainLenght
    SUB AX,4
    ;CHECK BOUNDARY OF 1ST  TANK DUE TO MOUNTAIIN
    cmp x0[bx],ax
    je nothing
    ; SET LAST POSITON OF TANK TO CLEAR IT     
    mov ax,x0[bx]
    mov x1,ax
    mov ax,y0[bx]
    mov y1,ax
    push bx
    call cleartank
    
    pop bx
    sub x0[bx],1 
    ; set variables to start drawing     
    d1:
        mov ax,x0[bx]
        mov x1,ax
        mov ax,y0[bx]
        mov y1,ax
        call drawtank
    nothing:

 ret 
movetank endp 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PROCEDURE used to CLEAR TANKS
cleartank PROC
        
    mov l1,30
    push l1 
    ;change  drawing color od tank to backgroung color
    MOV AL,COLOR1  ; save the primary tank color
    push ax   
    mov bl,backgroundcolor
    mov color1,bl 
    ; change wheals drawing color to background 
    mov al,color  ; save the primary wheals color
    push ax
    mov color,bl
    call drawtank 
    pop bx
    mov color,bl  ; return to primary color
    pop ax 
    mov color1,al  ;return to primary color

    pop l1
 
     ret 
cleartank endp    

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                            
DRAWPROJ PROC

    ;X=VTCOS0 Y=VTSIN0-HALFGT^2 
    
    MOV CX,01 ;T  
    PROJ: 
    PUSH BX ;val of x
    MOV BP,DX   ;val of y
    ;CALC X
    MOV AX,CX ;AX=T
    MUL [SI]  ;AX=VCOS(THETA)*T
    SHR AX,1  ;AX=/2 (AS IF I WALK ONE T EVERY 2 LOOPS, FOR HIGHER ACCURACY)
    ADD AX,BX ;BX=X+VTCOS(THETA)/2
    PUSH AX   ; curr val of x to be popped  to cx
    ;CALC Y
    MOV AX,CX ;AX=T
    MUL [DI]  ;AX=VSIN(THETA)*T
    SHR AX,1  ;AX=/2 (AS IF I WALK ONE T EVERY 2 LOOPS, FOR HIGHER ACCURACY)
    MOV BX,AX  
    MOV AX,CX ;AX=T
    MUL CX    ;AX=T^2
    SHR AX,2  ;AX=(T/2)^2
    MUL HalfG ;AX=HALFG*(T/2)^2      
    MOV DX,BP ;DX=Y
    SUB BX,AX ;BX=VSIN(THETA)*T- HALFG*(T/2)^2
    ADD DX,BX ;DX=Y+BX
    
    ;REFLECT ON X AXIS
    MOV AX,0          
    SUB AX,DX ;AX=-Y       
    ADD AX,200       
    MOV DX,AX        
    
    MOV BX,CX ;SAVE CURRENT VAL OF T 
    POP CX    ;VALUE OF X
    
    ;CHECK IF PLAYER 2 TO REVERSE DIRECTION OF PROJECTION (REFLECT ON X=PROJECTION STARTING POSITION)
    CMP CurrentPlayer, 2 
    JNE COMP
    SUB CX, GX1+2
    MOV AX,0
    SUB AX,CX
    MOV CX, AX 
    ADD CX, GX1+2 
                
 
    COMP:
    ;CHECK THAT PROJECTILE IS <XMAX AND >XMIN
    CMP CX,320  
    JNLE ENDPROJ
    CMP CX,0  
    JNGE ENDPROJ 
    ;
    ;IF PROJECTILE < YMIN (OUTSIDE SCREEN FROM TOP), WAIT FOR IT TO COMEDOWN AND WILL SKIP DRAWING.
    CMP DX,SCREENUPPER
    JGE MOVON20
    PUSH BX
    PUSH AX 
    CALL PAUSE  
    POP AX
    POP BX
    JMP SKIPDRAW 
    
    MOVON20: 
    ;IF PROJECTILE >YMAX (OUTSIDE SCREEN FROM BOTTOM) BRING IT UP TO BOTTOM AND CREATE COLISION EFFECT
    CMP DX,SCREENLOWER
    JL MOVON
    MOV DX,SCREENLOWER 
    ;GET BACKGROUND COLOR  
    MOV AH, 0DH
    INT 10H  
    JMP COLLISION 

    MOVON: 
    ;GET BACKGROUND COLOR
    MOV AH, 0DH
    INT 10H 
                                         
    ;DETECTING COLLISION  BY COMPARING PIXEL COLOR TO COLOR OF OBJECTS TO COLLIDE WITH
    CMP AL,COLOR ;TANK COLOR 
    JE COLLISION  
    CMP AL,COLOR1 ;WHEEL COLOR
    JE COLLISION 
    CMP AL,MountainColor ;THEEEEEEE OBSTAACCCLLLEEE
    JE COLLISION 
    CMP  al,0fh
    je collision
    JMP MOVON1
    
    COLLISION:
    CALL IMPACT ;IMPACT EFFECT (RED FLASHING)
    PUSH CX
    PUSH DX
    CALCDAMAGE 2 ;CALCULATE POSSIBLE DAMAGE ON PLAYER 2
    POP DX
    POP CX  
    PUSH CX
    PUSH DX
    CALCDAMAGE 0 ;CALCULATE POSSIBLE DAMAGE ON PLAYER 1 SINCE PLAYER CAN HURT HIMSELF
    POP DX
    POP CX
    
    JMP ENDPROJ  ;STOP PTOJECTION 
    
    
    MOVON1:    
    PUSH BX  ; push index (VAL OF T)                    
    PUSH AX  ; PUSH BACKGROUND COLOR
    
    ;Mai: Draw Projectile
    
    dec Dx 
    mov Bx,offset SavedPixels
    
    Push si
    push di
    
    mov si,2
    DrawBigProjectile:  
    MOV AH, 0DH
    INT 10H
    
    mov [Bx],Al
    inc bx
    
    ;DRAW PROJECTILE IN ITS COLOR
    MOV AH, 0CH 
    MOV AL, 130
    INT 10H  
    
    add dx,2
    dec si
    JNZ  DrawBigProjectile 
    
    
    sub dx,3
    dec cx
     
    mov di,3
                        
    DrawBigProjectileHorizontal:  
    
    MOV AH, 0DH
    INT 10H
    mov [Bx],Al
    inc bx
    
    ;DRAW PROJECTILE IN ITS COLOR
    MOV AH, 0CH 
    MOV AL, 130
    INT 10H
    
    inc cx
    
    dec di
    JNZ  DrawBigProjectileHorizontal

    pop si
    pop di 
    sub cx,2
    
    
    ;ACTIVATE PAUSE FOR DOSBOX
    CALL PAUSE  
    
    POP AX   ; POP BACKGROUND COLOR
    
    ;Mai: Remove Projectile
    
    dec Dx 
    mov Bx,offset SavedPixels
    
    Push si
    push di
    
    mov si,2
    RemoveBigProjectile:
      
    mov Al,[Bx]
    inc bx
    
    ;DRAW PROJECTILE IN ITS COLOR
    MOV AH, 0CH 
    ;MOV AL, 130
    INT 10H  
    
    add dx,2
    dec si
    JNZ  RemoveBigProjectile
    sub dx,3
    dec cx
     
    mov di,3
                        
    RemoveBigProjectileHorizontal:  
    
    mov Al,[Bx]
    inc bx
    
    ;DRAW PROJECTILE IN ITS COLOR
    MOV AH, 0CH 
    ;MOV AL, 130
    INT 10H
    
    inc cx
    
    dec di
    JNZ  RemoveBigProjectileHorizontal

    pop si
    pop di
    dec cx
 

    pop bx  ; pop index

    SKIPDRAW:
    MOV CX,BX ; mov index to cx
    MOV DX,BP ; KEEP INITIAL VAL OF Y
    INC CX    ;INC T   
    POP BX ; KEEP INITIAL VAL OF X
    JMP PROJ
    ENDPROJ:
    POP BX ;POP PUSHED X
    
    
    
    RET
DRAWPROJ ENDP 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
IMPACT PROC   ;CX=X, DX=Y AND AL= BACKGROUND COLOR
         
        ;FLASH 4 TIMEZ 
        MOV BX,4
        LOOP1:   
        PUSH AX ;PUSH BACKGROUND COLOR 
        MOV AH, 0CH 
        MOV AL, 04H  ;RED FLASHING
        INT 10H
        
        PUSH BX ;PUSH INDEX
          
        CALL PAUSE
        
        POP BX ;POP INDEX    
        POP AX ;POP BACKGROUND
        
        ;REMOVE PIXEL       
        MOV AH, 0CH  
        INT 10H  
        
        PUSH BX
        PUSH AX 
        CALL PAUSE  
        POP AX
        POP BX
        
        DEC BX
        JNZ LOOP1  
    
    RET 
IMPACT ENDP  
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
PAUSE PROC
        mov bx, 100d 
        mov ax, 200d
        loop2P:
        myloop1P:
        dec bx
        jnz myloop1P
        mov bx, 1000d 
        dec ax 
        jnz loop2P 
    
    RET
    PAUSE ENDP 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
;PROCEDURE used to display sound if tanks is hitted  
DISPLAY_SOUND PROC
 
     PUSHA  
     mov al,182
     out 43h,al
     mov ax,4560
 
     out 42h,al
     mov al,ah
     out 42h,al
     in al,61h 
 
     or al,00000011b
     out 61h,al
     mov bx,5
 
 .pause1:
        mov cx,65535
        
 .pause2:
        dec cx
        jne .pause2
        dec bx
        jne .pause1   
        in al,61h
        
        and al,11111100b
        out 61h,al
        
POPA   
    RET 
DISPLAY_SOUND ENDP     



DRAW_CLOUDS PROC 
  
  PUSHA
  push r  
  MOV AX, CLX1
  MOV X1,AX
  MOV AX, CLY
  Mov Y1,AX
  PUSH X1
  PUSH Y1
  mov r,15  
  PUSH R
 ; MOV L1,30
  CALL Drawlcircle
  POP R 
  
  POP Y1
  POP X1 
  PUSH X1
  CALL Drawucircle     
  POP X1
  
  
  ADD X1,13
  Mov Y1,70 
  PUSH X1
  PUSH Y1 
  mov r,15  
  PUSH R
 ; MOV L1,30
  CALL Drawlcircle
  POP R 
  
  POP Y1
  POP X1
  
  PUSH X1
  PUSH Y1
  push r
  CALL Drawucircle  
  pop r
  pop y1
  pop x1
  
  
  ADD X1,13
  Mov Y1,70 
  PUSH X1
  PUSH Y1 
  mov r,15  
  PUSH R
 ; MOV L1,30
  CALL Drawlcircle
  POP R 
  
  POP Y1
  POP X1
  
  CALL Drawucircle
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  MOV AX, CLX2
  MOV X1,AX
  MOV AX, CLY
  Mov Y1,AX
  PUSH X1
  PUSH Y1
  mov r,15  
  PUSH R
 ; MOV L1,30
  CALL Drawlcircle
  POP R 
  
  POP Y1
  POP X1 
  PUSH X1
  CALL Drawucircle     
  POP X1
  
  
  ADD X1,13
  Mov Y1,70 
  PUSH X1
  PUSH Y1 
  mov r,15  
  PUSH R
 ; MOV L1,30
  CALL Drawlcircle
  POP R 
  
  POP Y1
  POP X1
  
  PUSH X1
  PUSH Y1
  push r
  CALL Drawucircle  
  pop r
  pop y1
  pop x1
  
  
  ADD X1,13
  Mov Y1,70 
  PUSH X1
  PUSH Y1 
  mov r,15  
  PUSH R
 ; MOV L1,30
  CALL Drawlcircle
  POP R 
  
  POP Y1
  POP X1
  
  CALL Drawucircle
  
  
  
  pop r 
  POPA  
    RET 
DRAW_CLOUDS ENDP  


MOV_CLOUDS PROC 
    PUSHA 
    
    DEC MOVEDELAY   
    MOV CX,0
    CMP MOVEDELAY,CX
    JNE DRAAWCLOUDD
    MOV CX,MOVEDELAYTIME
    MOV MOVEDELAY,CX
    
    MOV CL,BACKGROUNDCOLOR
    MOV DRAWINGCOLOR, CL  
    CALL DRAW_CLOUDS    
    
    MOV AX,CLX1
    CMP AX,250
    JNE CHECKMOSTLEFT 
    ;CLX1=250           
    MOV CX,1
    MOV MOVEDIRECTION1,CX 
    MOV MOVEDIRECTION2,CX
    JMP STARTDRAWCLOUDD
    CHECKMOSTLEFT:
    ;CLX1 != 300
    CMP AX,20
    JNE STARTDRAWCLOUDD
    ;AX=20    
    MOV CX,0
    MOV MOVEDIRECTION1,CX
    MOV MOVEDIRECTION2,CX
    STARTDRAWCLOUDD:
    CMP MOVEDIRECTION1,0
    JNE MOVECLOUDLEFT
    ;DIRECTION = 0 (RIGHT)
    INC CLX1 
    DEC CLX2
    JMP DRAAWCLOUDD
    MOVECLOUDLEFT:
    ;DIRECTION = 1 (LEFT)
    DEC CLX1  
    INC CLX2
    
    
    DRAAWCLOUDD:
    MOV DRAWINGCOLOR,0FH
    CALL DRAW_CLOUDS
    
    POPA
    RET
    MOV_CLOUDS ENDP
    
SELECTLEVEL PROC
    ;Fill Background with Background Color
    MOV AH, 06h    ; Scroll up function
    XOR AL, AL     ; Clear entire screen
    MOV CX, 500h  ; Upper left corner CH=row, CL=column 
    MOV DX, 124FH  ; lower right corner DH=row, DL=column 
    MOV BH, 0
    INT 10H     
    
    mov CursorPositionX,17
    mov CursorPositionY,13
    Call MoveCursor
    ;Change in string based on current level number
    mov al,1 
    add al,30h
    mov Level+6,al
    ;Print Level at new Cursor position
    mov ah, 9
    mov dx, offset Level
    int 21h 
    
    
    mov CursorPositionX,17
    mov CursorPositionY,15
    Call MoveCursor
    ;Change in string based on current level number
    mov al,2 
    add al,30h
    mov Level+6,al
    ;Print Level at new Cursor position
    mov ah, 9
    mov dx, offset Level
    int 21h  
 
    
    MOV CL,1      
    MOV LEVELNUMBER,CL
    CALL CHANGEARROWPOSITION
    
    WAITFORSELECTLEVEL: 
        ; this is used as if player  press by wrong button (during projectile movement)
    ;EMPTY THE BUFFER 
    MOV AL,0 
    mov ah,0Ch              
    int 21h 
    
    MOV AH, 00 
    INT 16H  
    
    MOV BL,0
    CMP MYNUM,BL
    JNE WAITFORSELECTLEVEL
    CMP AL,13
    JE ENDSELECTINGLEVEL   
    CMP AH,UP
    JNE WAITFORSELECTLEVEL
    ;PLAYER1 PRESSED UP KEY 
    MOV DL,1
    CMP LEVELNUMBER,DL
    JNE SWITCHUPTOLEVEL2 
    MOV DL,2
    MOV LEVELNUMBER,DL
    JMP CHANGEARROWPOSITION
    SWITCHUPTOLEVEL2:
    MOV DL,1
    MOV LEVELNUMBER,DL
    JMP CHANGEARROWPOSITION  
    
    CHANGEARROWPOSITION:  
    MOV DL,1
    CMP LEVELNUMBER,DL
    JNE LEVELTWOISNOWSELECTED
    
    mov CursorPositionX,15
    mov CursorPositionY,13
    Call MoveCursor  
    
        ;Print Heart after health Number
        mov ah, 0eh           ;0eh = 14
        mov al,16
        xor bx, bx            ;Page number zero
        mov bl, 0ch           ;Color is red
        int 10h  
        
    mov CursorPositionX,15
    mov CursorPositionY,15
    Call MoveCursor    
        
            
        mov ah, 0eh           ;0eh = 14
        mov al,16
        xor bx, bx            ;Page number zero
        mov bl, 0           ;Color is red
        int 10h  
        
     JMP WAITFORSELECTLEVEL   
   LEVELTWOISNOWSELECTED:
     
    mov CursorPositionX,15
    mov CursorPositionY,13
    Call MoveCursor  
    
       ;Print Heart after health Number
        mov ah, 0eh           ;0eh = 14
        mov al,16
        xor bx, bx            ;Page number zero
        mov bl, 0           ;Color is red
        int 10h  
        
    mov CursorPositionX,15
    mov CursorPositionY,15
    Call MoveCursor    
        
            
        mov ah, 0eh           ;0eh = 14
        mov al,16
        xor bx, bx            ;Page number zero
        mov bl, 0CH           ;Color is red
        int 10h  
     
     JMP WAITFORSELECTLEVEL
        
      
    ENDSELECTINGLEVEL:
      
RET
SELECTLEVEL ENDP    
    

                 
                 
MANAGER PROC                
     START_AGAIN1:
       mov CursorPositionX,1
    mov CursorPositionY,23
    
    Call MoveCursor
     
    MOV AH, 01 ; ZF =0 if key pressed, else ZF=1
    INT 16H  
    JZ PRINTNULL1
    
    MOV AH, 00 ; AL: ASCII Code, AH: Scancode
    INT 16H 
    
    JMP R1
    PRINTNULL1:
    MOV AX,0
    R1:
    PUSH AX 
    
             
        mov dx , 3FDH
        MOV CX,1		; Line Status Register
 AGAIN1:  
         INC CX
  CMP CX,50000 
  JE NOCON1
        In al , dx 			;Read Line Status
        AND al , 00100000b   
        
        JZ AGAIN1
        
         
        mov dx , 3F8H		; Transmit data register
        POP AX 
        MOV AL,AH
  		out dx , aL   
  		
  		CMP ah, cf2
  		jne con1 
  		CMP MYNUM,2
  		JE STARTG
  		MOV MYNUM,0 
  		MOV OTHNUM, 2 
  		
  
  		 
      delete_screen 23,25  
        MOV AH,9
        MOV DX,OFFSET INV
        INT 21H
  		
  	    MOV AH,9	
	    MOV DX,OFFSET P2NAME[2]
        INT 21H 
  		
        con1: 
        CMP ah, cf1
  		jne con2 
  		CMP PF1,1
  		JE STARTC
  		MOV PF1,2
  		
  
        MOV AH,9H
        MOV DX,OFFSET INV1 ;INVITATION TO CHAT
        INT 21H
  		
  	    MOV AH,9H	
	    MOV DX,OFFSET P2NAME[2]
        INT 21H 
        
        
        
        
        CON2:             
        mov dx , 3FDH		; Line Status Register     
        MOV CX,1
  CHK1:  
  INC CX
  CMP CX,50000
  JE NOCON1
   in al , dx 
        AND al , 1 
       JZ CHK1

        mov dx , 03F8H
        in al , dx  
        CMP AL,CF2 
        jne con11 
  		CMP MYNUM,0
  		JE STARTG
  		MOV MYNUM,2 
  		MOV OTHNUM ,0
  		
  		
       MOV AH,9	
	   MOV DX,OFFSET P2NAME[2]
       INT 21H 
        
        MOV AH,9
        MOV DX,OFFSET RINV
        INT 21H 
        
        CON11: 
        CMP AL,CF1 
        jne con12 
  		CMP PF1,2
  		JE STARTC
  		MOV PF1,1
  		
  		
       MOV AH,9H	
	   MOV DX,OFFSET P2NAME[2]
       INT 21H 
        
        MOV AH,9H
        MOV DX,OFFSET RINV1
        INT 21H 
        
         
       con12:  
         
         ;CALL CONNECTION_CHECK
    JMP START_AGAIN1
      
             
    NOCON1:      
    ;MOV AH,9H
;    MOV DX,OFFSET CONNECTIONERROR
;    INT 21H 
    ;CALL CONNECTION_CHECK       
     JMP START_AGAIN1  
     
STARTC:
 MOV MODE,1
 MOV AH,cf1
JMP H  
STARTG: 
;       ;START GAME 
;        MOV AH,9H
;        MOV DX,OFFSET START
;        INT 21H 
;        
       MOV AH,cf2 

H:       
   
      delete_screen 23,25  
            
    RET
    MANAGER ENDP


CONFIGURE PROC 
    
    mov dx,3fbh 			; Line Control Register
    mov al,10000000b		;Set Divisor Latch Access Bit
    out dx,al				;Out it
    
    mov dx,3f8h			
    mov al,0ch			
    out dx,al
    
    mov dx,3f9h
    mov al,00h
    out dx,al
    
    mov dx,3fbh
    mov al,00011011b
    ;0Access to Receiver buffer, Transmitter buffer
    ;0:Set Break disabled
    ;011:Even Parity
    ;0:One Stop Bit
    ;11:8bits
    out dx,al
    
       
    RET
    CONFIGURE ENDP    

CONNECTION_CHECK PROC
    
    
 START_AGAINR:   
              
        mov dx , 3FDH		; Line Status Register
 AGAINR:  In al , dx 			;Read Line Status
        AND al , 00100000b   
        
        JZ AGAINR
        
         
        mov dx , 3F8H		; Transmit data register
        MOV AL, 'R'
  		out dx , al 
                       
        mov dx , 3FDH		; Line Status Register
   CHKR: 
   in al , dx 
        AND al , 1
        JZ CHKR
       
        
        mov dx , 03F8H
        in al , dx  
        mov dl,AL
        CMP AL,'R'              
       JNE START_AGAINR 
     ;  MOV AH, 02 ; Output Char
;    MOV DL,AL ; Char to Display
;    INT 21H
        
        
         
 START_AGAINM:       
        mov dx , 3FDH		; Line Status Register
 AGAINM:  In al , dx 			;Read Line Status
        AND al , 00100000b
        JZ AGAINM
        
        mov dx , 3F8H		; Transmit data register
        MOV AL, 'M'
  		out dx , al      
  
  		
  		 mov dx , 3FDH		; Line Status Register
   CHKM: in al , dx 
        AND al , 1
        JZ CHKM
        
        
        mov dx , 03F8H
        in al , dx 
        CMP AL,'M'              
      JNE START_AGAINM 
        ;  MOV AH, 02 ; Output Char
; 
;        MOV DL,AL
;        INT 21H   
  		
                    
                   RET
     CONNECTION_CHECK ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SENDNAME PROC
    
   mov bx,0
START_AGAINP:
    MOV DX,3FDH
  AGAINP:
    IN AL,DX
    AND AL,00100000B
    JZ AGAINP
    
    MOV DX,3F8H
    MOV AL,P1NAME[BX]
    OUT DX,AL   
    CALL RECIEVENAME 
  
    INC BX
    CMP BX,16
    JNE START_AGAINP
             
      RET        
SENDNAME ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RECIEVENAME PROC 
  MOV DX,3FDH
  CHKP:
     IN AL,DX
     AND AL,1
     JZ CHKP
  
  MOV DX,03F8H
  IN AL,DX
  MOV P2NAME[BX],AL

 RET  
RECIEVENAME ENDP    

CHAT PROC 
    MOV CL,0
    MOV CH,0 
    MOV CursorPositionX,CL
    MOV CursorPositionY,CH 
    call movecursor 
    
    MOV AH,2
    MOV DX,':'
    INT 21H 
    
    MOV AH,9H
    MOV DX,OFFSET P1NAME[2] 
    INT 21H  
    
    
     
  ;  MOV AH,9H
;    MOV DX,OFFSET COLMN 
;    INT 21H 
    MOV CL,0
    MOV CH,12 
    MOV CursorPositionX,CL
    MOV CursorPositionY,CH 
    call movecursor 
    
    MOV AH,9H
    MOV DX,OFFSET P2NAME[2] 
    INT 21H  
     
         PUSH L1
    ; SET POSITION TO DRAW BELLOW LINE
    MOV X1,5
    MOV Y1,181 
    MOV L1,300
    MOV DRAWINGCOLOR,0DH      
    CALL DRAWHLINE 
    ; SET CURSOR POSTION TO DISPLAY MESSAGE 
    
    mov CursorPositionX,1
    mov CursorPositionY,23
    
    Call MoveCursor
    

    ; DIPLAYING ESCAPE MESSAGE
    MOV AH ,9H
    MOV DX,OFFSET F3MESSAGE
    INT 21H
    
    POP L1  
    

    

      
    ;MOV AH,9H
;    MOV DX,OFFSET COLMN 
;    INT 21H
     
   
  

    
   
 CHATLOOP:   
     MOV AH, 01 ; ZF =0 if key pressed, else ZF=1
    INT 16H  
    JZ PRINTNULL
    
    MOV AH, 00 ; AL: ASCII Code, AH: Scancode
    INT 16H   
     JMP L
    PRINTNULL:
    MOV AL,0
    L:
    PUSH AX
    
    CMP YPOS,12
    JL CONTINUE
    DELETE_SCREEN 1,11
    MOV XPOS,0
    MOV YPOS,1
    CONTINUE: 
    MOV CL,XPOS
    MOV CH,YPOS 
    MOV CursorPositionX,CL
    MOV CursorPositionY,CH
    CALL MOVECURSOR 
   ; print my wordes (sending characters)
   CMP AL,0
   JE NOPRINT
    MOV AH, 02 ; Output Char
    MOV DL,AL ; Char to Display
    INT 21H        
    
    CALL GETCURSOR
    MOV XPOS,DL
    MOV YPOS,DH  
    
    NOPRINT:
     
    POP AX	
    CMP AH,61
    JNE AJUMP
      MOV AL,15   ; FR HANDELING A USER GOING BACK TO MENUE
     AJUMP: 
     PUSH AX     
    mov dx , 3FDH		; Line Status Register
    AGAINPP: 
    In al , dx 			;Read Line Status
    AND al , 00100000b
    JZ AGAINPP 

     
    mov dx , 3F8H
    POP AX		; Transmit data register
    out dx , al 
     
    CMP AL,15
    JE ENDCHAT  
        
   CHECKINP:  
     mov dx , 3FDH		; Line Status Register
   CHKPP: in al , dx 
        AND al , 1
        JZ CHKPP
    
        
    mov dx , 03F8H
    in al , dx 
    CMP AL,15
    JE ENDCHAT  
    
    CMP AL,0
    JE CHATLOOP
    ; CHECKING BOUNDARY OF RECIEVING AREA
    
    MOV CL,XRPOS
    MOV CH,YRPOS
    CMP YRPOS,23
    JL CONTINUE2
    DELETE_SCREEN 13,23
    MOV XRPOS,0
    MOV YRPOS,13
    CONTINUE2:
    MOV CL,XRPOS
    MOV CH,YRPOS
   MOV CursorPositionX,CL
   MOV CursorPositionY,CH
    
    CALL MOVECURSOR
    MOV AH, 02 ; Output Char , 7 :Bell SOud
    MOV DL ,AL ; Char to Display
    INT 21H 
    CALL GETCURSOR
    MOV XRPOS,DL
    MOV YRPOS,dh
    JMP CHATLOOP

    ENDCHAT:
 
    RET
    CHAT ENDP 
     
GETCURSOR PROC
   MOV AH,3H
   MOV BH,0H
   INT 10H 
    RET
GETCURSOR ENDP 

INNERCHAT PROC    
    Mov cl,myx
    mov ch, myy
     mov CursorPositionx,cl
    mov CursorPositiony,ch
    CALL MOVECURSOR 
    cmp myinp,'a'
    jae Print1
    cmp myinp, 32
    jne no      
    Print1:
    MOV AH, 02 ; Output Char , 7 :Bell SOud
    MOV DL ,myinp ; Char to Display
    INT 21H 
    CALL GETCURSOR
    MOV myx,DL
    MOV myy,dh 
    CMP MYX,39
    JNE NO
    DELETE_SCREEN 20,20
    MOV CURSORPOSITIONX,0
    MOV CURSORPOSITIONY,20
    CALL MOVECURSOR 
    
    MOV AH,2
    MOV Dl,P2NAME[2]
    INT 21H 
    
       
    MOV AH,2
    MOV DX,':'
    INT 21H 
    
    MOV myx,2
    MOV myy,20
    no: 
     mov cl,ux
    mov ch, uy
     mov CursorPositionx,cl
    mov CursorPositiony,ch
    CALL MOVECURSOR 
    cmp userinp,'a'
    jae Print2
    cmp userinp, 32
    jne no2 
   Print2:
    MOV AH, 02 ; Output Char , 7 :Bell SOud
    MOV DL ,userinp ; Char to Display
    INT 21H 
    CALL GETCURSOR
    MOV ux,DL
    MOV uy,dh 
    CMP UX,39
    JNE NO2
  DELETE_SCREEN 20,20
    MOV CURSORPOSITIONX,0
    MOV CURSORPOSITIONY,21
    CALL MOVECURSOR 
    
    MOV AH,2
    MOV Dl,P1NAME[2]
    INT 21H 
    
     MOV AH,2
    MOV DX,':'
    INT 21H 
    MOV Ux,2
    MOV Uy,21
    no2:
    
    
    RET
    INNERCHAT ENDP

