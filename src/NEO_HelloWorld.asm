
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

STATE_DEMO equ 0
STATE_TITLE equ 1
STATE_GAME equ 2

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
	dc.w $0FFF 			;NGH number ($0000 is prohibited)
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
	dc.b "EXAMPLE SET A   " 		; Game Name
	dc.w $FFFF 						; Special Option 1
	dc.w $FFFF 						; Special Option 2
	dc.b $FF 						; Special Option 3
	dc.b $FF 						; Special Option 4
	dc.b $02 						; Option 1: 2 choices, default #0
	dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00 ; filler
	dc.b "OPTION 1A   " 			; Option 1 description
	dc.b "CHOICE1 A   " 			; Option choices
	dc.b "CHOICE2 A   "

	
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
	jsr GameInit
	rts
	
COIN_SOUND:					
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

	jmp userReq_Active

userReq_Game:
userReq_Active:
	move.b	d0,$300001		;REG_DIPSW -Kick watchdog
	
	;        -RGB			;Color Num:
	move.w #$0FDA,$401FFE	;0 - Background color
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
	dc.l	DemoUpdate, TitleUpdate, GameUpdate

DemoUpdate:
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

	move.l #0,d0		;Hard Sprite Number (10)
	move.l #$50,d1		;Xpos
	move.l #388,d2		;Ypos
	move.l #$2000,d3	;Pattern Num
	move.l #$10,d4		;Palette
	jsr SetSprite
	rts

SetSprite:
	moveM.l d0-d7,-(sp)	
		
	move.l d0,d7
	add.l #$8000,d7			;Sprite Settings start at $8000+Sprnum
	
	move.w d7,$3C0000 		
	move.w #$0FFF,$3C0002	;----HHHH VVVVVVVV - Shrink
	
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

	rts

GameUpdate:
	jsr drawSprite
	jsr DrawCredit
	rts
