; lib.s - ライブラリ
;


; 6502 - CPU の選択
.setcpu     "6502"

; 自動インポート
.autoimport +

; エスケープシーケンスのサポート
.feature    string_escapes


; ファイルの参照
;
.include    "apple2.inc"
.include    "iocs.inc"
.include    "lib.inc"


; コードの定義
;
.segment    "BOOT"

; 直線を描画する
;
.global _LibDrawLine
.proc   _LibDrawLine

    ; IN
    ;   ax[0] = X 開始位置
    ;   ax[1] = Y 開始位置
    ;   ax[2] = X 終了位置
    ;   ax[3] = Y 終了位置
    ; WORK
    ;   LIB_0_WORK_0..1

    ; 引数の保持
    stx     LIB_0_WORK_0
    sta     LIB_0_WORK_1

    ; 位置の取得
    ldy     #$00
    lda     (LIB_0_WORK_0), y
    sta     LIB_0_LINE_X_1
    iny
    lda     (LIB_0_WORK_0), y
    sta     LIB_0_LINE_Y_1
    iny
    lda     (LIB_0_WORK_0), y
    sta     LIB_0_LINE_X_2
    iny
    lda     (LIB_0_WORK_0), y
    sta     LIB_0_LINE_Y_2

    ; X_1 < X_2
    lda     LIB_0_LINE_X_1
    cmp     LIB_0_LINE_X_2
    beq     @line_v
    bcc     :+
    ldx     LIB_0_LINE_X_2
    stx     LIB_0_LINE_X_1
    sta     LIB_0_LINE_X_2
    lda     LIB_0_LINE_Y_1
    ldy     LIB_0_LINE_Y_2
    sty     LIB_0_LINE_Y_1
    sta     LIB_0_LINE_Y_2
:
    ldx     LIB_0_LINE_X_1
    ldy     LIB_0_LINE_Y_1
    jsr     LibGetShapeAddr

    ; 傾きの判定
    lda     LIB_0_LINE_X_2
    sec
    sbc     LIB_0_LINE_X_1
    sta     LIB_0_LINE_DX
    inc     LIB_0_LINE_DX
    lda     LIB_0_LINE_Y_2
    sec
    sbc     LIB_0_LINE_Y_1
    beq     @line_h
    bcc     :+
    sta     LIB_0_LINE_DY
    inc     LIB_0_LINE_DY
    lda     LIB_0_LINE_DX
    cmp     LIB_0_LINE_DY
    bcs     @line_p0045
    jmp     @line_p4590
:
    eor     #$ff
    sta     LIB_0_LINE_DY
    inc     LIB_0_LINE_DY
    inc     LIB_0_LINE_DY
    lda     LIB_0_LINE_DX
    cmp     LIB_0_LINE_DY
    bcc     :+
    jmp     @line_m0045
:
    jmp     @line_m4590

    ; 垂直線の描画
@line_v:
    lda     LIB_0_LINE_Y_1
    cmp     LIB_0_LINE_Y_2
    bcc     :+
    ldy     LIB_0_LINE_Y_2
    sty     LIB_0_LINE_Y_1
    sta     LIB_0_LINE_Y_2
:
    lda     LIB_0_LINE_Y_2
    sec
    sbc     LIB_0_LINE_Y_1
    sta     LIB_0_LINE_DY
    inc     LIB_0_LINE_DY
    ldx     LIB_0_LINE_X_1
    ldy     LIB_0_LINE_Y_1
    jsr     LibGetShapeAddr
:
    jsr     @set_pixel
    dec     LIB_0_LINE_DY
    beq     :+
    jsr     @move_down
    jmp     :-
:
    rts

    ; 水平線の描画
@line_h:
:
    jsr     @set_pixel
    dec     LIB_0_LINE_DX
    beq     :+
    jsr     @move_right
    jmp     :-
:
    rts

    ; +0 〜 +45 度線の描画
@line_p0045:
    lda     LIB_0_LINE_DX
    sta     LIB_0_LINE_LENGTH
    lsr     a
    sta     LIB_0_LINE_S
:
    jsr     @set_pixel
    dec     LIB_0_LINE_LENGTH
    beq     :+
    jsr     @move_right
    lda     LIB_0_LINE_S
    sec
    sbc     LIB_0_LINE_DY
    sta     LIB_0_LINE_S
    bcs     :-
;   clc
    adc     LIB_0_LINE_DX
    sta     LIB_0_LINE_S
    jsr     @move_down
    jmp     :-
:
    rts

    ; +45 〜 +90 度線の描画
@line_p4590:
    lda     LIB_0_LINE_DY
    sta     LIB_0_LINE_LENGTH
    lsr     a
    sta     LIB_0_LINE_S
:
    jsr     @set_pixel
    dec     LIB_0_LINE_LENGTH
    beq     :+
    jsr     @move_down
    lda     LIB_0_LINE_S
    sec
    sbc     LIB_0_LINE_DX
    sta     LIB_0_LINE_S
    bcs     :-
;   clc
    adc     LIB_0_LINE_DY
    sta     LIB_0_LINE_S
    jsr     @move_right
    jmp     :-
:
    rts

    ; -0 〜 -45 度線の描画
@line_m0045:
    lda     LIB_0_LINE_DX
    sta     LIB_0_LINE_LENGTH
    lsr     a
    sta     LIB_0_LINE_S
:
    jsr     @set_pixel
    dec     LIB_0_LINE_LENGTH
    beq     :+
    jsr     @move_right
    lda     LIB_0_LINE_S
    sec
    sbc     LIB_0_LINE_DY
    sta     LIB_0_LINE_S
    bcs     :-
;   clc
    adc     LIB_0_LINE_DX
    sta     LIB_0_LINE_S
    jsr     @move_up
    jmp     :-
:
    rts

    ; -45 〜 -90 度線の描画
@line_m4590:
    lda     LIB_0_LINE_DY
    sta     LIB_0_LINE_LENGTH
    lsr     a
    sta     LIB_0_LINE_S
:
    jsr     @set_pixel
    dec     LIB_0_LINE_LENGTH
    beq     :+
    jsr     @move_up
    lda     LIB_0_LINE_S
    sec
    sbc     LIB_0_LINE_DX
    sta     LIB_0_LINE_S
    bcs     :-
;   clc
    adc     LIB_0_LINE_DY
    sta     LIB_0_LINE_S
    jsr     @move_right
    jmp     :-
:
    rts

    ; ピクセルの描画
@set_pixel:
    ldy     #$00
    lda     (LIB_0_SHAPE_ADDR), y
    ora     LIB_0_SHAPE_BIT
    sta     (LIB_0_SHAPE_ADDR), y
    rts

    ; アドレスの更新
@move_up:
    lda     LIB_0_SHAPE_ADDR_H
    sec
    sbc     #$04
    sta     LIB_0_SHAPE_ADDR_H
    cmp     #$20
    bcs     :+
    ldx     LIB_0_SHAPE_INDEX
    lda     LIB_0_SHAPE_ADDR_L
    sec
    sbc     _iocs_hgr_tile_y_address_low, x
    dex
    clc
    adc     _iocs_hgr_tile_y_address_low, x
    sta     LIB_0_SHAPE_ADDR_L
    lda     _iocs_hgr_tile_y_address_high, x
    clc
    adc     #$1c
    sta     LIB_0_SHAPE_ADDR_H
    stx     LIB_0_SHAPE_INDEX
:
    rts
@move_down:
    lda     LIB_0_SHAPE_ADDR_H
    clc
    adc     #$04
    sta     LIB_0_SHAPE_ADDR_H
    cmp     #$40
    beq     :+
    bcc     :++
:
    ldx     LIB_0_SHAPE_INDEX
    lda     LIB_0_SHAPE_ADDR_L
    sec
    sbc     _iocs_hgr_tile_y_address_low, x
    inx
    clc
    adc     _iocs_hgr_tile_y_address_low, x
    sta     LIB_0_SHAPE_ADDR_L
    lda     _iocs_hgr_tile_y_address_high, x
    sta     LIB_0_SHAPE_ADDR_H
    stx     LIB_0_SHAPE_INDEX
:
    rts
@move_right:
    asl     LIB_0_SHAPE_BIT
    bpl     :+
    inc     LIB_0_SHAPE_ADDR_L
    lda     #%00000001
    sta     LIB_0_SHAPE_BIT
:
    rts

.endproc

; 矩形を描画する
;
.global _LibDrawRect
.proc   _LibDrawRect

    ; IN
    ;   ax[0] = 左位置
    ;   ax[1] = 上位置
    ;   ax[2] = 右位置
    ;   ax[3] = 下位置
    ; WORK
    ;   LIB_0_WORK_0..3

    ; 引数の保持
    stx     LIB_0_WORK_0
    sta     LIB_0_WORK_1

    ; 直線の設定
    ldy     #$00
    lda     (LIB_0_WORK_0), y
    sta     @line + $0000 + $0000
    sta     @line + $0004 + $0000
    sta     @line + $0008 + $0000
    sta     @line + $0008 + $0002
    iny
    lda     (LIB_0_WORK_0), y
    sta     @line + $0000 + $0001
    sta     @line + $0000 + $0003
    sta     @line + $0008 + $0001
    sta     @line + $000c + $0001
    iny
    lda     (LIB_0_WORK_0), y
    sta     @line + $0000 + $0002
    sta     @line + $0004 + $0002
    sta     @line + $000c + $0000
    sta     @line + $000c + $0002
    iny
    lda     (LIB_0_WORK_0), y
    sta     @line + $0004 + $0001
    sta     @line + $0004 + $0003
    sta     @line + $0008 + $0003
    sta     @line + $000c + $0003

    ; 直線の描画
    ldx     #<(@line + $0000)
    lda     #>(@line + $0000)
    jsr     _LibDrawLine
    ldx     #<(@line + $0004)
    lda     #>(@line + $0004)
    jsr     _LibDrawLine
    ldx     #<(@line + $0008)
    lda     #>(@line + $0008)
    jsr     _LibDrawLine
    ldx     #<(@line + $000c)
    lda     #>(@line + $000c)
    jsr     _LibDrawLine

    ; 終了
    rts

; 直線
@line:

    .byte   $00, $00, $00, $00
    .byte   $00, $00, $00, $00
    .byte   $00, $00, $00, $00
    .byte   $00, $00, $00, $00

.endproc

; 矩形を塗りつぶす
;
.global _LibFillRect
.proc   _LibFillRect

    ; IN
    ;   ax[0] = 左位置
    ;   ax[1] = 上位置
    ;   ax[2] = 右位置
    ;   ax[3] = 下位置
    ; WORK
    ;   LIB_0_WORK_0..3

    ; 引数の保持
    stx     LIB_0_WORK_0
    sta     LIB_0_WORK_1

    ; 位置の取得
    ldy     #$00
    lda     (LIB_0_WORK_0), y
    sta     LIB_0_RECT_X_1
    iny
    lda     (LIB_0_WORK_0), y
    sta     LIB_0_RECT_Y_1
    iny
    lda     (LIB_0_WORK_0), y
    sta     LIB_0_RECT_X_2
    iny
    lda     (LIB_0_WORK_0), y
    sta     LIB_0_RECT_Y_2

    ; X_1 < X_2
    lda     LIB_0_RECT_X_1
    cmp     LIB_0_RECT_X_2
    bcc     :+
    ldx     LIB_0_RECT_X_2
    stx     LIB_0_RECT_X_1
    sta     LIB_0_RECT_X_2
:
    lda     LIB_0_RECT_X_2
    sec
    sbc     LIB_0_RECT_X_1
    sta     LIB_0_RECT_DX
    inc     LIB_0_RECT_DX

    ; Y_1 < Y_2
    lda     LIB_0_RECT_Y_1
    cmp     LIB_0_RECT_Y_2
    bcc     :+
    ldx     LIB_0_RECT_Y_2
    stx     LIB_0_RECT_Y_1
    sta     LIB_0_RECT_Y_2
:
    lda     LIB_0_RECT_Y_2
    sec
    sbc     LIB_0_RECT_Y_1
    sta     LIB_0_RECT_DY
    inc     LIB_0_RECT_DY

    ; 位置の取得
    ldx     LIB_0_RECT_X_1
    ldy     LIB_0_RECT_Y_1
    jsr     LibGetShapeAddr
    lda     LIB_0_SHAPE_ADDR_L
    sta     LIB_0_RECT_ADDR_L

    ; ビットの反転
    lda     LIB_0_SHAPE_BIT
    eor     #$ff
    sta     LIB_0_SHAPE_BIT
    sta     LIB_0_RECT_BIT

    ; 水平線の描画
@line:
    lda     LIB_0_RECT_DX
    sta     LIB_0_RECT_LENGTH

    ; 最初の 1 byte 境界の描画
    lda     LIB_0_SHAPE_BIT
    cmp     #%11111110
    beq     :++
:
    jsr     @set_pixel
    dec     LIB_0_RECT_LENGTH
    beq     @next
    sec
    rol     LIB_0_SHAPE_BIT
    bmi     :-
    inc     LIB_0_SHAPE_ADDR_L
    lda     #%11111110
    sta     LIB_0_SHAPE_BIT
:

    ; 1 byte 単位の描画
:
    lda     LIB_0_RECT_LENGTH
    sec
    sbc     #7
    bcc     :+
    sta     LIB_0_RECT_LENGTH
    ldy     #$00
    lda     (LIB_0_SHAPE_ADDR), y
    and     #%10000000
    sta     (LIB_0_SHAPE_ADDR), y
    inc     LIB_0_SHAPE_ADDR_L
    jmp     :-
:

    ; 最後の 1 byte 境界の描画
    lda     LIB_0_RECT_LENGTH
    beq     @next
:
    jsr     @set_pixel
    dec     LIB_0_RECT_LENGTH
    beq     @next
    sec
    rol     LIB_0_SHAPE_BIT
    jmp     :-

    ; 次の水平線へ
@next:
    dec     LIB_0_RECT_DY
    beq     :+
    jsr     @move_down
    jmp     @line
:

    ; 終了
    rts

;   ; 水平線の描画
;:
;   lda     LIB_0_RECT_DX
;   sta     LIB_0_RECT_LENGTH
;:
;   jsr     @set_pixel
;   dec     LIB_0_RECT_LENGTH
;   beq     :+
;   jsr     @move_right
;   jmp     :-
;:
;   dec     LIB_0_RECT_DY
;   beq     :+
;   jsr     @move_down
;   jmp     :---
;:
;   rts

    ; ピクセルの描画
@set_pixel:
    ldy     #$00
    lda     (LIB_0_SHAPE_ADDR), y
    and     LIB_0_SHAPE_BIT
    sta     (LIB_0_SHAPE_ADDR), y
    rts

    ; アドレスの更新
@move_down:
    lda     LIB_0_SHAPE_ADDR_H
    clc
    adc     #$04
    sta     LIB_0_SHAPE_ADDR_H
    cmp     #$40
    beq     :+
    bcs     :+
    lda     LIB_0_RECT_ADDR_L
    sta     LIB_0_SHAPE_ADDR_L
    jmp     :++
:
    ldx     LIB_0_SHAPE_INDEX
    lda     LIB_0_RECT_ADDR_L
    sec
    sbc     _iocs_hgr_tile_y_address_low, x
    inx
    clc
    adc     _iocs_hgr_tile_y_address_low, x
    sta     LIB_0_SHAPE_ADDR_L
    sta     LIB_0_RECT_ADDR_L
    lda     _iocs_hgr_tile_y_address_high, x
    sta     LIB_0_SHAPE_ADDR_H
    stx     LIB_0_SHAPE_INDEX
:
    lda     LIB_0_RECT_BIT
    sta     LIB_0_SHAPE_BIT
    rts
@move_right:
    asl     LIB_0_SHAPE_BIT
    bpl     :+
    inc     LIB_0_SHAPE_ADDR_L
    lda     #%00000001
    sta     LIB_0_SHAPE_BIT
:
    rts

.endproc

; 円を描画する
;
.global _LibDrawCircle
.proc   _LibDrawCircle

    ; IN
    ;   ax[0] = 中心 X 位置
    ;   ax[1] = 中心 Y 位置
    ;   ax[2] = 半径
    ; WORK
    ;   LIB_0_WORK_0..3

    ; 引数の保持
    stx     LIB_0_WORK_0
    sta     LIB_0_WORK_1

    ; 中心と半径の取得
    ldy     #$00
    lda     (LIB_0_WORK_0), y
    sta     LIB_0_CIRCLE_OX
    iny
    lda     (LIB_0_WORK_0), y
    sta     LIB_0_CIRCLE_OY
    iny
    lda     (LIB_0_WORK_0), y
    sta     LIB_0_CIRCLE_R

    ; 円の描画
;   lda     LIB_0_CIRCLE_R
    sta     LIB_0_CIRCLE_X
    lda     #$00
    sta     LIB_0_CIRCLE_Y

    ; ピクセルの描画
@draw:
    lda     LIB_0_CIRCLE_X
    cmp     LIB_0_CIRCLE_Y
    bcs     :+
    rts
:
    lda     LIB_0_CIRCLE_OX
    clc
    adc     LIB_0_CIRCLE_X
    pha
    tax
    lda     LIB_0_CIRCLE_OY
    clc
    adc     LIB_0_CIRCLE_Y
    tay
    jsr     _LibDrawPixel
    pla
    tax
    lda     LIB_0_CIRCLE_OY
    sec
    sbc     LIB_0_CIRCLE_Y
    tay
    jsr     _LibDrawPixel
    lda     LIB_0_CIRCLE_OX
    sec
    sbc     LIB_0_CIRCLE_X
    pha
    tax
    lda     LIB_0_CIRCLE_OY
    clc
    adc     LIB_0_CIRCLE_Y
    tay
    jsr     _LibDrawPixel
    pla
    tax
    lda     LIB_0_CIRCLE_OY
    sec
    sbc     LIB_0_CIRCLE_Y
    tay
    jsr     _LibDrawPixel
    lda     LIB_0_CIRCLE_OX
    clc
    adc     LIB_0_CIRCLE_Y
    pha
    tax
    lda     LIB_0_CIRCLE_OY
    clc
    adc     LIB_0_CIRCLE_X
    tay
    jsr     _LibDrawPixel
    pla
    tax
    lda     LIB_0_CIRCLE_OY
    sec
    sbc     LIB_0_CIRCLE_X
    tay
    jsr     _LibDrawPixel
    lda     LIB_0_CIRCLE_OX
    sec
    sbc     LIB_0_CIRCLE_Y
    pha
    tax
    lda     LIB_0_CIRCLE_OY
    clc
    adc     LIB_0_CIRCLE_X
    tay
    jsr     _LibDrawPixel
    pla
    tax
    lda     LIB_0_CIRCLE_OY
    sec
    sbc     LIB_0_CIRCLE_X
    tay
    jsr     _LibDrawPixel

    ; 次のピクセルへ
    lda     LIB_0_CIRCLE_Y
    asl     a
    sta     LIB_0_WORK_0
    inc     LIB_0_WORK_0
    lda     LIB_0_CIRCLE_R
    sec
    sbc     LIB_0_WORK_0
    sta     LIB_0_CIRCLE_R
    bcc     :+
    bne     :++
:
    dec     LIB_0_CIRCLE_X
    lda     LIB_0_CIRCLE_X
    asl     a
    sta     LIB_0_WORK_0
    lda     LIB_0_CIRCLE_R
    clc
    adc     LIB_0_WORK_0
    sta     LIB_0_CIRCLE_R
:
    inc     LIB_0_CIRCLE_Y
    jmp     @draw

.endproc

; ピクセルを描画する
;
.global _LibDrawPixel
.proc   _LibDrawPixel

    ; IN
    ;   x = X 位置
    ;   y = Y 位置
    ; WORK
    ;   LIB_0_WORK_0..1

    ; アドレスの取得
    jsr     LibGetShapeAddr

    ; ピクセルの描画
    ldy     #$00
    lda     (LIB_0_SHAPE_ADDR), y
    ora     LIB_0_SHAPE_BIT
    sta     (LIB_0_SHAPE_ADDR), y
    
    ; 終了
    rts

.endproc

; 図形を描画する
;
.global _LibDrawShapes
.proc   _LibDrawShapes

    ; IN
    ;   ax[n + 0] = 種類（0: 終了, 1: 直線, 2: 矩形, 3: 塗り潰しの矩形（枠あり）, 4: 塗り潰しの矩形（枠なし）, 5: 円）
    ;   ax[n + 1] = 引数
    ;     :
    ; WORK
    ;   LIB_0_WORK_0..1

    ; 引数の保持
    stx     LIB_0_SHAPE_ARG_L
    sta     LIB_0_SHAPE_ARG_H

    ; 種類の取得
@shape:
    ldy     #$00
    lda     (LIB_0_SHAPE_ARG), y
    bne     :+
    jmp     @end
:
    tay
    inc     LIB_0_SHAPE_ARG_L
    bne     :+
    inc     LIB_0_SHAPE_ARG_H
:
    ldx     LIB_0_SHAPE_ARG_L
    lda     LIB_0_SHAPE_ARG_H

    ; 直線の描画
    cpy     #$01
    bne     :+
    jsr     _LibDrawLine
    lda     #$04
    jmp     @next
:

    ; 矩形の描画
    cpy     #$02
    bne     :+
    jsr     _LibDrawRect
    lda     #$04
    jmp     @next
:

    ; 矩形の塗り潰し（枠あり）
    cpy     #$03
    bne     :+
    ldy     #$00
    lda     (LIB_0_SHAPE_ARG), y
    sta     @fill_arg + $0000
    inc     @fill_arg + $0000
    iny
    lda     (LIB_0_SHAPE_ARG), y
    sta     @fill_arg + $0001
    inc     @fill_arg + $0001
    iny
    lda     (LIB_0_SHAPE_ARG), y
    sta     @fill_arg + $0002
    dec     @fill_arg + $0002
    iny
    lda     (LIB_0_SHAPE_ARG), y
    sta     @fill_arg + $0003
    dec     @fill_arg + $0003
    ldx     #<@fill_arg
    lda     #>@fill_arg
    jsr     _LibFillRect
    ldx     LIB_0_TEXT_ARG_L
    lda     LIB_0_TEXT_ARG_H
    jsr     _LibDrawRect
    lda     #$04
    jmp     @next
:

    ; 矩形の塗り潰し（枠なし）
    cpy     #$04
    bne     :+
    jsr     _LibFillRect
    lda     #$04
    jmp     @next
:

    ; 円の描画
    cpy     #$05
    bne     :+
    jsr     _LibDrawCircle
    lda     #$03
    jmp     @next
:
    jmp     @end

    ; 次の図形へ
@next:
    clc
    adc     LIB_0_SHAPE_ARG_L
    sta     LIB_0_SHAPE_ARG_L
    bcc     :+
    inc     LIB_0_SHAPE_ARG_H
:
    jmp     @shape
    lda     KBD
    bpl     :-
    sta     KBDSTRB
    and     #$7f
    cmp     #'Q'
    beq     @end
    jmp     @shape

    ; 終了
@end:
    rts

; FILL
@fill_arg:

    .byte   $00, $00, $00, $00

.endproc

; 図形の描画エリアをクリアする
;
.global _LibClearShape
.proc   _LibClearShape

    ; WORK
    ;   LIB_0_WORK_0..2

    ; VRAM のクリア
    lda     #$20
    sta     LIB_0_WORK_1
:
    lda     #$00
    sta     LIB_0_WORK_0
    lda     #$03 + $01
    sta     LIB_0_WORK_2
    ldx     #$50
    ldy     #$00
    lda     #$00
:
    sta     (LIB_0_WORK_0), y
    inc     LIB_0_WORK_0
    bne     :+
    inc     LIB_0_WORK_1
:
    dex
    bne     :--
    dec     LIB_0_WORK_2
    bne     :--
    lda     #$80
    sta     LIB_0_WORK_0
    ldx     #$50
    ldy     #$00
    tya
:
    sta     (LIB_0_WORK_0), y
    iny
    dex
    bne     :-
    lda     LIB_0_WORK_1
    and     #$fc
    clc
    adc     #$04
    sta     LIB_0_WORK_1
    cmp     #$40
    bcc     :----

    ; 終了
    rts

.endproc

; VRAM のアドレスを取得する
;
.proc   LibGetShapeAddr

    ; IN
    ;   x = X 位置
    ;   y = Y 位置
    ; WORK
    ;   LIB_0_WORK_0..1

    ; 位置の取得
    stx     LIB_0_WORK_0
    sty     LIB_0_WORK_1

    ; アドレスの取得
    tya
    lsr     a
    lsr     a
    lsr     a
    tax
    lda     _iocs_hgr_tile_y_address_low, x
    sta     LIB_0_SHAPE_ADDR_L
    lda     _iocs_hgr_tile_y_address_high, x
    sta     LIB_0_SHAPE_ADDR_H
    stx     LIB_0_SHAPE_INDEX
    tya
    and     #$07
    beq     :++
    tay
    lda     LIB_0_SHAPE_ADDR_H
:
    clc
    adc     #$04
    dey
    bne     :-
    sta     LIB_0_SHAPE_ADDR_H
:
    lda     LIB_0_WORK_0
    ldx     #$00
:
    sec
    sbc     #$07
    bcc     :+
    inx
    and     #$ff
    bne     :-
    jmp     :++
:
;   clc
    adc     #$07
:
    tay
    lda     @pixel_bit, y
    sta     LIB_0_SHAPE_BIT
    txa
    clc
    adc     LIB_0_SHAPE_ADDR_L
    sta     LIB_0_SHAPE_ADDR_L
    inc     LIB_0_SHAPE_ADDR_L

    ; 終了
    rts

; ピクセルのビット
@pixel_bit:

    .byte   %00000001, %00000010, %00000100, %00001000, %00010000, %00100000, %01000000

.endproc

; テキストをクリアする
;
.global _LibClearText
.proc   _LibClearText

    ; VRAM の設定
    lda     #' '
    ldx     #$00
:
    sta     lib_text_vram_upper, x
    sta     lib_text_vram_lower, x
    inx
    cpx     #LIB_TEXT_SIZE_X
    bne     :-
    lda     #$00
    sta     lib_text_vram_upper, x
    sta     lib_text_vram_lower, x

    ; カーソルの設定
    lda     #$00
    sta     lib_text_cursor_x

    ; 終了
    rts

.endproc

; テキストに文字列を表示する
;
.global _LibPrintTextString
.proc   _LibPrintTextString

    ; IN
    ;   ax = 文字列

    ; 引数の保持
    stx     LIB_0_TEXT_ARG_L
    sta     LIB_0_TEXT_ARG_H

    ; 文字列の VRAM への設定
    lda     #$00
    sta     LIB_0_TEXT_SRC
:
    ldy     LIB_0_TEXT_SRC
    lda     (LIB_0_TEXT_ARG), y
    beq     :+++
    cmp     #$0d
    beq     :+
    cmp     #$0a
    beq     :+
    ldx     lib_text_cursor_x
    sta     lib_text_vram_lower, x
    inx
    stx     lib_text_cursor_x
    cpx     #LIB_TEXT_SIZE_X
    bne     :++
:
    jsr     LibFillTextLine
    jsr     LibNewTextLine
:
    inc     LIB_0_TEXT_SRC
    jmp     :---
:
    jsr     LibFillTextLine

    ; テキストの描画
    jsr     LibDrawText

    ; 終了
    rts

.endproc

; テキストに 1 文字を表示する
;
.global _LibPutTextChar
.proc   _LibPutTextChar

    ; IN
    ;   a = 文字

    ; 文字の VRAM への設定
    ldx     lib_text_cursor_x
    sta     lib_text_vram_lower, x

    ; 文字の描画
    sta     @char_string + $0000
    txa
    clc
    adc     #LIB_TEXT_X
    sta     @char_arg + $0000
    ldx     #<@char_arg
    lda     #>@char_arg
    jsr     _IocsDrawString

    ; カーソルの移動
    inc     lib_text_cursor_x
    lda     lib_text_cursor_x
    cmp     #LIB_TEXT_SIZE_X
    bne     :+
    jsr     LibNewTextLine
    jsr     LibDrawText
:

    ; 終了
    rts

; 文字
@char_arg:

    .byte   $00, LIB_TEXT_Y_LOWER
    .word   @char_string

@char_string:

    .byte   $00, $00

.endproc

; テキストから 1 文字を削除する
;
.global _LibBackspaceTextChar
.proc   _LibBackspaceTextChar

    ; 1 文字の削除
    ldx     lib_text_cursor_x
    beq     @end
    dex
    stx     lib_text_cursor_x
    lda     #' '
    sta     lib_text_vram_lower, x

    ; 文字の描画
    txa
    clc
    adc     #LIB_TEXT_X
    sta     @char_arg + $0000
    ldx     #<@char_arg
    lda     #>@char_arg
    jsr     _IocsDrawString

    ; 終了
@end:
    rts

; 文字
@char_arg:

    .byte   $00, LIB_TEXT_Y_LOWER
    .word   @char_string

@char_string:

    .byte   " ", $00

.endproc

; テキストのカーソル以降を空白で埋める
;
.proc   LibFillTextLine

    ; １行を埋める
    lda     #' '
    ldx     lib_text_cursor_x
:
    cpx     #LIB_TEXT_SIZE_X
    beq     :+
    sta     lib_text_vram_lower, x
    inx
    jmp     :-
:

    ; 終了
    rts

.endproc

; テキストを改行する
;
.proc   LibNewTextLine

    ; 下行を上行に移す
    ldx     #$00
:
    lda     lib_text_vram_lower, x
    sta     lib_text_vram_upper, x
    inx
    cpx     LIB_TEXT_SIZE_X
    bne     :-

    ; カーソル位置の設定
    lda     #$00
    sta     lib_text_cursor_x

    ; 終了
    rts

.endproc

; テキストを描画する
;

; 上下行の描画
.proc   LibDrawText

    ; 上行の描画
    jsr     LibDrawTextUpperLine

    ; 下行の描画
    jsr     LibDrawTextLowerLine

    ; 終了
    rts

.endproc

; 上行の描画
.proc   LibDrawTextUpperLine

    ; 行の描画
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString

    ; 終了
    rts

; テキスト
@text_arg:

    .byte   LIB_TEXT_X, LIB_TEXT_Y_UPPER
    .word   lib_text_vram_upper

.endproc

; 下行の描画
.proc   LibDrawTextLowerLine

    ; 行の描画
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString

    ; 終了
    rts

; テキスト
@text_arg:

    .byte   LIB_TEXT_X, LIB_TEXT_Y_LOWER
    .word   lib_text_vram_lower

.endproc



; データの定義
;
.segment    "BSS"

; テキスト
;

; VRAM
lib_text_vram_upper:

    .res    LIB_TEXT_SIZE_X + $01

lib_text_vram_lower:

    .res    LIB_TEXT_SIZE_X + $01

; カーソル
lib_text_cursor_x:

    .res    $01

