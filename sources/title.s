; title.s - タイトル / MYS.BAS
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
.include    "app.inc"
.include    "title.inc"


; コードの定義
;
.segment    "APP"

; タイトルのエントリポイント
;
.global _TitleEntry
.proc   _TitleEntry

    ; アプリケーションの初期化

    ; VRAM のクリア
    ; jsr     _IocsClearVram

    ; タイトルの初期化

    ; 処理の設定
    lda     #<Title_0150
    sta     APP_0_PROC_L
    lda     #>Title_0150
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

.endproc

; MYS.BAS / 150 - 1950
;
.proc   Title_0150

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized

    ; VRAM のクリア
    jsr     _IocsClearVram

    ; 図形の描画
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes

    ; 名前の描画
    ldx     #<@name_string_arg
    lda     #>@name_string_arg
    jsr     _IocsDrawString

    ; BEEP の再生
    ldx     #<@beep_arg
    lda     #>@beep_arg
    jsr     _IocsBeepScore

    ; HIT ANY KEY の描画
    ldx     #<@hit_string_arg
    lda     #>@hit_string_arg
    jsr     _IocsDrawString

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE
    beq     @end

    ; 処理の設定
    lda     #<Title_2000
    sta     APP_0_PROC_L
    lda     #>Title_2000
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; 図形
@shape_arg:

    .byte   $01, 145,  70, 145, 100
    .byte   $01, 145, 100, 165,  90
    .byte   $01, 165,  90, 185,  95
    .byte   $01, 185,  95, 185,  60
    .byte   $01, 185,  60, 163,  30
    .byte   $01, 163,  30, 145,  70
    .byte   $01, 185,  60, 185,  95
    .byte   $01, 185,  95, 235, 108
    .byte   $01, 235, 108, 235,  83
;-  .byte   $01, 235,  83, 185,  60
    .byte   $01, 163,  30, 190,  67

    .byte   $01, 190,  67, 240,  85
    .byte   $01, 240,  85, 227,  70
    .byte   $01, 227,  70, 163,  30
    .byte   $01, 165,  90, 235, 108
;-  .byte   $01, 235, 108, 235, 155
    .byte   $01, 235, 117, 235, 139 ;+
;-  .byte   $01, 235, 155, 165, 155
    .byte   $01, 205, 155, 185, 155 ;+
;-  .byte   $01, 165, 155, 165,  90
    .byte   $01, 165, 135, 165,  90 ;+
    .byte   $01, 125, 110, 125, 138
    .byte   $01, 125, 138, 150, 135
    .byte   $01, 150, 135, 165, 135

    .byte   $01, 165, 135, 165,  90
    .byte   $01, 165,  90, 125, 110
    .byte   $01, 185,  95, 190, 105
    .byte   $01, 190, 105, 242, 117
    .byte   $01, 242, 117, 235, 108
    .byte   $01, 235, 108, 185,  95
    .byte   $01, 110, 140, 110, 160
    .byte   $01, 110, 160, 150, 165
    .byte   $01, 150, 165, 150, 135
    .byte   $01, 150, 135, 110, 140

;-  .byte   $03, 150, 135, 185, 165
    .byte   $02, 150, 135, 185, 165 ;+
    .byte   $01, 205, 135, 205, 165
    .byte   $01, 205, 165, 240, 165
    .byte   $01, 240, 165, 240, 140
    .byte   $01, 240, 140, 205, 135
    .byte   $01, 210,  50, 210,  59
    .byte   $01, 210,  59, 215,  63
    .byte   $01, 215,  63, 215,  52
    .byte   $01, 215,  52, 210,  50
    .byte   $01, 140, 120, 160, 115
    .byte   $01, 160, 115, 160, 135
    .byte   $01, 160, 135, 150, 135
    .byte   $01, 150, 135, 140, 136
    .byte   $01, 140, 136, 140, 120
    .byte   $01, 155,  70, 170,  65
    .byte   $01, 170,  65, 170,  85
    .byte   $01, 170,  85, 155,  90
    .byte   $01, 155,  90, 155,  70
    .byte   $01, 200,  80, 220,  85
    .byte   $01, 220,  85, 220, 100
    .byte   $01, 220, 100, 200,  95
    .byte   $01, 200,  95, 200,  80
    .byte   $01, 190, 125, 190, 155
    .byte   $01, 190, 155, 200, 155
    .byte   $01, 200, 155, 200, 130
    .byte   $01, 200, 130, 190, 125
    .byte   $05, 196, 142, 2
    .byte   $05, 196, 142, 1
    .byte   $01, 150, 135, 110, 140
    .byte   $01, 110, 140, 110, 160
    .byte   $01, 110, 160, 150, 165
    .byte   $01, 150, 165, 185, 165
    .byte   $01, 185, 165, 185, 135
    .byte   $01, 185, 135, 150, 135
    .byte   $01, 150, 135, 150, 165
    .byte   $01, 240, 140, 205, 135
    .byte   $01, 205, 135, 205, 165
    .byte   $01, 205, 165, 240, 165
    .byte   $01, 240, 165, 240, 140
    .byte   $01, 125, 138, 125, 110
    .byte   $01, 125, 110, 165,  90
    .byte   $01, 165,  90, 165, 135
    .byte   $01, 140, 136, 140, 120
    .byte   $01, 140, 120, 160, 115
    .byte   $01, 160, 115, 160, 135
    .byte   $01, 140, 130, 160, 125
    .byte   $01, 149, 118, 149, 135
    .byte   $01, 165,  90, 185,  95
    .byte   $01, 185,  95, 190, 105
    .byte   $01, 190, 105, 242, 117
    .byte   $01, 235, 115, 235, 139
    .byte   $01, 185, 155, 205, 155
    .byte   $01, 140,  80, 145,  70
    .byte   $01, 185,  60, 185,  95
    .byte   $01, 185,  95, 235, 108
    .byte   $01, 235, 108, 235,  83
    .byte   $01, 145,  70, 145, 100
    .byte   $01, 155,  70, 170,  65
    .byte   $01, 170,  65, 170,  85
    .byte   $01, 170,  85, 155,  90
    .byte   $01, 155,  90, 155,  70
    .byte   $01, 155,  80, 170,  75
    .byte   $01, 162,  68, 162,  88
    .byte   $01, 200,  80, 200,  95
    .byte   $01, 200,  95, 220, 100
    .byte   $01, 220, 100, 220,  85
    .byte   $01, 220,  85, 200,  80
    .byte   $01, 200,  88, 220,  92
    .byte   $01, 210,  83, 210,  98
    .byte   $01, 130, 107, 130,  97
    .byte   $01, 130,  97, 165,  80
    .byte   $01, 165,  80, 185,  85
    .byte   $01, 140, 102, 140,  92
    .byte   $01, 160,  93, 160,  83
    .byte   $01, 150,  98, 150,  88
    .byte   $01, 170,  92, 170,  82
    .byte   $01, 180,  94, 180,  84
    .byte   $00

; 名前
@name_string_arg:

    .byte   0 + 1, 1
    .word   @name_string

@name_string:

    .byte   "  MYSTERY  HOUSE", $00

; BEEP
@beep_arg:

    ; T120O3A8A4R8A4R16L4AR4L8O3A8O4C.ED+4R4O3L2AR4A2
    ; T120O4D+8E4R8F+16R16GRL8E.F+G.O5CO4B4O4A8O5C.ED+4R4O5C4C4R2
    ; T120O4G+8A4R8B16R16O5CRL8O4A.BO5C.ED+4R4R4R8O5D+16ED+8.CO4A.GA2
    .byte   _O4Dp, _L8
    .byte   _O4E,  _L4
    .byte   _R,    _L8
    .byte   _O4Fp, _L16
    .byte   _R,    _L16
    .byte   _O4G,  _L4
    .byte   _R,    _L4
    .byte   _O4E,  _L8p
    .byte   _O4Fp, _L8
    .byte   _O4G,  _L8p
    .byte   _O5C,  _L8
    .byte   _O4B,  _L4
    .byte   _O4A,  _L8
    .byte   _O5C,  _L8p
    .byte   _O5E,  _L8
    .byte   _O5Dp, _L4
    .byte   _R,    _L4
    .byte   _O5C,  _L8
    .byte   _O4A,  _L8p
    .byte   _O4G,  _L8
    .byte   _O4A,  _L2
    .byte   IOCS_BEEP_END

; HIT ANY KEY
@hit_string_arg:

    .byte   12, 22
    .word   @hit_string

@hit_string:

    .byte   "Hit Any KEY !!!", $00

.endproc

; MYS.BAS / 2000 - 2165
;
.proc   Title_2000

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized

    ; VRAM のクリア
    jsr     _IocsClearVram

    ; テキストの描画
    ldx     #<@text_0_arg
    lda     #>@text_0_arg
    jsr     _IocsDrawString
    ldx     #<@text_1_arg
    lda     #>@text_1_arg
    jsr     _IocsDrawString

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE
    beq     @end

    ; 処理の設定
    lda     #<_GameEntry
    sta     APP_0_PROC_L
    lda     #>_GameEntry
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; テキスト
@text_0_arg:

    .byte   4, 1
    .word   @text_0_string

@text_0_string:

    ; "  MYSTRY  HOUSE"
    ; "    by せかいに やくしんする ARROW SOFT"
    ; ""
    ; ""
    ; "    あなた は いま ミステリ-ハウス の まえ に "
    ; "    います。"
    ; "    このなか に かくされている ダイヤモンド を"
    ; "    みつけだして ください。"
    .byte   "  MYSTRY  HOUSE\n"
    .byte   "    by ", hSE, hKA, h_I, hNI, " ", hYA, hKU, hSI, h_N, hSU, hRU, "  ARROW SOFT\n"
    .byte   "\n"
    .byte   "\n"
    .byte   "    ", h_A, hNA, hTA, " ", hHA, " ", h_I, hMA, " ", kMI, kSU, kTE, kRI, _HF, kHA, k_U, kSU, " ", hNO, " ", hMA, h_E, " ", hNI, "\n"
    .byte   "    ", h_I, hMA, hSU, _PR, "\n"
    .byte   "    ", hKO, hNO, hNA, hKA, " ", hNI, " ", hKA, hKU, hSA, hRE, hTE, h_I, hRU, " ", kTA, _VM, k_I, kYA, kMO, k_N, kTO, _VM, " ", hWO, "\n"
    .byte   "    ", hMI, hTU, hKE, hTA, _VM, hSI, hTE, " ", hKU, hTA, _VM, hSA, h_I, _PR
    .byte   $00

@text_1_arg:

    .byte   4, 9
    .word   @text_1_string

@text_1_string:

    ; "    コマンド は えいご てﾞ にゅうりょく を"
    ; "    し return を おしてください。"
    ; "    あたま3もじ てﾞ はんだんします。"
    ; "    たとえば help なら hel てﾞす。"
    ; "    みつけた もの は take してください。"
    ; "    かいだん を あがるのは up です。"
    ; ""
    ; "     Start Hit  F1 key !"
    .byte   "    ", kKO, kMA, k_N, kTO, _VM, " ", hHA, " ", h_E, h_I, hKO, _VM, " ", hTE, _VM, " ", hNI, hyu, h_U, hRI, hyo, hKU, " ", hWO, "\n"
    .byte   "    ", hSI, " RETURN ", hWO, " ", h_O, hSI, hTE, hKU, hTA, _VM, hSA, h_I, _PR, "\n"
    .byte   "    ", h_A, hTA, hMA, "3", hMO, hSI, _VM, " ", hTE, _VM, " ", hHA, h_N, hTA, _VM, h_N, hSI, hMA, hSU, _PR, "\n"
    .byte   "    ", hTA, hTO, h_E, hHA, _VM, " HELP ", hNA, hRA, " HEL ", hTE, _VM, hSU, _PR, "\n"
    .byte   "    ", hMI, hTU, hKE, hTA, " ", hMO, hNO, " ", hHA, " TAKE ", hSI, hTE, hKU, hTA, _VM, hSA, h_I, _PR, "\n"
    .byte   "    ", h_I, hTO, _VM, h_U, " ", hHA, " 'F''B''L''R' ", hTE, _VM, hSU, _PR, "\n"
    .byte   "    ", hKA, h_I, hTA, _VM, h_N, " ", hWO, " ", h_A, hKA, _VM, hRU, hNO, hHA, " 'U' ", hTE, _VM, hSU, _PR, "\n"
    .byte   "\n"
    .byte   "     Start Hit Any key !\n"
    .byte   $00

.endproc


; データの定義
;
.segment    "BSS"

; タイトルの情報
;
title:
    .tag    Title

