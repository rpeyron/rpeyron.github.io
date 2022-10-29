;SameGame v1.1 by Jimmy Mardell
;Ported to Fargo II by Skip Jordan
;Ported to TI89 by RPS modification en commentaires

 include  "util.h"
 include  "tios.h"

 xdef   _main
 xdef   _comment
 xdef _ti89

WriteStr MACRO
 move.w  \3,-(a7)
 pea     \4
 move.w  \2,-(a7)
 move.w  \1,-(a7)
 jsr tios::DrawStrXY
 lea     10(a7),a7
 ENDM

WriteStrA MACRO
 move.w  \3,-(a7)
 move.l  \4,-(a7)
 move.w  \2,-(a7)
 move.w  \1,-(a7)
 jsr tios::DrawStrXY
 lea     10(a7),a7
 ENDM

WriteChar  MACRO
 move.w  #$00FF,-(a7)
 move.w  #$0000,-(a7)
 move.w  #$00FF,-(a7)
 move.w  \3,-(a7)
 move.w  \2,-(a7)
 move.w  \1,-(a7)
 move.w  \4,-(a7)
 jsr tios::DrawCharXY
 lea     14(a7),a7
 ENDM

_main:
; jsr Init
 move.l  #200,-(a7)
 bsr tios::HeapAlloc
 move.w  d0,fieldH
 tios::DEREF d0,a0
 move.l  a0,field
 move.w  d0,cfH
 tios::DEREF d0,a0
 move.l  a0,cf
 bsr tios::HeapAlloc
 move.w  d0,undoH
 tios::DEREF d0,a0
 move.l  a0,undoB
 add.w    #4,a7
 clr.w   mode
 sf      intflag
; move.w #$700,d0
; trap   #1
 bclr.b #2,$600001      ;disable mem protection :>
; move.w d0,-(a7)
 move.l $64,oldint1
 move.l #IntHandler,$64
 bset.b #2,$600001      ;re-enable mem protection :<
; move.w (a7),d0
; lea    2(a7),a7
; trap   #1
 ;;move.w  #$2700,sr
 ;;move.l  ($020064),oldint1
 ;;move.l  #IntHandler,($020064)
 ;;move.w  #$2000,sr
 jsr util::idle_loop

MainMenu:
 jsr util::clr_scr
 move.w  #2,-(a7)
 jsr tios::FontSetSys
 addq    #2,a7
 WriteStr #40,#5,#4,_comment            ;10
 move.w  #01,-(a7)
 jsr tios::FontSetSys
 addq    #2,a7
 WriteStr #34,#20,#4,author             ;30
 WriteStr #10,#30,#4,porter             ;40
 WriteStr #47,#45,#4,pmodetxt           ;55
 WriteStr #47,#55,#4,amodetxt           ;65
 WriteStr #47,#65,#4,omodetxt           ;!!
 WriteStr #26,#80,#4,hitxt
ChooseMode:
 lea     LCD_MEM+56*30+5,a0
 lea     ball(PC),a1
 add.w   mode,a1
 bsr PutSpr
 lea     150(a0),a0
 lea     ball+5(PC),a1
 sub.w   #5,a1                          ;mode
 bsr PutSpr
 lea     150(a0),a0
 lea     ball+5(PC),a1
 sub.w   #5,a1                          ;mode
 bsr PutSpr
 lea     hiscore(PC),a2
 tst.w   mode
 beq PuzzleHi
 addq    #6,a2
 cmp.w #5,mode
 beq PuzzleHi
 addq #6,a2
PuzzleHi:
 move.w  (a2),d0
 lea     tmpstr+5(PC),a0
 moveq   #5,d1
 bsr ConvStr
 subq    #1,d1
 bcs ShowHiscore
FillOut:
 move.b  #32,-(a0)
 dbra    d1,FillOut
ShowHiscore:
 WriteStrA #80,#80,#4,a0
 addq    #2,a2
 WriteStrA #120,#80,#4,a2
CM_WaitKey:
 jsr util::idle_loop
 cmp.w   #264,d0
 beq Done
 cmp.w   #13,d0
 beq StartGame
 cmp.w   #337,d0
 beq ChgMode1
 cmp.w   #340,d0
 bne CM_WaitKey
ChgMode2:
 add.w  #5,mode
 cmp.w #10,mode
 blt ChooseMode
 move.w #0,mode
 bra ChooseMode
ChgMode1: 
 sub.w #5,mode
 cmp.w #0,mode
 bge ChooseMode
 move.w #10,mode
 bra ChooseMode
StartGame:
 jsr util::clr_scr
 clr.w   -(a7)
 jsr tios::FontSetSys
 WriteStr #5,#123,#4,_comment(PC)
 lea      pmodetxt(PC),a0
 tst.w    mode
 beq ShowMode
 add.w    #12,a0
ShowMode:
 WriteStrA #10,#95,#4,a0
 WriteStr #70,#95,#4,scoretxt(PC)
 addq    #2,a7
 bsr Randomize
 move.w  #9,x
 move.w  #4,y
 cmp.w   #10,mode
 beq opecs
 clr.w   score
 bra opfin
opesc:
 move.w #200,score
opfin:
 st      intflag
 clr.w   delaycnt
 move.w  #200,fdelay
 move.w  fdelay,timer
 move.w  #-1,uscore
Main:
 bsr ShowField
 cmp.w  #5,mode
 bne NoGameOverCheck
 bsr CheckGameOver
 bne GameOver
NoGameOverCheck:
 move.w  #1000,clrtimer
Update:
 bsr Cursor
WaitKey:
 cmp.w   #5,mode
 bne NoBlockFill
 tst.w   timer
 beq     FillBlock
NoBlockFill:

 clr.l D0
; move.w (tios::kb_globals+$1e),D0
; move.l #0,D1
; move.l #0,D2
; move.l #3,D4
; jsr hexlib::put_hex
; tst.w (tios::kb_globals+$1c)
; beq NoAKey
; clr.w (tios::kb_globals+$1c)

 bsr GetKeyStat
 move.b  keystat,d0
 and.b   #$0F,d0
 cmp.b   #$0F,d0
 beq NoAKey
 tst.w   keytimer
 bne WaitKey
 bsr Cursor
 move.w  #60,keytimer
 sub.w   #30,timer
 bcc NoCarry
 clr.w   timer
NoCarry:
 
; cmp.w #342,d0
 btst    #1,keystat
 bne CUp
 subq.w  #1,x
 bcc CUp
 move.w  #19,x
CUp:
; cmp.w #337,d0
 btst    #0,keystat
 bne CRight
 subq.w  #1,y
 bcc CRight
 move.w  #9,y
CRight:
; cmp.w #344,d0
 btst    #3,keystat
 bne CDown
 addq.w  #1,x
 cmp.w   #20,x
 bne CDown
 clr.w   x
CDown:
; cmp.w #340,d0
 btst    #2,keystat
 bne Update
 addq.w  #1,y
 cmp.w   #10,y
 bne Update
 clr.w   y
 bra Update
NoAKey:
; cmp.w #112,d0
 btst.b  #1,keystat+5   ;P
 beq Pause
; cmp.w #258,d0          ;eq P
; beq Pause
; cmp.w #264,d0
 btst.b  #0,keystat+6   ;ESC
 beq GameOver
; cmp.w #13,d0
 btst.b  #0,keystat+1   ;ENTER
 beq Clear
; cmp.w #268,d0
 btst.b  #7,keystat+5   ;F1
 beq Clear
; cmp.w #117,d0
 btst.b  #1,keystat+1   ;U
 beq Undo
; cmp.w #43,d0           ;eq U
; beq Undo
 clr.w   keytimer
 clr.w   clrtimer
 bra WaitKey

Undo:
 tst.w   mode
 bne WaitKey
 cmp.w   #-1,uscore
 beq WaitKey
 move.w  uscore,score
 move.w  #-1,uscore
 move.l  undoB(PC),a0
 move.l  field(PC),a1
 move.w  #49,d0
CopyUndo:
 move.l  (a0)+,(a1)+
 dbra    d0,CopyUndo
 bra Main

Pause:
 sf      intflag
 lea     LCD_MEM,a0
 move.w  #899,d0
ClearTiles:
 clr.l   (a0)+
 dbra    d0,ClearTiles
 lea     pausedialog(PC),a6
 jsr util::show_dialog
PClearBuf:
 tst.w   (tios::kb_vars+$1C)
 beq PKeyBufClr
 clr.w   (tios::kb_vars+$1C)
 bra PClearBuf
PKeyBufClr:
 jsr util::idle_loop
 cmp.w   #264,d0
 beq PKeyBufClr
 clr.w   -(a7)
 jsr tios::ST_busy
 addq    #2,a7
 st      intflag
 bra Main

Clear:
 tst.w   clrtimer
 bne WaitKey
 move.l  cf(PC),a0
 moveq   #49,d0
ClearCF:
 clr.l   (a0)+
 dbra    d0,ClearCF
 move.w  y(PC),d0
 mulu    #20,d0
 add.w   x(PC),d0
 move.l  cf(PC),a0
 move.l  field(PC),a1
 move.b  0(a1,d0),d6
 beq WaitKey
 st      0(a0,d0)
 clr.w   d4
CheckConnections:
 moveq   #19,d0
 moveq   #9,d1
 move.w  #199,d2
 move.w  d4,d5
CheckL:
 tst.b   0(a0,d2)
 beq CheckNext
 tst.w   d0
 beq CheckR
 cmp.b   -1(a1,d2),d6
 bne CheckR
 tst.b   -1(a0,d2)
 bne CheckR
 st      -1(a0,d2)
 addq    #1,d4
CheckR:
 cmp.w   #19,d0
 beq CheckU
 cmp.b   1(a1,d2),d6
 bne CheckU
 tst.b   1(a0,d2)
 bne CheckU
 st      1(a0,d2)
 addq    #1,d4
CheckU:
 tst.w   d1
 beq CheckD
 cmp.b   -20(a1,d2),d6
 bne CheckD
 tst.b   -20(a0,d2)
 bne CheckD
 st      -20(a0,d2)
 addq    #1,d4
CheckD:
 cmp.w   #9,d1
 beq CheckNext
 cmp.b   20(a1,d2),d6
 bne CheckNext
 tst.b   20(a0,d2)
 bne CheckNext
 st      20(a0,d2)
 addq    #1,d4
CheckNext:
 subq    #1,d0
 bcc CLoop
 move.w  #19,d0
 subq    #1,d1
CLoop:
 dbra    d2,CheckL
 cmp.w   d4,d5
 bne CheckConnections
 tst.w   d4
 beq WaitKey
 move.w  score,uscore
 cmp.w #10,mode
 beq osco
 mulu    d4,d4
 add.w   d4,score
 bra oscofi
osco:
 sub.w d4,score
oscofi:
 move.l  undoB(PC),a4
 move.l  field(PC),a5
 move.w  #49,d0
CopyToUndo:
 move.l  (a5)+,(a4)+
 dbra    d0,CopyToUndo
 clr.l   d0
UpdateField:
 tst.b   0(a0,d0)
 beq UF_Next
 move.w  d0,d1
FallDown:
 sub.w   #20,d1
 bcs TopReached
 move.b  0(a1,d1),20(a1,d1)
 bra FallDown
TopReached:
 clr.b   20(a1,d1)
UF_Next:
 addq    #1,d0
 cmp.w   #200,d0
 bne UpdateField
 moveq   #19,d0
 move.l  a1,a0
 adda.w  #180,a0
CheckEmptyColumns:
 tst.b   0(a0,d0)
 bne CEC_Next
 moveq   #9,d1
 move.l  a1,a2
 add.w   d0,a2
MoveRow:
 move.l  a2,a3
 moveq   #19,d2
 sub.w   d0,d2
 beq MRL_Done
MoveRowLeft:
 move.b  1(a3),(a3)+
 subq    #1,d2
 bne MoveRowLeft
MRL_Done:
 clr.b   (a3)
 add.w   #20,a2
 dbra    d1,MoveRow
CEC_Next:
 dbra    d0,CheckEmptyColumns
 bra Main

FillBlock:
 clr.l   d0
 moveq   #9,d1
 move.l  field(PC),a0
 add.w   #180,a0
SearchEmpty:
 tst.b   (a0)
 beq EmptyFound
 addq    #1,a0
 addq    #1,d0
 cmp.w   #20,d0
 bne SearchEmpty
 lea     -40(a0),a0
 clr.l   d0
 subq    #1,d1
 bcc SearchEmpty
 bra GameOver
EmptyFound:
 lea     LCD_MEM,a1
 mulu    #240,d1
 add.w   d1,a1
 add.w   #240,a1
 ;mulu    #8,d0
 ;move.w  d0,d4
 ;lsr.w   #4,d0
 ;lsl.w   #1,d0
 add.w   d0,a1
 ;and.w   #$0F,d4
 moveq   #5,d0
 jsr util::random
 addq    #1,d0
 move.w  d0,d2
 move.b  d0,(a0)
 bsr Cursor
 bsr PutBlock
 bsr Cursor
 move.w  fdelay,timer
 addq.w  #1,delaycnt
 cmp.w   #4,delaycnt
 bne NoBlockFill
 clr.w   delaycnt
 cmp.w   #10,fdelay
 beq NoBlockFill
 subq.w  #1,fdelay
 bra NoBlockFill

CheckGameOver:
 move.l  field(PC),a0
 moveq   #19,d0
 moveq   #9,d1
 move.w  #199,d2
CGO_Left:
 move.b  0(a0,d2),d3
 beq CGO_Next
 tst.w   d0
 beq CGO_Right
 cmp.b   -1(a0,d2),d3
 beq NotGameOver
CGO_Right:
 cmp.w   #19,d0
 beq CGO_Up
 cmp.b   1(a0,d2),d3
 beq NotGameOver
CGO_Up:
 tst.w   d1
 beq CGO_Down
 cmp.b   -20(a0,d2),d3
 beq NotGameOver
CGO_Down:
 cmp.w   #9,d1
 beq CGO_Next
 cmp.b   20(a0,d2),d3
 beq NotGameOver
CGO_Next:
 subq    #1,d0
 bcc CGO_Loop
 move.w  #19,d0
 subq    #1,d1
CGO_Loop:
 dbra    d2,CGO_Left
NotGameOver:
 rts

Cursor:
 movem.l d0-d3/a0-a1,-(a7)
 lea     LCD_MEM,a0
 move.w  x(PC),d0
 move.w  y(PC),d1
 mulu    #240,d1
 add.w   d1,a0
 add.w  #240,a0
 ;mulu    #8,d0
 ;move.w  d0,d1
 ;lsr.w   #4,d0
 ;lsl.w   #1,d0
 add.w   d0,a0
 ;and.w   #$0F,d1
 ;move.l  #$FFF00000,d2
 ;lsr.l   d1,d2
 moveq   #7,d3
InvertLine:
 eor.b   #$FF,(a0)
 lea     30(a0),a0
 dbra    d3,InvertLine
 movem.l (a7)+,d0-d3/a0-a1
 rts

ShowField:
 move.l  field(PC),a0
 lea     LCD_MEM,a1
 add.l #240,a1
 moveq   #9,d0
SFRow:
 moveq   #4,d1
SFCol:
; clr.l   d4
 bsr PutTile
; moveq   #12,d4
 addq #1,a1
 bsr PutTile
 addq    #1,a1
; moveq   #8,d4
 bsr PutTile
  addq #1,a1
; moveq   #20,d4
 bsr PutTile
 addq    #1,a1
 dbra    d1,SFCol
 add.w   #220,a1
 dbra    d0,SFRow
 lea     tmpstr+5(PC),a0
 move.w  score,d0
 moveq   #5,d1
 bsr ConvStr
 lsl.w   #2,d1
 add.w   #100,d1
 WriteStrA d1,#95,#4,a0
 rts

PutTile:
 clr.l   d2
 move.b  (a0)+,d2
PutBlock:
 move.l  a1,a3
 lea     sprites(PC),a2
 mulu    #8,d2
 adda.w  d2,a2
 ;move.l  #$000FFFFF,d3
 ;ror.l   d4,d3
 moveq   #7,d5
PTLine:
; clr.l   d6
 move.b  (a2)+,d6
 ;swap    d6
 ;lsr.l   d4,d6
 ;and.l   d3,(a3)
 ;or.l    d6,(a3)
 move.b   d6,(a3)
 lea     30(a3),a3
 dbra    d5,PTLine
 rts

PutSpr:
 moveq   #4,d0
PS_Rep:
 move.b  (a1)+,(a0)
 lea     30(a0),a0
 dbra    d0,PS_Rep
 rts

GameOver:
 sf      intflag
 lea     gameoverdialog(PC),a6
 jsr util::show_dialog
ClearBuf:
 tst.w   (tios::kb_vars+$1C)
 beq KeyBufEmpty
 clr.w   (tios::kb_vars+$1C)
 bra ClearBuf
KeyBufEmpty:
 jsr util::idle_loop
 lea     hiscore(PC),a3
 cmp.w   #0,mode
 beq CompareHiscore
 addq    #6,a3
 cmp.w   #5,mode
 beq CompareHiscore
 addq    #6,a3
CompareHiscore:
 move.w  (a3),d0
 cmp.w  #10,mode
 beq omodhi
 cmp.w   score,d0
 bcc MainMenu
 bra omofin
omodhi:
 bls MainMenu
 bra omofin
omofin:
 move.w  score,(a3)+
 move.l  #$41414100,(a3)
 lea     hiscoredialog(PC),a6
 jsr util::show_dialog
 move.w  #1,-(a7)
 jsr tios::FontSetSys
 addq    #2,a7
 WriteStr #21,#60,#4,entintxt(PC)
 clr.l   d7
EnterInitials:
 move.l  a3,a0
 move.w  #110,d3
 WriteStrA d3,#60,#4,a0
 move.w  d7,d6
 mulu    #6,d6
 add.w   d6,d3
 clr.l   d0
 move.b  0(a3,d7),d0
 WriteChar d3,#60,#0,d0
EI_WaitKey:
 jsr util::idle_loop
 cmp.w   #13,d0
 beq CurRight
 cmp.w   #264,d0
 beq MainMenu
 cmp.w   #338,d0
 beq CurLeft
 cmp.w   #337,d0
 beq LetUp
 cmp.w   #344,d0
 beq CurRight
 cmp.w   #340,d0
 bne EI_WaitKey
 move.b  0(a3,d7),d0
 subq    #1,d0
 cmp.b   #64,d0
 bne StoreLetter
 move.b  #90,d0
StoreLetter:
 move.b  d0,0(a3,d7)
 bra EnterInitials
LetUp:
 move.b  0(a3,d7),d0
 addq    #1,d0
 cmp.b   #91,d0
 bne StoreLetter
 move.b  #65,d0
 bra StoreLetter
CurLeft:
 tst.w   d7
 beq EI_WaitKey
 subq    #1,d7
 bra EnterInitials
CurRight:
 cmp.w   #2,d7
 bne MoveCurRight
 cmp.w   #13,d0
 bne EI_WaitKey
 bra MainMenu
MoveCurRight:
 addq    #1,d7
 bra EnterInitials

ConvStr:
 movem.l d0/d2,-(a7)
 clr.b   (a0)
RepConv:
 divu    #10,d0
 move.l  d0,d2
 swap    d2
 add.b   #48,d2
 move.b  d2,-(a0)
 subq    #1,d1
 and.l   #$FFFF,d0
 bne RepConv
CS_Done:
 movem.l (a7)+,d0/d2
 rts

Init:
 move.l a7,d0
 move.l #1,d1
 move.l #1,d2
 move.l #7,d4
 jsr   hexlib::put_char
 move.l  #200,-(a7)
 bsr tios::HeapAlloc
 move.w  d0,fieldH
 tios::DEREF d0,a0
 move.l  a0,field
 move.w  d0,cfH
 tios::DEREF d0,a0
 move.l  a0,cf
 bsr tios::HeapAlloc
 move.w  d0,undoH
 tios::DEREF d0,a0
 move.l  a0,undoB
 add.w    #4,a7
 clr.w   mode
 sf      intflag
 move.w #$700,d0
 trap   #1
 bclr.b #2,$600001      ;disable mem protection :>
 move.w d0,-(a7)
 move.l $64,oldint1
 move.l #IntHandler,$64
 bset.b #2,$600001      ;re-enable mem protection :<
 move.w (a7),d0
 lea    2(a7),a7
 trap   #1
 ;;move.w  #$2700,sr
 ;;move.l  ($020064),oldint1
 ;;move.l  #IntHandler,($020064)
 ;;move.w  #$2000,sr
 move.l a7,d0
 move.l #2,d1
 move.l #1,d2
 move.l #7,d4
 jsr hexlib::put_hex
 jsr util::idle_loop
 rts

Randomize:
 move.l  field(PC),a0
 move.w  #199,d1
 cmp.w   #5,mode
 bne RandomSymbol
 moveq   #24,d2
ClrHalf:
 clr.l   (a0)+
 dbra    d2,ClrHalf
 moveq   #99,d1
RandomSymbol:
 moveq   #5,d0
 jsr util::random
 addq    #1,d0
 move.b  d0,(a0)+
 dbra    d1,RandomSymbol
 rts

Done:
 ;move.w  #$2700,sr
 move.w #$700,d0
 trap   #1
 bclr.b #2,$600001
 move.l oldint1,$64
 bset.b #2,$600001
 trap   #1
 ;move.l  oldint1(PC),($020064)
 ;move.w  #$2000,sr
 move.w  fieldH(PC),-(a7)
 jsr tios::HeapFree
 move.w  cfH(PC),-(a7)
 jsr tios::HeapFree
 move.w  undoH(PC),-(a7)
 jsr tios::HeapFree
 addq    #6,a7
 rts

IntHandler:
 tst.w   timer
 beq DecKTimer
 subq.w  #1,timer
DecKTimer:
 tst.w   keytimer
 beq DecCTimer
 subq.w  #1,keytimer
DecCTimer:
 tst.w   clrtimer
 beq CheckFlag
 subq.w  #1,clrtimer
CheckFlag:
 tst.b   intflag
 bne EndInt
 move.l  oldint1(PC),-(a7)
 rts
EndInt:
 rte

GetKeyStat:
 movem.l d0-d1/a0,-(a7)
 lea     keystat(PC),a0
 move.w  #$FFFE,d0
 moveq   #9,d1
GetKeys:
 move.w  d0,$600018
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 nop
 move.b  $60001B,(a0)+
 rol.w   #1,d0
 dbra    d1,GetKeys
 movem.l (a7)+,d0-d1/a0
 rts

fieldH   dc.w 0
field    dc.l 0
cfH      dc.w 0
cf       dc.l 0
undoH    dc.w 0
undoB    dc.l 0

x        dc.w 0
y        dc.w 0
score    dc.w 0
uscore   dc.w 0
mode     dc.w 0
timer    dc.w 0
fdelay   dc.w 0
keytimer dc.w 0
clrtimer dc.w 0
delaycnt dc.w 0
oldint1  dc.l 0

hiscore  dc.b 7,111,'REM',0,9,237,'REM',0,0,200,'REM'

keystat  ds.b 10

scoretxt dc.b "Score:",0

tmpstr   ds.b 6
intflag  dc.b 0

gotxt    dc.b "GAME OVER",0

_comment     dc.b "SameGame 89",0
author   dc.b "by Jimmy Mârdell",0
pmodetxt dc.b "Puzzle mode",0
amodetxt dc.b "Action mode",0
omodetxt dc.b "Funny mode",0
hitxt    dc.b "Hiscore:",0
newhitxt dc.b "A NEW HISCORE!",0
entintxt dc.b "Enter initials:",0
pausetxt dc.b "PAUSE",0

 even

pausedialog
 dc.l $00100019,$008F0041,$0028000F,pausetxt,0

gameoverdialog
 dc.l $00100019,$008F0041,$0018000F,gotxt,0

hiscoredialog
 dc.l $00020015,$009F004A,$0019000F,newhitxt,0

sprites
 ds.b 8

 dc.b %00000000
 dc.b %00111000
 dc.b %01100100
 dc.b %11110110
 dc.b %11111110
 dc.b %11111110
 dc.b %01111100
 dc.b %00111000

 dc.b %00000000
 dc.b %00010000
 dc.b %00111000
 dc.b %01100100
 dc.b %11110010
 dc.b %01111100
 dc.b %00111000
 dc.b %00010000

 dc.b %00000000
 dc.b %11111110
 dc.b %11110010
 dc.b %11111010
 dc.b %11111010
 dc.b %11111110
 dc.b %11111110
 dc.b %11111110

 dc.b %00000000
 dc.b %00010000
 dc.b %00010000
 dc.b %00101000
 dc.b %00111000
 dc.b %01111100
 dc.b %11111110
 dc.b %11111110
    
 dc.b %00000000
 dc.b %00111000
 dc.b %00111000
 dc.b %11100110
 dc.b %11110110
 dc.b %11111110
 dc.b %00111000
 dc.b %00111000

extraball:
 dc.b 0,0,0,0,0
 dc.b 0,0,0,0,0
ball:
 dc.b %00111000
 dc.b %01011100
 dc.b %01111100
 dc.b %01111100
 dc.b %00111000
 dc.b 0,0,0,0,0
 dc.b 0,0,0,0,0

porter: dc.b    "Ported to TI-89 by RPS",0
    end
