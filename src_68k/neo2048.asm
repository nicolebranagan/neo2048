
	bss
flag_VBlank:
	dx.b 1
gameState:
	dx.b 1
Cursor_X:
	dx.b 1
Cursor_Y:
	dx.b 1
Message:
 	dx.b 64
SpriteNum:
	dx.b 1
	align 4
Grid:
	dx.b 16
	align 4
NewGrid:
	dx.b 16
	align 4
RestrictGrid:
	dx.b 16
score:
	even
	dx.w 1
highScore:
	dx.w 1
RandSeed:
	dx.b 1
dyX:
	dx.b 1
dyY:
	dx.b 1

STATE_DEMO equ 0
STATE_TITLE equ 1
STATE_GAME equ 2
STATE_GAMEOVER equ 3

	code
; This Header is based on the work from 
; "Neo-Geo Assembly Programming for the Absolute Beginner" by freem
; http://ajworld.net/neogeodev/beginner/

	
	dc.l	$0010F300		; Initial Supervisor Stack Pointer (SSP)
	dc.l	$00C00402		; Initial PC			(BIOS $C00402)
	dc.l	$00C00408		; Bus error/Monitor		(BIOS $C00408)
	dc.l	$00C0040E		; Address error			(BIOS $C0040E)
	dc.l	$00C00414		; Illegal Instruction	(BIOS $C00414)
	dc.l	$00C00426		; Divide by 0
	dc.l	$00C00426		; CHK Instruction
	dc.l	$00C00426		; TRAPV Instruction
	dc.l	$00C0041A		; Privilege Violation	(BIOS $C0041A)
	dc.l	$00C00420		; Trace					(BIOS $C00420)
	dc.l	$00C00426		; Line 1010 Emulator
	dc.l	$00C00426		; Line 1111 Emulator
	dc.l	$00C00426		; Reserved
	dc.l	$00C00426		; Reserved
	dc.l	$00C00426		; Reserved
	dc.l	$00C0042C		; Uninitialized Interrupt Vector

	dc.l	$00C00426		; Reserved
	dc.l	$00C00426		; Reserved
	dc.l	$00C00426		; Reserved
	dc.l	$00C00426		; Reserved
	dc.l	$00C00426		; Reserved
	dc.l	$00C00426		; Reserved
	dc.l	$00C00426		; Reserved
	dc.l	$00C00426		; Reserved
	dc.l	$00C00432		; Spurious Interrupt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 									Interrupts
	dc.l	VBlank			; Level 1 interrupt (VBlank)
	dc.l	IRQ2			; Level 2 interrupt (HBlank)
	dc.l	IRQ3			; Level 3 interrupt
	dc.l	$00000000		; Level 4 interrupt
	dc.l	$00000000		; Level 5 interrupt
	dc.l	$00000000		; Level 6 interrupt
	dc.l	$00000000		; Level 7 interrupt (NMI)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;									 Traps
	dc.l	$FFFFFFFF		; TRAP #0 Instruction
	dc.l	$FFFFFFFF		; TRAP #1 Instruction
	dc.l	$FFFFFFFF		; TRAP #2 Instruction
	dc.l	$FFFFFFFF		; TRAP #3 Instruction
	dc.l	$FFFFFFFF		; TRAP #4 Instruction
	dc.l	$FFFFFFFF		; TRAP #5 Instruction
	dc.l	$FFFFFFFF		; TRAP #6 Instruction
	dc.l	$FFFFFFFF		; TRAP #7 Instruction
	dc.l	$FFFFFFFF		; TRAP #8 Instruction
	dc.l	$FFFFFFFF		; TRAP #9 Instruction
	dc.l	$FFFFFFFF		; TRAP #10 Instruction
	dc.l	$FFFFFFFF		; TRAP #11 Instruction
	dc.l	$FFFFFFFF		; TRAP #12 Instruction
	dc.l	$FFFFFFFF		; TRAP #13 Instruction
	dc.l	$FFFFFFFF		; TRAP #14 Instruction
	dc.l	$FFFFFFFF		; TRAP #15 Instruction
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;							Cart Header
	dc.b "NEO-GEO"
	dc.b $00 			;System Version (0=cart; 1/2 are used for CD games)
	dc.w $2048 			;NGH number ($0000 is prohibited)
	dc.l $00080000 		;game prog size in bytes (4Mbits/512KB)
	dc.l $00108000 		;pointer to backup RAM block (first two bytes are debug dips)
	dc.w $0000 			;game save size in bytes
	dc.b $00 			;Eye catcher anim flag (0=BIOS,1=game,2=nothing)
	dc.b $00 			;Sprite bank for eyecatch if done by BIOS
	dc.l softDips_All  	;Software dips for Japan
	dc.l softDips_All   ;Software dips for USA
	dc.l softDips_All 	;Software dips for Europe

	dc.w $4EF9 ; Jump to USER
	dc.l USER
	dc.w $4EF9 ; Jump to PLAYER_START
	dc.l PLAYER_START
	dc.w $4EF9 ; Jump to DEMO_END
	dc.l DEMO_END
	dc.w $4EF9 ; Jump to COIN_SOUND
	dc.l COIN_SOUND

	dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l $FFFFFFFF,$FFFFFFFF

	;org $00000182
	dc.l TRAP_CODE 				;pointer to TRAP_CODE

	; security code required by Neo-Geo games
TRAP_CODE:
	dc.l $76004A6D,$0A146600,$003C206D,$0A043E2D
	dc.l $0A0813C0,$00300001,$32100C01,$00FF671A
	dc.l $30280002,$B02D0ACE,$66103028,$0004B02D
	dc.l $0ACF6606,$B22D0AD0,$67085088,$51CFFFD4
	dc.l $36074E75,$206D0A04,$3E2D0A08,$3210E049
	dc.l $0C0100FF,$671A3010,$B02D0ACE,$66123028
	dc.l $0002E048,$B02D0ACF,$6606B22D,$0AD06708
	dc.l $588851CF,$FFD83607
	dc.w $4E75
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 				Software Dip Switches (a.k.a. "soft dip")
softDips_All:
	dc.b "NEO 2048        "			; Game Name
	dc.w $FFFF 						; Special Option 1
	dc.w $FFFF 						; Special Option 2
	dc.b 30 						; Special Option 3
	dc.b $FF 						; Special Option 4
	dc.b $00 						; Option 1: 2 choices, default #0
	dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00 ; filler
	dc.b "STEP TIMER  " 			; Option 1 description

	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 									USER
; Needs to perform actions according to the value in BIOS_USER_REQUEST.
; Must jump back to SYSTEM_RETURN at the end so the BIOS can have control.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
USER:	
	move.b	d0,$300001			;Kick watchdog
	lea		$10F300,sp			;Set stack pointer to BIOS_WORKRAM
	move.w	#0,$3C0006			;LSPC_MODE - Disable auto-animation, timer interrupts
									;set auto-anim speed to 0 frames
	move.w	#7,$3C000C			;LSPC_IRQ_ACK - acknowledge all IRQs

	move.w	#$2000,sr			; Enable VBlank interrupt, go Supervisor

	; Handle user request
	moveq	#0,d0
	move.b	($10FDAE).l,d0		;BIOS_USER_REQUEST
	lsl.b	#2,d0				; shift value left to get offset into table
	lea		cmds_USER_REQUEST,a0
	movea.l	(a0,d0),a0
	jsr		(a0)
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 							BIOS_USER_REQUEST commands

cmds_USER_REQUEST:
	dc.l	userReq_StartupInit	; Command 0 (Initialize)
	dc.l	userReq_StartupInit	; Command 1 (Custom eyecatch)
	dc.l	userReq_Game		; Command 2 (Demo Game/Game)
	dc.l	userReq_TitleDisplay		; Command 3 (Title Display)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 							userReq_StartupInit

userReq_StartupInit:
	move.b	d0,$300001		;REG_DIPSW - kick watchdog
	jmp		$C00444			;SYSTEM_RETURN

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;				Handle Interrupts and system events	
	
PLAYER_START:					;Player pressed start on title
	move.b	d0,$300001;REG_DIPSW		; kick the watchdog
	move.l 	#%010000,$10FDB0	; BIOS_CREDIT_DEC
	jsr $C00456 ; CREDIT_DOWN
	jsr GameInit
	rts
	
COIN_SOUND:				
	move.b #$04,$320000 ; REG_SOUND
DEMO_END:						
	rts

VBlank:
	btst	#7,$10FD80			;BIOS_SYSTEM_MODE - check if the BIOS wants to run its vblank
	bne		gamevbl
	jmp		$C00438				;SYSTEM_INT1 - run BIOS vblank
gamevbl:						;run the game's vblank
	movem.l d0-d7/a0-a6,-(sp)	;save registers
		move.w	#4,$3C000C		;LSPC_IRQ_ACK - acknowledge the vblank interrupt
		move.b	d0,$300001		;REG_DIPSW - kick the watchdog	
		jsr		$C0044A 		;"Call SYSTEM_IO every 1/60 second."
		jsr		$C004CE			;Puzzle Bobble calls MESS_OUT just after SYSTEM_IO
		move.b	#0,flag_VBlank	;clear vblank flag so waitVBlank knows to stop
	movem.l (sp)+,d0-d7/a0-a6	;restore registers
	rte

IRQ2:
	move.w	#2,$3C000C			;LSPC_IRQ_ACK - ack. interrupt #2 (HBlank)
	move.b	d0,$300001			;REG_DIPSW - kick watchdog
	rte
IRQ3:
	move.w  #1,$3C000C			;LSPC_IRQ_ACK - acknowledge interrupt 3
	move.b	d0,$300001			;REG_DIPSW - kick watchdog
	rte
	 	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 							UserReq_Game

MessageRaw:    dc.b '00 CREDIT',255
	even
TitleRaw:			 dc.b 'NEO 2048',255
	even

userReq_TitleDisplay:
	move.b #(STATE_TITLE),d0
	move.b d0,gameState
	jsr COIN_SOUND

	jmp userReq_Active

userReq_Game:
userReq_Active:
	move.b	d0,$300001		;REG_DIPSW -Kick watchdog
	
	;        -RGB			;Color Num:
	move.w #$0ADF,$401FFE	;0 - Background color
	move.w #$0F0F,$400022	;1

inf:	
	move.b	d0,$300001		;REG_DIPSW - Kick the watchdog

	moveq #0,d0
	move.b (gameState),d0
	lsl.b #2,d0
	lea		cmds_UPDATE_TABLE,a0
	movea.l	(a0,d0),a0
	jsr		(a0)

	jsr waitVBlank
	jmp inf

cmds_UPDATE_TABLE:
	dc.l	DemoUpdate, TitleUpdate, GameUpdate, GameOverUpdate

DemoUpdate:
	addi.b #1,RandSeed
	jsr drawScore
DrawCredit:
	lea MessageRaw,a0
	lea Message,a1
.fillMessage:
	moveq.l #0,d0	; clear d0
	move.b (a0)+,d0
	move.b d0,(a1)+

	cmpi #$ff,d0
	bne .fillMessage

	move.b #$19,(Cursor_Y)
	move.b #$10,(Cursor_X)

	; Display up-to-date credit counter
	moveq.l #0,d0	; clear d0
	move.b $D00034,d0; P1 credit count

	move.l d0,d1			; tens
	lsr.b #4,d1
	andi.b #$000F,d1
	ori.b #$30,d1
	move.b d1,(Message)

	move.l d0,d1			; ones
	andi.b #$000F,d1
	ori.b #$30,d1
	move.b d1,(Message+1)

	lea Message,a3
	jsr PrintString			;Show String Message
	rts

TitleUpdate:
	move.b #$08,(Cursor_Y)
	move.b #$10,(Cursor_X)

	lea TitleRaw,a3
	jsr PrintString			;Show String Message

; Display up-to-date timeout
	move.b #$0C,(Cursor_Y)
	move.b #$10,(Cursor_X)

	moveq.l #0,d0	; clear d0
	move.b $10FDDA,d0; compulsion start timer

	move.l d0,d1			; tens
	lsr.b #4,d1
	andi.b #$000F,d1
	ori.b #$30,d1
	move.b d1,(Message)

	move.l d0,d1			; ones
	andi.b #$000F,d1
	ori.b #$30,d1
	move.b d1,(Message+1)
	move.b #$FF,(Message+2)

	lea Message,a3
	jsr PrintString			;Show String Message

	jmp DemoUpdate

PrintString:
	move.b (a3)+,d0			;Read a character in from A3
	cmp.b #255,d0
	beq PrintString_Done	;Return on 255
	jsr PrintChar			;Print the Character
	bra PrintString
PrintString_Done:		
	rts
	
NewLine:
	addq.b #1,(Cursor_Y)	;Inc Ypos
	clr.b (Cursor_X)		;Zero Xpos
	rts	
	
	
PrintChar:
	moveM.l d0-d7/a0-a7,-(sp)
		and #$FF,d0
		sub #32,d0				;First character in font is CHR(32)
		
;VRAM address = $7000 + (Xpos * 32) + Ypos

		Move.L  #$7000,d5		;Tilemap base $7000
		clr.L d4
		Move.B (Cursor_X),D4
		rol.L #5,D4				;X*32
		add.L D4,D5
		
		clr.L d4
		Move.B (Cursor_Y),D4
		
		add #2,d4				;NEO doesn't recommend using top 2 columns
		add.L D4,D5
		
			;	PTTT - P=Palette T=TileNum
		add.w #$1020,d0			;Tile Num (Palette 1 - Tile $020+) ROM font
		
		move.w d5,$3C0000 		;VRAM Address
		move.w d0,$3C0002		;VRAM Write (tile data)
		
		addq.b #1,(Cursor_X)	;INC Xpos
		cmp.b #39,(Cursor_X)	;At end of line?
		bls nextpixel_Xok
		jsr NewLine				;NewLine!
nextpixel_Xok:
	moveM.l (sp)+,d0-d7/a0-a7
	rts

waitVBlank:
	cmpi.b #0,flag_VBlank
	bne waitVBlank
	move.b #1,flag_VBlank
	rts

SpritePalette:
	incbin ./palettes/tiles.pal
	even

drawSprite:
	clr d7
	movea.l #(Grid),a0
	move.l #$0FFF,d5 ; shrinking
	
	moveq #10,d0 ;Hard Sprite Number (10)
	move.l #500,d2		;Ypos
	move.l #$10,d4		;Palette

.drawTile:
	move.l a0,d6
	and.l #3,d6
	bne .dontResetY

	move.l #$60,d1		;Xpos
	sub.l #$20,d2		;Ypos

.dontResetY:
	move.b (a0)+,d7
	
	move.l #$2000,d3	;Pattern Num
	move.l d7,d6
	lsl #2,d6					; multiply tile by 4
	add.l d6,d3				; add to 2000

	jsr SetSprite

	addq.l #1,d0			; second row, which should be sticky but eh
	add.l #16,d1
	addq.l #2,d3
	jsr SetSprite
	addq.l #1,d0
	add.l #16,d1

	cmpa.l #(Grid+16),a0
	bne .drawTile

	rts

SetSprite:
	moveM.l d0-d7,-(sp)	
		
	move.l d0,d7
	add.l #$8000,d7			;Sprite Settings start at $8000+Sprnum
	
	move.w d7,$3C0000 		
	move.w d5,$3C0002	;----HHHH VVVVVVVV - Shrink
	
	add.l #$200,d7			;Ypos at $8200+Sprnum
	move.w d7,$3C0000 		
	
	rol.l #7,d2				;Shift Ypos into correct position
	or.l #$0002,d2			;Just 1 sprite
	
	move.w d2,$3C0002		;YYYYYYYY YCSSSSSS Ypos
									;Chain Sprite Size (1 sprite)
	
	add.l #$200,d7			;Xpos at $8400+Sprnum
	move.w d7,$3C0000 		
	
	rol.l #7,d1
	move.w d1,$3C0002		;XXXXXXXX X------- Xpos

	move.l d0,d7
	rol.l #6,d7				;SpriteNum*64
	move.w d7,$3C0000 		;TileNum.1 at $0000+Sprnum*64
	
	move.w d3,$3C0002		;NNNNNNNN NNNNNNNN Tile
							;(tiles start at $2000 - set by MAME XML)									
	addq.l #1,d7
	move.w d7,$3C0000 		;TilePal.1 at $0001+Sprnum*64
	
	rol.l #8,d4				;Palette into top byte
	move.w d4,$3C0002		;PPPPPPPP NNNNAAVH Palette Tile, 

	addq.l #1,d7
	move.w d7,$3C0000 		;TileNum.1 at $0000+Sprnum*64
	
	addq.l #1,d3
	move.w d3,$3C0002		;NNNNNNNN NNNNNNNN Tile
							;(tiles start at $2000 - set by MAME XML)									
	addq.l #1,d7
	move.w d7,$3C0000 		;TilePal.1 at $0001+Sprnum*64
	move.w d4,$3C0002		;PPPPPPPP NNNNAAVH Palette Tile, 
								;Autoanimate Flip
	moveM.l (sp)+,d0-d7
	rts

GameInit:
	jsr $C004C2 			;FIX_CLEAR - clear fix layer
	jsr $C004C8				;LSP_1st   - clear first sprite

	move.b #(STATE_GAME),d0
	move.b d0,gameState
	move.b #2,d0
	move.b d0,$10FDAF ; BIOS_USER_MODE
	move.b #1,d0
	move.b d0,$10FDB6 ; BIOS_PLAYER_MOD1

	; Put sprite palette real
	move.l #$400200,a0
	move.l #SpritePalette,a1
	move.l (a1)+,d0
	move.l d0,(a0)+
	move.l (a1)+,d0
	move.l d0,(a0)+
	move.l (a1)+,d0
	move.l d0,(a0)+
	move.l (a1)+,d0
	move.l d0,(a0)+
	move.l (a1)+,d0
	move.l d0,(a0)+
	move.l (a1)+,d0
	move.l d0,(a0)+
	move.l (a1)+,d0
	move.l d0,(a0)+
	move.l (a1)+,d0
	move.l d0,(a0)+

	clr.l d0
	move.l d0,Grid
	move.l d0,Grid+4
	move.l d0,Grid+8
	move.l d0,Grid+12
	rts

GameUpdate:
	move.l Grid,d0
	add.l (Grid+4),d0
	add.l (Grid+8),d0
	add.l (Grid+12),d0
	bne .skipInit

	jsr SpawnRandom
	move.w #0,score

.skipInit
	jsr drawSprite
	jsr DrawCredit
	jsr HandleInput
	jsr drawScore
	rts

SpawnRandom:
	jsr drawSprite
	clr.l d0 ; grid walk offset
	jsr getRandom ; puts random in d7
	and.b #%00001111,d7
	movea.l #(Grid),a0

.checkNext:
	move.b (0,a0,d0),d1
	bne .goToNext

	cmpi.b #0,d7
	beq .spawnBlock

	subi.b #1,d7

.goToNext:
	add.b #1,d0
	cmpi.b #16,d0
	bne .checkNext
	clr d0
	bra .checkNext

.spawnBlock:
	move.b #1,(0,a0,d0)
	
	move.l d0,d7
	moveq #60,d0

	moveq #96,d1 ; calculate xpos
	clr d6
	move.b d7,d6
	and.w #3,d6 ; mask and then multiply by 32
	lsl.w #5,d6
	add.l d6,d1

	move #468,d2 ; calculate ypos
	clr d6
	move.b d7,d6
	lsr.w #2,d6 ; divide by 4, multiply by 32
	and.l #$0000FFFF,d6 ; mask
	lsl.w #5,d6
	sub.l d6,d2

	move.l #$2004,d3  ; Pattern
	move.l #$10,d4		;Palette

	move.w #$01FF,d5
.spriteLoop
	jsr SetSprite
	addq.l #1,d0			; second column
	add.l #16,d1
	addq.l #2,d3

	jsr SetSprite

	subq.l #1,d0
	sub.l #16,d1
	subq.l #2,d3

	jsr waitVBlank
	add.w #$100,d5
	cmp.w #$0FFF,d5
	bls .spriteLoop

	move.w #0,d2
	move.w #0,d1
	move.w #60,d0
	jsr SetSprite
	move.w #61,d0
	jsr SetSprite
	jsr drawSprite

	jsr CheckForGameOver

	rts

HandleInput:
	clr.l d0
	clr.l d1
	move.b $10FD97,d0 ;BIOS_P1CHANGE 

	move.b d0,d1
	andi.b #%00000010,d1
	bne MoveDown

	move.b d0,d1
	andi.b #%00000001,d1
	bne MoveUp

	move.b d0,d1
	andi.b #%00001000,d1
	bne MoveRight

	move.b d0,d1
	andi.b #%00000100,d1
	bne MoveLeft

	rts

MoveDown:
	clr d0
	moveq.l #1,d1
	jmp StepGrid

MoveUp:
	clr d0
	move.l #-1,d1
	jmp StepGrid

MoveRight:
	clr d1
	moveq.l #1,d0
	jmp StepGrid

MoveLeft:
	clr d1
	move.l #-1,d0
	jmp StepGrid

; d0 delta-x
; d1 delta-y
; d2 current x
; d3 current y
StepGrid:
	clr.l d2
	clr.l d3

	move.l d2,RestrictGrid
	move.l d2,RestrictGrid+4
	move.l d2,RestrictGrid+8
	move.l d2,RestrictGrid+12

	; clear the working grid
	movea.l #(Grid),a0
	movea.l #(NewGrid),a1
	move.l (a0)+,(a1)+
	move.l (a0)+,(a1)+
	move.l (a0)+,(a1)+
	move.l (a0)+,(a1)+

	; Move the deltas into place
	move.b #1,dyX
	move.b #1,dyY

	cmpi.b #1,d0
	bne .ascendX
	move.b #-1,dyX
	move.l #3,d2
.ascendX
	cmpi.b #1,d1
	bne .ascendY
	move.b #-1,dyY
	move.l #3,d3
.ascendY

.xloop
	; load tile at d2, d3 on grid
	move d3,d4
	lsl #2,d4
	add d2,d4
	movea.l #(Grid),a0
	adda.l d4,a0

	; put current value in d4
	move.b (a0),d4
	beq .nextX
	move.b #0,(a0)

	; do work on x
	; d5, d6 working x-y
	move d2,d5
	move d3,d6

	add.b d0,d5
	add.b d1,d6

	; bounds check
	cmpi.b #-1,d5
	beq .dontMove

	cmpi.b #4,d5
	beq .dontMove

	cmpi.b #-1,d6
	beq .dontMove

	cmpi.b #4,d6
	beq .dontMove

	; Get spot on new grid
	move d6,d7
	lsl #2,d7
	add d5,d7
	movea.l #(Grid),a0
	adda.l d7,a0
	cmpi.b #0,(a0)
	beq .freeMove

	cmp.b (a0),d4
	bne .dontMove

	movea.l #(RestrictGrid),a1
	adda.l d7,a1
	cmpi.b #0,(a1)
	bne .dontMove

	; Combine pieces
	movea.l #(Grid),a0
	adda.l d7,a0
	addq.l #1,d4
	move.b d4,(a0)
	move.b #1,(a1)

	move.w #1,d7
	lsl.w d4,d7
	add.w d7,score

	bra .nextX

.freeMove
	add.b d0,d5
	add.b d1,d6

	; bounds check
	cmpi.b #-1,d5
	beq .completeMove

	cmpi.b #4,d5
	beq .completeMove

	cmpi.b #-1,d6
	beq .completeMove

	cmpi.b #4,d6
	beq .completeMove

	move.b d7,Message ; Using the message as a dummy variable

	move d6,d7
	lsl #2,d7
	add d5,d7
	movea.l #(Grid),a0
	adda.l d7,a0
	cmpi.b #0,(a0)
	beq .freeMove

	cmp.b (a0),d4
	bne .dontMergeAndComplete

	movea.l #(RestrictGrid),a1
	adda.l d7,a1
	cmpi.b #0,(a1)
	bne .dontMergeAndComplete

	; Combine pieces
	movea.l #(Grid),a0
	adda.l d7,a0
	addq.l #1,d4
	move.b d4,(a0)
	move.b #1,(a1)

	move.w #1,d7
	lsl.w d4,d7
	add.w d7,score

	bra .nextX

.dontMergeAndComplete
	move.b Message,d7
.completeMove
	movea.l #(Grid),a0
	adda.l d7,a0
	move.b d4,(a0)
	bra .nextX

.dontMove
	move d3,d7
	lsl #2,d7
	add d2,d7
	movea.l #(Grid),a0
	adda.l d7,a0
	move.b d4,(a0)
	bra .nextX

.nextX
	add.b dyX,d2
	cmpi.b #4,d2
	beq .nextY
	cmpi.b #-1,d2
	beq .nextY
	bra .xloop

.nextY
	; reset, increment y
	clr.l d2

	cmpi.b #1,d0
	bne .ascendX2
	move.b #3,d2
.ascendX2
	add.b dyY,d3

	cmpi.b #4,d3
	beq .done
	cmpi.b #-1,d3
	beq .done
	bra .xloop

.done

	move.l Grid,d7
	cmp.l NewGrid,d7
	bne .hasChanges
	move.l Grid+4,d7
	cmp.l (NewGrid+4),d7
	bne .hasChanges
	move.l Grid+8,d7
	cmp.l (NewGrid+8),d7
	bne .hasChanges
	move.l Grid+12,d7
	cmp.l (NewGrid+12),d7
	bne .hasChanges

.hasNoChanges
	rts

.hasChanges
	jsr SpawnRandom

	rts

; d0 delta-x
; d1 delta-y
; returns 0 in d2 if can't step grid
; returns 1 in d2 if can step grid further
CanStepGrid:
	clr.l d2
	clr.l d3

.xloop
	; load tile at d2, d3 on grid
	move d3,d4
	lsl #2,d4
	add d2,d4
	movea.l #(Grid),a0
	adda.l d4,a0

	; put current value in d4
	move.b (a0),d4
	beq .nextX

	; do work on x
	; d5, d6 working x-y
	move d2,d5
	move d3,d6

	add.b d0,d5
	add.b d1,d6

	; bounds check
	cmpi.b #-1,d5
	beq .dontMove

	cmpi.b #4,d5
	beq .dontMove

	cmpi.b #-1,d6
	beq .dontMove

	cmpi.b #4,d6
	beq .dontMove

	; Get spot on new grid, put in d5
	move d6,d7
	lsl #2,d7
	add d5,d7
	movea.l #(Grid),a0
	adda.l d7,a0
	move.b (a0),d5
	beq .freeMove

	cmp.b d4,d5
	bne .dontMove

	; Can combine pieces
	move.l #2,d2
	rts

	bra .nextX

.freeMove
	move.l #2,d2
	rts

.dontMove
	bra .nextX

.nextX
	addq.l #1,d2
	cmpi.l #4,d2
	bne .xloop

	; reset, increment y
	clr.l d2
	addq.l #1,d3
	cmpi.l #4,d3
	bne .xloop

	move.l #0,d2
	rts

RandomGarbage:
	dc.b 092, 230, 008, 149, 132, 161, 125, 129, 031, 249, 060, 045, 160, 035, 247, 145, 242, 237, 147, 017, 189, 244, 137, 078, 230, 023, 140, 066, 084, 044, 107, 140, 250, 241, 058, 008, 018, 069, 172, 163, 166, 152, 196, 110, 085, 160, 173, 240, 084, 077, 229, 193, 179, 000, 161, 084, 226, 247, 110, 021, 115, 012, 020, 180, 033, 160, 191, 192, 018, 210, 097, 119, 089, 244, 082, 221, 191, 063, 057, 011, 195, 197, 048, 202, 223, 168, 035, 096, 013, 138, 121, 170, 138, 068, 247, 107, 218, 219, 225, 228, 012, 175, 098, 165, 063, 246, 045, 162, 101, 105, 101, 137, 071, 061, 186, 083, 201, 085, 213, 025, 112, 182, 247, 042, 033, 059, 221, 090, 044, 138, 230, 156, 136, 070, 119, 212, 096, 134, 159, 230, 207, 135, 247, 019, 232, 157, 205, 133, 250, 112, 129, 040, 018, 100, 046, 188, 193, 089, 141, 040, 031, 149, 023, 018, 015, 254, 106, 172, 197, 141, 238, 209, 134, 255, 184, 080, 175, 206, 175, 136, 249, 095, 237, 053, 251, 125, 103, 137, 240, 006, 209, 126, 187, 228, 188, 107, 040, 063, 002, 214, 117, 241, 099, 138, 017, 059, 112, 233, 163, 182, 168, 131, 078, 140, 226, 231, 052, 231, 234, 184, 057, 170, 111, 004, 009, 095, 029, 210, 092, 113, 006, 250, 120, 156, 070, 058, 248, 161, 231, 133, 205, 062, 002, 158, 130, 093, 039, 230, 196, 140, 255, 114, 033, 173, 048, 097

getRandom:
	clr d7
	move.b RandSeed,d7
	
	move.l a0,-(sp)

	movea.l #(RandomGarbage),a0
	adda.l d7,a0
	move.b (a0),d7

	move.l (sp)+,a0
	addi.b #1,RandSeed

	rts

drawScore:
	clr d0

	move.w score,d0
	divu #10000,d0
	addi.b #$30,d0
	move.b d0,Message

	swap d0
	and.l #$0000FFFF,d0
	divu #1000,d0
	addi.b #$30,d0
	move.b d0,Message+1

	swap d0
	and.l #$0000FFFF,d0
	divu #100,d0
	addi.b #$30,d0
	move.b d0,Message+2

	swap d0
	and.l #$0000FFFF,d0
	divu #10,d0
	addi.b #$30,d0
	move.b d0,Message+3

	swap d0
	and.l #$0000FFFF,d0
	addi.b #$30,d0
	move.b d0,Message+4

	move.b #$30,Message+5
	move.b #255,Message+6

	move.b #17,Cursor_X
	move.b #2,Cursor_Y
	lea Message,a3
	jsr PrintString			;Show String Message

	rts

CheckForGameOver:
	move.l #1,d0
	move.l #0,d1
	move.l #(Grid),a0

	jsr CanStepGrid
	bne .2048Loop

	move.l #-1,d0
	move.l #0,d1

	jsr CanStepGrid
	bne .2048Loop

	move.l #0,d0
	move.l #-1,d1

	jsr CanStepGrid
	bne .2048Loop

	move.l #0,d0
	move.l #1,d1

	jsr CanStepGrid
	beq .GameOver

.2048Loop:
	cmpi.b #11,(a0)
	beq .GameOver
	adda.l #1,a0
	cmpa.l #(Grid+16),a0
	bne .2048Loop

.NoGameOver:
	rts

.GameOver:
	move.b #(STATE_GAMEOVER),d0
	move.b d0,gameState

	move.b #$01,(Cursor_Y)
	move.b #$0F,(Cursor_X)

	lea GameOverRaw,a3
	jsr PrintString			;Show String Message
	rts

GameOverRaw:			 dc.b 'GAME  OVER',255
	even

GameOverUpdate:
	cmpi.b #0,$10FD97 ; is any key pressed
	beq .noKeysPressed

	move.b #1,d0
	move.b d0,$10FDAF ; BIOS_USER_MODE
	move.b #1,d0
	move.b d0,$10FDB6 ; BIOS_PLAYER_MOD1
	
.noKeysPressed:
	jsr DemoUpdate
	rts
