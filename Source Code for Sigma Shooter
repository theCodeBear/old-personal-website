TITLE Sigma Shooter                             (SigmaShooter.asm)

; Description: Final Project for Assembly Language Class
; Creator: Todd Kronenberg
;
; NOTES ON PLAYING THE GAME:
;           ARROW KEYS USED FOR MOVEMENT, SPACEBAR LAYS A BOMB,  AND LOWERCASE KEYS a,d,w,s FIRE LASER LEFT, RIGHT, UP, AND DOWN RESPECTIVELY
;
;
; Start Date: 3/26/13

INCLUDE Irvine32.inc


; GLOBAL VARIABLES AND DATA STRUCTURE DEFINITIONS

Enemy STRUCT
        x BYTE ?
        y BYTE ?
        alive BYTE ?                            ; 1 if enemy is alive, 0 if enemy is dead, 2 if enemy is in a state of exploding
Enemy ENDS

Astro STRUCT
        x BYTE ?
        y BYTE ?
        exists BYTE ?                           ; 1 if asteroid exists, 0 if no asteroid
        image BYTE ?,0
        MoveX SBYTE ?                           ; how much to move asteroid by, (x and y can be -1, 0, or 1)
        MoveY SBYTE ?
Astro ENDS

Weapon STRUCT
        x BYTE ?
        y BYTE ?
Weapon ENDS

EnemyGroup1Num = 32
EnemyGroup2Num = 32
EnemyGroup3Num = 32

.data
        gameTitle BYTE "SIGMA SHOOTER!",0
        gameCreator BYTE "Created by Todd Kronenberg",0
        gameOverStr BYTE "GAME OVER",0
        chooseGameStr BYTE "Choose your game type.",0
        regularGameStr BYTE "REGULAR GAME - Play through all the levels",0
        pointGameStr BYTE "POINT ATTACK - Get as many points as you can",0
        swarmGameStr BYTE "SWARM - Just survive 3 minutes",0
        swarmStr BYTE "SWARM",0
        pointAttackStr BYTE "POINT ATTACK",0
        gameType BYTE ?                                                             ; determines what gametype is being played (0,1,2)
        difficultyStr BYTE "What difficulty do you prefer (Type: E, M, or H)? ",0
        difficultyLevel BYTE ?                                                      ; 0 is easy, 1 is medium, 2 is hard
        easyStr BYTE "Easy",0
        mediumStr BYTE "Medium",0
        hardStr BYTE "Hard",0
        go BYTE "Go!",0
        points DWORD 0
        pointStr BYTE "POINTS: ",0
        timeStr BYTE "TIME: ",0
        wonGameStr BYTE "You won the game!!!",0
        pressEnterStr BYTE "Press Enter to Continue...",0
        endl BYTE 1 DUP (13,10,0)
        character BYTE  228,0                               ;"Capital Sigma",0
        char2 BYTE 1 DUP ("O",0)
        blank BYTE " ",0
        x BYTE ?
        y BYTE ?
        
        offsetForBaddies DWORD ?
        baddiesG1 ENEMY EnemyGroup1Num DUP (<0,0,0>)
        baddiesG2 ENEMY EnemyGroup2Num DUP (<0,0,0>)
        baddiesG3 ENEMY EnemyGroup3Num DUP (<0,0,0>)

        timerX BYTE 70                  ; coordinate position of the clock on-screen
        timerY BYTE 0
        quit BYTE 0                     ; quit=1 means player died, quit = 2 means player chose to quit during one of the option menus
        sysTime SYSTEMTIME <>           ; stores the local system time

        level BYTE 0                    ; value if playing regular game will be 1 through 6 corresponding to which level the player is on
        levelDisplay BYTE "LEVEL ",0    ; displayed in StartNextLevel procedure

        seconds WORD ?                  ; saves the seconds from the local system time
        mSeconds1 WORD ?                ; saves milliseconds for baddiesG1
        mSeconds2 WORD ?                ; saves milliseconds for baddiesG2
        mSeconds3 WORD ?                ; saves milliseconds for baddiesG3
        mSeconds4 WORD ?                ; saves milliseconds for baddiesG4
        mSeconds5 WORD ?                ; saves milliseconds for baddiesG5
        

        mSecondLaser DWORD ?
        mSecondAstro WORD ?             ; saves milliseconds for asteroids
        countdown SWORD ?               ; set in StartNextLevel procedure for regular game
        wave1time WORD ?                ; these times represent when in the countdown the wave of enemies will show up
        wave2time WORD ?
        wave3time WORD ?
        wave4time WORD ?

        defaultColor BYTE ?                             ; default foreground/background color scheme of console, BlackSpace color scheme
        whiteSpaceColor BYTE BLACK + (WHITE*16)         ; colors for menu screens and WhiteSpace color scheme
        snowyFieldColor BYTE 0                          ; 0 means this color scheme is not set, 1 means it is set. It's handled in StartNextLevel procedure.
        userColor BYTE ?                                ; which ever color style the user chooses

        chooseColorStr BYTE "Please choose your Color Scheme",0
        blackSpaceStr BYTE "BLACK SPACE",0
        whiteSpaceStr BYTE "WHITE SPACE",0
        snowyFieldStr BYTE "SNOWY FIELD",0


;       EmovR SBYTE 0                   ; used in EnemiesTouching PROC whenchecking for enemy-on-enemy contact...
;       EmovL SBYTE 0                   ; "E" = enemy, "mov" = moved, "R/L/U/D" = directions...
;       EmovU SBYTE 0                   ; variable will be 1 if enemy's currently moved...
;       EmovD SBYTE 0                   ; in that direction.

        bombUpgrade BYTE 234,0
        bombUpgradeStartTime BYTE 0
        bombUpgradePosition WEAPON <0,0>
        bombUpgradeExists BYTE 0
        bombUpgradeColor BYTE LIGHTGREEN + (BLACK*16)

        laserUpgrade BYTE 232,0
        laserUpgradeStartTime BYTE 0
        laserUpgradePosition WEAPON <0,0>
        laserUpgradeExists BYTE 0                          ; 0 means upgrade isn't on map, 1 means it is
        laserUpgradeColor BYTE LIGHTCYAN + (BLACK*16)

        audioBell BYTE 7,0                                 ; call WriteString on this to hear the "beep" noise
        laserPower BYTE 1                                  ; default laser is power 1, can be upgraded to power 2
        goodLaser WEAPON <0,0>                             ; laser of player (green color)
        goodLaser2 WEAPON <0,0>                            ; goodLaser2 and 3 used for triple laser when upgraded
        goodLaser3 WEAPON <0,0>
        pewpew BYTE ?,0                                    ; this will hold the correct ASCII character for a laser when fired
        greenText BYTE GREEN + (BLACK*16)
        laserDirection BYTE ?                              ; specifies is the current laser is going up("u"), down("d"), left("l"), or right("r")
        explosion BYTE 176,0                               ; explosion displays a mesh type thing (ASCII 176)
        yellowText BYTE YELLOW + (BLACK*16)
        bombPower BYTE 1                                   ; default bomb is power 1, can be upgraded to power 2
        boomboom BYTE 235,0                                ; 232 is the ASCII code
        bombTime SDWORD ?                                  ; represents the time associated with a bomb
        bombLaid BYTE 1                                    ; if 1 then bomb is available, if 0 then bomb is currently laid and can't lay another one
        bombPosition WEAPON <?,?>
        bombExplodeTimer DWORD ?                           ; timer for explosion from bomb to fade away (it'll take one second)
        bombExplodeX BYTE ?                                ; coordinates for where current bomb explosion started (top left position of explosion)
        bombExplodeY BYTE ?
        asteroidImage BYTE 219,220,221,222,223             ; five different possible ASCII values (images) for asteroids
        asteroidFrequency BYTE 1                           ; =2 means 50% change of asteroid showing up each second if there is no asteroid on-screen already, =1 means every second 
        asteroid ASTRO <?,?>     ; 60 DUP (<0,0>)          ; asteroid coordinates
        asteroidSlowDownChange BYTE ?                      ; decremented to control asteroid speed, reset to the following variable after each move
        asteroidSlowDownPermanent BYTE ?                   ; sets the permanent value (based on difficulty level) that is placed into the preceding variable

        sideBoundary BYTE "|",0
        topBottomBoundary BYTE "-",0

.code
main PROC
; SAVING DEFAULT COLORS
        call GetTextColor                    ; retrieve default console colors
        mov defaultColor, AL                 ; save default colors

; GAME INTRO
        call TitleScreen
BeginningOfGame:
        call SetGameType
        .IF quit==2
                call EndGame
                jmp EndOfGame
        .ENDIF
        call SetDifficulty
        .IF quit==2
                call EndGame
                jmp EndOfGame
        .ENDIF
        call SetColorScheme
        .IF quit==2
                call EndGame
                jmp EndOfGame
        .ENDIF
        call StartNextLevel                  ; starts first level of game if player is playing regular game

        call Randomize                       ; seeding the randomizer, for use with Asteroids

; MAIN GAME LOOP
    Game:
        call PrintPoints
        call DrawBoundaries
        call Timer
        call UserMove
        .IF quit==1
                .IF gameType==0                         ; if died in main game
                        call EndGame
                        jmp BeginningOfGame
                .ELSEIF gameType==1                     ; if died in point attack
                        call EndGame
                        jmp BeginningOfGame
                .ELSEIF gameType==2                     ; if died in swarm
                        call EndGame
                        jmp BeginningOfGame
                .ENDIF
        .ENDIF
        .IF countdown < 1 && level > 0 && level < 6            ; if player has survived the level and is playing normal game and not beaten the last level
                call StartNextLevel
        .ELSEIF countdown == 0 && level == 6                   ; if player beat the main game
               call WonGame
                jmp BeginningOfGame
        .ELSEIF gameType == 2 && countdown == 0                ; if player beat the game in Swarm mode
               call WonGame
                jmp BeginningOfGame
        .ENDIF
    jmp Game                        ; continue looping through game loop until player decides to quit (quit==2 jumps to EndOfGame label)
    EndOfGame:
exit
main ENDP

;################################################################################################

StartNextLevel PROC
;----------------------------------------------------
; Sets up everything needed to start a new level or
; start the Swarm and PointAttack modes.
;----------------------------------------------------
        mov AL, whiteSpaceColor
        call SetTextColor
        call Clrscr
        mov DL, 37
        mov DH, 33
        call Gotoxy

; IF PLAYING REGULAR GAME
        .IF gameType==0
                inc level                       ; set level to the next level
                mov EDX, OFFSET levelDisplay
                call WriteString                ; display what level is coming up
                movzx EAX, level
                call WriteDec
                mov countdown, 201              ; reset game clock

; IF PLAYING POINT ATTACK
        .ELSEIF gameType==1
                mov EDX, OFFSET pointAttackStr
                call WriteString

; IF PLAYING SWARM
        .ELSEIF gameType==2
                mov EDX, OFFSET swarmStr
                call WriteString
        .ENDIF

; RESETTING GAME ACTIVITIES
        mov x, 39                               ; reset starting coordinates for character
        mov y, 33
        mov goodLaser.x, 0                      ; reset lasers
        mov goodLaser.y, 0
        mov goodLaser2.x, 0
        mov goodLaser2.y, 0
        mov goodLaser3.x, 0
        mov goodLaser3.y, 0
        mov asteroid.x, 0                       ; reset asteroid
        mov asteroid.y, 0
        mov bombPosition.x, 0                   ; reset bomb
        mov bombPosition.y, 0
        mov bombLaid, 1
        mov bombTime, 0
        mov bombUpgradeStartTime, 0             ; reset bomb upgrade character
        mov bombUpgradePosition.x, 0
        mov bombUpgradePosition.y, 0
        mov bombUpgradeExists, 0
        mov laserUpgradeStartTime, 0            ; reset laser upgrade character
        mov laserUpgradePosition.x, 0
        mov laserUpgradePosition.y, 0
        mov laserUpgradeExists, 0

; RESET ENEMIES
        mov ECX, EnemyGroup3Num                 ; these 3 lines set up the loop counter for loop L5     
        add ECX, EnemyGroup1Num
        add ECX, EnemyGroup2Num                 ; loop counter = total number of enemies
        mov EBX, 0                              ; EBX = offset to move through arrays of badguys
        mov ESI, OFFSET baddiesG1               ; ESI points to arrays of badguys
        EnemyReset:
                mov BYTE PTR [ESI+EBX], 0       ; reset enemy x-coord
                mov BYTE PTR [ESI+EBX+1], 0     ; reset enemy y-coord
                mov BYTE PTR [ESI+EBX+2], 0     ; reset enemy alive flag
                add EBX, SIZE ENEMY             ; add byte size of enemy to EBX to point to next badguy in the next loop iteration (ENEMY has 3 bytes)
        Loop EnemyReset

; DISPLAY WAIT MESSAGE (PROCEDURE)
        mov DL, 26
        mov DH, 40
        call Gotoxy     
        call WaitMsg                            ; game on pause until user decides to start next level

; GETTING THE TIME WHEN GAME BEGINS
        INVOKE GetLocalTime, ADDR sysTime       ; get current time
        mov AX, sysTime.wSecond                 ; save starting time (in sec) in AX
        mov seconds, AX                         ; save starting time in "seconds" variable
        mov AX, sysTime.wMilliseconds           ; save starting time (in milliseconds) in AX
        mov mSeconds1, AX
        mov mSeconds2, AX
        mov mSeconds3, AX

; SET GAMEPLAY COLORS AND CLEAR SCREEN
        .IF snowyFieldColor == 0
                mov AL, userColor
                call SetTextColor
                call Clrscr
        .ELSE                                   ; if snowyFieldColor = 1 then set up colors for that scheme
                mov AL, whiteSpaceColor
                call SetTextColor
                call Clrscr
                mov AL, defaultColor
                call SetTextColor
        .ENDIF
        ret
StartNextLevel ENDP

;################################################################################################

WonGame PROC
;----------------------------------------------------
; If the player beat the game this procedure displays
; that the user won the game, displays the point
; score, the game type, and the difficulty setting.
;----------------------------------------------------
    mov AL, whiteSpaceColor
    call SetTextColor
    call Clrscr
; PRINT WON-GAME STRING
    mov DH, 10
    mov DL, 32
    call Gotoxy
    mov EDX, OFFSET wonGameStr
    call WriteString
; PRINT GAMETYPE
    mov DH, 20
    .IF gameType==1
        mov DL, 35
        call Gotoxy
        mov EDX, OFFSET pointAttackStr
        call WriteString
    .ELSEIF gameType==2
        mov DL, 39
        call Gotoxy
        mov EDX, OFFSET swarmStr
        call WriteSTring
    .ENDIF
; PRINTING THE DIFFICULTY
    mov DH, 22
    mov DL, 39
    call Gotoxy
    .IF difficultyLevel==0
        mov EDX, OFFSET easyStr
    .ELSEIF difficultyLevel==1
        mov EDX, OFFSET mediumStr
    .ELSEIF difficultyLevel==2
        mov EDX, OFFSET hardStr
    .ENDIF
    call WriteString
; PRINT POINT SCORE
    mov DH, 26
    mov DL, 35
    call Gotoxy
    mov EDX, OFFSET pointStr
    call WriteString
    mov EAX, points
    call WriteDec
; PRINT "PRESS ENTER" STRING
    mov DH, 33
    mov DL, 28
    call Gotoxy
    mov EDX, OFFSET pressEnterStr
    call WriteString
WaitForEnter:
    mov EAX, 10
    call Delay                      ; delay so that ReadKey is more likely to pick up user key-press
    call ReadKey
    .IF AH != 28
        jmp WaitForEnter            ; only continue if user presses Enter, otherwise jump to WaitForEnter label
    .ENDIF
; RESETING SOME GAME VALUES
    mov points, 0                           ; reset point score to zero
    mov level, 0                            ; reset game level to zero
    mov quit, 0                             ; reset quit to zero
    mov laserPower, 1                       ; reset laser power
    mov bombPower, 1                        ; reset bomb power
    mov greenText, GREEN + (BLACK*16)       ; reset colors of certain items
    mov yellowText, YELLOW + (BLACK*16)
    mov laserUpgradeColor, LIGHTCYAN + (BLACK*16)
    mov bombUpgradeColor, LIGHTGREEN + (BLACK*16)
; CLEAR SCREEN
    call ClrScr
    ret
WonGame ENDP

;################################################################################################

TitleScreen PROC
;----------------------------------------------------
; Display the title screen.
;----------------------------------------------------
; PRINTING GAME TITLE ON SCREEN
        mov AL, whiteSpaceColor                 ; title screen is black on white
        call SetTextColor
        call Clrscr
        mov DL, 32
        mov DH, 30
        call Gotoxy
        mov EDX, OFFSET gameTitle
        call WriteString                        ; print Game Title
        mov DL, 26
        mov DH, 32
        call Gotoxy
        mov EDX, OFFSET gameCreator
        call WriteString                        ; print Creator's name
        mov EAX, 5000                           ; pause for 4 seconds
        call Delay
        call Clrscr
        ret
TitleScreen ENDP

;################################################################################################

SetGameType PROC
;----------------------------------------------------
; Displays the menu for the player to decide which
; game mode to play. Handles everything associated
; with that menu screen, including setting up the
; wavetime variables and the countdown clock
; according to which game mode is selected.
;----------------------------------------------------
; PRINT GAME TYPES POSSIBILITIES
        mov DL, 15
        mov DH, 25
        call Gotoxy
        mov EDX, OFFSET chooseGameStr
        call WriteString
        mov DL, 30
        mov DH, 30
        call Gotoxy
        mov EDX, OFFSET regularGameStr
        call WriteString
        mov DL, 30
        mov DH, 33
        call Gotoxy
        mov EDX, OFFSET pointGameStr
        call WriteString
        mov DL, 30
        mov DH, 36
        call Gotoxy
        mov EDX, OFFSET swarmGameStr
        call WriteString
; PRINT INITIAL PLACEMENT OF GAME-TYPE SELECTOR
        mov DL, 25
        mov DH, 30
        push EDX                                        ; save selector placement for SelectType loop
        call Gotoxy
        mov EDX, OFFSET character
        call WriteString
        mov gameType, 0
; MOVE SELECTOR UP OR DOWN TO DIFFERENT SELECTIONS
        pop EDX                                         ; DL and DH hold placement of selector character
        .REPEAT
                call ReadChar
                .IF AH == 80                            ; 80 = scan code for down arrow key
                        .IF DH==30
                                call EraseSpot
                                mov DL, 25
                                mov DH, 33
                                call Gotoxy
                                push EDX
                                mov EDX, OFFSET character
                                call WriteString
                                mov gameType, 1
                                pop EDX
                        .ELSEIF DH==33
                                call EraseSpot
                                mov DL, 25
                                mov DH, 36
                                call Gotoxy
                                push EDX
                                mov EDX, OFFSET character
                                call WriteString
                                mov gameType, 2
                                pop EDX
                        .ELSEIF DH==36
                                call EraseSpot
                                mov DL, 25
                                mov DH, 30
                                call Gotoxy
                                push EDX
                                mov EDX, OFFSET character
                                call WriteString
                                mov gameType, 0
                                pop EDX
                        .ENDIF
                .ELSEIF AH == 72                        ; 72 = scan code for up arrow key
                        .IF DH==30
                                call EraseSpot
                                mov DL, 25
                                mov DH, 36
                                call Gotoxy
                                push EDX
                                mov EDX, OFFSET character
                                call WriteString
                                mov gameType, 2
                                pop EDX
                        .ELSEIF DH==33
                                call EraseSpot
                                mov DL, 25
                                mov DH, 30
                                call Gotoxy
                                push EDX
                                mov EDX, OFFSET character
                                call WriteString
                                mov gameType, 0
                                pop EDX
                        .ELSEIF DH==36
                                call EraseSpot
                                mov DL, 25
                                mov DH, 33
                                call Gotoxy
                                push EDX
                                mov EDX, OFFSET character
                                call WriteString
                                mov gameType, 1
                                pop EDX
                        .ENDIF
                .ELSEIF AL =="q"                ; if user types "q" then program will end
                        mov quit, 2
                .ENDIF
        .UNTIL AH == 28 || AL == "q"            ; 28 = scan code for Enter key, signifies user has made a selection
        
        .IF gameType==2                         ; if player chose to play "Swarm"
                mov countdown, 181
                mov wave1Time, 180
                mov wave2Time, 160
                mov wave3Time, 140
                mov wave4Time, 120
        .ELSEIF gameType==1
                mov countdown, 0
                mov wave1Time, 1
                mov wave2Time, 30
                mov wave3Time, 60
                mov wave4Time, 90
        .ELSEIF gameType==0                     ; countdown for main game is set in StartNextLevel procedure b/c it needs to be reset every level
                mov wave1Time, 200
                mov wave2Time, 150
                mov wave3Time, 100
                mov wave4Time, 50
        .ENDIF
        call Clrscr
        ret
SetGameType ENDP

;################################################################################################

SetDifficulty PROC
;----------------------------------------------------
; Displays the menu for selecting the difficulty
; level of the game. Sets the variables that change
; based on what difficulty is selected.
;----------------------------------------------------
; SETTING DIFFICULTY LEVEL
        mov DL, 5
        mov DH, 25
        call Gotoxy
        mov EDX, OFFSET difficultyStr
        call WriteString                                ; ask user for difficulty level
        PickDifficulty:
        call ReadChar                                   ; retrieve user input
        .IF AL=="e" || AL=="E"
                mov difficultyLevel, 0                  ; Easy - this variable used at beginning of UserMove procedure
                mov EDX, OFFSET easyStr
                mov asteroidSlowDownPermanent, 3        ; these two variables control asteroid speed, higher number = slower asteroids
                mov asteroidSlowDownChange, 3
        .ELSEIF AL=="m" || AL=="M"
                mov difficultyLevel, 1                  ; Medium - this variable used at beginning of UserMove procedure
                mov EDX, OFFSET mediumStr
                mov asteroidSlowDownPermanent, 1
                mov asteroidSlowDownChange, 1
        .ELSEIF AL=="h" || AL=="H"
                mov difficultyLevel, 2                  ; Hard - this variable used at beginning of UserMove procedure
                mov EDX, OFFSET hardStr
                mov asteroidSlowDownPermanent, 0
                mov asteroidSlowDownChange, 0
        .ELSEIF AL =="q"                                ; if user types "q" then program will end
                mov quit, 2
                call Clrscr
        .ELSE
                jmp PickDifficulty                      ; go back to ReadChar until user puts in a valid response
        .ENDIF
        
        .IF quit != 2
                call Clrscr
                push EDX                                ; save to stack offset to difficulty string: "Easy", "Medium", or "Hard"
                mov DL, 36                              ; setting position to output difficulty string
                mov DH, 30
                call Gotoxy
                pop EDX                                 ; get offset to string back from stack into EDX for output on next line
                call WriteString
                mov EAX, 1000
                call Delay                              ; half-second delay before game starts
                call Clrscr
        .ENDIF
        ret
SetDifficulty ENDP

;################################################################################################

SetColorScheme PROC
;----------------------------------------------------
; Diplays the color scheme menu. Sets up the
; appropriate color scheme based on what the player
; selects.
;----------------------------------------------------
; NOTE: code is similar to SetGameType procedure

; SET USERCOLOR TO BLACKSPACE BECAUSE CURSOR STARTS BY POINTING TO BLACKSPACE OPTION
        mov snowyFieldColor, 0                          ; reset this variable in case it was set in last game and then player died and is beginning another game
        mov AL, defaultColor
        mov userColor, AL                               ; defaultColor is black space colors

; SAVE INITIAL PLACEMENT OF GAME-TYPE SELECTOR
        mov DL, 25
        mov DH, 30
        push EDX                                        ; save selector placement for SelectType loop

ChangeColors:                                           ; after selector is moved the procedure jumps back to this point
        .IF snowyFieldColor==0                          ; if snowyFieldColor is not currently pointed to
                mov AL, userColor
                call SetTextColor
                call Clrscr
        .ELSE                                           ; if snowyFieldColor is currently pointed to by the selector
                mov AL, whiteSpaceColor
                call SetTextColor                       ; set white space as the color and clear the screen
                call Clrscr
                mov AL, defaultColor                    ; but then set black space as color so any movement causes black space to take over the white space
                call SetTextColor
                mov userColor, AL                       ; need to set userColor to default (black space) color or else snowy field effect won't happen correctly
        .ENDIF

        pop EDX                                         ; pop Selector coordinates into EDX
        push EDX                                        ; save selector placement onto stack for use in SelectType loop
        call Gotoxy
        mov EDX, OFFSET character
        call WriteString

; PRINT COLOR SCHEME POSSIBILITIES
        mov DL, 15
        mov DH, 25
        call Gotoxy
        mov EDX, OFFSET chooseColorStr
        call WriteString
        mov DL, 30
        mov DH, 30
        call Gotoxy
        mov EDX, OFFSET blackSpaceStr
        call WriteString
        mov DL, 30
        mov DH, 33
        call Gotoxy
        mov EDX, OFFSET whiteSpaceStr
        call WriteString
        mov DL, 30
        mov DH, 36
        call Gotoxy
        mov EDX, OFFSET snowyFieldStr
        call WriteString
; MOVE SELECTOR UP OR DOWN TO DIFFERENT SELECTIONS
        pop EDX                                         ; DL and DH hold placement of selector character
        call ReadChar
        .IF AH == 80                                    ; 80 = scan code for down arrow key
                .IF DH==30
                        call EraseSpot
                        mov DL, 25
                        mov DH, 33
                        push EDX                        ; save Selector coordinates to print Selector character out after colors have been changed
                        mov BL, whiteSpaceColor
                        mov userColor, BL
                ; SETTING VARIABLES RELATED TO COLOR CHANGE
                        mov snowyFieldColor, 0
                        mov yellowText, MAGENTA + (WHITE*16)
                        mov greenText, GREEN + (WHITE*16)
                        mov laserUpgradeColor, CYAN + (WHITE*16)
                        mov bombUpgradeColor, BLUE + (WHITE*16)
                        jmp ChangeColors
                .ELSEIF DH==33
                        call EraseSpot
                        mov DL, 25
                        mov DH, 36
                        push EDX                                        ; save Selector coordinates to print Selector character out after colors have been changed
                ; SETTING VARIABLES RELATED TO COLOR CHANGE
                        mov snowyFieldColor, 1
                        mov yellowText, YELLOW + (BLACK*16)
                        mov greenText, GREEN + (BLACK*16)
                        mov laserUpgradeColor, LIGHTCYAN + (BLACK*16)
                        mov bombUpgradeColor, LIGHTGREEN + (BLACK*16)
                        jmp ChangeColors
                .ELSEIF DH==36
                        call EraseSpot
                        mov DL, 25
                        mov DH, 30
                        push EDX                                        ; save Selector coordinates to print Selector character out after colors have been changed
                        mov BL, defaultColor
                        mov userColor, BL
                ; SETTING VARIABLES RELATED TO COLOR CHANGE
                        mov snowyFieldColor, 0
                        mov yellowText, YELLOW + (BLACK*16)
                        mov greenText, GREEN + (BLACK*16)
                        mov laserUpgradeColor, LIGHTCYAN + (BLACK*16)
                        mov bombUpgradeColor, LIGHTGREEN + (BLACK*16)
                        jmp ChangeColors
                .ENDIF
        .ELSEIF AH == 72                                                ; 72 = scan code for up arrow key
                .IF DH==30
                        call EraseSpot
                        mov DL, 25
                        mov DH, 36
                        push EDX                                        ; save Selector coordinates to print Selector character out after colors have been changed
                ; SETTING VARIABLES RELATED TO COLOR CHANGE
                        mov snowyFieldColor, 1
                        mov yellowText, YELLOW + (BLACK*16)
                        mov greenText, GREEN + (BLACK*16)
                        mov laserUpgradeColor, LIGHTCYAN + (BLACK*16)
                        mov bombUpgradeColor, LIGHTGREEN + (BLACK*16)
                        jmp ChangeColors
                .ELSEIF DH==33
                        call EraseSpot
                        mov DL, 25
                        mov DH, 30
                        push EDX                                        ; save Selector coordinates to print Selector character out after colors have been changed
                        mov BL, defaultColor
                        mov userColor, BL
                ; SETTING VARIABLES RELATED TO COLOR CHANGE
                        mov snowyFieldColor, 0
                        mov yellowText, YELLOW + (BLACK*16)
                        mov greenText, GREEN + (BLACK*16)
                        mov laserUpgradeColor, LIGHTCYAN + (BLACK*16)
                        mov bombUpgradeColor, LIGHTGREEN + (BLACK*16)
                        jmp ChangeColors
                .ELSEIF DH==36
                        call EraseSpot
                        mov DL, 25
                        mov DH, 33
                        push EDX                                        ; save Selector coordinates to print Selector character out after colors have been changed
                        mov BL, whiteSpaceColor
                        mov userColor, BL
                ; SETTING VARIABLES RELATED TO COLOR CHANGE
                        mov snowyFieldColor, 0
                        mov yellowText, MAGENTA + (WHITE*16)
                        mov greenText, GREEN + (WHITE*16)
                        mov laserUpgradeColor, CYAN + (WHITE*16)
                        mov bombUpgradeColor, BLUE + (WHITE*16)
                        jmp ChangeColors
                .ENDIF
        .ELSEIF AL =="q"                        ; if user types "q" then program will end
                mov quit, 2
                call Clrscr
        .ELSEIF AH == 28                        ; if user presses enter to choose a color scheme
                ; don't do anything as color scheme is already implemented, just allows program to end this procedure
        .ENDIF
        call Clrscr
        ret
SetColorScheme ENDP

;################################################################################################

PrintPoints PROC
;----------------------------------------------------
; Displays during gameplay (at the top of the screen)
; the current point score, the game mode and the
; difficulty level.
;----------------------------------------------------
; PRINTING THE POINT SCORE
    mov DL, 5
    mov DH, 0
    call Gotoxy
    mov EAX, points
    call WriteDec
    
; PRINTING THE LEVEL OR GAME TYPE
    mov DL, 25
    mov DH, 0
    call Gotoxy
    .IF gameType==0
        mov EDX, OFFSET levelDisplay
        call WriteString
        movzx EAX, level
        call WriteDec
    .ELSEIF gameType==1
        mov EDX, OFFSET pointAttackStr
        call WriteString
    .ELSEIF gameType==2
        mov EDX, OFFSET swarmStr
        call WriteString
    .ENDIF
    
; PRINTING THE DIFFICULTY
    mov DL, 45
    mov DH, 0
    call Gotoxy
    .IF difficultyLevel==0
        mov EDX, OFFSET easyStr
    .ELSEIF difficultyLevel==1
        mov EDX, OFFSET mediumStr
    .ELSEIF difficultyLevel==2
        mov EDX, OFFSET hardStr
    .ENDIF
    call WriteString
    ret
PrintPoints ENDP

;################################################################################################

DrawBoundaries PROC
;----------------------------------------------------
; Handles drawing the boundaries of the playable
; screen during gameplay.
;----------------------------------------------------
; FILLING THE LEFT BOUNDARY
        mov DL, 2                                           ; remain at x=2 throughout loop
        mov DH, 4
        mov ECX, 60                                         ; loop counter to move from y=4 to y=63
        mov EAX, OFFSET sideBoundary
        BoundaryLoop1:
            call SingleBoundary                             ; draws the boundary character in the current location
            inc DH
        Loop BoundaryLoop1

; FILLING THE RIGHT BOUNDARY
        mov DL, 77                                          ; remain at x=77 throughout loop
        mov DH, 4
        mov ECX, 60                                         ; loop counter to move from y=4 to y=63
        mov EAX, OFFSET sideBoundary
        BoundaryLoop2:
            call SingleBoundary
            inc DH
        Loop BoundaryLoop2

; FILLING THE TOP BOUNDARY
        mov DL, 3
        mov DH, 4                                           ; remain at y=4 throughout loop
        mov ECX, 74                                         ; loop counter to move from x=2 to x=77
        mov EAX, OFFSET topBottomBoundary
        BoundaryLoop3:
            call SingleBoundary
            inc DL
        Loop BoundaryLoop3

; FILLING THE BOTTOM BOUNDARY
        mov DL, 3
        mov DH, 63                                          ; remain at y=63 throughout loop
        mov ECX, 74                                         ; loop counter to move from x=2 to x=77
        mov EAX, OFFSET topBottomBoundary
        BoundaryLoop4:
            call SingleBoundary
            inc DL
        Loop BoundaryLoop4
        ret
DrawBoundaries ENDP

;################################################################################################

SingleBoundary PROC
;----------------------------------------------------
; Called by the DrawBoundaries procedure. This
; simply displays a single boudary to the current position.
;
; Receives: EDX = X,Y coordinates of where to draw boundary onscreen.
;           EAX = the offset to the character boundary character to display.
;----------------------------------------------------
        call Gotoxy
        push EDX                              ; save x,y coordinates
        mov EDX, EAX                          ; moving offset to boundary character to EDX
        call WriteString
        pop EDX
        ret
SingleBoundary ENDP

;################################################################################################

EndGame PROC
;----------------------------------------------------
; Handles the Game Over screen when a player dies.
; Prints the score and countdown time if playing
; Point Attack mode or Swarm mode. Prints the
; game over screen. Resets various gameplay values.
;----------------------------------------------------
    mov AL, whiteSpaceColor
    call SetTextColor
    call Clrscr
; IF PLAYING SWARM OR POINT ATTACK - DISPLAY GAMETYPE, DIFFICULTY, POINTS, AND TIME
    .IF gameType==1 || gameType==2
; PRINT GAMETYPE
        mov DH, 20
        .IF gameType==1
            mov DL, 35
            call Gotoxy
            mov EDX, OFFSET pointAttackStr
        .ELSEIF gameType==2
            mov DL, 39
            call Gotoxy
            mov EDX, OFFSET swarmStr
        .ENDIF
        call WriteString
; PRINTING THE DIFFICULTY
        mov DH, 22
        mov DL, 39
        call Gotoxy
        .IF difficultyLevel==0
            mov EDX, OFFSET easyStr
        .ELSEIF difficultyLevel==1
            mov EDX, OFFSET mediumStr
        .ELSEIF difficultyLevel==2
            mov EDX, OFFSET hardStr
        .ENDIF
        call WriteString
; PRINT POINT SCORE
        mov DH, 26
        mov DL, 35
        call Gotoxy
        mov EDX, OFFSET pointStr
        call WriteString
        mov EAX, points
        call WriteDec
; PRINT TIMER
        mov DH, 28
        mov DL, 37
        call Gotoxy
        mov EDX, OFFSET timeStr
        call WriteString
        movzx EAX, countdown            ; print countdown timer
        call WriteDec
; PRINT "PRESS ENTER" STRING
        mov DH, 33
        mov DL, 28
        call Gotoxy
        mov EDX, OFFSET pressEnterStr
        call WriteString
    WaitForEnter:
        mov EAX, 10
        call Delay                      ; delay so that ReadKey is more likely to pick up user key-press
        call ReadKey
        .IF AH != 28
            jmp WaitForEnter            ; only continue if user presses Enter, otherwise jump to WaitForEnter label
        .ENDIF
    .ENDIF

; DISPLAY GAME OVER SCREEN AND RESET SOME GAME VALUES
    call Clrscr
    mov DH, 33
    mov DL, 36
    call Gotoxy
    mov EDX, OFFSET gameOverStr
    call WriteString
    mov points, 0                           ; reset point score to zero
    mov level, 0                            ; reset game level to zero
    mov quit, 0                             ; reset quit to zero
    mov laserPower, 1                       ; reset laser power
    mov bombPower, 1                        ; reset bomb power
    mov greenText, GREEN + (BLACK*16)       ; reset colors of certain items
    mov yellowText, YELLOW + (BLACK*16)
    mov laserUpgradeColor, LIGHTCYAN + (BLACK*16)
    mov bombUpgradeColor, LIGHTGREEN + (BLACK*16)
    mov EAX, 2000
    call Delay
    call Clrscr
    ret
EndGame ENDP

;################################################################################################

DeathDisplay PROC
;----------------------------------------------------
; Handles the output of the flashing "explosion" display
; when the player dies.
;----------------------------------------------------
        mov ECX, 10
        DeathLoop:                                          ; flash background colors of ship explosion
                .IF ECX > 5                                 ; only allow bell to beep 5 times
                        mov EDX, OFFSET audioBell
                        call WriteString
                .ENDIF
                mov AL, lightRed*16                         ; light red and yellow background
                call SetTextColor
                call Clrscr                                 ; clear screen to turn whole screen selected color
                mov EAX, 50                                 ; set parameter to Delay program for 50 milliseconds
                call Delay
                mov AL, yellow*16
                call SetTextColor
                call Clrscr                                 ; clear screen to turn whole screen selected color
                mov EAX, 50
                call Delay
        Loop DeathLoop
        ret
DeathDisplay ENDP

;################################################################################################

UserMove PROC
;----------------------------------------------------
; Handles all the functions related to the player
; typing into the keyboard during gameplay, including
; moving, firing a laser, and laying a bomb. Also
; sets the speed that objects like lasers, asteriods,
; and enemies move at by varying the length of a
; program delay according to which difficulty level
; is set.
;----------------------------------------------------
        .IF difficultyLevel==0          ; pass argument to Delay procedure based on difficulty level (changes speed of lasers and enemies)
                mov EAX, 24
        .ELSEIF difficultyLevel==1
                mov EAX, 18
        .ELSEIF difficultyLevel==2
                mov EAX, 12
        .ENDIF
        call Delay                              ; delay needed to record key stroke (10 milliseconds)
        mov AH, 0
        call ReadKey                            ; returns scan code for arrow key in AH
        mov DH, y                               ; sets current x,y as parameters for Gotoxy to erase old character
        mov DL, x
        call EraseSpot                          ; prints a blank space in last place to erase character
        .IF AH == 77                            ; 77 = scan code for right arrow key
                .IF x < 76
                        inc x
                .ENDIF
        .ELSEIF AH == 75                        ; 75 = scan code for left arrow key
                .IF x > 3
                        dec x
                .ENDIF
        .ELSEIF AH == 80                        ; 80 = scan code for down arrow key
                .IF y < 62
                        inc y
                .ENDIF
        .ELSEIF AH == 72                        ; 72 = scan code for up arrow key
                .IF y > 5
                        dec y
                .ENDIF
        .ELSEIF AL==" " && bombLaid == 1 && x != 3      ; if player presses spacebar and a bomb is not already on map and player isn't at x=3 (which would put bomb in a boundary), then lay bomb
        ;       INVOKE GetLocalTime ,ADDR sysTime       ; get current time (when bomb was laid)
        ;       movzx EAX, sysTime.wSecond
        ;       mov bombTime, EAX                       ; copy time (the current second) bomb was laid into EAX
                movzx EAX, countdown
                mov bombTime, EAX
                .IF gameType==1
                        add bombTime, 4                 ; in point attack mode time counts up, so add 4 seconds to bombTime
                .ELSE
                        sub bombTime, 4                 ; bomb will take 4 seconds to blow up
                .ENDIF
                mov DL, x
                dec DL
                mov DH, y
                call Gotoxy
                mov bombPosition.x, DL
                mov bombPosition.y, DH
                mov EDX, OFFSET boomboom
                call WriteString
                mov bombLaid, 0
; PLAYER LASER-FIRE - INITIALIZING A LASER FOR THE PLAYER
        .ELSEIF ((laserPower==1 && goodLaser.y == 0) || (laserPower==2 && goodLaser.y == 0 && goodLaser2.y == 0 && goodLaser3.y == 0)) && (AL=="a" || AL=="s" || AL=="d" || AL=="w")            ; if user presses a laser-fire button and y-coord of laser is zero
                .IF AL == "a"
                        mov laserDirection, "l"                 ; if AL = "a" then laser direction is to the left
                .ENDIF
                .IF AL == "s"
                        mov laserDirection, "d"                 ; if AL = "s" then laser direction is down
                .ENDIF
                .IF AL == "d"
                        mov laserDirection, "r"                 ; if AL = "d" then laser direction is to the right
                .ENDIF
                .IF AL == "w"
                        mov laserDirection, "u"                 ; if AL = "w" then laser direction is up
                .ENDIF
                INVOKE GetLocalTime, ADDR sysTime               ; get current time
                movzx EAX, sysTime.wSecond
                movzx EAX, sysTime.wMilliseconds                ; save starting time (in millisec) in AX                
                
                mov mSecondLaser, EAX   ; AX                    ; save milliseconds to start Laser clock
                mov AL, x                                       ; laser starts at position of ship. But doesn't appear onscreen until position one space to the right of ship (handled in Timer PROC)
                mov goodLaser.x, AL                             ; set starting x-position for laser
                mov AL, y
                mov goodLaser.y, AL                             ; set starting y-position for laser (same y-coord as ship)      
               .IF laserPower==2
                .IF laserDirection == "l" || laserDirection == "r"
                        mov AL, x
                        mov goodLaser2.x, AL
                        mov goodLaser3.x, AL
                        mov AL, y
                        dec AL
                        mov goodLaser2.y, AL
                        add AL, 2
                        mov goodLaser3.y, AL
                .ELSEIF laserDirection == "u" || laserDirection == "d"
                        mov AL, x
                        dec AL
                        mov goodLaser2.x, AL
                        add AL, 2
                        mov goodLaser3.x, AL
                        mov AL, y
                        mov goodLaser2.y, AL
                        mov goodLaser3.y, AL
                .ENDIF  
               .ENDIF
        .ENDIF
        
        mov DH, y                     ; sets new parameters for Gotoxy
        mov DL, x

; IF PLAYER RUNS INTO LASER UPGRADE
        .IF laserUpgradePosition.x == DL && laserUpgradePosition.y == DH
                mov laserUpgradeExists, 0
                mov laserUpgradePosition.x, 0
                mov laserUpgradePosition.y, 0
                mov laserPower, 2
                add points, 5000
        .ENDIF

; IF PLAYER RUNS INTO BOMB UPGRADE
        .IF bombUpgradePosition.x == DL && bombUpgradePosition.y == DH
                mov bombUpgradeExists, 0
                mov bombUpgradePosition.x, 0
                mov bombUpgradePosition.y, 0
                mov bombPower, 2
                add points, 5000
        .ENDIF

        call Crashed                         ; takes x and y in DL and DH, returns quit=1 if player crashed
        .IF quit==1
                call DeathDisplay            ; displays full screen death explosion
                jmp EndOfMove                ; jump to end of procedure
        .ENDIF
        call Gotoxy                          ; set new position of ship
        mov EDX, OFFSET character
        call WriteString                     ; print a capital Sigma to represent the player's ship
EndOfMove:
        ret
UserMove ENDP

;################################################################################################

Crashed PROC USES eax
;----------------------------------------------------
; Checks to see if the player crashed into an enemy
; ship or an asteroid.
;
; Receives: DH = player y-coordinate
;           DL = player x-coordinate
; Returns: quit = 1 if player crashed into enemy or asteroid.
;----------------------------------------------------

; SET UP REGISTERS FOR THE LOOP
        mov ECX, EnemyGroup1Num                 ; setting loop counter to...
        add ECX, EnemyGroup2Num                 ; check every enemy's position...
        add ECX, EnemyGroup3Num
        mov EBX, 0                              ; counter to advance through each enemy coordinate pair
; CHECK IF CRASHED INTO ENEMY SHIP
CollisionLoop:
        mov ESI, OFFSET baddiesG1.x             ; point to enemy x-coordinate
        mov AL, BYTE PTR [ESI+EBX]              ; move enemy x-coord into AL
        mov ESI, OFFSET baddiesG1.y             ; point to enemy y-coordinate
        mov AH, BYTE PTR [ESI+EBX]              ; move enemy y-coord into AH
        .IF DL==AL && DH==AH                    ; if player position matches enemy position
                mov quit, 1
                jmp BreakLoop
        .ENDIF
        add EBX, SIZE ENEMY                     ; add 3 bytes because ENEMY structure is 3 bytes
Loop CollisionLoop
; CHECK IF CRASHED INTO AN ASTEROID
        .IF DL==asteroid.x && DH==asteroid.y
                mov quit, 1
        .ENDIF
BreakLoop:
        ret
Crashed ENDP

;################################################################################################

COMMENT #       THIS PROCEDURE IS NOT IMPLEMENTED
EnemiesTouching PROC USES eax ebx ecx esi
; receives DH and DL as y and x position that enemy which called this Proc is trying to move into.
; returns DL and DH as final x and y positions of the enemy ship after contact has been checked for.
.data
        matches BYTE 0
.code
        mov ECX, EnemyGroup1Num                 ; setting loop counter to...
        add ECX, EnemyGroup2Num                 ; check every enemy's position...
        add ECX, EnemyGroup3Num                 ; to check for enemy-on-enemy collisions.
touchLoop:
        mov ESI, OFFSET baddiesG1.x             ; point to enemy x-coordinate
        mov AL, BYTE PTR [ESI+EBX]              ; move enemy x-coord into AL
        mov ESI, OFFSET baddiesG1.y             ; point to enemy y-coordinate
        mov AH, BYTE PTR [ESI+EBX]              ; move enemy y-coord into AH
        .IF DL==AL && DH==AH
                inc matches                     ; increment matches variable
        .ENDIF
Loop touchLoop
        .IF matches > 1                         ; matches=1 just reads the equivalent position of the ship with itself...
                .IF EmovU==1                    ; but match>1 means ship is gonna run into another ship, so don't make a move...
                        mov EmovU, -1           ; by reversing the move in this if-statements, to be added to the DH and DL...
                .ENDIF                          ; registers in this procedure, which are copied into the actual enemy...
                .IF EmovD==1                    ; positions in the calling procedure
                        mov EmovD, -1
                .ENDIF
                .IF EmovR==1
                        mov EmovR, -1
                .ENDIF
                .IF EmovL==1
                        mov EmovL, -1
                .ENDIF
                mov AL, EmovR
                add AL, EmovL                   ; make AL equal reverse x-movement
                mov AH, EmovU
                add AH, EmovD                   ; make AH equal reverse y-movement
                add DL, AL                      ; alter x-movement of ship to produce no movement
                add DH, AH                      ; alter y-movement of ship to produce no movement
        .ENDIF                                  ; end of if-statement for if the ship was gonna run into another ship
        ret
EnemiesTouching ENDP
#

;################################################################################################

yoMove PROC USES eax edx
;----------------------------------------------------
; Handles everything associated with moving each enemy.
; Also gets rid of explosions after enemy death.
; Called by EnemyMovement procedure.
;
; Receives:  ESI = offset to baddiesG1 (array of bad guys)
;----------------------------------------------------
        mov EBX, offsetForBaddies
L3:                                                             ; loops through each member of this particular enemy group

; IF ENEMY IS DEAD
        .IF BYTE PTR [ESI+EBX+2] != 1                           ; if enemy is dead (either gone --> =0, or in a state of explosion --> =2)
                .IF BYTE PTR [ESI+EBX+2]==2                     ; if enemy is in a state of explosion
                        mov DL, BYTE PTR [ESI+EBX]
                        mov DH, BYTE PTR [ESI+EBX+1]
                        call EraseSpot                          ; clear the explosion from the screen
                        mov BYTE PTR [ESI+EBX+2], 0             ; change enemy to dead (explosion gone)
                        mov BYTE PTR [ESI+EBX], 1               ; then make enemy position x=1
                        mov BYTE PTR [ESI+EBX+1], 0             ; and enemy position y=0
                .ENDIF
        .ENDIF

; EXTENSION OF LOOP BEYOND ITS NORMAL MAX LENGTH
        jmp Next                                                ; these 8 lines extend the loop beyond what it could normally go
;       IterateLoop2:
        IterateLoop:
                add EBX, SIZE ENEMY                             ; points ESI to next enemy coordinates (ENEMY structure is 3 bytes)
        Loop L3
;       jmp AfterLoop1
        jmp AfterLoop
        Next:


; IF ENEMY IS ALIVE
; HORIZONTAL MOVEMENT OF ENEMY
        .IF BYTE PTR [ESI+EBX+2] == 1
        ; ERASE THE ENEMY AT THE PREVIOUS POSITION ONSCREEN
                mov DL, BYTE PTR [ESI+EBX]
                mov DH, BYTE PTR [ESI+EBX+1]
                push EDX
                call EraseSpot
                pop EDX

        ; HORIZONTAL MANUEVERS TO AVOID A LASER AND ASTEROID
                push ECX                                        ; save loop counter to stack
                mov CL, goodLaser.x
                mov CH, asteroid.x
;;;;;;;;;;;;;;;;;;;;;;;
.data
        tempL BYTE ?                                            ; temporary variables to be used with determining enemy ship movements
        tempA BYTE ?
;       iterateJump BYTE 0
.code
;;;;;;;;;;;;;;;;;;;;;;;
                mov tempL, CL                                   ; move laser and asteroid x-coords into CL and CH
                mov tempA, CH
                dec CL                                          ; CL and CH = one position to the left of laser and asteroid
                dec CH
                inc tempL                                       ; tempL and tempA = one position to the right of laser and asteroid
                inc tempA
                .IF goodLaser.x==DL || asteroid.x==DL || bombPosition.x==DL             ; if enemy is on same column (same x-coord) as laser/asteroid/bomb
                        mov EAX, 3                                                      ; then enemy move either left, right, or no x-coord motion
                        call RandomRange
                        dec AL                                                          ; turns 0 to 2 range into -1 to 1 range to correspond to chosen change in x-coord
                        add BYTE PTR [ESI+EBX], AL
                .ELSEIF CL == DL || CH == DL || tempL == DL || tempA == DL              ; if moving right would put enemy ship on same x-coord as laser/asteroid
                        mov EAX, 3                                                      ; then randomly move enemy either left, right, or no x-coord motion
                        call RandomRange
                        dec AL                                  ; turns 0 to 2 range into -1 to 1 range to correspond to chosen change in x-coord
                        add BYTE PTR [ESI+EBX], AL
        ; JUST CHASE PLAYER IF NO LASER OR ASTEROID DANGER                      
                .ELSE
                        mov AL, x                               ; setting AL equal to character x-coordinate
                        .IF BYTE PTR [ESI+EBX] > AL             ; if enemy x-position is to the right of player
                                dec BYTE PTR [ESI+EBX]          ; then enemy moves left
                ;               mov EmovL, 1                    ; signifies that the enemy moved left
                        .ELSEIF BYTE PTR [ESI+EBX] < AL         ; if enemy to the right of player
                                inc BYTE PTR [ESI+EBX]          ; then move right
                ;               mov EmovR, 1                    ; signifies that the enemy moved right
                        .ENDIF
                .ENDIF
        ; DON'T LET ENEMY SHIP MOVE INTO THE LEFT AND RIGHT BORDERS OF THE SCREEN
                .IF BYTE PTR [ESI+EBX]==0
                        inc BYTE PTR [ESI+EBX]
                .ELSEIF BYTE PTR [ESI+EBX]==79
                        dec BYTE PTR [ESI+EBX]
                .ENDIF
        ; SET NEW X-COORDINATE FOR Gotoxy PROC
                mov DL, BYTE PTR [ESI+EBX]                      ; set x parameter for later Gotoxy procedure


; JUMP FROM AFTERLOOP1 TO THE END OF THE LOOP WAS TOO BIG, SO AFTERLOOP2 IS ADDED HERE
;       .IF ECX==0
;               AfterLoop1:
;               jmp AfterLoop2
;       .ENDIF

;       .IF iterateJump==1
;               IterateLoop1:
;               jmp IterateLoop2
;       .ENDIF


; VERTICAL MOVEMENT OF ENEMY
        ; VERTICAL MANUEVERS TO AVOID A LASER AND ASTEROID
                mov CL, goodLaser.y
                mov CH, asteroid.y
                mov tempL, CL                                           ; move laser and asteroid y-coords into CL and CH
                mov tempA, CH
                dec CL                                                  ; CL and CH = one position up from laser and asteroid
                dec CH
                inc tempL                                               ; tempL and tempA = one position down from laser and asteroid
                inc tempA
                .IF goodLaser.y==DH || asteroid.y==DH || bombPosition.y==DH             ; if enemy is on same row (same y-coord) as laser/asteroid/bomb
                        mov EAX, 3                                                      ; then enemy move either up, down, or no y-coord motion
                        call RandomRange
                        dec AL                                                          ; turns 0 to 2 range into -1 to 1 range to correspond to chosen change in y-coord
                        add BYTE PTR [ESI+EBX+1], AL
                .ELSEIF CL == DH || CH == DH || tempL == DH || tempA == DH              ; if moving up or down would put enemy ship on same y-coord as laser/asteroid
                        mov EAX, 3                                                      ; then randomly move enemy either up, down, or no y-coord motion
                        call RandomRange
                        dec AL                                           ; turns 0 to 2 range into -1 to 1 range to correspond to chosen change in y-coord
                        add BYTE PTR [ESI+EBX+1], AL
        ; JUST CHASE PLAYER IF NO LASER OR ASTEROID DANGER
                .ELSE   
                        mov AL, y                                        ; setting AL equal to character y-coordinate
                        .IF BYTE PTR [ESI+EBX+1] > AL
                                dec BYTE PTR [ESI+EBX+1]
                ;               mov EmovD, 1                             ; signifies that the enemy moved down
                        .ELSEIF BYTE PTR [ESI+EBX+1] < AL
                                inc BYTE PTR [ESI+EBX+1]
                ;               mov EmovU, 1                             ; signifies that the enemy moved up
                        .ENDIF
                .ENDIF
        ; DON'T LET ENEMY SHIP MOVE INTO THE TOP AND BOTTOM BORDERS OF THE SCREEN
                .IF BYTE PTR [ESI+EBX+1]==0
                        inc BYTE PTR [ESI+EBX+1]
                .ELSEIF BYTE PTR [ESI+EBX+1]==67
                        dec BYTE PTR [ESI+EBX+1]
                .ENDIF

                pop ECX                                 ; restore loop counter to ECX
; WRITING ENEMY TO CORRECT POSITION ON MAP
                mov DH, BYTE PTR [ESI+EBX+1]
        ;       call EnemiesTouching                    ; procedure to see if enemies would overlap positions, and prevent it
        ;       mov BYTE PTR [ESI+EBX+1], DH            ; altering x and y positions according to return values of EnemiesTouching procedure
        ;       mov BYTE PTR [ESI+EBX], DL
                call Gotoxy
                mov EDX, OFFSET char2
                call WriteString                        ; print "O"
; RESETING DIRECTIONAL MOVEMENT FLAGS FOR NEXT LOOP ITERATION
        ;       mov EmovU, 0
        ;       mov EmovD, 0
        ;       mov EmovR, 0
        ;       mov EmovL, 0
        .ENDIF                                          ; possible place to end the ELSE above, not sure if this is right spot
;       mov iterateJump, 1
;       jmp IterateLoop1                                ; these two lines help extend the loop, along with prior code in this PROC
;       AfterLoop2:
        jmp IterateLoop
        AfterLoop:
        ret
yoMove ENDP

;################################################################################################

EnemyMovement PROC
;----------------------------------------------------
; Sets up some data to pass into yoMove procedure.
; Called from Timer procedure.
;
; Receives: EDX = number of enemies in memory before the set of enemies addressed here.
;           ECX = number of enemies in this set, to be used by yoMove as loop counter.
;----------------------------------------------------
    mov EAX, SIZE ENEMY             ; move size of Enemy Data Struct (3 bytes) into AX
    mul EDX                         ; EDX:EAX = EAX * EDX
    mov offsetForBaddies, EAX       ; save product of MUL in offsetForBaddies
    mov ESI, OFFSET baddiesG1
    call yoMove
    ret
EnemyMovement ENDP

;################################################################################################

WaveGenerator PROC USES eax
;----------------------------------------------------
; Called from Timer procedure. Generates the current
; wave of enemies.
;
; Receives: ESI = offset to baddiesG1 (array of enemies)
;           EBX = number that gives a byte offset (to add to location pointed to by ESI) to point to the correct starting point for the wave
;----------------------------------------------------
        mov ECX, 3                                                          ; outer loop counter = number of enemy groups
; OUTER LOOP MOVES THROUGH BADDIE GROUPS 1,2, AND 3 FOR THE WAVE
        WaveOuter:
                push ECX                                                    ; save outer loop counter
                mov EDX, 0                        ; extra inner (little) offset in baddies array, will increment at end of each inner loop (0,3,6,9,12,15,18,21) - points to next enemy.
                mov ECX, 8                                                  ; inner loop counter = how many bad guys from each group (same # in each group) will appear
; INNER LOOP MOVES THROUGH EACH BADDIE IN EACH GROUP FOR THE WAVE
                WaveInner:
                        push EDX
                        add EDX, EBX                    ; combine little (enemy) offset with bigger (group) offset because indirect operand only takes up to two added registers
                        
            .IF BYTE PTR [ESI+EDX+2]==0
                        
                        mov BYTE PTR [ESI+EDX+2], 1                     ; setting this enemy as being alive
                ; RANDOMLY CHOOSING X-COORDINATE FOR ENEMY TO APPEAR AT
                        mov EAX, 2
                        call RandomRange
                        .IF EAX==0
                                mov BYTE PTR [ESI+EDX], 1                       ; x=1
                        .ELSE                                                   ; implied-if: EAX=1
                                mov BYTE PTR [ESI+EDX], 78                      ; x=78
                        .ENDIF
                ; RANDOMLY CHOOSING Y-COORDINATE FOR ENEMY TO APPEAR AT
                        mov EAX, 66
                        call RandomRange
                        inc EAX                                                 ; possible y-coords = 1 to 66
                        mov BYTE PTR [ESI+EDX+1], AL            
                ; PLACING ENEMY ON MAP
                        push ECX                                  ; need to exchange ECX for EDX or else the DH coordinate get screwed up because EDX is used as offset while setting DL
                        mov ECX, EDX
                        mov DL, BYTE PTR [ESI+ECX]                ; copy enemy x-coord into DL
                        mov DH, BYTE PTR [ESI+ECX+1]              ; copy enemy y-coord into DH
                        pop ECX                                   ; restore loop counter to ECX
                        call Gotoxy
                        mov EDX, OFFSET char2
                        call WriteString                          ; print "O"
            .ENDIF
                        pop EDX                                   ; restore inner offset to EDX
                        add EDX, SIZE ENEMY                       ; points to next enemy in group at the next inner loop iteration
                Loop WaveInner  
                pop ECX
                add EBX, 96                                       ; points to next group of enemies at the next outer loop iteration
        Loop WaveOuter
        ret
WaveGenerator ENDP

;################################################################################################

TurnOfSecondsFixer PROC USES eax ebx
;----------------------------------------------------
; Makes an adjustment to the timer variable (in milliseconds)
; associated with each enemy group so that the pass
; of each second (from 999 milliseconds to 0) doesn't
; screw up enemy movement.
;----------------------------------------------------
; makes it so the turn of each second isn't a problem
        mov ESI, OFFSET mSeconds1
        mov EBX, 0                                              ; extra offset in the pointer to go through all mSeconds variables. will increase by 2 bytes each loop iteration
        mov ECX, 3  ; 15                                        ; loop counter. There are 15 mSecond variables.
        TurnSecondLoop:
                .IF WORD PTR [ESI+EBX] > 999
                        sub WORD PTR [ESI+EBX], 1000
                .ENDIF
                add EBX, 2                                      ; next loop points to next mSeconds variable to bytes further
        Loop TurnSecondLoop
        ret
TurnOfSecondsFixer ENDP

;################################################################################################

Timer PROC USES eax ebx edx
;----------------------------------------------------
; Handles everything related to timed events,
; including the countdown game clock, enemy movement, laser movement,
; asteroid movement, release of enemy waves, the timer
; on bombs causing them to explode, and disappearance
; of bomb explosions.
;----------------------------------------------------
        INVOKE GetLocalTime, ADDR sysTime
        movzx EAX, sysTime.wSecond
        movzx EBX, sysTime.wMilliseconds

        call TurnOfSecondsFixer

        push EAX                                       ; save recorded second to stack
        push EBX                                       ; save current millisecond value to be used with each enemy type and asteroids
        push EBX
        push EBX
        push EBX
  
; MOVING PLAYER LASER FORWARD
        .IF laserPower==1 && goodLaser.y != 0          ; if y-coord isn't zero then the LASER EXISTS
                call LaserControl1
        .ELSEIF laserPower==2 && (goodLaser.y != 0 || goodLaser2.y != 0 || goodLaser3.y != 0)
                call LaserControl2
        .ENDIF

; CONTROLS SPEED AND MOVEMENT OF EACH GROUP OF ENEMIES
        pop EBX
        .IF BX > mSeconds1
                mov ECX, EnemyGroup1Num                ; parameter for yoMove (loop counter)
                mov EDX, 0                             ; 0 added offset needed for slowest enemies
                call EnemyMovement
                .IF level==1
                    add BX, 9700        ; 65000 is about one/sec, half of that is two/sec, placing a number in the hundreds place pauses movement for that many hundredths of a second.
                .ELSEIF level==2 || gameType==1
                    add BX, 8700
                .ELSEIF level==3
                    add BX, 6700
                .ELSEIF level==4 || gameType==2
                    add BX, 5700
                .ELSEIF level==5
                    add BX, 4700
                .ENDIF
                mov mSeconds1, BX
        .ENDIF
        pop EBX                                        ; get back millisecond time recorded by sysTime
        .IF BX > mSeconds2
                mov ECX, EnemyGroup2Num                ; parameter for yoMove (loop counter)   
                mov EDX, EnemyGroup1Num                ; move EnemyGroup1Num so it can be multiplied
                call EnemyMovement
                .IF level==1
                    add BX, 15000
                .ELSEIF level==2 || gameType==1
                    add BX, 13000
                .ELSEIF level==3
                    add BX, 11000
                .ELSEIF level==4 || gameType==2
                    add BX, 9000
                .ELSEIF level==5
                    add BX, 7000
                .ENDIF
                mov mSeconds2, BX                      ; move DX into mSeconds
        .ENDIF
        pop EBX                                        ; get back millisecond time recorded by sysTime
        .IF BX > mSeconds3
                mov ECX, EnemyGroup3Num                ; parameter for yoMove (loop counter)   
                mov EDX, EnemyGroup1Num                ; move EnemyGroup1Num so it can be multiplied
                add EDX, EnemyGroup2Num                ; add EnemyGroup2Num to group1, for multiplication
                call EnemyMovement
                .IF level==1
                    add BX, 10400
                .ELSEIF level==2 || gameType==1
                    add BX, 9400
                .ELSEIF level==3
                    add BX, 8400
                .ELSEIF level==4 || gameType==2
                    add BX, 7400
                .ELSEIF level==5
                    add BX, 6400
                .ENDIF    
                mov mSeconds3, BX                      ; move DX into mSeconds
        .ENDIF

; CONTROLS SPEED OF ASTEROID, MAKES ASTEROID MOVE, ERASES ASTEROID AT LAST POSITION
        pop EBX
        .IF asteroid.exists == 1                       ; if asteroid is on the map
        ; CONTROLS THE ASTEROID SPEED
                .IF asteroidSlowDownChange > 0         ; asteroid will only move once if-statement has been hit the number of times set by the variable
                        dec asteroidSlowDownChange
                .ELSE
        ; ERASING ASTEROID AT PREVIOUS LOCATION
                        mov DL, asteroid.x
                        mov DH, asteroid.y
                        call EraseSpot
        ; MOVING THE ASTEROID
                        mov AL, asteroid.MoveX                  ; AL = asteroid.MoveX value
                        mov AH, asteroid.MoveY                  ; AH = asteroid.MoveY value
                        add asteroid.x, AL                      ; change asteroid.x by MoveX value
                        add asteroid.y, AH                      ; change asteroid.y by MoveY value
        ; PRINTING THE ASTEROID
                        mov DL, asteroid.x                      ; set up parameters (x,y coords) for Gotoxy
                        mov DH, asteroid.y
                        push EDX                                ; save DL and DH being x,y-coords of asteroid
                        call Gotoxy
                        mov EDX, OFFSET asteroid.image          ; printing the asteroid.image to screen
                        call WriteString
                        mov AL, asteroidSlowDownPermanent       ; reset the asteroid speed counter for its next movement
                        mov asteroidSlowDownChange, AL
        ; IF ASTEROID HITS BOMB, BOMB EXPLODES, ASTEROID KEEPS GOING
                        pop EDX                                                          ; DL and DH being x,y-coords of asteroid
                        .IF bombLaid==0 && bombPosition.x == DL && bombPosition.y == DH
                                .IF gameType==1
                                        sub bombTime, 4         ; point attack mode counts up, so to explode bomb subtract 4 seconds
                                .ELSE
                                        add bombTime, 4         ; otherwise subtract 4 seconds to explode bomb
                                .ENDIF
                        .ENDIF
        ; CHECK TO SEE IF ASTEROID HIT AN ENEMY SHIP, IF IT DID, BLOW UP THE SHIP
                        mov ECX, EnemyGroup1Num                                 ; these lines set up the loop counter for loop L6       
                        add ECX, EnemyGroup2Num
                        add ECX, EnemyGroup3Num                                 ; loop counter = total number of enemies
                        mov EBX, 0                                              ; EBX = offset to move through arrays of badguys
                        mov ESI, OFFSET baddiesG1                               ; ESI points to arrays of badguys
                        mov DL, asteroid.x
                        mov DH, asteroid.y
                        L6:
                        ; IF ASTEROID DID HIT AN ENEMY
                                .IF BYTE PTR [ESI+EBX] == DL && BYTE PTR [ESI+EBX+1] == DH && BYTE PTR[ESI+EBX+2] == 1  ; if asteroid runs into enemy (has same x,y coords) that is alive.
                                        mov BYTE PTR [ESI+EBX+2], 2                                                                                                                             ; then enemy is dead (alive=1) (just killed=2) (already dead, explosion gone=0)
                                        dec DL                      ; need to decrement DL (x-coord) b/c for some reason the explosion normally occurs one spot back from where it should.
                        ; SHOW EXPLOSION AND RING AUDIOBELL
                                        call EraseSpot                        ; erase laser at current position (just before laser is moved)
                                        mov AL, yellowText                    ; display explosion as yellow
                                        call SetTextColor
                                        mov EDX, OFFSET explosion
                                        call WriteString
                                        mov AL, userColor
                                        call SetTextColor                     ; restore normal colors
                                        mov EDX, OFFSET audioBell
                                        call WriteString
                                .ENDIF
                                add EBX, 3                                    ; add 3 to EBX to point to next badguy in the next loop iteration (ENEMY has 3 bytes)
                        Loop L6
                .ENDIF                     ; end of "if asteroid is going to move this turn"
        .ENDIF                             ; end of "if asteroid exists"

; MAKES ASTEROID DISAPPEAR ONCE IT IS OFF THE SCREEN
        .IF asteroid.exists == 1 && (asteroid.x==0 || asteroid.y < 2 || asteroid.x==79 || asteroid.y==67)
                mov DL, asteroid.x
                mov DH, asteroid.y
                call EraseSpot
                mov asteroid.exists, 0
        .ENDIF 

; FIXES THE SECOND (59 to 0) TURNOVER PROBLEM
        pop EAX                                         ; get recorded second back from stack
        .IF AX==0 && seconds != 0                       ; solves timer problem of seconds switching...
                mov seconds, 0                          ; ...over from 59 to 0 at turn of a minute.
                jmp TurnOfMinute
        .ENDIF

        push EAX
; HANDLING THE TIMER FOR THE PLAYER'S BOMB
        mov DL, bombPosition.x                          ; these two parameters to pass to SearchEnemies procedure and BombExplosion procedure
        mov DH, bombPosition.y
        ; CHECK IF PLAYER RUNS INTO BOMB
        .IF DL==x && DH==y                              ; if player runs into bomb, it explodes and player dies
                call ExplodeBomb
        .ENDIF
; CHECK IF ENEMY RAN INTO BOMB
        mov EAX, 0                                      ; make sure EAX is not 1 before calling SearchEnemies because it returns 1 for something specific
        call SearchEnemies                              ; takes DL and DH as parameters, returns EAX=1 if enemy ship hit the bomb
        .IF EAX==1                                      ; if enemy ship hits bomb it explodes, player gets points
                sub points, 1000                        ; subtracting one kill worth of points if enemy hit bomb because the points will be counted both now and...
                call ExplodeBomb                        ; ...when BombExplosion PROC calls SearchEnemies to see what ships were in the explosion.
        .ENDIF
; WHEN TIME HAS RUN OUT ON THE BOMB (OR IF SOMETHING HITS IT) IT EXPLODES
        mov EAX, bombTime
        .IF gameType==1                                 ; in Point Attack mode clock counts up
                .IF countdown >= AX                     ; if 4 seconds have passed on the countdown since the bomb was laid, then blow it up
                        call ExplodeBomb
                .ENDIF
        .ELSE                                           ; in Swarm and main game modes clock counts down
                .IF countdown <= AX                     ; if 4 seconds have passed on the countdown since the bomb was laid, then blow it up
                        call ExplodeBomb
                .ENDIF
        .ENDIF
; MAKING BOMB EXPLOSION FADE AWAY (IF ENEMY FLIES INTO DEBRIS OF EXPLOSION THEY DIE)
        mov EAX, bombExplodeTimer
        .IF (countdown <= AX && gameType != 1) || (countdown >= AX && gameType==1)      ; if bomb explosion needs to fade away (2 seconds on countdown clock have passed)
                mov DL, bombExplodeX                                                    ; save bomb explosion starting coordinates to DL and DH
                mov DH, bombExplodeY
                
                .IF bombPower==1
                        mov ECX, 5                         ; outer loop counter (15 squares blow up - a 3x5 (row x col) grid)
                .ELSEIF bombPower==2
                        mov ECX, 11                        ; outer loop counter: upgraded bomb explosion takes up 11 columns (77 squares - a 7x11 (row x col) grid)
                .ENDIF
                BombGridX:                                 ; Outer Loop, incrementing through x-coordinates
                        push ECX                           ; save outer loop counter
                        .IF bombPower==1
                                mov ECX, 3                 ; inner loop counter - explosion takes up 3 rows
                        .ELSEIF bombPower==2
                                mov ECX, 7                 ; inner loop counter - upgraded bomb explosion takes up 7 rows
                        .ENDIF
                        BombGridY:
                                call Gotoxy                ; move cursor to current spot on bombgrid
                                call SearchEnemies         ; see if any enemies were in the explosion, if they were then they are blown up
                                push EDX                   ; save coordinates to stack
                                mov EDX, OFFSET blank      ; erase explosion from this position
                                call WriteString
                                pop EDX                    ; restore coordinate from stack into EDX
                                inc DH                     ; increment y-coord.
                        Loop BombGridY
                        pop ECX                            ; pop outer loop counter back into ECX for outer loop iteration
                        .IF bombPower==1
                                sub DH, 3                  ; subtract 3 from y-coord to get it back to top of explosion for next loop iteration
                        .ELSEIF bombPower==2
                                sub DH, 7                  ; to get y-coord back to top of explosion in upgraded bomb explosion
                        .ENDIF                  
                        inc DL                             ; increment x-coord.
                Loop BombGridX
                .IF gameType == 1
                        mov bombExplodeTimer, 10000        ; During Point Attack Mode, this timer is at 10,000 except while explosion in on the map
                .ELSE
                        mov bombExplodeTimer, 0            ; this timer is at zero except while explosion in on the map
                .ENDIF
        .ENDIF

        pop EAX

; CODE TO EXECUTE ONCE A SECOND HAS PASSED
        .IF AX > seconds                                   ; if current time is greater than previous time
            inc seconds                                    ; increment seconds to keep up with clock
        TurnOfMinute:                                      ; see the comment above, just before code for handling the bomb timer starts
        
        ; DECIDES IF AN ASTEROID SHOWS UP, AND INITIALIZES ITS VALUES
                movzx EAX, asteroidFrequency                    ; passing EAX parameter to RandomRange, which returns in EAX too.
                call RandomRange
                .IF asteroid.exists==0 && EAX==0                ; if there's no current asteroid and if RandomRange returned 0 then asteroid is coming
                        mov asteroid.exists, 1                  ; set the asteroid to it existing
                        mov EAX, 5                              ; 5 options for asteroid image to be displayed onscreen
                        call RandomRange                        ; returns in EAX extra offset to point to chosen asteroid image (EAX = 0 thru 4)
                        mov ESI, OFFSET asteroidImage           ; pointer to array of 5 asteroid images
                        mov AL, BYTE PTR [ESI+EAX]              ; randomly chosen image of asteroid moved into AL
                        mov asteroid.image, AL                  ; puts chosen image of asteroid in Astro object
                ; HANDLES STARTING PLACEMENT AND MOVEMENT DIRECTION OF ASTEROID
                        mov EAX, 4
                        call RandomRange                                ; 4 choices (astroid starts at x=0, x=79, y=0, or y=67)
                        .IF EAX <= 1                                    ; if RandomRange returned 0 or 1 (asteroid x-coord. is set, randomly generate y-coord)
                                push EAX
                                mov EAX, 65
                                call RandomRange
                                add EAX, 2                              ; asteroid can choose from 66 y-values to start, 2->66 (not on edges of screen)
                                mov asteroid.y, AL                      ; copy result of RandomRange into asteroid.y coordinate
                                mov EAX, 3
                                call RandomRange                        ; will return EAX = 0, 1, or 2
                                .IF EAX==0
                                        mov asteroid.MoveY, -1          ; asteroid will decrement y with each movement
                                .ELSEIF EAX==1
                                        mov asteroid.MoveY, 0           ; asteroid not change it's y-coordinate during motion
                                .ELSE                                                           ; implied-if: EAX = 2
                                        mov asteroid.MoveY, 1           ; asteroid will increment y with each movement
                                .ENDIF
                                pop EAX
                                .IF EAX==0
                                        mov asteroid.x, 1       ; 0
                                        mov asteroid.MoveX, 1           ; asteroid will increment x with each movement
                                .ELSEIF EAX==1
                                        mov asteroid.x, 78
                                        mov asteroid.MoveX, -1          ; asteroid will decrement x with each movement
                                .ENDIF
                        .ELSE                                           ; implied-if: RandomRange returned 2 or 3
                                push EAX
                                mov EAX, 78
                                call RandomRange
                                add EAX, 1                              ; asteroid can choose from 78 y-values to start, 1->78 (not on the edges of screen)
                                mov asteroid.x, AL                      ; copy result of RandomRange into asteroid.y coordinate
                                mov EAX, 3
                                call RandomRange                        ; will return EAX = 0, 1, or 2
                                .IF EAX==0
                                        mov asteroid.MoveX, -1          ; asteroid will decrement x with each movement
                                .ELSEIF EAX==1
                                        mov asteroid.MoveX, 0           ; asteroid not change it's x-coordinate during motion
                                .ELSE                                   ; implied-if: EAX = 2
                                        mov asteroid.MoveX, 1           ; asteroid will increment x with each movement
                                .ENDIF
                                pop EAX
                                .IF EAX==2
                                        mov asteroid.y, 1       ; 0
                                        mov asteroid.MoveY, 1           ; asteroid will increment y with each movement
                                .ELSEIF EAX==3
                                        mov asteroid.y, 66
                                        mov asteroid.MoveY, -1          ; asteroid will decrement y with each movement
                                .ENDIF
                        .ENDIF
                .ENDIF

        ; HANDLES THE WAVES OF ENEMIES - 4 WAVES OF 8 ENEMIES FROM EACH OF 3 GROUPS (4 WAVES OF 32 ENEMIES)
                mov EBX, 0                              ; clearing EBX
                movzx EAX, wave1time
                mov ESI, OFFSET baddiesG1
                mov BX, 0                               ; extra outer offset in baddies array, will increment at end of each outer loop (0,96,192) - points to next group
                mov CX, 0                               ; extra offset related to the wave number(wave1,2,3,4: 0, 24, 48, 72) (+24 each time b/c 8-Enemies * 3-Bytes each)
                add BX, CX                              ; now EBX equal to outer (group) offset + wave offset. ECX doesn't matter b/c it'll be set as loop counter in WaveGenerator proc.
        ; WAVE 1
                .IF countdown == AX                     ; if countdown has reached when wave 1 will be released
                        call WaveGenerator
                .ENDIF
                .IF AX < countdown && gameType==1       ; if playing Point Attack and wave1time has passed
                    add wave1time, 40
                .ELSEIF AX > countdown && gameType==2   ; if playing Swarm and wave1time has passed
                    sub wave1time, 30
                .ENDIF
        ; WAVE 2
                movzx EAX, wave2time
                mov BX, 0                               ; extra outer offset in baddies array, will increment at end of each outer loop (0,96,192) - points to next group
                mov CX, 24                              ; extra offset related to the wave number(wave1,2,3,4: 0, 24, 48, 72) (+24 each time b/c 8-Enemies * 3-Bytes each)
                add BX, CX                              ; now EBX equal to outer (group) offset + wave offset. ECX doesn't matter b/c it'll be set as loop counter in WaveGenerator proc.
                .IF countdown == AX
                        call WaveGenerator              ; creates wave of enemies
                .ENDIF
                .IF AX < countdown && gameType==1       ; if playing Point Attack and wave1time has passed
                    add wave2time, 40
                .ELSEIF AX > countdown && gameType==2   ; if playing Swarm and wave1time has passed
                    sub wave2time, 30
                .ENDIF
        ; WAVE 3
                movzx EAX, wave3time
                mov BX, 0                               ; extra outer offset in baddies array, will increment at end of each outer loop (0,96,192) - points to next group
                mov CX, 48                              ; extra offset related to the wave number(wave1,2,3,4: 0, 24, 48, 72) (+24 each time b/c 8-Enemies * 3-Bytes each)
                add BX, CX                              ; now EBX equal to outer (group) offset + wave offset. ECX doesn't matter b/c it'll be set as loop counter in WaveGenerator proc.
                .IF countdown == AX
                        call WaveGenerator
                .ENDIF
                .IF AX < countdown && gameType==1       ; if playing Point Attack and wave1time has passed
                    add wave3time, 40
                .ELSEIF AX > countdown && gameType==2   ; if playing Swarm and wave1time has passed
                    sub wave3time, 30
                .ENDIF
        ; WAVE 4
                movzx EAX, wave4time
                mov BX, 0                               ; extra outer offset in baddies array, will increment at end of each outer loop (0,96,192) - points to next group
                mov CX, 72                              ; extra offset related to the wave number(wave1,2,3,4: 0, 24, 48, 72) (+24 each time b/c 8-Enemies * 3-Bytes each)
                add BX, CX                              ; now EBX equal to outer (group) offset + wave offset. ECX doesn't matter b/c it'll be set as loop counter in WaveGenerator proc.
                .IF countdown == AX
                        call WaveGenerator
                .ENDIF
                .IF AX < countdown && gameType==1       ; if playing Point Attack and wave1time has passed
                    add wave4time, 40
                .ELSEIF AX > countdown && gameType==2   ; if playing Swarm and wave1time has passed
                    sub wave4time, 30
                .ENDIF

        ; LASER UPGRADE
                .IF laserUpgradeExists==0                               ; if laser upgrade is not on the map
                        mov EAX, 50
                        call RandomRange                                ; upgrade will show up on average once every 50 seconds
                        .IF EAX==0
                                mov EAX, 74
                                call RandomRange
                                add AL, 3
                                mov laserUpgradePosition.x, AL          ; setting random x-coord of upgrade (from 3 to 76)
                                mov EAX, 58
                                call RandomRange
                                add AL, 5
                                mov laserUpgradePosition.y, AL          ; setting random y-coord of upgrade (from 5 to 62)
                                mov laserUpgradeExists, 1               ; tell program upgrade is on the map
                                mov AX, countdown
                                mov laserUpgradeStartTime, AL           ; holds time when upgrade appeared...
                                .IF gameType==1
                                        add laserUpgradeStartTime, 8    ; During Point Attack Mode, plus 8 seconds, because that's how long the upgrade stays on the map
                                .ELSE
                                        sub laserUpgradeStartTime, 8    ; minus 8 seconds, because that's how long the upgrade stays on the map
                                .ENDIF
                        .ENDIF
                .ENDIF

        ; EVERYTIME TIMER PROC IS CALLED RE-DISPLAY LASER UPGRADE IF IT IS ON THE MAP
                .IF laserUpgradeExists==1
                        mov AX, countdown
                ; FOR POINT ATTACK MODE
                        .IF gameType==1
                                .IF laserUpgradeStartTime > AL                          ; if laser time variable > countdown it'll be printed out continuousy
                                        mov DL, laserUpgradePosition.x
                                        mov DH, laserUpgradePosition.y
                                        call Gotoxy                                     ; move cursor to upgrade position
                                        mov AL, laserUpgradeColor
                                        call SetTextColor                               ; change color to upgrade color
                                        mov EDX, OFFSET laserUpgrade
                                        call WriteString                                ; print out laser
                                        mov AL, userColor
                                        call SetTextColor                               ; restore normal colors
                                .ELSEIF laserUpgradeStartTime <= AL                     ; if laser time variable <= countdown it'll be taken off map
                                        mov laserUpgradeExists, 0
                                        mov DL, laserUpgradePosition.x
                                        mov DH, laserUpgradePosition.y
                                        call EraseSpot
                                        mov laserUpgradePosition.x, 0
                                        mov laserUpgradePosition.y, 0
                                .ENDIF
                ; FOR MAIN GAME MODE AND SWARM MODE
                        .ELSE
                                .IF laserUpgradeStartTime < AL                          ; if laser time variable < countdown it'll be printed out continuousy
                                        mov DL, laserUpgradePosition.x
                                        mov DH, laserUpgradePosition.y
                                        call Gotoxy                                     ; move cursor to upgrade position
                                        mov AL, laserUpgradeColor
                                        call SetTextColor                               ; change color to upgrade color
                                        mov EDX, OFFSET laserUpgrade
                                        call WriteString                                ; print out laser
                                        mov AL, userColor
                                        call SetTextColor                               ; restore normal colors
                                .ELSEIF laserUpgradeStartTime >= AL                     ; if laser time variable >= countdown it'll be taken off map
                                        mov laserUpgradeExists, 0
                                        mov DL, laserUpgradePosition.x
                                        mov DH, laserUpgradePosition.y
                                        call EraseSpot
                                        mov laserUpgradePosition.x, 0
                                        mov laserUpgradePosition.y, 0
                                .ENDIF
                        .ENDIF
                .ENDIF

        ; BOMB UPGRADE
                .IF bombUpgradeExists==0                                ; if bomb upgrade is not on the map
                        mov EAX, 50
                        call RandomRange                                ; upgrade will show up on average once every 50 seconds
                        .IF EAX==0
                                mov EAX, 74
                                call RandomRange
                                add AL, 3
                                mov bombUpgradePosition.x, AL           ; setting random x-coord of upgrade (from 3 to 76)
                                mov EAX, 58
                                call RandomRange
                                add AL, 5
                                mov bombUpgradePosition.y, AL           ; setting random y-coord of upgrade (from 5 to 62)
                                mov bombUpgradeExists, 1                ; tell program upgrade is on the map
                                mov AX, countdown
                                mov bombUpgradeStartTime, AL            ; holds time when upgrade appeared...
                                .IF gameType==1
                                        add bombUpgradeStartTime, 8     ; During Point Attack Mode, plus 8 seconds, because that's how long the upgrade stays on the map
                                .ELSE
                                        sub bombUpgradeStartTime, 8     ; minus 8 seconds, because that's how long the upgrade stays on the map
                                .ENDIF
                        .ENDIF
                .ENDIF

        ; EVERYTIME TIMER PROC IS CALLED RE-DISPLAY BOMB UPGRADE IF IT IS ON THE MAP
                .IF bombUpgradeExists==1
                        mov AX, countdown
                ; FOR POINT ATTACK MODE
                        .IF gameType==1
                                .IF  bombUpgradeStartTime > AL                   ; if bomb time variable > countdown it'll be printed out
                                        mov DL, bombUpgradePosition.x
                                        mov DH, bombUpgradePosition.y
                                        call Gotoxy                              ; move cursor to upgrade position
                                        mov AL, bombUpgradeColor
                                        call SetTextColor                        ; change color to upgrade color
                                        mov EDX, OFFSET bombUpgrade
                                        call WriteString                         ; print out bomb
                                        mov AL, userColor
                                        call SetTextColor                        ; restore normal colors
                                .ELSEIF bombUpgradeStartTime <= AL
                                        mov bombUpgradeExists, 0                 ; if bomb time variable <= countdown it'll be taken off map
                                        mov DL, bombUpgradePosition.x
                                        mov DH, bombUpgradePosition.y
                                        call EraseSpot
                                        mov bombUpgradePosition.x, 0
                                        mov bombUpgradePosition.y, 0
                                .ENDIF
                ; FOR MAIN GAME MODE AND SWARM MODE
                        .ELSE
                                .IF  bombUpgradeStartTime < AL                   ; if bomb time variable < countdown it'll be printed out
                                        mov DL, bombUpgradePosition.x
                                        mov DH, bombUpgradePosition.y
                                        call Gotoxy                              ; move cursor to upgrade position
                                        mov AL, bombUpgradeColor
                                        call SetTextColor                        ; change color to upgrade color
                                        mov EDX, OFFSET bombUpgrade
                                        call WriteString                         ; print out bomb
                                        mov AL, userColor
                                        call SetTextColor                        ; restore normal colors
                                .ELSEIF bombUpgradeStartTime >= AL      
                                        mov bombUpgradeExists, 0                 ; if bomb time variable >= countdown it'll be taken off map
                                        mov DL, bombUpgradePosition.x
                                        mov DH, bombUpgradePosition.y
                                        call EraseSpot
                                        mov bombUpgradePosition.x, 0
                                        mov bombUpgradePosition.y, 0
                                .ENDIF
                        .ENDIF
                .ENDIF

        ; HANDLING THE COUNTDOWN TIMER
                .IF gameType==1
                        inc countdown                ; if playing in Point Attack mode count up
                .ELSE
                        dec countdown                ; otherwise count down
                .ENDIF
                mov DH, timerY                       ; set cursor to timer location
                mov DL, timerX
                push EDX                             ; pushed thrice because it'll be popped thrice
                push EDX
                push EDX
                call EraseSpot                       ; erase previous timer numbers
                pop EDX
                inc DL
                call EraseSpot                       ; erasing done
                pop EDX
                inc DL
                call EraseSpot
                pop EDX
                .IF gameType != 1
                        .IF countdown == 99
                                inc timerX
                                mov DL, timerX
                        .ENDIF
                .ENDIF
                call Gotoxy                          ; set cursor to timer location
                movzx EAX, countdown                 ; write new time to screen
                call WriteDec
        .ENDIF
        ret
TIMER ENDP

;################################################################################################

LaserControl1 PROC
;----------------------------------------------------
; Handles the movement on screen of the default
; (single) laser. Checks to see if laser hit an
; asteroid, ran off the edge of the screen, hit an
; enemy ship, or hit a bomb.
;----------------------------------------------------
; ERASE LASER AT PREVIOUS SPOT
        mov DL, goodLaser.x                             ; move laser x-coord into DL
        mov DH, goodLaser.y                             ; move laser y-coord into DH
        call EraseSpot                                  ; erase laser at current position (just before laser is moved)

; HANDLES THE DIRECTION AND ASCII SYMBOL FOR THE LASER
        .IF laserDirection=="r"                         ; shooting laser right
                inc goodLaser.x                         ; set new laser position on screen (incrementing x-coord)
                mov pewpew, "-"
        .ENDIF
        .IF laserDirection=="l"                         ; shooting laser left
                dec goodLaser.x                         ; set new laser position on screen (decrementing x-coord)
                mov pewpew, "-"
        .ENDIF
        .IF laserDirection=="u"                         ; shooting laser up
                dec goodLaser.y                         ; set new laser position on screen (decrementing y-coord)
                mov pewpew, 179                         ; a vertical bar
        .ENDIF
        .IF laserDirection=="d"                         ; shooting laser down
                inc goodLaser.y                         ; set new laser position on screen (incrementing y-coord)
                mov pewpew, 179                         ; a vertical bar
        .ENDIF

; CHECKS TO SEE IF LASER HIT ASTEROID
        mov DL, goodLaser.x                             ; set new laser position as parameters for Gotoxy
        mov DH, goodLaser.y
        .IF DL==asteroid.x && DH==asteroid.y
                mov goodLaser.x, 0
                mov goodLaser.y, 0
        .ELSE
; HANDLES THE OUTPUTTING OF THE LASER
                call Gotoxy
                mov AL, greenText                       ; set green color for player laser
                call SetTextColor
                mov EDX, OFFSET pewpew                  ; output the laser ("-") onscreen
                call WriteString
                mov AL, userColor                       ; set text color back to normal
                call SetTextColor
        .ENDIF
; TURNS OFF LASER WHEN IT HAS RUN OFF THE SCREEN
        .IF goodLaser.x==77 || goodLaser.x==2  || goodLaser.y==4  || goodLaser.y==63                    ; turn off laser once it has gone across the screen
                mov DL, goodLaser.x                     ; move laser x-coord into DL
                mov DH, goodLaser.y                     ; move laser y-coord into DH
                call EraseSpot
                mov goodLaser.x, 0                      ; make x-coord = 0
                mov goodLaser.y, 0                      ; make y-coord = 0
        .ENDIF

; CHECK FOR PLAYER-LASER HIT ON ENEMY SHIPS AT EACH MOVEMENT OF LASER, ALSO TURNS OFF LASER IF HIT OCCURRED
        mov DL, goodLaser.x
        mov DH, goodLaser.y
        mov AH, 0                                       ; AH = 0 tells HitEnemyWithLaser to stop goodLaser in the case of an enemy hit
        call HitEnemyWithLaser
                
; IF PLAYER'S LASER HITS BOMB THE BOMB WILL EXPLODE AND LASER WILL BE GONE
        mov AL, goodLaser.x
        mov AH, goodLaser.y
        .IF bombLaid==0 && bombPosition.x == AL && bombPosition.y == AH
                .IF gameType==1
                        sub bombTime, 4                 ; point attack mode counts up, so to explode bomb subtract 4 seconds
                .ELSE
                        add bombTime, 4                 ; otherwise subtract 4 seconds to explode bomb
                .ENDIF
                mov goodLaser.x, 0
                mov goodLaser.y, 0
        .ENDIF
        ret
LaserControl1 ENDP

;################################################################################################

LaserControl2 PROC
;----------------------------------------------------
; Handles the movement on screen of the upgraded
; (triple) laser. Checks to see if laser hit an
; asteroid, ran off the edge of the screen, hit an
; enemy ship, or hit a bomb.
;----------------------------------------------------
; ERASE LASER AT PREVIOUS SPOT
        mov DL, goodLaser.x                             ; move laser x-coord into DL
        mov DH, goodLaser.y                             ; move laser y-coord into DH
        call EraseSpot                                  ; erase laser at current position (just before laser is moved)
        mov DL, goodLaser2.x                            ; move laser x-coord into DL
        mov DH, goodLaser2.y                            ; move laser y-coord into DH
        call EraseSpot                                  ; erase laser at current position (just before laser is moved)
        mov DL, goodLaser3.x                            ; move laser x-coord into DL
        mov DH, goodLaser3.y                            ; move laser y-coord into DH
        call EraseSpot                                  ; erase laser at current position (just before laser is moved)
        
; HANDLES THE DIRECTION AND ASCII SYMBOL FOR THE LASER
        .IF laserDirection=="r"                         ; shooting laser right
                .IF goodLaser.y != 0
                        inc goodLaser.x                 ; set new laser position on screen (incrementing x-coord)
                .ENDIF
                .IF goodLaser2.y != 0
                        inc goodLaser2.x
                .ENDIF
                .IF goodLaser3.y != 0
                        inc goodLaser3.x
                .ENDIF
                mov pewpew, 179                         ; vertical bar
        .ENDIF
        .IF laserDirection=="l"                         ; shooting laser left
                .IF goodLaser.y != 0
                        dec goodLaser.x                 ; set new laser position on screen (decrementing x-coord)
                .ENDIF
                .IF goodLaser2.y != 0
                        dec goodLaser2.x
                .ENDIF
                .IF goodLaser3.y != 0
                        dec goodLaser3.x
                .ENDIF
                mov pewpew, 179                         ; vertical bar
        .ENDIF
        .IF laserDirection=="u"                         ; shooting laser up
                .IF goodLaser.y != 0
                        dec goodLaser.y                 ; set new laser position on screen (decrementing y-coord)
                .ENDIF
                .IF goodLaser2.y != 0
                        dec goodLaser2.y
                .ENDIF
                .IF goodLaser3.y != 0
                        dec goodLaser3.y
                .ENDIF
                mov pewpew, 196                         ; horizontal bar
        .ENDIF
        .IF laserDirection=="d"                         ; shooting laser down
                .IF goodLaser.y != 0
                        inc goodLaser.y                 ; set new laser position on screen (incrementing y-coord)
                .ENDIF
                .IF goodLaser2.y != 0
                        inc goodLaser2.y
                .ENDIF
                .IF goodLaser3.y != 0
                        inc goodLaser3.y
                .ENDIF
                mov pewpew, 196                         ; horizontal bar
        .ENDIF

; CHECKS TO SEE IF LASER HIT ASTEROID
        mov DL, goodLaser.x                             ; set new laser position as parameters for Gotoxy
        mov DH, goodLaser.y
        mov CL, goodLaser2.x
        mov CH, goodLaser2.y
        mov BL, goodLaser3.x
        mov BH, goodLaser3.y
        .IF DL==asteroid.x && DH==asteroid.y
                mov goodLaser.x, 0
                mov goodLaser.y, 0
        .ENDIF
        .IF CL==asteroid.x && CH==asteroid.y
                mov goodLaser2.x, 0
                mov goodLaser2.y, 0
        .ENDIF
        .IF BL==asteroid.x && BH==asteroid.y
                mov goodLaser3.x, 0
                mov goodLaser3.y, 0
        .ENDIF

; HANDLES THE OUTPUTTING OF THE LASER
        ; SHOOTING HORIZONTALLY
        .IF laserDirection=="r" || laserDirection=="l"
        
        ; OUTPUT MIDDLE LASER
                .IF goodLaser.y != 0
                        call Gotoxy
                        mov AL, greenText               ; set green color for player laser
                        call SetTextColor
                        mov EDX, OFFSET pewpew          ; output the laser onscreen
                        call WriteString
                .ENDIF

        ; OUTPUT TOP LASER
                .IF goodLaser2.y != 0
                        mov DX, CX                      ; CX holds coordinates of goodLaser2
                        call Gotoxy
                        mov AL, greenText               ; set green color for player laser
                        call SetTextColor
                        mov EDX, OFFSET pewpew          ; output the laser onscreen
                        call WriteString
                .ENDIF

        ; OUTPUT BOTTOM LASER
                .IF goodLaser3.y != 0
                        mov DX, BX                      ; BX holds coordinates of goodLaser3
                        call Gotoxy
                        mov AL, greenText               ; set green color for player laser
                        call SetTextColor
                        mov EDX, OFFSET pewpew          ; output the laser onscreen
                        call WriteString
                .ENDIF

        ; SET DEFAULT COLORS
                mov AL, userColor                       ; set text color back to normal
                call SetTextColor

        ; SHOOTING VERTICALLY
        .ELSEIF laserDirection=="u" || laserDirection=="d"
        
        ; OUTPUT MIDDLE LASER
                .IF goodLaser.y != 0
                        mov DL, goodLaser.x
                        mov DH, goodLaser.y
                        call Gotoxy
                        mov AL, greenText               ; set green color for player laser
                        call SetTextColor
                        mov EDX, OFFSET pewpew          ; output the laser onscreen
                        call WriteString
                .ENDIF
                
        ; OUTPUT LEFT LASER
                .IF goodLaser2.y != 0
                        mov DX, CX                      ; CX holds coordinates of goodLaser2
                        call Gotoxy
                        mov AL, greenText               ; set green color for player laser
                        call SetTextColor
                        mov EDX, OFFSET pewpew          ; output the laser onscreen
                        call WriteString
                .ENDIF

        ; OUTPUT RIGHT LASER
                .IF goodLaser3.y != 0
                        mov DX, BX                      ; BX holds coordinates of goodLaser3
                        call Gotoxy
                        mov AL, greenText               ; set green color for player laser
                        call SetTextColor
                        mov EDX, OFFSET pewpew          ; output the laser onscreen
                        call WriteString
                .ENDIF

        ; SET DEFAULT COLORS
                mov AL, userColor                       ; set text color back to normal
                call SetTextColor
        .ENDIF

; TURNS OFF LASER WHEN IT HAS RUN OFF THE SCREEN
; MIDDLE LASER
        .IF goodLaser.x==77 || goodLaser.x==2  || goodLaser.y==4  || goodLaser.y==63                    ; turn off laser once it has gone across the screen
                mov DL, goodLaser.x                     ; move laser x-coord into DL
                mov DH, goodLaser.y                     ; move laser y-coord into DH
                call EraseSpot
                mov goodLaser.x, 0                      ; make x-coord = 0
                mov goodLaser.y, 0                      ; make y-coord = 0
        .ENDIF
; TOP OR LEFT LASER     
        .IF goodLaser2.x==77 || goodLaser2.x==2  || goodLaser2.y==4  || goodLaser2.y==63                        ; turn off laser once it has gone across the screen
                mov DL, goodLaser2.x                    ; move laser x-coord into DL
                mov DH, goodLaser2.y                    ; move laser y-coord into DH
                call EraseSpot
                mov goodLaser2.x, 0                     ; make x-coord = 0
                mov goodLaser2.y, 0                     ; make y-coord = 0
        .ENDIF
; BOTTOM OR RIGHT LASER
        .IF goodLaser3.x==77 || goodLaser3.x==2  || goodLaser3.y==4  || goodLaser3.y==63                        ; turn off laser once it has gone across the screen
                mov DL, goodLaser3.x                    ; move laser x-coord into DL
                mov DH, goodLaser3.y                    ; move laser y-coord into DH
                call EraseSpot
                mov goodLaser3.x, 0                     ; make x-coord = 0
                mov goodLaser3.y, 0                     ; make y-coord = 0
        .ENDIF

; CHECK FOR PLAYER-LASER HIT ON ENEMY SHIPS AT EACH MOVEMENT OF LASER, ALSO TURNS OFF LASER IF HIT OCCURRED
        mov DL, goodLaser.x
        mov DH, goodLaser.y
        mov AH, 0                                       ; HitEnemyWithLaser PROC uses AH to determine which laser to turn off in the case of a hit
        call HitEnemyWithLaser
        mov DL, goodLaser2.x
        mov DH, goodLaser2.y
        mov AH, 1
        call HitEnemyWithLaser
        mov DL, goodLaser3.x
        mov DH, goodLaser3.y
        mov AH, 2
        call HitEnemyWithLaser

; IF PLAYER'S LASER HITS BOMB THE BOMB WILL EXPLODE AND LASER WILL BE GONE
        mov AL, goodLaser.x
        mov AH, goodLaser.y
        mov BL, goodLaser2.x
        mov BH, goodLaser2.y
        mov CL, goodLaser3.x
        mov CH, goodLaser3.y
        .IF bombLaid==0 && bombPosition.x == AL && bombPosition.y == AH
                .IF gameType==1
                        sub bombTime, 4                 ; point attack mode counts up, so to explode bomb subtract 4 seconds
                .ELSE
                        add bombTime, 4                 ; otherwise subtract 4 seconds to explode bomb
                .ENDIF
                mov goodLaser.x, 0
                mov goodLaser.y, 0
        .ELSEIF bombLaid==0 && bombPosition.x == BL && bombPosition.y == BH
                .IF gameType==1
                        sub bombTime, 4                 ; point attack mode counts up, so to explode bomb subtract 4 seconds
                .ELSE
                        add bombTime, 4                 ; otherwise subtract 4 seconds to explode bomb
                .ENDIF
                mov goodLaser2.x, 0
                mov goodLaser2.y, 0
        .ELSEIF bombLaid==0 && bombPosition.x == CL && bombPosition.y == CH
                .IF gameType==1
                        sub bombTime, 4                 ; point attack mode counts up, so to explode bomb subtract 4 seconds
                .ELSE
                        add bombTime, 4                 ; otherwise subtract 4 seconds to explode bomb
                .ENDIF
                mov goodLaser3.x, 0
                mov goodLaser3.y, 0
        .ENDIF
        ret
LaserControl2 ENDP

;################################################################################################

HitEnemyWithLaser PROC
;----------------------------------------------------
; Called from LaserControl1 and LaserControl2
; procedures. Checks to see if the laser hit an
; enemy ship.
;----------------------------------------------------
        mov ECX, EnemyGroup1Num                ; these lines set up the loop counter for loop L5       
        add ECX, EnemyGroup2Num
        add ECX, EnemyGroup3Num                ; loop counter = total number of enemies
        mov EBX, 0                             ; EBX = offset to move through arrays of badguys
        mov ESI, OFFSET baddiesG1              ; ESI points to arrays of badguys
        .REPEAT
        ; IF LASER DID HIT AN ENEMY
                .IF BYTE PTR [ESI+EBX] == DL && BYTE PTR [ESI+EBX+1] == DH && BYTE PTR[ESI+EBX+2] == 1          ; if laser runs into enemy (has same x,y coords) that is alive
                        mov BYTE PTR [ESI+EBX+2], 2                                                             ; then enemy is dead (alive=1) (just killed=2) (already dead, explosion gone=0)
                        dec DL                                   ; need to decrement DL (x-coord) b/c for some reason the explosion normally occurs one spot back from where it should
        ; STOP AND REMOVE THE LASER ONCE IT HAS HIT AN ENEMY
                        call EraseSpot                           ; erase laser at current position (just before laser is moved)
                        mov AL, yellowText                       ; display explosion as yellow
                        call SetTextColor
                        .IF AH==0
                                mov goodLaser.x, 0               ; make x-coord = 0
                                mov goodLaser.y, 0               ; make y-coord = 0
                        .ELSEIF AH==1
                                mov goodLaser2.x, 0              ; make x-coord = 0
                                mov goodLaser2.y, 0              ; make y-coord = 0
                        .ELSEIF AH==2
                                mov goodLaser3.x, 0              ; make x-coord = 0
                                mov goodLaser3.y, 0              ; make y-coord = 0
                        .ENDIF
                        mov EDX, OFFSET explosion
                        call WriteString
                        mov AL, userColor
                        call SetTextColor                        ; restore normal colors
                        mov EDX, OFFSET audioBell
                        call WriteString
                        add points, 1000                         ; 1000 points for destroying an enemy ship
                .ENDIF
                add EBX, SIZE ENEMY                              ; add 3 to EBX to point to next badguy in the next loop iteration (ENEMY has 3 bytes)
                dec ECX 
        .UNTIL ECX==0
        ret
HitEnemyWithLaser ENDP

;################################################################################################

ExplodeBomb PROC
;----------------------------------------------------
; Calls BombExplosion procedure to explode a bomb,
; and handles the reseting of bomb related variables
; that must be reset since the bomb exploded.
;----------------------------------------------------
        call BombExplosion                      ; creates the explosion around the bomb
        mov bombLaid, 1                         ; signifies that player can lay another bomb
        movzx EAX, countdown
        mov bombExplodeTimer, EAX               ; explosion has starting at current countdown time
        .IF gameType==1
                mov bombTime, 10000             ; During Point Attack mode, bombTime is at 10,000 except while a bomb is on the map
                add bombExplodeTimer, 2         ; Point attack mode clock counts up - explosion will end in two seconds
        .ELSE
                mov bombTime, 0                 ; bombTime is at zero except while a bomb is on the map
                sub bombExplodeTimer, 2         ; swarm and main game mode clock counts down - explosion will end in two seconds
        .ENDIF
        mov bombPosition.x, 0
        mov bombPosition.y, 0
        ret
ExplodeBomb ENDP


;################################################################################################

BombExplosion PROC USES ecx edx
;----------------------------------------------------
; Creates the explosion on screen when a bomb blows up.
; Called from ExplodeBomb procedure.
;
; Receives: DL = x coordinate of bomb
;           DH = y coordinate of bomb
; Returns: nothing
; Calls: Gotoxy, WriteString, SearchEnemies, SetTextColor
;----------------------------------------------------
        mov AL, yellowText                      ; display explosion in yellow
        call SetTextColor

        .IF bombPower==1
                sub DL, 2                       ; default bomb loop starts bomb explosion grid up one and left two from bomb position
                dec DH
        .ELSEIF bombPower==2
                sub DL, 5                       ; upgraded bomb loop starts bomb explosion grid up three and left five from bomb position       
                sub DH, 3
        .ENDIF
        
        mov bombExplodeX, DL                    ; save the explosion starting coordinates to variables for use in Timer PROC to make explosion fade away
        mov bombExplodeY, DH
        .IF bombPower==1
                mov ECX, 5                      ; outer loop counter (15 squares blow up - a 3x5 (row x col) grid)
        .ELSEIF bombPower==2
                mov ECX, 11                     ; outer loop counter: upgraded bomb explosion takes up 11 columns (77 squares - a 7x11 (row x col) grid)
        .ENDIF
        BombGridX:                              ; Outer Loop, incrementing through x-coordinates
                push ECX                        ; save outer loop counter
                .IF bombPower==1
                        mov ECX, 3              ; inner loop counter - explosion takes up 3 rows
                .ELSEIF bombPower==2
                        mov ECX, 7              ; inner loop counter - upgraded bomb explosion takes up 7 rows
                .ENDIF
                BombGridY:
                        call Gotoxy             ; move cursor to current spot on bombgrid
                        .IF x==DL && y==DH      ; if player is in explosion then player was killed.
                                mov quit, 1     ; quit = 1 signifies that player died
                        .ENDIF
                        call SearchEnemies                               ; see if any enemies were in the explosion, if they were then they are blown up
                        push EDX                                         ; save coordinates to stack
                        .IF DL > 2 && DL < 77 && DH > 4 && DH < 63       ; this keeps the explosion from going out of the playable area
                                mov EDX, OFFSET explosion                ; print explosion for current spot on bombgrid
                                call WriteString
                        .ENDIF
                        pop EDX                          ; restore coordinate from stack into EDX
                        inc DH                           ; increment y-coord.
                Loop BombGridY
                pop ECX                                  ; pop outer loop counter back into ECX for outer loop iteration
                .IF bombPower==1
                        sub DH, 3                        ; subtract 3 from y-coord to get it back to top of explosion for next loop iteration
                .ELSE                                    ; implied-if: bombPower==2
                        sub DH, 7                        ; to get y-coord back to top of explosion in upgraded bomb explosion
                .ENDIF                  
                inc DL                                   ; increment x-coord.
        Loop BombGridX
        mov EDX, OFFSET audioBell                        ; "beep" sounds twice when bomb blows up
        call WriteString
 ;       call WriteString
        mov AL, userColor                                ; restore normal colors after explosion has been output
        call SetTextColor
        ret
BombExplosion ENDP

;################################################################################################

SearchEnemies PROC USES ebx ecx edx esi
;----------------------------------------------------
; Searches through all the enemies to see if they
; were hit by a bomb explosion either when it first
; exploded or when the explosion is fading away.
; Called from BombExplosion and Timer procedures.
;
; Receives: DL = x-coordinate of a single part of the bomb explosion
;           DH = y-coordinate of a single part of the bomb explosion
; Returns: EAX = 1 if an enemy did hit the positoin specified by the explosion's x,y-coordinates
;----------------------------------------------------
; call from BombExplosion procedure
        mov EAX, 0
        mov ECX, EnemyGroup1Num                 ; these lines set up the loop counter for loop L5       
        add ECX, EnemyGroup2Num
        add ECX, EnemyGroup3Num                 ; loop counter = total number of enemies
        mov EBX, 0                              ; EBX = offset to move through arrays of badguys
        mov ESI, OFFSET baddiesG1               ; ESI points to arrays of badguys
        L5:
                .IF BYTE PTR [ESI+EBX] == DL && BYTE PTR [ESI+EBX+1] == DH && BYTE PTR [ESI+EBX+2] == 1   ; if explosion hits enemy (has same x,y coords) and enemy is alive
                        mov BYTE PTR [ESI+EBX+2], 2                                                       ; then enemy is dead (alive=1) (just killed=2) (already dead, explosion gone=0)
                        call Gotoxy
                        mov EAX, 1
                        add points, 1000                       ; 1000 points for destroying enemy ship
                .ENDIF
                add EBX, SIZE ENEMY                            ; add byte size of enemy to EBX to point to next badguy in the next loop iteration (ENEMY has 3 bytes)
        Loop L5
        ret
SearchEnemies ENDP

;################################################################################################

EraseSpot PROC
;----------------------------------------------------
; Erases a spot on the map specified by DL and DH.
;
; Receives: DL = x-coordinate of character to erase
;           DH = y-coordinate of character to erase
;----------------------------------------------------
        call Gotoxy
        mov EDX, OFFSET blank
        call WriteString
        ret
EraseSpot ENDP

END main