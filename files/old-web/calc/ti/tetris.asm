 include 92plus.h
 include tetmacr.h
 include gray4lib.h
 include util.h

 xdef _main
 xdef _comment
 xdef _ti89

_main:
 movem.l d0-d7/a0-a6,-(a7)
 bsr Init
 tst.b   tkflag
 beq MainRepeat
 lea     $300,a0
 lea     $4C00,a1
 move.l  gray4lib::plane0,a2
 move.w  #959,d1
RestoreScreen:
 move.l  (a0)+,(a1)+
 move.l  (a0)+,(a2)+
 dbra    d1,RestoreScreen
 add.w   #40,timer
 sf      tkflag
 st      intflag
 bra Main
MainRepeat:
 bsr Titel
 jsr util::idle_loop
 cmp.w   #264,d0
 beq Done
 bsr Menu
 cmp.w   #264,d0
 beq Done
 bsr NewGame
Main:
 tst.w   twopl
 beq GetKeyInfo
 bsr ReceiveByte
 move.w  d0,d1
 lsr.w   #4,d0
 beq GetKeyInfo
 and.w   #$0F,d1
 cmp.w   #$0F,d0
 beq PenaltyRows
 cmp.w   #$0E,d0
 beq BarInfoH
 cmp.w   #$0D,d0
 beq BarInfo
 cmp.w   #$0C,d0
 bne GetKeyInfo
 lea     windialog(PC),a6
 bra EndGame
BarInfoH:
 moveq   #16,d1
BarInfo:
 bsr ShowBar
 bra GetKeyInfo
PenaltyRows:
 bsr RemoveCurPiece
Put_PR:
 bsr TrashRow
 tst.w   y
 beq NextPR
 subq.w  #1,y
NextPR:
 dbra    d1,Put_PR
 bsr ShowCurPiece
 bsr SendBarInfo
GetKeyInfo:
 bsr GetKeyStat
 move.w  x(PC),d4
 move.w  y(PC),d5
 move.w  rot(PC),d6
 bsr CheckDown
 bsr CheckLeftRight
 bsr CheckRotate
 bsr CheckDrop

 clr.l   ltimer
 sf      upflag
 sf      downflag
 btst.b  #1,keystat+4
 beq GameOver
 btst.b  #0,keystat+6
 beq GameOver
 tst.w   twopl
 bne EndKeyCheck
 btst.b  #1,keystat+5
 beq Pause
 btst.b  #5,keystat+2
 beq TeacherKey
EndKeyCheck:

CheckTimer:
 tst.w   timer
 bne Main
ShortWait:
 move.w  #20,timer
Wait:
 tst.w   timer
 bne Wait
 bra MoveDown

RetEKC:
 addq    #4,a7
 bra EndKeyCheck

CheckRotate:
 tst.w   disUflag
 bne SkipUpCheck
 btst.b  #0,keystat
 beq TryRot
 btst.b  #3,keystat+3           ;;; 8
 beq TryRot
                                ;;; Skikup
 btst.b  #7,keystat+4
 beq TryRot
 btst.b  #7,keystat+5
 beq tryro
 btst.b  #4,keystat+4   ;; (
 beq tryro
 btst.b  #4,keystat+3           ;;; )
 beq tryro
 btst.b  #4,keystat+2   ;; ,
 beq TryRot
SkipUpCheck:
 bra ClearUp
tryro: 
 addq    #2,d6
TryRot:
 clr.l   ltimer
 sf      downflag
 addq    #1,d6
 and.w   #3,d6
 tst.b   upflag
 bne RetEKC
 st      upflag
 lea     tmpp(PC),a0
 move.w  curPN(PC),d0
 move.w  d6,d1
 bsr Uncrunch
 bsr TestMoveA0
 bne RetEKC
 bsr RemoveCurPiece
 move.w  d6,rot
 bsr UncrunchCurPiece
 bsr ShowCurPiece
 bra RetEKC
ClearUp:
 sf      upflag
 rts

CheckLeftRight:
 btst.b  #1,keystat
 beq leok
 btst.b  #3,keystat+4
 beq leok
 bra CheckRight
leok: 
 clr.w   rtimer
 sf      downflag
 tst.w   ltimer
 bne RetEKC
 move.w  #60,ltimer
 subq    #1,d4
 bsr TestMove
 bne RetEKC
 bsr RemoveCurPiece
 move.w  d4,x
 bsr ShowCurPiece
 bra RetEKC
CheckRight:
 clr.w   ltimer
 btst.b  #3,keystat
 beq riok
 btst.b  #3,keystat+2 ;; 9
 beq riok
 bra ClearRight
riok: 
 sf      downflag
 tst.w   rtimer
 bne RetEKC
 move.w  #60,rtimer
 addq    #1,d4
 bsr TestMove
 bne RetEKC
 bsr RemoveCurPiece
 move.w  d4,x
 bsr ShowCurPiece
 bra RetEKC
ClearRight:
 clr.w   rtimer
 rts

CheckDown:
 tst.w   disDflag
 bne Return
 btst.b  #2,keystat
 beq dook
 btst.b  #3,keystat+5
 beq dook
 btst.b  #2,keystat+3
 beq dook
 bra Return
dook: 
 tst.b   downflag
 bne RetEKC
 addq.l  #1,score
 addq    #4,a7
 bra ShortWait

CheckDrop:
 btst.b  #2,keystat
 beq TryDrop
 btst.b  #4,keystat+2
 beq TryDrop
 btst.b  #3,keystat+1
 beq TryDrop
 btst.b  #0,keystat+1
 bne ClearDown
TryDrop:
 tst.b   downflag
 bne RetEKC
Drop:
 addq    #1,d5
 addq.l  #1,score
 bsr TestMove
 beq Drop
 bsr RemoveCurPiece
 move.w  d5,y
 subq.w  #1,y
 bsr ShowCurPiece
 addq    #4,a7
 bra StorePiece
ClearDown:
 sf      downflag
 rts

MoveDown:
 move.w  levtimer(PC),timer
 move.w  x(PC),d4
 move.w  y(PC),d5
 addq    #1,d5
 bsr TestMove
 bne StorePiece
 bsr RemoveCurPiece
 move.w  d5,y
 bsr ShowCurPiece
 bra Main
StorePiece:
 subq    #1,d5
 moveq   #3,d7
 lea     curp(PC),a0
StoreSq:
 move.w  (a0)+,d2
 move.w  (a0)+,d3
 add.w   d5,d2
 lsl.w   #4,d2
 add.w   d3,d2
 add.w   d4,d2
 st      0(a5,d2)
 dbra    d7,StoreSq
 move.l  a5,a0
 lea     rows(PC),a1
 moveq   #17,d0
 clr.l   d2
 clr.l   d5
CheckRow:
 moveq   #15,d1
CheckRCol:
 tst.b   0(a0,d1)
 beq CheckNextRow
 dbra    d1,CheckRCol
 addq    #1,d5
 move.w  d2,(a1)+
CheckNextRow:
 lea     16(a0),a0
 addq    #1,d2
 dbra    d0,CheckRow
 bsr ShowScore
 tst.w   d5
 beq NewP
 add.w   d5,lines
 clr.l   d0
 move.w  lines(PC),d0
 divu    #10,d0
 cmp.w   level(PC),d0
 blt SameLevel
 move.w  d0,level
 lea     levels(PC),a0
 lsl.w   #1,d0
 move.w  0(a0,d0),levtimer
SameLevel:
 subq    #1,d5
 lea     scoring(PC),a0
 move.w  d5,d0
 lsl.w   #1,d0
 move.w  0(a0,d0),d0
 move.w  level(PC),d1
 addq    #1,d1
 mulu    d1,d0
 add.l   d0,score
 moveq   #3,d6
Flash:
 move.w  d5,d0
 lea     rows(PC),a0
 ;lea     $4C00,a1;;;;;!!!!!!!!!!!!!!
 move.l  gray4lib::plane1,a1
 move.l  gray4lib::plane0,a2
FlashRows:
 move.w  (a0)+,d1
 subq    #6,d1                  ;2!!!
 mulu    #240,d1
 add.w   #120,d1                ;!!!!!!
 add.w   #5,d1                  ;10!!!!
 moveq   #7,d2
FlashLine:
 move.w  d1,d3
 moveq   #4,d4
FlashWord:
 ;jsr util::idle_loop
 eori.b  #$FFFF,0(a1,d3.w)
 eori.b  #$FFFF,0(a2,d3.w)
 eori.b  #$FFFF,1(a1,d3.w)
 eori.b  #$FFFF,1(a2,d3.w)
 addq    #2,d3
 dbra    d4,FlashWord
 add.w   #30,d1
 dbra    d2,FlashLine
 dbra    d0,FlashRows
 move.w  #40,timer
FlashPause:
 tst.w   timer
 bne FlashPause
 dbra    d6,Flash
 move.w  d5,d0
 lea     rows(PC),a0
MoveLines:
 move.l  gray4lib::plane1,a1            ;lea     $4C00,a1
 move.l  gray4lib::plane0,a2
 move.w  (a0)+,d1
 move.w  d1,d4
 subq    #6,d1          ;!!!!!2
 move.w  d1,d3
 mulu    #240,d1
 add.w   #120,d1        ;!!!!!!!
 add.w   #216,d1        ;220
 move.w  d1,d2
 sub.w   #240,d2
 lsl.w   #3,d3
 subq    #1,d3
MoveGFXRows:
 move.b  -1(a1,d2),-1(a1,d1)
 move.b  -1(a2,d2),-1(a2,d1)
 move.l  0(a1,d2),0(a1,d1)
 move.l  0(a2,d2),0(a2,d1)
 move.l  4(a1,d2),4(a1,d1)
 move.l  4(a2,d2),4(a2,d1)
 move.b  8(a1,d2),8(a1,d1)
 move.b  8(a2,d2),8(a2,d1)
 sub.w   #30,d1
 sub.w   #30,d2
 dbra    d3,MoveGFXRows
 moveq   #7,d3
ClearTopRows:
 clr.b   -1(a1,d1)
 clr.b   -1(a2,d1)
 clr.l   0(a1,d1)
 clr.l   0(a2,d1)
 clr.l   4(a1,d1)
 clr.l   4(a2,d1)
 clr.b   8(a1,d1)
 clr.b   8(a2,d1)
 sub.w   #30,d1
 dbra    d3,ClearTopRows
 move.l  a5,a1
 lsl.w   #4,d4
 add.w   d4,a1
 move.l  a1,a2
 lea     16(a2),a2
 lsr.w   #2,d4
 subq    #1,d4
UpdateBoard:
 move.l  -(a1),-(a2)
 dbra    d4,UpdateBoard
 dbra    d0,MoveLines
 tst.w   twopl
 beq NewP
 tst.w   d5
 beq NewP
 move.w  llflag(PC),d0
 lsr.w   #3,d0
 sub.w   d0,d5
 move.w  d5,d0
 or.w    #$F0,d0
 bsr SendByte
NewP:
 tst.w   twopl
 beq NoBarInfo
 bsr SendBarInfo
NoBarInfo:
 bsr ShowScore
 bsr NewPiece
 moveq   #6,d4
 moveq #4,d5            ;clr.l   d5
 bsr TestMove
 beq Main
GameOver:
 tst.w   twopl
 beq ShowGameOver
 move.b  #$C0,d0
 bsr SendByte
ShowGameOver:
 lea     losedialog(PC),a6
EndGame:
 bsr ShowDialog
WaitQRel:
 bsr GetKeyStat
 btst    #3,keystat+9
 beq WaitQRel
 btst    #6,keystat+8
 beq WaitQRel
 sf      intflag
 clr.w   $759a;$75B0
WaitKeyPress:
 jsr util::idle_loop
 cmp.w   #337,d0
 bcs CheckGameOver
 cmp.w   #353,d0
 bcs WaitKeyPress
CheckGameOver:
 tst.w   twopl
 bne MainRepeat
 move.l  score(PC),d0
 cmp.l   hiscore+96,d0
 ble MainRepeat
 lea     hiscore+16(PC),a0
 moveq   #4,d1
CheckPl:
 cmp.l   (a0),d0
 bgt PlFound
 lea     20(a0),a0
 dbra    d1,CheckPl
PlFound:
 lea     hiscore+100(PC),a0
 lea     hiscore+80(PC),a1
 tst.w   d1
 beq NoHiMove
 mulu    #5,d1
 subq    #1,d1
MoveHiTable:
 move.l  -(a1),-(a0)
 dbra    d1,MoveHiTable
NoHiMove:
 move.l  d0,16(a1)
 bsr ClrScr
 SetFont #2
 WriteStr #16,#30,#4,ent1txt
 SetFont #1
 WriteStr #8,#58,#4,ent2txt
 WriteStr #4,#80,#4,ent3txt
 bsr CopyScreen
 move.w  #100,d3
 moveq   #80,d1
 clr.l   d4
Input:
 jsr util::idle_loop
 cmp.w   #13,d0
 beq InputDone
 cmp.w   #257,d0
 beq BackSpace
 cmp.w   #32,d0
 bcs Input
 cmp.w   #256,d0
 bcc Input
 cmp.w   #15,d4
 beq Input
 move.b  d0,(a1)+
 move.w  d0,d2
 move.w  d3,d0
 bsr WriteChar
 addq    #6,d3
 addq    #1,d4
 bra Input
BackSpace:
 tst.w   d4
 beq Input
 clr.b   -(a1)
 subq    #6,d3
 move.w  d3,d0
 moveq   #32,d2
 bsr WriteChar
 subq    #1,d4
 bra Input
InputDone:
 clr.b   (a1)
 bra MainRepeat

ShowScore:
 movem.l d0-d2/a0-a1,-(a7)
 SetFont #1                             ;2
 lea     tmpstr+6(PC),a0
 move.l  score(PC),d0
 moveq   #5,d1
 bsr ConvStr
 WriteStrA #130,#18,#4,a0               ;176 ;20
 lea     tmpstr+6(PC),a0
 clr.l   d0
 move.w  level(PC),d0
 moveq   #4,d1
 bsr ConvStr
 WriteStrA #130,#36,#4,a0               ;184 ;50
 lea     tmpstr+6(PC),a0
 clr.l   d0
 move.w  lines(PC),d0
 moveq   #4,d1
 bsr ConvStr
 WriteStrA #130,#54,#4,a0               ;184  ;80
 ;lea     $4c15,a0
 move.l gray4lib::plane1,a0
 add.w  #$15,a0
 move.l  gray4lib::plane0,a1
 add.w   #$15,a1
 moveq   #90,d0
SS_CopyRow:
 moveq   #8,d1
SS_CopyCol:
 move.b  (a0)+,(a1)+
 dbra    d1,SS_CopyCol
 lea     21(a0),a0
 lea     21(a1),a1
 dbra    d0,SS_CopyRow
 movem.l (a7)+,d0-d2/a0-a1
 rts

ConvStr:
 movem.l d0-d2,-(a7)
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
 tst.w   d1
 beq CS_Done
 subq    #1,d1
FillOut:
 move.b  #32,-(a0)
 dbra    d1,FillOut
CS_Done:
 movem.l (a7)+,d0-d2
 rts

TrashRow:
 movem.l d0-d4/a0-a4,-(a7)
 ;lea     $4C00,a2
 move.l  gray4lib::plane1,a2
 move.l  gray4lib::plane0,a3
 moveq   #6,d1                  ;;10
 move.w  #246,d2                ;;250
 moveq   #91,d3                 ;119
MoveUpGFXRows:
 move.b  -1(a2,d2),-1(a2,d1)
 move.b  -1(a3,d2),-1(a3,d1)
 move.l  0(a2,d2),0(a2,d1)
 move.l  0(a3,d2),0(a3,d1)
 move.l  4(a2,d2),4(a2,d1)
 move.l  4(a3,d2),4(a3,d1)
 move.b  8(a2,d2),8(a2,d1)
 move.b  8(a3,d2),8(a3,d1)
 add.w   #30,d1
 add.w   #30,d2
 dbra    d3,MoveUpGFXRows
 add.w   d1,a2
 add.w   d1,a3
 sub.w #1,a2                    ;!!!!
 sub.w #1,a3                    ;!!!!
 move.l  a5,a0
 move.l  a0,a4
 add.w   #16,a0
 moveq   #67,d1
MoveUpRows:
 move.l  (a0)+,(a4)+
 dbra    d1,MoveUpRows
 addq    #3,a4
 moveq   #9,d3
TR_Fill:
 st      0(a4,d3)
 dbra    d3,TR_Fill
 moveq   #4,d3
MakeHoles:
 moveq   #10,d0
 jsr util::random
 clr.b   0(a4,d0)
 dbra    d3,MakeHoles
 moveq   #9,d3
 clr.l   d2
TR_PutSquares:
 lea     empty(PC),a0
 tst.b   0(a4,d2)
 beq TR_PutSquare
 lea     pgfx(PC),a0
 moveq   #7,d0
 jsr util::random
 lsl.w   #4,d0
 add.w   d0,a0
TR_PutSquare:
 move.l  a2,a1
 bsr PutSprite
 move.l  a3,a1
 bsr PutSprite
 addq    #1,d2
 addq    #1,a2
 addq    #1,a3
 dbra    d3,TR_PutSquares
 movem.l (a7)+,d0-d4/a0-a4
 rts

TestMove:
 lea     curp(PC),a0
TestMoveA0:
 movem.l d2-d3/d7,-(a7)
 moveq   #3,d7
CheckSq:
 move.w  (a0)+,d2
 move.w  (a0)+,d3
 add.w   d5,d2
 lsl.w   #4,d2
 add.w   d3,d2
 add.w   d4,d2
 tst.b   0(a5,d2)
 bne TM_Done
 dbra    d7,CheckSq
 cmp.w   d0,d0
TM_Done:
 movem.l (a7)+,d2-d3/d7
 rts

Pause:
 move.w  timer(PC),d6
 move.l  #2560,-(a7)
 jsr tios::HeapAlloc
 lea     4(a7),a7
 move.w  d0,d7
 handle_ptr d0,a0
 move.l  a0,a3
 ;lea     $4c03,a1                       ;A
 move.l gray4lib::plane1,a1
 add.w #5,a1                                    ;3
 move.l  gray4lib::plane0,a2
 add.w   #5,a2                          ;10
 moveq   #127,d1
P_MoveRow:
 moveq   #4,d2
P_MoveWord:
 move.b  (a1),(a0)+
 clr.b   (a1)+
 move.b  (a1),(a0)+
 clr.b   (a1)+
 move.b  (a2),(a0)+
 clr.b   (a2)+
 move.b  (a2),(a0)+
 clr.b   (a2)+
 dbra    d2,P_MoveWord
 lea     20(a1),a1
 lea     20(a2),a2
 dbra    d1,P_MoveRow
 lea     pausedialog(PC),a6
 bsr ShowDialog
 SetFont #0
 WriteStr #60,#55,#4,paus2txt(PC)
 bsr CopyDialogBox
WaitPRel:
 GetKey  #$FFBF,d1
 btst    #7,d1
 beq WaitPRel
 sf      intflag
 clr.w   $759a;$75B0
 jsr util::idle_loop
 clr.w   -(a7)
 jsr tios::ST_busy
 addq    #2,a7
 st      intflag
WaitPRelA:
 GetKey  #$FFBF,d1
 btst    #7,d1
 beq WaitPRelA
 jsr util::clear_dialog
 bsr CopyDialogBox
 bsr ShowBrickWall
 move.l  gray4lib::plane1,a1
 ;lea     $4c06,a1               ; A
 add.w   #5,a1
 move.l  gray4lib::plane0,a2
 add.w   #5,a2                  ;10
 moveq   #127,d1
P_MoveRowB:
 moveq   #4,d2
P_MoveWordB:
 move.b  (a3)+,(a1)+
 move.b  (a3)+,(a1)+
 move.b  (a3)+,(a2)+
 move.b  (a3)+,(a2)+
 dbra    d2,P_MoveWordB
 lea     20(a1),a1
 lea     20(a2),a2
 dbra    d1,P_MoveRowB
 move.w  d7,-(a7)
 jsr tios::HeapFree
 addq    #2,a7
 move.w  d6,timer
 bra Main

TeacherKey:
 sf      intflag
 st      tkflag
 lea     $300,a0
 ;lea     $4C00,a1
 move.l  gray4lib::plane1,a1
 move.l  gray4lib::plane0,a2
 move.w  #959,d1
SaveScreen:
 move.l  (a1)+,(a0)+
 move.l  (a2)+,(a0)+
 dbra    d1,SaveScreen
; move.w  #264,$75B2
; move.w  #1,$75B0
 bra Done

ShowCurPiece:
 movem.l d0-d1/d6/a0,-(a7)
 lea     curp(PC),a0
 move.w  x(PC),d0
 move.w  y(PC),d1
 move.w  curPN(PC),d6
 bsr ShowPiece
 movem.l (a7)+,d0-d1/d6/a0
 rts

RemoveCurPiece:
 movem.l d0-d1/d6/a0,-(a7)
 lea     curp(PC),a0
 move.w  x(PC),d0
 move.w  y(PC),d1
 move.w  curPN(PC),d6
 bsr RemovePiece
 movem.l (a7)+,d0-d1/d6/a0
 rts

UncrunchCurPiece:
 movem.l d0-d1/a0,-(a7)
 lea     curp(PC),a0
 move.w  curPN(PC),d0
 move.w  rot(PC),d1
 bsr Uncrunch
 movem.l (a7)+,d0-d1/a0
 rts

SendBarInfo:
 move.l  a5,a0
 lea     35(a0),a0
 moveq   #16,d0
SBI_CheckRow:
 moveq   #9,d1
SBI_CheckCol
 tst.b   0(a0,d1)
 bne TileFound
 dbra    d1,SBI_CheckCol
 lea     16(a0),a0
 dbra    d0,SBI_CheckRow
TileFound:
 add.w   #$D0,d0
 bsr SendByte
 rts

ShowBar:
 moveq   #11,d2                         ;15
 ;lea     $4c03,a2                       ;8
 move.l  gray4lib::plane1,a2
 add.w #3,a2
 move.l  gray4lib::plane0,a3
 addq    #3,a3                          ;4
 add.w    #120,a2                        ;
 add.w    #120,a3                         ;
RepShowBar:
 lea     bargfx(PC),a0
 cmp.w   d1,d2
 bge EmptyBox
 addq    #8,a0
EmptyBox:
 move.l  a0,a4
 move.l  a2,a1
 bsr PutSprite
 move.l  a4,a0
 move.l  a3,a1
 bsr PutSprite
 lea     240(a2),a2
 lea     240(a3),a3
 dbra    d2,RepShowBar
 rts

NewPiece:
 lea     nextp(PC),a0
 moveq   #15,d0                 ;16
 moveq   #13,d1                 ;13
 bsr RemovePiece
 move.w  #6,x
 move.w #4,y                            ;clr.w   y
 clr.w   rot
 move.w  nextPN(PC),curPN
 bsr UncrunchCurPiece
 lea     curp(PC),a0
 bsr ShowCurPiece
RandomNewPiece:
 moveq   #7,d0
 jsr util::random
 move.w  d0,d6
 move.w  d0,nextPN
 move.w #1,d1
 ;clr.l   d1    ;;;;!!!!!!!!
 lea     nextp(PC),a0
 bsr Uncrunch
 moveq   #15,d0                 ;16                 
 moveq   #13,d1                 ;13
 move.w #1,rot  ;!!!!!!!
 bsr ShowPiece
 clr.w rot ;!!!!!!!
 move.w  levtimer(PC),timer
 add.w   #20,timer
 st      downflag
 clr.l   ltimer
 rts

ShowPiece:    ; Shows the piece no D6, (A0) at D0,D1
 movem.l d0-d5/a0-a4,-(a7)
 ;lea     $4C00,a1
 move.l gray4lib::plane1,a1
 move.l  gray4lib::plane0,a2
 lea     pgfx(PC),a3
 move.w  d6,d2
 lsl.w   #4,d2
 adda.w  d2,a3
 cmp.w   #6,d6
 bne StartPut
 cmp.w   #3,(a0)
 bne StartPut
 lea     64(a3),a3
StartPut:
 addq    #2,d0                 ;!!!!!! 7
 subq    #6,d1                  ;!!!!!! 2
 moveq   #3,d4
SP_PutSq:
 move.w  d0,d2
 move.w  d1,d3
 add.w   (a0)+,d3
 add.w   (a0)+,d2
 btst    #15,d3
 bne SP_SkipSq
 mulu    #240,d3
 add.w   #120,d3                ;!!!!!!!!
 add.w   d2,d3
 move.l  a3,a4
 moveq   #7,d5
SP_PutRow:
 move.b  (a4)+,0(a1,d3)
 move.b  7(a4),0(a2,d3)
 add.w   #30,d3
 dbra    d5,SP_PutRow
SP_SkipSq:
 cmp.w   #6,d6
 bne SP_NextSq
 lea     16(a3),a3
SP_NextSq:
 dbra    d4,SP_PutSq
 movem.l (a7)+,d0-d5/a0-a4
 rts

RemovePiece:   ; Removes the piece at (A0) at D0,D1
 movem.l d0-d5/a0-a2,-(a7)
 lea     $4C00,a1
 move.l  gray4lib::plane0,a2
 addq    #2,d0                          ; 7 !!!!!!
 subq    #6,d1                  ; 2 !!!!!
 moveq   #3,d4
RP_ClrSq:
 move.w  d0,d2
 move.w  d1,d3
 add.w   (a0)+,d3
 add.w   (a0)+,d2
 btst    #15,d3
 bne RP_SkipSq
 mulu    #240,d3
 add.w   #120,d3                ;!!!!!!
 add.w   d2,d3
 moveq   #7,d5
RP_PutRow:
 clr.b   0(a1,d3)
 clr.b   0(a2,d3)
 add.w   #30,d3
 dbra    d5,RP_PutRow
RP_SkipSq:
 dbra    d4,RP_ClrSq
 movem.l (a7)+,d0-d5/a0-a2
 rts

Uncrunch:     ; Uncrunch piece D0, rot D1 into (A0)
 movem.l d0-d2/a0-a1,-(a7)
 lea     pieces(PC),a1
 lsl.w   #3,d0
 lsl.w   #1,d1
 add.w   d1,d0
 move.w  0(a1,d0),d0
 moveq   #7,d1
GetBits:
 move.w  d0,d2
 lsr.w   #2,d0
 and.w   #$03,d2
 move.w  d2,(a0)+
 dbra    d1,GetBits
 movem.l (a7)+,d0-d2/a0-a1
 rts

NewGame:
 bsr ClrScr
 moveq   #17,d0
 move.l  a5,a1
ClrBoard:
 move.l  #$01010100,(a1)+
 clr.l   (a1)+
 clr.l   (a1)+
 move.l  #$00010101,(a1)+
 dbra    d0,ClrBoard
 moveq   #7,d0
BBorder:
 move.w  #$0101,(a1)+
 dbra    d0,BBorder
 tst.w   twopl
 beq StartGame
 lea     waitdialog(PC),a6
 bsr ShowDialog
 SetFont #0
 WriteStr #48,#55,#4,canctxt(PC)
 bsr CopyScreen
 move.b  #$AA,d0
 bsr SendByte
WaitReply:
 clr.w   KEY_PRESSED_FLAG ;$759a;$75B0
 bsr ReceiveByte
NoByte:
 cmp.b   #$AA,d0
 beq SynchDone
 cmp.w   #264,GETKEY_CODE ;$75B2     ;
 bne WaitReply          ;
 clr.w   KEY_PRESSED_FLAG ;$759a;$75B0
 addq    #4,a7
 bra MainRepeat
SynchDone:
 move.b  #$AA,d0
 bsr SendByte
 bsr ClrScr
 clr.l   d1
 bsr ShowBar
StartGame:
 st      intflag
 bsr ShowBrickWall
 move.w  high(PC),d1
 beq NoTrashRows
 lsl.w   #1,d1
 subq    #1,d1
TrashRows:
 bsr TrashRow
 dbra    d1,TrashRows
NoTrashRows:
 bsr RandomNewPiece
 bsr NewPiece
 clr.l   score
 clr.w   lines
 lea     levels(PC),a0
 move.w  level(PC),d0
 move.w  d0,st_lev
 lsl.w   #1,d0
 move.w  0(a0,d0),levtimer
ShowInfoText:
 SetFont #1
 WriteStr #129,#10,#4,scoretxt(PC)      ;184
 WriteStr #129,#28,#4,leveltxt(PC)      ;184
 WriteStr #129,#46,#4,linestxt(PC)      ;184
 bsr ShowScore
 rts

WriteChar:
 movem.l d0-d2/a0,-(a7)
 move.w  #$00FF,-(a7)
 clr.w   -(a7)
 move.w  #$00FF,-(a7)
 move.w  #4,-(a7)
 move.w  d1,-(a7)
 move.w  d0,-(a7)
 move.w  d2,-(a7)
 jsr tios::DrawCharXY
 lea     14(a7),a7
 movem.l (a7)+,d0-d2/a0
 rts

Menu:
 bsr ShowTetrisLogo
 SetFont #1
 lea     $4C00+48*30+3,a0 ;60*30 +5
 moveq   #20,d0         ;32
VLines:
 moveq   #10,d1
 move.l  a0,a1
VLine:
 cmp.b   #4,d1
 beq SkipVLine
; move.b  #$80,(a1)
SkipVLine:
 addq    #1,a1          ;2
 dbra    d1,VLine
 lea     30(a0),a0
 dbra    d0,VLines
 lea     $4C00+48*30+3,a0
 moveq   #2,d0
HLines:
 moveq   #9,d1         ;19
HLine:
 move.w  d1,d2
 subq    #6,d2
 asr.w   #2,d2
 beq SkipHLine
; st      (a0)
SkipHLine:
 addq    #1,a0
 dbra    d1,HLine
 lea     320(a0),a0
 dbra    d0,HLines
 moveq   #33,d0         ;44
 moveq   #50,d1         ;64
 moveq   #48,d2
 moveq   #9,d3
PutLDig:
 bsr WriteChar
 add.w   #8,d0 ;16
 addq    #1,d2
 cmp.w   #53,d2
 bne LSameRow
 moveq   #33,d0          ;44
 moveq   #60,d1         ;80
LSameRow:
 dbra    d3,PutLDig
 move.w  #105,d0        ;156
 moveq   #50,d1         ;64
 moveq   #48,d2
 moveq   #5,d3
PutRDig:
 bsr WriteChar
 add.w   #8,d0 ; 16
 addq    #1,d2
 cmp.w   #51,d2
 bne RSameRow
 move.w  #105,d0                ;156
 moveq   #60,d1                 ;80
RSameRow:
 dbra    d3,PutRDig


stlines:
 SetFont #2
 WriteStr #33,#36,#4,leveltxt(PC)
 WriteStr #100,#36,#4,hightxt(PC)
 SetFont #0
 WriteStr #30,#75,#4,disUtxt(PC)
 WriteStr #100,#75,#4,disDtxt(PC)
 WriteStr #30,#83,#4,tptxt(PC)
 WriteStr #30,#91,#4,ltxt(PC)
 move.l  #$0003C000,$4C00+80*30+2
 move.w  #$00F0,$4C00+80*30+12
 move.l  #$0003C000,$4C00+88*30+2
 move.w  #$003C,$4C00+96*30+4
 bsr CopyScreen
 bsr ShowFlags
 move.w  st_lev(PC),d0
 move.w  d0,d1
 moveq   #9,d6
 moveq   #5,d5
 bsr Mark
 move.w  high(PC),d0
 moveq   #5,d6
 moveq   #3,d5
 bsr Mark
 clr.l   d7
ChooseLevel:
 moveq   #5,d5
 moveq   #9,d6
ResTimer:
 move.w  #200,timer
WaitKey:
 tst.w   timer
 bne NoFlash
 move.w  #200,timer
 move.w  d1,d0
 bsr Mark
NoFlash:
; tst.w   $759a;$75B0
 tst.w KEY_PRESSED_FLAG
 beq WaitKey
 move.w  d1,d2
; move.w  $759a,d0;$75B2,d0
 move.w GETKEY_CODE,d0
; clr.w   $759a;$75B0
 clr.w KEY_PRESSED_FLAG
 cmp.w   #337,d0
 bne CDown
 cmp.w   d5,d1
 bcs WaitKey
 sub.w   d5,d1
 bra Update
CDown:
 cmp.w   #340,d0
 bne CLeft
 cmp.w   d5,d1
 bcc WaitKey
 add.w   d5,d1
 bra Update
CLeft:
 cmp.w   #338,d0
 bne CRight
 tst.w   d1
 beq WaitKey
 subq    #1,d1
 bra Update
CRight:
 cmp.w   #344,d0
 bne COther
 cmp.w   d6,d1
 beq WaitKey
 addq    #1,d1
Update:
 tst.w   d7
 bne NoRemove
 move.w  d2,d0
 bsr Mark
NoRemove:
 move.w  d1,d0
 bsr Mark
 clr.l   d7
 move.w  #200,timer
 bra WaitKey
COther:
 cmp.w   #264,d0
 beq Return
 cmp.w   #100,d0
 beq ChangeDisUFlag
 cmp.w   #105,d0
 beq ChangeDisDFlag
 cmp.w   #115,d0
 beq ChangeLLFlag
 cmp.w   #116,d0
 beq ChangeTPFlag
 cmp.w   #257,d0
 bne CEnter
 cmp.w   #9,d6
 beq WaitKey
 tst.w   d7
 beq ChooseLev
 move.w  d1,d0
 bsr Mark
ChooseLev:
 move.w  d1,high
 move.w  level(PC),d1
 bra ChooseLevel
CEnter:
 cmp.w   #13,d0
 bne WaitKey
 cmp.w   #9,d6
 bne HighChosen
 move.w  d1,level
 tst.w   d7
 beq ChooseHigh
 move.w  d1,d0
 bsr Mark
ChooseHigh:
 moveq   #3,d5
 moveq   #5,d6
 move.w  high(PC),d1
 bra ResTimer
HighChosen:
 move.w  d1,high
Return:
 rts

ChangeDisUFlag:
 eori.w  #8,disUflag
 bsr ShowFlags
 bra WaitKey

ChangeDisDFlag:
 eori.w  #8,disDflag
 bsr ShowFlags
 bra WaitKey

ChangeLLFlag:
 eori.w  #8,llflag
 bsr ShowFlags
 bra WaitKey

ChangeTPFlag:
 eori.w  #8,twopl
 bsr ShowFlags
 bra WaitKey

PutSprite:
 moveq   #7,d0
PS_PutRow:
 move.b  (a0)+,(a1)
 lea     30(a1),a1
 dbra    d0,PS_PutRow
 rts

ShowFlags:
 lea     box(PC),a0
 add.w   disDflag(PC),a0
 move.l  a0,a2
 move.l  gray4lib::plane0,a3
 move.l  gray4lib::plane1,a1
 add.w #2231,a1
 ;lea     $4C00+2956,a1

 bsr PutSprite
 add.w   #2231,a3                       ; 2956
 move.l  a3,a1
 move.l  a2,a0
 bsr PutSprite

 lea     box(PC),a0
 add.w   disUflag(PC),a0
 move.l  a0,a2
 move.l  gray4lib::plane0,a3
 move.l  gray4lib::plane1,a1
 add.w #2222,a1
 ;lea     $4C00+2946,a1 ;;
 bsr PutSprite
 add.w   #2222,a3               ;2946
 move.l  a3,a1
 move.l  a2,a0
 bsr PutSprite

 lea     box(PC),a0
 add.w   twopl(PC),a0
 move.l  a0,a2
 move.l gray4lib::plane1,a1
 add.l #2462,a1
 ;lea     $4C00+3215,a1
 bsr PutSprite
 add.w   #240,a3        ;300
 move.l  a3,a1
 move.l  a2,a0
 bsr PutSprite

 lea     box(PC),a0
 add.w   llflag(PC),a0
 move.l  a0,a2
 move.l gray4lib::plane1,a1
 add.w #2702,a1
 ;lea     $4C00+3515,a1
 bsr PutSprite
 add.w   #240,a3        ;300
 move.l  a3,a1
 move.l  a2,a0
 bsr PutSprite
 rts

Mark:
 movem.l d0-d1/a0,-(a7)
 bchg    #0,d7
 lea     $4C00+49*30+4,a0
 cmp.w   #9,d6
 beq MarkLevel
 lea     9(a0),a0
MarkLevel:
 cmp.w   d5,d0
 bcs MarkSquare
 sub.w   d5,d0
 lea     300(a0),a0     ;480
MarkSquare:
 ;lsl.w   #1,d0         ;!!!!
 moveq   #8,d1  ;14
ML_MarkRow:
 ;eori.b  #$7F,0(a0,d0)
 eori.b  #$FF,0(a0,d0)  ;1()
 lea     30(a0),a0
 dbra    d1,ML_MarkRow
 movem.l (a7)+,d0-d1/a0
 rts

CopyScreen:
 movem.l d0/a0-a1,-(a7)
 lea     $4C00,a0
 move.l  gray4lib::plane0,a1
 move.w  #959,d0
RepCopy:
 move.l  (a0)+,(a1)+
 dbra    d0,RepCopy
 movem.l (a7)+,d0/a0-a1
 rts

Titel:
 bsr ShowTetrisLogo
 SetFont #2
 WriteStr #48,#46,#4,top5txt(PC)
 SetFont #0
 WriteStr #16,#35,#4,author(PC)
 lea     hiscore(PC),a2
 moveq   #30,d0
 moveq   #58,d1
 move.l  #$002E0031,d2
 moveq   #4,d3
ShowHiscore:
 bsr WriteChar
 swap    d2
 addq    #6,d0
 bsr WriteChar
 swap    d2
 subq    #6,d0
 move.l  d1,d4
 movem.l d0-d2,-(a7)
 WriteStrA #38,d1,#4,a2
 lea     tmpstr+6(PC),a0
 move.l  16(a2),d0
 moveq   #6,d1
 bsr ConvStr
 WriteStrA #120,d4,#4,a0
 movem.l (a7)+,d0-d2
 lea     20(a2),a2
 addq    #1,d2
 addq    #7,d1
 dbra    d3,ShowHiscore
 bsr CopyScreen
 rts

ShowTetrisLogo:
 bsr ClrScr
 lea     $4c05+120,a0 ; $4c0A
 lea     logo(PC),a1
 moveq   #27,d0
ShowLogo:
 moveq   #9,d1
ShowLogoRow:
 move.b  (a1)+,(a0)+
 dbra    d1,ShowLogoRow
 lea     20(a0),a0
 dbra    d0,ShowLogo
 rts

ShowDialog:
 jsr util::show_dialog
CopyDialogBox:
 lea     $4C00+$1C*30+2,a0
 move.l  gray4lib::plane0,a1
 add.w   #$1C*30+2,a1
 moveq   #39,d0
SD_CopyRow:
 moveq   #13,d1                         ;11
SD_CopyByte:
 move.b  (a0)+,(a1)+
 dbra    d1,SD_CopyByte
 lea     16(a0),a0                      ;16
 lea     16(a1),a1                      ;16
 dbra    d0,SD_CopyRow
 rts

ClrScr:
 movem.l d0/a0-a1,-(a7)
 lea     $4C00,a0
 move.l  gray4lib::plane0,a1
 move.w  #959,d0
RepClr:
 clr.l   (a0)+
 clr.l   (a1)+
 dbra    d0,RepClr
 movem.l (a7)+,d0/a0-a1
 rts

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
 nop
 nop
 move.b  $60001B,(a0)+
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
 nop
 nop
 rol.w   #1,d0
 dbra    d1,GetKeys
 movem.l (a7)+,d0-d1/a0
 rts

ShowBrickWall:
 ;lea     $4C00,a0
 move.l  gray4lib::plane1,a0
 move.l  gray4lib::plane0,a1
 moveq   #15,d0
PutBrickWall:
 lea     brickgfx(PC),a2
 moveq   #7,d1
PBWRow:
 move.b  (a2),4(a0)                     ;9 ;4
 move.b  8(a2),4(a1)
 move.b  (a2)+,15(a0)                   ;20 ;15
 move.b  7(a2),15(a1)
 lea     30(a0),a0
 lea     30(a1),a1
 dbra    d1,PBWRow
 dbra    d0,PutBrickWall
 rts

SendByte:
 movem.l d0-d1/a0-a1,-(a7)
 move.b  d0,linkbuf
 move.w  #1,-(a7)
 pea     linkbuf(PC)
 jsr tios::transmit
 addq    #6,a7
 movem.l (a7)+,d0-d1/a0-a1
 rts

ReceiveByte:
 movem.l d1/a0-a1,-(a7)
 clr.b   linkbuf
 move.w  #1,-(a7)
 pea     linkbuf(PC)
 jsr tios::receive
 addq    #6,a7
 clr.l   d0
 move.b  linkbuf(PC),d0
 movem.l (a7)+,d1/a0-a1
 rts

Init:
 move.l  #304,-(a7)
 jsr tios::HeapAlloc
 lea     4(a7),a7
 move.w  d0,boardH
 handle_ptr d0,a5
 sf      intflag
 move.w  #$0700,d0
 trap #1
 move.l  ($040064),oldint1
 bclr.b #2,$600001
 move.l  #IntHandler,($040064)
 bset.b #2,$600001
 trap #1
 jsr gray4lib::on
 rts

Done:
 jsr gray4lib::off
 move.w  #$2700,d0
 trap #1
 bclr.b #2,$600001
 move.l  oldint1(PC),($040064)
 bset.b #2,$600001
 trap #1
 move.w  boardH(PC),-(a7)
 jsr tios::HeapFree
 addq    #2,a7
 movem.l (a7)+,d0-d7/a0-a6
 rts

IntHandler:
 tst.w   timer
 beq DecLTimer
 subq.w  #1,timer
DecLTimer:
 tst.w   ltimer
 beq DecRTimer
 subq.w  #1,ltimer
DecRTimer:
 tst.w   rtimer
 beq CheckFlag
 subq.w  #1,rtimer
CheckFlag:
 tst.b   intflag
 bne EndInt
 move.l  oldint1(PC),-(a7)
 rts
EndInt:
 rte

boardH   dc.w 0
oldint1  dc.l 0

curp     ds.w 8
nextp    ds.w 8
tmpp     ds.w 8
curPN    dc.w 0
nextPN   dc.w 0
x        dc.w 0
y        dc.w 0
rot      dc.w 0
rows     ds.w 4

score    dc.l 0
lines    dc.w 0

level    dc.w 0
high     dc.w 0

st_lev   dc.w 0
st_high  dc.w 0
disUflag dc.w 0
disDflag dc.w 0
llflag   dc.w 0
twopl    dc.w 0

timer    dc.w 0
ltimer   dc.w 0
rtimer   dc.w 0
levtimer dc.w 0

tmpstr   ds.b 8

levels
 dc.w 310,258,215,179,149,124,104,86,72,60
 dc.w 51,40,36,32,28,24,20,16,13,10,8,6,5,4,3,2,1,0

scoring
 dc.w 40,100,300,1200

pieces
 dc.w %0010011010101011,%0101011000110111
 dc.w %0001001001101010,%0101100101100111
 dc.w %0010011010100011,%0001010101100111
 dc.w %0010011010101001,%0101011001111011
 dc.w %0110101001111011,%0110101001111011
 dc.w %0110101001111011,%0110101001111011
 dc.w %0010011010100111,%0010010101100111
 dc.w %0010010101101010,%0101011001111010
 dc.w %0011011001111010,%0001001001100111
 dc.w %0011011001111010,%0001001001100111
 dc.w %0010011001111011,%0010001101010110
 dc.w %0010011001111011,%0010001101010110
 dc.w %0010011010101110,%0100010101100111
 dc.w %0010011010101110,%0100010101100111

empty
 dc.w 0,0,0,0,0,0,0,0

pgfx
 dc.b $FF,$81,$BD,$A5,$A5,$BD,$81,$FF
 dc.b $FF,$FF,$FF,$E7,$E7,$FF,$FF,$FF
 dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 dc.b $FF,$81,$81,$81,$81,$81,$81,$FF
 dc.b $FF,$81,$BD,$BD,$BD,$BD,$81,$FF
 dc.b $FF,$81,$BD,$BD,$BD,$BD,$81,$FF
 dc.b $FF,$81,$81,$85,$85,$BD,$81,$FF
 dc.b $FF,$FF,$C3,$DF,$DF,$FF,$FF,$FF
 dc.b $FF,$FF,$FF,$E7,$E7,$FF,$FF,$FF
 dc.b $FF,$81,$BD,$A5,$A5,$BD,$81,$FF
 dc.b $FF,$81,$81,$99,$99,$81,$81,$FF
 dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

 dc.b $FF,$89,$21,$05,$51,$03,$29,$FF
 dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 dc.b $FF,$A8,$02,$40,$84,$11,$44,$FF
 dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 dc.b $FF,$A0,$02,$20,$84,$11,$44,$FF
 dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 dc.b $FF,$A4,$80,$CA,$80,$A2,$88,$FF
 dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 dc.b $83,$91,$C5,$91,$C3,$85,$A1,$FF
 dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 dc.b $93,$C1,$8B,$A1,$83,$D1,$85,$A1
 dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 dc.b $93,$C1,$8B,$A1,$81,$B1,$85,$A1
 dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
 dc.b $FF,$89,$A3,$81,$C9,$83,$A9,$81
 dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

box
 dc.b %1111111,%1000001,%1000001,%1000001,%1000001,%1000001,%1111111,0
 dc.b %1111111,%1100011,%1010101,%1001001,%1010101,%1100011,%1111111,0

bargfx
 dc.b $00,$C6,$82,$82,$82,$82,$82,$C6
 dc.b $00,$C6,$82,$BA,$BA,$BA,$82,$C6

brickgfx
 dc.b $44,$44,$44,$FF,$11,$11,$11,$FF
 dc.b $DD,$FF,$FF,$FF,$77,$FF,$FF,$FF

logo
 dc.b $00,$00,$00,$04,$00,$00,$00,$00,$00,$00
 dc.b $00,$7F,$FF,$F8,$00,$00,$00,$00,$00,$00
 dc.b $03,$FF,$FF,$F0,$00,$00,$00,$00,$00,$00
 dc.b $0F,$FF,$FF,$C0,$00,$00,$00,$06,$00,$00
 dc.b $1F,$C0,$00,$00,$00,$20,$00,$0F,$00,$00
 dc.b $38,$38,$00,$00,$00,$20,$00,$0F,$00,$00
 dc.b $60,$07,$00,$00,$00,$60,$00,$0E,$00,$00
 dc.b $40,$03,$C0,$00,$00,$60,$00,$04,$00,$00
 dc.b $80,$01,$E0,$00,$00,$E0,$00,$00,$00,$00
 dc.b $80,$01,$E0,$01,$E3,$F8,$41,$86,$01,$C8
 dc.b $80,$00,$F0,$07,$F0,$E0,$E3,$CF,$07,$F8
 dc.b $00,$00,$F0,$0C,$F8,$E1,$E7,$D7,$0C,$30
 dc.b $03,$80,$F8,$18,$70,$E2,$ED,$C7,$0E,$10
 dc.b $0C,$60,$78,$18,$60,$E0,$E9,$87,$0F,$00
 dc.b $10,$30,$78,$38,$40,$E0,$F1,$07,$07,$80
 dc.b $20,$18,$78,$38,$80,$E0,$E0,$07,$03,$E0
 dc.b $20,$18,$78,$39,$00,$E0,$E0,$07,$01,$F0
 dc.b $40,$18,$78,$3A,$00,$E0,$E0,$07,$08,$78
 dc.b $40,$18,$78,$3C,$00,$E4,$E0,$07,$08,$38
 dc.b $40,$10,$78,$3E,$10,$E8,$E0,$07,$4C,$18
 dc.b $60,$20,$78,$1F,$E0,$F0,$E0,$07,$8F,$30
 dc.b $60,$00,$70,$0F,$C0,$60,$C0,$03,$07,$E0
 dc.b $70,$00,$F0,$00,$00,$00,$00,$00,$00,$00
 dc.b $30,$00,$E0,$00,$00,$00,$00,$00,$00,$00
 dc.b $38,$01,$C0,$00,$00,$00,$00,$00,$00,$00
 dc.b $1C,$03,$80,$00,$00,$00,$00,$00,$00,$00
 dc.b $0F,$0F,$00,$00,$00,$00,$00,$00,$00,$00
 dc.b $03,$FC,$00,$00,$00,$00,$00,$00,$00,$00

losedialog
 dc.l $0020001C,$007F0044,$0008000F,gotxt,0

windialog
 dc.l $0020001C,$007F0044,$001B000F,wintxt,0

waitdialog
 dc.l $0020001C,$007F0044,$001B000C,waittxt,0

pausedialog
 dc.l $0020001C,$007F0044,$001B000C,pausetxt,0

hiscore
 dc.b "---------------",0,0,0,0,0
 dc.b "---------------",0,0,0,0,0
 dc.b "---------------",0,0,0,0,0
 dc.b "---------------",0,0,0,0,0
 dc.b "---------------",0,0,0,0,0

intflag  dc.b 0
downflag dc.b 0
upflag   dc.b 0
linkbuf  dc.b 0
tkflag   dc.b 0

keystat  ds.b 10

oldstackptr dc.l 0

scoretxt dc.b "SCORE",0
leveltxt dc.b "LEVEL",0
linestxt dc.b "LINES",0
hightxt  dc.b "HIGH",0
pausetxt dc.b "PAUSE",0
paus2txt dc.b "PRESS ANY KEY",0
waittxt  dc.b "WAITING",0
canctxt  dc.b "PRESS ESC TO CANCEL",0
gotxt    dc.b "GAME OVER",0
wintxt   dc.b "YOU WIN",0

disUtxt  dc.b "Disable ",23,0
disDtxt  dc.b "Disable ",24,0

tptxt    dc.b "Two player mode (link)",0
ltxt     dc.b "2P: Send one row less",0

author   dc.b "by Jimmy M",$E2,"rdell <mja@algonet.se>",0
top5txt  dc.b "TOP FIVE",0
ent1txt  dc.b "CONGRATULATIONS!",0
ent2txt  dc.b "You entered the Top Five list!",0
ent3txt  dc.b "Enter your name:",0

_comment dc.b "Tetris 89. (RPS)",0

 end
