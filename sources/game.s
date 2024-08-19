; game.s - ゲーム / MYS22.BAS
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
.include    "game.inc"


; コードの定義
;
.segment    "APP"

; ゲームのエントリポイント
;
.global _GameEntry
.proc   _GameEntry

    ; アプリケーションの初期化

    ; VRAM のクリア
    ; jsr     _IocsClearVram

    ; テキストのクリア
    jsr     _LibClearText

    ; ゲーム情報の初期化
    lda     #$00
    tax
:
    sta     game, x
    inx
    cpx     #.sizeof(Game)
    bne     :-

    ; ユーザーデータの初期化
    lda     #$00
    tax
:
    sta     user, x
    inx
    cpx     #.sizeof(User)
    bne     :-

    ; 処理の設定
    lda     #<Game_0120
    sta     APP_0_PROC_L
    lda     #>Game_0120
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

.endproc

; MYS22.BAS / 120 - 190
;
.proc   Game_0120

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized

    ; VRAM のクリア
    jsr     _IocsClearVram

    ; 初期値の設定
    lda     #$00
    sta     game + Game::TIME
    lda     #$01
    sta     user + User::SC

    ; テキストの描画
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE

    ; '1': はじめから
    cmp     #'1'
    bne     :+
    lda     #<Game_0280
    sta     APP_0_PROC_L
    lda     #>Game_0280
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    jmp     @end
:

    ; '2': とちゅうから
    cmp     #'2'
    bne     :+
    lda     #<Game_0200
    sta     APP_0_PROC_L
    lda     #>Game_0200
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    jmp     @end
:

    ; 終了
@end:
    rts

; "ゲ-ム を とちゅうから しますか ?"
; "はじめ から なら...1"
; "とちゅう から なら...2"
; "どちらかの キ- を おして ください !!!"
@text_arg:

    .byte   6, 9
    .word   @text_string

@text_string:

    .byte   kKE, _VM, _HF, kMU, " ", hWO, " ", hTO, hTI, hyu, h_U, hKA, hRA, " ", hSI, hMA, hSU, hKA, " ?\n"
    .byte   "\n"
    .byte   hHA, hSI, _VM, hME, " ", hKA, hRA, " ", hNA, hRA, "...1\n"
    .byte   "\n"
    .byte   hTO, hTI, hyu, h_U, " ", hKA, hRA, " ", hNA, hRA, "...2\n"
    .byte   "\n"
    .byte   hTO, _VM, hTI, hRA, hKA, hNO, " ", kKI, _HF, " ", hWO, " ", h_O, hSI, hTE, " ", hKU, hTA, _VM, hSA, h_I, " !!!"
    .byte   $00

.endproc

; MYS22.BAS / 200 - 270
;
.proc   Game_0200

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized

    ; ゲームの初期設定
    jsr     Game_3340

    ; VRAM のクリア
    jsr     _IocsClearVram

    ; テキストの描画
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE
    beq     @end
    cmp     #'Z'
    bne     :+

    ; user のファイルからの読み込み
    ldx     #<@file_arg
    lda     #>@file_arg
    jsr     _IocsBload
:

    ; どうする？のクリア
    lda     #$00
    sta     game + Game::AD

    ; 処理の設定
    lda     #<Game_1560
    sta     APP_0_PROC_L
    lda     #>Game_1560
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; "GAME DATA の TAPE の"
; "じゅんびはいいですか?"
; "よかったら z キー を おして ください !"
@text_arg:

    .byte   3 + 1, 5
    .word   @text_string

@text_string:

    .byte   "GAME DATA ", hNO, " DISK ", hNO, "\n"
    .byte   "\n"
    .byte   hSI, _VM, hyu, h_N, hHI, _VM, hHA, h_I, h_I, hTE, _VM, hSU, hKA, "?\n"
    .byte   "\n"
    .byte   "\n"
    .byte   hYO, hKA, htu, hTA, hRA, " Z ", kKI, _HF, " ", hWO, " ", h_O, hSI, hTE, " ", hKU, hTA, _VM, hSA, h_I, " !"
    .byte   $00

; ファイル
@file_arg:

    .word   @file_name
    .word   user

@file_name:

    .asciiz "MYSDAT"

.endproc

; MYS22.BAS / 280
;
.proc   Game_0280

    ; どうする？のクリア
    lda     #$00
    sta     game + Game::AD

    ; ゲームの初期設定
    jsr     Game_3340

    ; 処理の設定
    lda     #<Game_1560
    sta     APP_0_PROC_L
    lda     #>Game_1560
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

.endproc

; MYS22.BAS / 310 - 320
;
.proc   Game_0310

    ; 改行
;   ldx     #<@newline_string
;   lda     #>@newline_string
;   jsr     _LibPrintTextString

    ; 処理の設定
    lda     #<Game_0330
    sta     APP_0_PROC_L
    lda     #>Game_0330
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; 改行
@newline_string:

    .byte   "\n", $00

.endproc

; MYS22.BAS / 330 - 440
;
.proc   Game_0330

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized


    ; どうする？の表示
    ldx     #<@what_string
    lda     #>@what_string
    jsr     _LibPrintTextString

;   ; デバッグ表示
;   jsr     GamePrintUser
;   ldx     user + User::SC
;   lda     #$00
;   jsr     _IocsGetNumberString
;   jsr     _LibPrintTextString
;   lda     #' '
;   jsr     _LibPutTextChar

    ; キー入力の設定
    lda     #$00
    sta     GAME_0_INKEY
    tax
:
    sta     game + Game::AV, x
    inx
    cpx     #(GAME_INKEY_SIZE + $01)
    bne     :-

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE
    bne     :+
    jmp     @end
:
    sta     game + Game::AD

    ; BEEP の再生
;   ldx     #_O5A
;   lda     #_L64
;   jsr     _IocsBeepNote

    ; RETURN
    lda     game + Game::AD
    cmp     #$0d
    bne     :+
    ldx     GAME_0_INKEY
;   beq     @end
    lda     #$00
    sta     game + Game::AV, x
    ldx     #<Game_0450
    lda     #>Game_0450
    jmp     @goto
:

    ; ← : 1 文字の削除
    cmp     #$08
    bne     :++
    ldx     GAME_0_INKEY
    bne     :+
    jmp     @end
:
    dex
    stx     GAME_0_INKEY
    lda     #$00
    sta     game + Game::AV, x
    jsr     _LibBackspaceTextChar
    jmp     @end
:

;   ; ^I : ↑
;   cmp     #$09
;   bne     :+
;   lda     #30
;   sta     game + Game::AD
;   jmp     @goto_1560
;:

;   ; ^K : ↓
;   cmp     #$0b
;   bne     :+
;   lda     #31
;   sta     game + Game::AD
;   jmp     @goto_1560
;:

;   ; ^J : ←
;   cmp     #$0a
;   bne     :+
;   lda     #29
;   sta     game + Game::AD
;   jmp     @clear_d
;:

;   ; ^L : →
;   cmp     #$0c
;   bne     :+
;   lda     #28
;   sta     game + Game::AD
;   jmp     @clear_d
;:

    ; 1 文字の入力
    cmp     #$21
    bcc     :+
    cmp     #$7f
    bcs     :+
    ldx     GAME_0_INKEY
    cpx     #GAME_INKEY_SIZE
    bcs     @end
    sta     game + Game::AV, x
    inc     GAME_0_INKEY
    jsr     _LibPutTextChar
:
    jmp     @end

;   ; D? のクリア
;@clear_d:
;   lda     #$00
;   sta     game + Game::D1
;   sta     game + Game::D2
;   sta     game + Game::D3
;   sta     game + Game::D4
;;  sta     game + Game::D5
;   sta     game + Game::DA
;   sta     game + Game::DB
;   sta     game + Game::DC
;   sta     game + Game::DD
;;  sta     game + Game::DDD
;;  sta     game + Game::DE

;   ; GOTO 1560
;@goto_1560:
;   ldx     #<Game_1560
;   lda     #>Game_1560

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; どうする？
@what_string:

    ; "どうする ? "
;   .byte   "\n"
    .byte   "\n"
    .byte   hTO, _VM, h_U, hSU, hRU, " ? "
    .byte   $00

.endproc

; MYS22.BAS / 450 - 510
;
.proc   Game_0450

    ; HELP
    ldx     #<@help_string
    lda     #>@help_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<Game_3040
    lda     #>Game_3040
    jmp     @goto
:

    ; SAVE
    ldx     #<@save_string
    lda     #>@save_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<Game_7230
    lda     #>Game_7230
    jmp     @goto
:

    ; F : ↑
    ldx     #<@forward_string
    lda     #>@forward_string
    jsr     GameCmpAv
    bcc     :+
    lda     #30
    sta     game + Game::AD
    jmp     @goto_1560
:

    ; B : ↓
    ldx     #<@back_string
    lda     #>@back_string
    jsr     GameCmpAv
    bcc     :+
    lda     #31
    sta     game + Game::AD
    jmp     @goto_1560
:

    ; L : ←
    ldx     #<@left_string
    lda     #>@left_string
    jsr     GameCmpAv
    bcc     :+
    lda     #29
    sta     game + Game::AD
    jmp     @clear_d
:

    ; R : →
    ldx     #<@right_string
    lda     #>@right_string
    jsr     GameCmpAv
    bcc     :+
    lda     #28
    sta     game + Game::AD
    jmp     @clear_d
:

    ; U : UP
    ldx     #<@up_string
    lda     #>@up_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<Game_1500
    lda     #>Game_1500
    jmp     @goto
:

    ; D : DOWN
    ldx     #<@down_string
    lda     #>@down_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<Game_1470
    lda     #>Game_1470
    jmp     @goto
:

    ; END
    ldx     #<@end_string
    lda     #>@end_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<_TitleEntry
    lda     #>_TitleEntry
    jmp     @goto
:

    ; その他
    ldx     #<Game_0520
    lda     #>Game_0520
    jmp     @goto

    ; D? のクリア
@clear_d:
    lda     user + User::SC     ; SC=1 のときはクリアしない
    cmp     #1
    beq     :+
    lda     #$00
    sta     game + Game::D1
    sta     game + Game::D2
    sta     game + Game::D3
    sta     game + Game::D4
;   sta     game + Game::D5
    sta     game + Game::DA
    sta     game + Game::DB
    sta     game + Game::DC
    sta     game + Game::DD
;   sta     game + Game::DDD
;   sta     game + Game::DE
:

    ; GOTO 1560
@goto_1560:
    ldx     #<Game_1560
    lda     #>Game_1560

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; HELP
@help_string:

    .byte   "HEL"

; SAVE
@save_string:

    .byte   "SAV"

; FORWARD
@forward_string:

    .byte   "F", $00, $00

; BACK
@back_string:

    .byte   "B", $00, $00

; LEFT
@left_string:

    .byte   "L", $00, $00

; RIGHT
@right_string:

    .byte   "R", $00, $00

; UP
@up_string:

;   .byte   "UP", $00
    .byte   "U", $00, $00

; DOWN
@down_string:

;   .byte   "DOW"
    .byte   "D", $00, $00

; END
@end_string:

    .byte   "END"

.endproc

; MYS22.BAS / 520 - 590
;
.proc   Game_0520

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized

    ; なにを？の表示
    ldx     #<@what_string
    lda     #>@what_string
    jsr     _LibPrintTextString

    ; キー入力の設定
    lda     #$00
    sta     GAME_0_INKEY
    tax
:
    sta     game + Game::PN, x
    inx
    cpx     #(GAME_INKEY_SIZE + $01)
    bne     :-

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE
    bne     :+
    jmp     @end
:

    ; BEEP の再生
;   pha
;   ldx     #_O5A
;   lda     #_L64
;   jsr     _IocsBeepNote
;   pla

    ; RETURN
    cmp     #$0d
    bne     :+
    ldx     GAME_0_INKEY
;   beq     @end
    lda     #$00
    sta     game + Game::PN, x
    ldx     #<Game_0600
    lda     #>Game_0600
    jmp     @goto
:

    ; ← : 1 文字の削除
    cmp     #$08
    bne     :+
    ldx     GAME_0_INKEY
    beq     @end
    dex
    stx     GAME_0_INKEY
    lda     #$00
    sta     game + Game::PN, x
    jsr     _LibBackspaceTextChar
    jmp     @end
:

    ; 1 文字の入力
    cmp     #$21
    bcc     :+
    cmp     #$7f
    bcs     :+
    ldx     GAME_0_INKEY
    cpx     #GAME_INKEY_SIZE
    bcs     @end
    sta     game + Game::PN, x
    inc     GAME_0_INKEY
    jsr     _LibPutTextChar
:
    jmp     @end

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; なにを？
@what_string:

    .byte   "\n"
    .byte   " ", hNA, hNI, hWO, "  ? "
    .byte   $00

.endproc

; MYS22.BAS / 600 - 710
;
.proc   Game_0600

    ; IF AV$="tak" THEN 1020
    ldx     #<@take_string
    lda     #>@take_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<Game_1020
    lda     #>Game_1020
    jmp     @goto
:

    ; IF AV$="mov" THEN 1280
    ldx     #<@move_string
    lda     #>@move_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<Game_1280
    lda     #>Game_1280
    jmp     @goto
:

    ; IF AV$="lig" THEN 1000
    ldx     #<@light_string
    lda     #>@light_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<Game_1000
    lda     #>Game_1000
    jmp     @goto
:

    ; IF AV$="use" THEN 1340
    ldx     #<@use_string
    lda     #>@use_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<Game_1340
    lda     #>Game_1340
    jmp     @goto
:
    ; IF AV$="unl" THEN 1270
    ldx     #<@unlock_string
    lda     #>@unlock_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<Game_1270
    lda     #>Game_1270
    jmp     @goto
:

    ; IF AV$="ope" THEN 720
    ldx     #<@open_string
    lda     #>@open_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<Game_0720
    lda     #>Game_0720
    jmp     @goto
:

    ; IF AV$="loo" THEN 1250
    ldx     #<@look_string
    lda     #>@look_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<Game_1250
    lda     #>Game_1250
    jmp     @goto
:

    ; IF AV$="sea" THEN 1110
    ldx     #<@search_string
    lda     #>@search_string
    jsr     GameCmpAv
    bcc     :+
    ldx     #<Game_1110
    lda     #>Game_1110
    jmp     @goto
:

    ; IF SC=34 AND PN$<>"" THEN 6360
    ; IF SC=34 AND AD$<>"" THEN 6360
    lda     user + User::SC
    cmp     #34
    bne     :++
    lda     game + Game::PN + $0000
    bne     :+
    lda     game + Game::AD + $0000
    beq     :++
:
    ldx     #<Game_6360
    lda     #>Game_6360
    jmp     @goto
:

    ; GOTO 3320
    ldx     #<Game_3320
    lda     #>Game_3320

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; TAKE
@take_string:

    .byte   "TAK"

; MOVE
@move_string:

    .byte   "MOV"

; LIGHT
@light_string:

    .byte   "LIG"

; USE
@use_string:

    .byte   "USE"

; UNLOCK
@unlock_string:

    .byte   "UNL"

; OPEN
@open_string:

    .byte   "OPE"

; LOOK
@look_string:

    .byte   "LOO"

; SEARCH
@search_string:

    .byte   "SEA"

.endproc

; MYS22.BAS / 720 - 990
;
Game_0800:
Game_0810:
Game_0820:
Game_0850:
Game_0860:
Game_0870:
Game_0880:
.proc   Game_0720

    ; IF SC=1 AND PN$="doo" THEN D1=1:SCREEN 2,2,2:GOSUB 5100:GOTO 3550
    lda     user + User::SC
    cmp     #1
    bne     :+
    ldx     #<@door_string
    lda     #>@door_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::D1
    jsr     Game_5100
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=2 AND PN$="doo" THEN D2=1:SCREEN 2,2,2:GOSUB 5110:GOSUB 4030:GOTO 3550
    lda     user + User::SC
    cmp     #2
    bne     :+
    ldx     #<@door_string
    lda     #>@door_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::D2
    jsr     Game_5110
    jsr     Game_4030
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=17 AND PN$="doo" THEN DA=1:SCREEN 2,2,2:GOSUB 5540:GOSUB 4030:GOTO 3550
    lda     user + User::SC
    cmp     #17
    bne     :+
    ldx     #<@door_string
    lda     #>@door_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::DA
    jsr     Game_5540
    jsr     Game_4030
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=3 AND PN$="doo" THEN D3=1:SCREEN 2,2,2:GOSUB 5140:GOSUB 4030:GOTO 3550
    lda     user + User::SC
    cmp     #3
    bne     :+
    ldx     #<@door_string
    lda     #>@door_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::D3
    jsr     Game_5140
    jsr     Game_4030
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC= 8 AND PN$="doo" THEN DB=1:SCREEN 2,2,2:GOSUB 5260:GOSUB 4030:GOTO 3550
    lda     user + User::SC
    cmp     #8
    bne     :+
    ldx     #<@door_string
    lda     #>@door_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::DB
    jsr     Game_5260
    jsr     Game_4030
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=11 AND PN$="doo" THEN D4=1:SCREEN 2,2,2:GOSUB 5340:GOSUB 4030:GOTO 3550
    lda     user + User::SC
    cmp     #11
    bne     :+
    ldx     #<@door_string
    lda     #>@door_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::D4
    jsr     Game_5340
    jsr     Game_4030
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=14 AND PN$="doo" THEN DD=1:SCREEN 2,2,2:GOSUB 5450:GOSUB 4030:GOTO 3550
    lda     user + User::SC
    cmp     #14
    bne     :+
    ldx     #<@door_string
    lda     #>@door_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::DD
    jsr     Game_5450
    jsr     Game_4030
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=16 AND PN$="doo" THEN DC=1:SCREEN 2,2,2:GOSUB 5510:GOSUB 4030:GOTO 3550
    lda     user + User::SC
    cmp     #16
    bne     :+
    ldx     #<@door_string
    lda     #>@door_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::DC
    jsr     Game_5510
    jsr     Game_4030
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=10 AND PN$="rac" THEN RA=1:SCREEN 2,2,2:GOSUB 5310:GOSUB 4480:GOTO 3550
    lda     user + User::SC
    cmp     #10
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::RA
    jsr     Game_5310
    jsr     Game_4480
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=12 AND PN$="rac" THEN RB=1:SCREEN 2,2,2:GOSUB 5370:GOSUB 4500:GOSUB 6520:GOTO 3550
    lda     user + User::SC
    cmp     #12
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::RB
    jsr     Game_5370
    jsr     Game_4500
    jsr     Game_6520
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=13 AND PN$="rac" THEN RC=1:SCREEN 2,2,2:GOSUB 5420:GOSUB 4480:GOTO 3550
    lda     user + User::SC
    cmp     #13
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::RC
    jsr     Game_5420
    jsr     Game_4480
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=18 AND PN$="doo" THEN D5=1:SCREEN 2,2,2:GOSUB 5570:GOSUB 4030:GOTO 3550
    lda     user + User::SC
    cmp     #18
    bne     :+
    ldx     #<@door_string
    lda     #>@door_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::D5
    jsr     Game_5570
    jsr     Game_4030
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=30 AND PN$="doo" THEN DE=1:SCREEN 2,2,2:GOSUB 5870:GOSUB 4030:GOTO 3550
    lda     user + User::SC
    cmp     #30
    bne     :+
    ldx     #<@door_string
    lda     #>@door_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::DE
    jsr     Game_5870
    jsr     Game_4030
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=19 AND PN$="rac" THEN RD=1:SCREEN 2,2,2:GOSUB 5600:GOSUB 4480:GOTO 3550
    lda     user + User::SC
    cmp     #19
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::RD
    jsr     Game_5600
    jsr     Game_4480
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=22 AND PN$="rac" THEN RE=1:SCREEN 2,2,2:GOSUB 5670:GOSUB 4500:GOTO 3550
    lda     user + User::SC
    cmp     #22
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::RE
    jsr     Game_5670
    jsr     Game_4500
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=26 AND PN$="rac" THEN RF=1:SCREEN 2,2,2:GOSUB 5780:GOSUB 4480:GOTO 3550
    lda     user + User::SC
    cmp     #26
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::RF
    jsr     Game_5780
    jsr     Game_4480
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=33 AND PN$="rac" AND RH=0 THEN RG=1:SCREE N2,2,2:GOSUB 5940:GOSUB 4480:GOTO 3550
    lda     user + User::SC
    cmp     #33
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::RH
    bne     :+
    lda     #1
    sta     game + Game::RG
    jsr     Game_5940
    jsr     Game_4480
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=41 AND PN$="doo" THEN DDD=1:SCREEN 2,2,2:GOSUB 5080:GOSUB 3550
    lda     user + User::SC
    cmp     #41
    bne     :+
    ldx     #<@door_string
    lda     #>@door_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::DDD
    jsr     Game_5080
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF PN$="saf" AND S1=SC AND P2<100 AND SC=23 THEN 3730
    ldx     #<@safe_string
    lda     #>@safe_string
    jsr     GameCmpPn
    bcc     :+
    lda     user + User::S1
    cmp     user + User::SC
    bne     :+
    lda     game + Game::P2
    cmp     #100
    bcs     :+
    lda     user + User::SC
    cmp     #23
    bne     :+
    ldx     #<Game_3730
    lda     #>Game_3730
    jmp     @goto
:

    ; IF PN$="saf" AND S2=SC AND F1<100 AND SC=12 THEN 3730
    ldx     #<@safe_string
    lda     #>@safe_string
    jsr     GameCmpPn
    bcc     :+
    lda     user + User::S2
    cmp     user + User::SC
    bne     :+
    lda     game + Game::F1
    cmp     #100
    bcs     :+
    lda     user + User::SC
    cmp     #12
    bne     :+
    ldx     #<Game_3730
    lda     #>Game_3730
    jmp     @goto
:

    ; IF PN$="saf" AND S2=SC AND F2<100 AND SC=22 THEN 3730
    ldx     #<@safe_string
    lda     #>@safe_string
    jsr     GameCmpPn
    bcc     :+
    lda     user + User::S2
    cmp     user + User::SC
    bne     :+
    lda     game + Game::F2
    cmp     #100
    bcs     :+
    lda     user + User::SC
    cmp     #22
    bne     :+
    ldx     #<Game_3730
    lda     #>Game_3730
    jmp     @goto
:

    ; ' IF PN$="saf" AND S1=SC AND P1<100 AND SC=1 THEN 3730
    ; IF PN$="saf" AND S1=SC AND P1<100 AND SC=15 THEN 3730
    ldx     #<@safe_string
    lda     #>@safe_string
    jsr     GameCmpPn
    bcc     :+
    lda     user + User::S1
    cmp     user + User::SC
    bne     :+
    lda     game + Game::P1
    cmp     #100
    bcs     :+
    lda     user + User::SC
    cmp     #15
    bne     :+
    ldx     #<Game_3730
    lda     #>Game_3730
    jmp     @goto
:

    ; IF S1=SC AND PN$="saf" AND P1=100 THEN 3700
    lda     user + User::S1
    cmp     user + User::SC
    bne     :+
    ldx     #<@safe_string
    lda     #>@safe_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::P1
    cmp     #100
    bne     :+
    ldx     #<Game_3700
    lda     #>Game_3700
    jmp     @goto
:

    ; IF S1=SC AND PN$="saf" AND P2=100 THEN 3700
    lda     user + User::S1
    cmp     user + User::SC
    bne     :+
    ldx     #<@safe_string
    lda     #>@safe_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::P2
    cmp     #100
    bne     :+
    ldx     #<Game_3700
    lda     #>Game_3700
    jmp     @goto
:

    ; IF S2=SC AND PN$="saf" AND F2=100 THEN 3700
    lda     user + User::S2
    cmp     user + User::SC
    bne     :+
    ldx     #<@safe_string
    lda     #>@safe_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::F2
    cmp     #100
    bne     :+
    ldx     #<Game_3700
    lda     #>Game_3700
    jmp     @goto
:

    ; IF S2=SC AND PN$="saf" AND F1=100 THEN 3700
    lda     user + User::S2
    cmp     user + User::SC
    bne     :+
    ldx     #<@safe_string
    lda     #>@safe_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::F1
    cmp     #100
    bne     :+
    ldx     #<Game_3700
    lda     #>Game_3700
    jmp     @goto
:

    ; IF SC=32 AND PN$="saf" THEN 6200
    lda     user + User::SC
    cmp     #32
    bne     :+
    ldx     #<@safe_string
    lda     #>@safe_string
    jsr     GameCmpPn
    bcc     :+
    ldx     #<Game_6200
    lda     #>Game_6200
    jmp     @goto
:

    ; GOTO 3320
    ldx     #<Game_3320
    lda     #>Game_3320

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; DOOR
@door_string:

    .byte   "DOO"

; RACK
@rack_string:

    .byte   "RAC"

; SAFE
@safe_string:

    .byte   "SAF"

.endproc

; MYS22.BAS / 1000 - 1010
;
.proc   Game_1000

    ; IF SC=34 AND CA=0 AND MA=0 AND PN$="can" THEN SC=33:GOTO 5920
    lda     user + User::SC
    cmp     #34
    bne     :+
    lda     user + User::CA
    bne     :+
    lda     user + User::MA
    bne     :+
    ldx     #<@candle_string
    lda     #>@candle_string
    jsr     GameCmpPn
    bcc     :+
    lda     #33
    sta     user + User::SC
    ldx     #<Game_5920
    lda     #>Game_5920
    jmp     @goto
:

    ; GOTO 3320
    ldx     #<Game_3320
    lda     #>Game_3320

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; CANDLE
@candle_string:

    .byte   "CAN"

.endproc

; MYS22.BAS / 1020 - 1100
;
.proc   Game_1020

    ; IF CA=100 AND PN$="can" THEN CA=0:GOSUB 1550:PRINT:PRINT" OK":GOTO 330
    lda     user + User::CA
    cmp     #100
    bne     :+
    ldx     #<@candle_string
    lda     #>@candle_string
    jsr     GameCmpPn
    bcc     :+
    lda     #0
    sta     user + User::CA
    jsr     Game_1550
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString
;   ldx     #<Game_0330
;   lda     #>Game_0330
    lda     #$00
    sta     game + Game::AD
    ldx     #<Game_1560
    lda     #>Game_1560
    jmp     @goto
:

    ; IF MA=100 AND PN$="mat" THEN MA=0:GOSUB 1550:PRINT:PRINT" OK":GOTO 330
    lda     user + User::MA
    cmp     #100
    bne     :+
    ldx     #<@match_string
    lda     #>@match_string
    jsr     GameCmpPn
    bcc     :+
    lda     #0
    sta     user + User::MA
    jsr     Game_1550
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString
;   ldx     #<Game_0330
;   lda     #>Game_0330
    lda     #$00
    sta     game + Game::AD
    ldx     #<Game_1560
    lda     #>Game_1560
    jmp     @goto
:

    ; IF HA=100 AND PN$="ham" THEN HA=0:GOSUB 1550:PRINT:PRINT" OK":GOTO 330
    lda     user + User::HA
    cmp     #100
    bne     :+
    ldx     #<@hammer_string
    lda     #>@hammer_string
    jsr     GameCmpPn
    bcc     :+
    lda     #0
    sta     user + User::HA
    jsr     Game_1550
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString
;   ldx     #<Game_0330
;   lda     #>Game_0330
    lda     #$00
    sta     game + Game::AD
    ldx     #<Game_1560
    lda     #>Game_1560
    jmp     @goto
:

    ; IF PI=100 AND PN$="pic" THEN PI=0:GOSUB 1550:PRINT:PRINT" OK":GOTO 330
    lda     user + User::PI
    cmp     #100
    bne     :+
    ldx     #<@pick_string
    lda     #>@pick_string
    jsr     GameCmpPn
    bcc     :+
    lda     #0
    sta     user + User::PI
    jsr     Game_1550
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString
;   ldx     #<Game_0330
;   lda     #>Game_0330
    lda     #$00
    sta     game + Game::AD
    ldx     #<Game_1560
    lda     #>Game_1560
    jmp     @goto
:

    ; IF K1=100 AND PN$="key" THEN K1=0:GOSUB 1550:PRINT:PRINT" OK":GOTO 330
    lda     user + User::K1
    cmp     #100
    bne     :+
    ldx     #<@key_string
    lda     #>@key_string
    jsr     GameCmpPn
    bcc     :+
    lda     #0
    sta     user + User::K1
    jsr     Game_1550
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString
;   ldx     #<Game_0330
;   lda     #>Game_0330
    lda     #$00
    sta     game + Game::AD
    ldx     #<Game_1560
    lda     #>Game_1560
    jmp     @goto
:

    ; IF K2=100 AND PN$="key" THEN K2=0:GOSUB 1550:PRINT:PRINT" OK":GOTO 330
    lda     user + User::K2
    cmp     #100
    bne     :+
    ldx     #<@key_string
    lda     #>@key_string
    jsr     GameCmpPn
    bcc     :+
    lda     #0
    sta     user + User::K2
    jsr     Game_1550
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString
;   ldx     #<Game_0330
;   lda     #>Game_0330
    lda     #$00
    sta     game + Game::AD
    ldx     #<Game_1560
    lda     #>Game_1560
    jmp     @goto
:

    ; IF SC=33 AND RG=1 AND PN$="mem" AND ME=0 THEN RG=0:ME=1:GOSUB 1550:PRINT:PRINT" OK":GOTO 310
    lda     user + User::SC
    cmp     #33
    bne     :+
    lda     game + Game::RG
    cmp     #1
    bne     :+
    ldx     #<@memo_string
    lda     #>@memo_string
    jsr     GameCmpPn
    bcc     :+
    lda     user + User::ME
    bne     :+
    lda     #0
    sta     game + Game::RG
    lda     #1
    sta     user + User::ME
    jsr     Game_1550
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString
;   ldx     #<Game_0310
;   lda     #>Game_0310
    lda     #$00
    sta     game + Game::AD
    ldx     #<Game_1560
    lda     #>Game_1560
    jmp     @goto
:

    ; IF SC=32 AND PN$="dia" AND DI=1 THEN 6440
    lda     user + User::SC
    cmp     #32
    bne     :+
    ldx     #<@diamond_string
    lda     #>@diamond_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     user + User::DI
    ldx     #<Game_6440
    lda     #>Game_6440
    jmp     @goto
:

    ; GOTO 3320
    ldx     #<Game_3320
    lda     #>Game_3320

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; CANDLE
@candle_string:

    .byte   "CAN"

; MATCH
@match_string:

    .byte   "MAT"

; HAMMER
@hammer_string:

    .byte   "HAM"

; PICK
@pick_string:

    .byte   "PIC"

; KEY
@key_string:

    .byte   "KEY"

; MEMO
@memo_string:

    .byte   "MEM"

; DIAMOND
@diamond_string:

    .byte   "DIA"

; OK
@ok_string:

    .byte   "\n"
    .byte   " OK"
    .byte   $00

.endproc

; MYS22.BAS / 1110 - 1240
;
Game_1130:
.proc   Game_1110

    ; IF SC=10 AND CA=SC AND PN$="rac" AND RA=1 THEN CA=100:GOTO 5970
    lda     user + User::SC
    cmp     #10
    bne     :+
    cmp     user + User::CA
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::RA
    cmp     #1
    bne     :+
    lda     #100
    sta     user + User::CA
    ldx     #<Game_5970
    lda     #>Game_5970
    jmp     @goto
:

    ; IF SC=12 AND MA=SC AND PN$="rac" AND RB=1 THEN MA=100:GOTO 6030
    lda     user + User::SC
    cmp     #12
    bne     :+
    cmp     user + User::MA
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::RB
    cmp     #1
    bne     :+
    lda     #100
    sta     user + User::MA
    ldx     #<Game_6030
    lda     #>Game_6030
    jmp     @goto
:

    ; IF SC=12 AND S2=SC AND PN$="fir" THEN F1=1:SCREEN 2:GOSUB 5370:GOSUB 4360:GOSUB 6520:GOTO 3550
    lda     user + User::SC
    cmp     #12
    bne     :+
    cmp     user + User::S2
    bne     :+
    ldx     #<@fireplace_string
    lda     #>@fireplace_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::F1
    jsr     Game_5370
    jsr     Game_4360
    jsr     Game_6520
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=12 AND K1=SC AND PN$="vas" THEN K1=100:GOTO 6090
    lda     user + User::SC
    cmp     #12
    bne     :+
    cmp     user + User::K1
    bne     :+
    ldx     #<@vase_string
    lda     #>@vase_string
    jsr     GameCmpPn
    bcc     :+
    lda     #100
    sta     user + User::K1
    ldx     #<Game_6090
    lda     #>Game_6090
    jmp     @goto
:

    ; IF SC=13 AND CA=SC AND PN$="rac" AND RC=1 THEN CA=100:GOTO 5970
    lda     user + User::SC
    cmp     #13
    bne     :+
    cmp     user + User::CA
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::RC
    cmp     #1
    bne     :+
    lda     #100
    sta     user + User::CA
    ldx     #<Game_5970
    lda     #>Game_5970
    jmp     @goto
:

    ; IF SC=19 AND CA=SC AND PN$="rac" AND RD=1 THEN CA=100:GOTO 5970
    lda     user + User::SC
    cmp     #19
    bne     :+
    cmp     user + User::CA
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::RD
    cmp     #1
    bne     :+
    lda     #100
    sta     user + User::CA
    ldx     #<Game_5970
    lda     #>Game_5970
    jmp     @goto
:

    ; IF SC=29 AND K1=SC AND PN$="vas" THEN K1=100:GOTO 6090
    lda     user + User::SC
    cmp     #29
    bne     :+
    cmp     user + User::K1
    bne     :+
    ldx     #<@vase_string
    lda     #>@vase_string
    jsr     GameCmpPn
    bcc     :+
    lda     #100
    sta     user + User::K1
    ldx     #<Game_6090
    lda     #>Game_6090
    jmp     @goto
:

    ; IF SC=22 AND MA=SC AND PN$="rac" AND RE=1 THEN MA=100:GOTO 6030
    lda     user + User::SC
    cmp     #22
    bne     :+
    cmp     user + User::MA
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::RE
    cmp     #1
    bne     :+
    lda     #100
    sta     user + User::MA
    ldx     #<Game_6030
    lda     #>Game_6030
    jmp     @goto
:

    ; IF SC=14 AND K2=SC AND PN$="cha" THEN K2=100:GOTO 6090
    lda     user + User::SC
    cmp     #14
    bne     :+
    cmp     user + User::K2
    bne     :+
    ldx     #<@chair_string
    lda     #>@chair_string
    jsr     GameCmpPn
    bcc     :+
    lda     #100
    sta     user + User::K2
    ldx     #<Game_6090
    lda     #>Game_6090
    jmp     @goto
:

    ; IF SC=22 AND S2=SC AND PN$="fir" THEN F2=1:GOTO 6060
    lda     user + User::SC
    cmp     #22
    bne     :+
    cmp     user + User::S2
    bne     :+
    ldx     #<@fireplace_string
    lda     #>@fireplace_string
    jsr     GameCmpPn
    bcc     :+
    lda     #100
    sta     game + Game::F2
    ldx     #<Game_6060
    lda     #>Game_6060
    jmp     @goto
:

    ; IF SC=16 AND K2=SC AND PN$="cha" THEN K2=100:GOTO 6090
    lda     user + User::SC
    cmp     #16
    bne     :+
    cmp     user + User::K2
    bne     :+
    ldx     #<@chair_string
    lda     #>@chair_string
    jsr     GameCmpPn
    bcc     :+
    lda     #100
    sta     user + User::K2
    ldx     #<Game_6090
    lda     #>Game_6090
    jmp     @goto
:

    ; IF SC=33 AND PN$="rac" AND RG=1 AND ME=0 THEN 6190
    lda     user + User::SC
    cmp     #33
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::RG
    cmp     #1
    bne     :+
    lda     user + User::ME
    bne     :+
    ldx     #<Game_6190
    lda     #>Game_6190
    jmp     @goto
:

    ; IF SC=26 AND RF=1 AND PN$="rac" THEN PI=100:GOTO 6150
    lda     user + User::SC
    cmp     #26
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::RF
    cmp     #1
    bne     :+
    lda     #100
    sta     user + User::PI
    ldx     #<Game_6150
    lda     #>Game_6150
    jmp     @goto
:

    ; PRINT:PRINT"  なにも ないよ !":GOTO 330
    ldx     #<@nothing_string
    lda     #>@nothing_string
    jsr     _LibPrintTextString
    ldx     #<Game_0330
    lda     #>Game_0330

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; RACK
@rack_string:

    .byte   "RAC"

; FIREPLACE
@fireplace_string:

    .byte   "FIR"

; VASE
@vase_string:

    .byte   "VAS"

; CHAIR
@chair_string:

    .byte   "CHA"

; なにもないよ
@nothing_string:

    ; " なにも ないよ !"
    .byte   "\n"
    .byte   " ", hNA, hNI, hMO, " ", hNA, h_I, hYO, " !"
    .byte   $00

.endproc

; MYS22.BAS / 1250 - 1260
;
.proc   Game_1250

    ; IF SC=33 AND PN$="mem" AND ME=1 THEN 3610
    lda     user + User::SC
    cmp     #33
    bne     :+
    ldx     #<@memo_string
    lda     #>@memo_string
    jsr     GameCmpPn
    bcc     :+
    lda     user + User::ME
    cmp     #1
    bne     :+
    ldx     #<Game_3610
    lda     #>Game_3610
    jmp     @goto
:

    ; GOTO 3320
    ldx     #<Game_3320
    lda     #>Game_3320

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; MEMO
@memo_string:

    .byte   "MEM"

.endproc

; MYS22.BAS / 1270
;
.proc   Game_1270

    ; IF PN$="saf" THEN AV$="use":PN$="key":GOTO 1340
    ldx     #<@safe_string
    lda     #>@safe_string
    jsr     GameCmpPn
    bcc     :+
    lda     #'U'
    sta     game + Game::AV + $0000
    lda     #'S'
    sta     game + Game::AV + $0001
    lda     #'E'
    sta     game + Game::AV + $0002
    lda     #$00
    sta     game + Game::AV + $0003
    lda     #'K'
    sta     game + Game::PN + $0000
    lda     #'E'
    sta     game + Game::PN + $0001
    lda     #'Y'
    sta     game + Game::PN + $0002
    lda     #$00
    sta     game + Game::PN + $0003
    ldx     #<Game_1340
    lda     #>Game_1340
    jmp     @goto
:
    ldx     #<Game_1280
    lda     #>Game_1280

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; SAFE
@safe_string:

    .byte   "SAF"

.endproc

; MYS22.BAS / 1280 - 1330
;
Game_1290:
Game_1300:
Game_1310:
Game_1320:
.proc   Game_1280

    ; IF SC=5 AND PN$="tab" THEN TA=1:SCREEN 2,2,2:GOSUB 4780:GOSUB 5190:GOTO 3550
    lda     user + User::SC
    cmp     #5
    bne     :+
    ldx     #<@table_string
    lda     #>@table_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::TA
    jsr     Game_4780
    jsr     Game_5190
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=24 AND PN$="lad" THEN D1=30:SCREEN 2,2,2:GOSUB 5730:LINE(120,31)-(140,149),4,BF:GOTO 3590
    lda     user + User::SC
    cmp     #24
    bne     :+
    ldx     #<@ladder_string
    lda     #>@ladder_string
    jsr     GameCmpPn
    bcc     :+
    lda     #30
    sta     game + Game::D1
    jsr     Game_5730
    ldx     #<@shape_1290_arg
    lda     #>@shape_1290_arg
    jsr     _LibDrawShapes
    ldx     #<Game_3590
    lda     #>Game_3590
    jmp     @goto
:

    ; IF SC=15 AND PN$="pic" THEN P1=1:SCREEN 2,2,2:GOSUB 5480:GOSUB 4840:GOSUB 4520:GOTO 3550
    lda     user + User::SC
    cmp     #15
    bne     :+
    ldx     #<@picture_string
    lda     #>@picture_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::P1
    jsr     Game_5480
    jsr     Game_4840
    jsr     Game_4520
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=23 AND PN$="pic" THEN P2=1:SCREEN 2,2,2:GOSUB 5700:GOSUB 4840:GOSUB 4520:GOTO 3550
    lda     user + User::SC
    cmp     #23
    bne     :+
    ldx     #<@picture_string
    lda     #>@picture_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::P2
    jsr     Game_5700
    jsr     Game_4840
    jsr     Game_4520
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; IF SC=33 AND PN$="rac" THEN RH=1:Z=56:SCREEN 2,2,2:GOSUB 5410:GOSUB 4950:GOTO 3550
    lda     user + User::SC
    cmp     #33
    bne     :+
    ldx     #<@rack_string
    lda     #>@rack_string
    jsr     GameCmpPn
    bcc     :+
    lda     #1
    sta     game + Game::RH
    lda     #56
    sta     game + Game::Z
    jsr     Game_5410
    jsr     Game_4950
    ldx     #<Game_3550
    lda     #>Game_3550
    jmp     @goto
:

    ; GOTO 3320
    ldx     #<Game_3320
    lda     #>Game_3320

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; TABLE
@table_string:

    .byte   "TAB"

; LADDER
@ladder_string:

    .byte   "LAD"

; PICTURE
@picture_string:

    .byte   "PIC"

; RACK
@rack_string:

    .byte   "RAC"

; 図形
@shape_1290_arg:

    .byte   $04, 120, 31, 140, 149
    .byte   $00

.endproc

; MYS22.BAS / 1340 - 1460
;
.proc   Game_1340

    ; IF SC=24 AND HS=1 AND HA=0 AND PN$="ham" AND KK=0 THEN KK=1:GOTO 3510
    lda     user + User::SC
    cmp     #24
    bne     :+
    lda     game + Game::HS
    cmp     #1
    bne     :+
    lda     user + User::HA
    bne     :+
    ldx     #<@hammer_string
    lda     #>@hammer_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::KK
    bne     :+
    lda     #1
    sta     game + Game::KK
    ldx     #<Game_3510
    lda     #>Game_3510
    jmp     @goto
:

    ; IF SC=24 AND HS=1 AND HA=0 AND PN$="ham" AND KK=1 THEN KK=0:GOTO 3570
    lda     user + User::SC
    cmp     #24
    bne     :+
    lda     game + Game::HS
    cmp     #1
    bne     :+
    lda     user + User::HA
    bne     :+
    ldx     #<@hammer_string
    lda     #>@hammer_string
    jsr     GameCmpPn
    bcc     :+
    lda     game + Game::KK
    cmp     #1
    bne     :+
    lda     #0
    sta     game + Game::KK
    ldx     #<Game_3570
    lda     #>Game_3570
    jmp     @goto
:

    ; IF SC=33 AND RH=1 AND HA=0 AND PN$="ham" THEN PRINT:PRINT" ハンマ-では むりだ!":GOTO 330
    lda     user + User::SC
    cmp     #33
    bne     :+
    lda     game + Game::RH
    cmp     #1
    bne     :+
    lda     user + User::HA
    bne     :+
    ldx     #<@hammer_string
    lda     #>@hammer_string
    jsr     GameCmpPn
    bcc     :+
    ldx     #<@not_hammer_string
    lda     #>@not_hammer_string
    jsr     _LibPrintTextString
    ldx     #<Game_0330
    lda     #>Game_0330
    jmp     @goto
:

    ; IF SC=33 AND RH=1 AND PI=0 AND PN$="pic" THEN 3690
    lda     user + User::SC
    cmp     #33
    bne     :+
    lda     game + Game::RH
    cmp     #1
    bne     :+
    lda     user + User::PI
    bne     :+
    ldx     #<@pick_string
    lda     #>@pick_string
    jsr     GameCmpPn
    bcc     :+
    ldx     #<Game_3690
    lda     #>Game_3690
    jmp     @goto
:

    ; IF F1=1 AND K2=0 AND PN$="key" THEN F1=100:PRINT:PRINT" OK":GOTO 330
    lda     game + Game::F1
    cmp     #1
    bne     :+
    lda     user + User::K2
    bne     :+
    ldx     #<@key_string
    lda     #>@key_string
    jsr     GameCmpPn
    bcc     :+
    lda     #100
    sta     game + Game::F1
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString
    ldx     #<Game_0330
    lda     #>Game_0330
    jmp     @goto
:

    ; IF F2=1 AND K2=0 AND PN$="key" THEN F2=100:PRINT:PRINT" OK":GOTO 330
    lda     game + Game::F2
    cmp     #1
    bne     :+
    lda     user + User::K2
    bne     :+
    ldx     #<@key_string
    lda     #>@key_string
    jsr     GameCmpPn
    bcc     :+
    lda     #100
    sta     game + Game::F2
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString
    ldx     #<Game_0330
    lda     #>Game_0330
    jmp     @goto
:

    ; IF P1=1 AND K1=0 AND PN$="key" THEN P1=100:PRINT:PRINT" OK":GOTO 330
    lda     game + Game::P1
    cmp     #1
    bne     :+
    lda     user + User::K1
    bne     :+
    ldx     #<@key_string
    lda     #>@key_string
    jsr     GameCmpPn
    bcc     :+
    lda     #100
    sta     game + Game::P1
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString
    ldx     #<Game_0330
    lda     #>Game_0330
    jmp     @goto
:

    ; IF P2=1 AND K1=0 AND PN$="key" THEN P2=100:PRINT:PRINT" OK":GOTO 330
    lda     game + Game::P2
    cmp     #1
    bne     :+
    lda     user + User::K1
    bne     :+
    ldx     #<@key_string
    lda     #>@key_string
    jsr     GameCmpPn
    bcc     :+
    lda     #100
    sta     game + Game::P2
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString
    ldx     #<Game_0330
    lda     #>Game_0330
    jmp     @goto
:

    ; IF S1=SC AND K1>0 THEN PRINT:PRINT" かぎ がないよ!":GOTO 330
    lda     user + User::S1
    cmp     user + User::SC
    bne     :+
    lda     user + User::K1
    beq     :+
    ldx     #<@no_key_string
    lda     #>@no_key_string
    jsr     _LibPrintTextString
    ldx     #<Game_0330
    lda     #>Game_0330
    jmp     @goto
:

    ; IF S2=SC AND K2>0 THEN PRINT:PRINT" かぎ がないよ!":GOTO 330
    lda     user + User::S2
    cmp     user + User::SC
    bne     :+
    lda     user + User::K2
    beq     :+
    ldx     #<@no_key_string
    lda     #>@no_key_string
    jsr     _LibPrintTextString
    ldx     #<Game_0330
    lda     #>Game_0330
    jmp     @goto
:

    ; IF S1=SC AND K1>0 AND K2=0 THEN PRINT:PRINT" かぎ がちがます。":GOTO 330
    lda     user + User::S1
    cmp     user + User::SC
    bne     :+
    lda     user + User::K1
    beq     :+
    lda     user + User::K2
    bne     :+
    ldx     #<@differ_key_string
    lda     #>@differ_key_string
    jsr     _LibPrintTextString
    ldx     #<Game_0330
    lda     #>Game_0330
    jmp     @goto
:

    ; IF S2=SC AND K1=0 AND K2>0 THEN PRINT:PRINT" かぎ がちがます。":GOTO 330
    lda     user + User::S2
    cmp     user + User::SC
    bne     :+
    lda     user + User::K1
    bne     :+
    lda     user + User::K2
    beq     :+
    ldx     #<@differ_key_string
    lda     #>@differ_key_string
    jsr     _LibPrintTextString
    ldx     #<Game_0330
    lda     #>Game_0330
    jmp     @goto
:

    ; GOTO 3320
    ldx     #<Game_3320
    lda     #>Game_3320

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; HAMMER
@hammer_string:

    .byte   "HAM"

; PICK
@pick_string:

    .byte   "PIC"

; KEY
@key_string:

    .byte   "KEY"

; OK
@ok_string:

    .byte   "\n"
    .byte   " OK"
    .byte   $00

; ハンマーではむりだ！
@not_hammer_string:

    ; " ハンマ-では むりだ!"
    .byte   "\n"
    .byte   " ", kHA, k_N, kMA, _HF, hTE, _VM, hHA, " ", hMU, hRI, hTA, _VM, "!"
    .byte   $00

; かぎがないよ！
@no_key_string:

    ; " かぎ が ないよ!"
    .byte   "\n"
    .byte   " ", hKA, hKI, _VM, " ", hKA, _VM, " ", hNA, h_I, hYO, "!"
    .byte   $00

; かぎがちがいます
@differ_key_string:

    ; " かぎ が ちがます。"
    .byte   "\n"
    .byte   " ", hKA, hKI, _VM, " ", hKA, _VM, " ", hTI, hKA, _VM, h_I, hMA, hSU
    .byte   $00

.endproc

; MYS22.BAS / 1470 - 1490
;
.proc   Game_1470

    ; IF SC=20 THEN SC=3:GOTO 5120
    lda     user + User::SC
    cmp     #20
    bne     :+
    lda     #3
    sta     user + User::SC
    ldx     #<Game_5120
    lda     #>Game_5120
    jmp     @goto
:

    ; IF SC=5 AND TA=1 THEN SC=34:GOTO 5950
    lda     user + User::SC
    cmp     #5
    bne     :+
    lda     game + Game::TA
    cmp     #1
    bne     :+
    lda     #34
    sta     user + User::SC
    ldx     #<Game_5950
    lda     #>Game_5950
    jmp     @goto
:

    ; GOTO 3320
    ldx     #<Game_3320
    lda     #>Game_3320

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

.endproc

; MYS22.BAS / 1500 - 1530
;
.proc   Game_1500

    ; IF SC=4 THEN SC=18:GOTO 5550
    lda     user + User::SC
    cmp     #4
    bne     :+
    lda     #18
    sta     user + User::SC
    ldx     #<Game_5550
    lda     #>Game_5550
    jmp     @goto
:

    ; IF SC=34 THEN SC=8:GOTO 5240
    lda     user + User::SC
    cmp     #34
    bne     :+
    lda     #8
    sta     user + User::SC
    ldx     #<Game_5240
    lda     #>Game_5240
    jmp     @goto
:

    ; IF SC=31 THEN SC=8:GOTO 5240
    lda     user + User::SC
    cmp     #31
    bne     :+
    lda     #8
    sta     user + User::SC
    ldx     #<Game_5240
    lda     #>Game_5240
    jmp     @goto
:

    ; GOTO 3320
    ldx     #<Game_3320
    lda     #>Game_3320

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

.endproc

; MYS22.BAS / 1550
;
.proc   Game_1550

    ; rack のクリア
    lda     #0
    sta     game + Game::RA
    sta     game + Game::RB
    sta     game + Game::RC
    sta     game + Game::RD
    sta     game + Game::RE
    sta     game + Game::RF
    sta     game + Game::RG
;   sta     game + Game::RH

    ; table のクリア
;   lda     #0
    sta     game + Game::TA

    ; picture のクリア
;   lda     #0
    sta     game + Game::P1
    sta     game + Game::P2

    ; fireplace のクリア
;   lda     #0
    sta     game + Game::F1
    sta     game + Game::F2

    ; カウンタのクリア
;   lda     #0
    sta     game + Game::I

    ; 終了
    rts

.endproc

; MYS22.BAS / 1560
;
.proc   Game_1560

    jsr     Game_1550

.endproc

; MYS22.BAS / 1570 - 3030
;
.proc   Game_1570

    ; IF SC=1 AND AD$=CHR$(30) AND D1=1 THEN SC=2:D1=0:GOTO 5050
    lda     user + User::SC
    cmp     #1
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     game + Game::D1
    cmp     #1
    bne     :+
    lda     #2
    sta     user + User::SC
    lda     #0
    sta     game + Game::D1
    ldx     #<Game_5050
    lda     #>Game_5050
    jmp     @goto
:

    ; IF SC=1 AND AD$=CHR$(8) AND D1=1 THEN 5100
    lda     user + User::SC
    cmp     #1
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::D1
    cmp     #1
    bne     :+
    ldx     #<Game_5100
    lda     #>Game_5100
    jmp     @goto
:

    ; IF SC=1 AND AD$=CHR$(8) THEN 5090
    lda     user + User::SC
    cmp     #1
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5090
    lda     #>Game_5090
    jmp     @goto
:

    ; IF SC=3 AND AD$=CHR$(30) AND D3=1 THEN SC=13:D3=0:GOTO 5390
    lda     user + User::SC
    cmp     #3
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     game + Game::D3
    cmp     #1
    bne     :+
    lda     #13
    sta     user + User::SC
    lda     #0
    sta     game + Game::D3
    ldx     #<Game_5390
    lda     #>Game_5390
    jmp     @goto
:

    ; IF SC=3 AND AD$=CHR$(8) AND D3=1 THEN 5130
    lda     user + User::SC
    cmp     #3
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     #1
    sta     game + Game::D3
    ldx     #<Game_5130
    lda     #>Game_5130
    jmp     @goto
:

    ; IF SC=3 AND AD$=CHR$(8) THEN 5120
    lda     user + User::SC
    cmp     #3
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5120
    lda     #>Game_5120
    jmp     @goto
:

    ; IF SC=2 AND AD$=CHR$(29) THEN SC=3:GOTO 5120
    lda     user + User::SC
    cmp     #2
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #3
    sta     user + User::SC
    ldx     #<Game_5120
    lda     #>Game_5120
    jmp     @goto
:

    ; IF SC=17 AND AD$=CHR$(28) THEN SC=3:GOTO 5120
    lda     user + User::SC
    cmp     #17
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #3
    sta     user + User::SC
    ldx     #<Game_5120
    lda     #>Game_5120
    jmp     @goto
:

    ; IF SC=17 AND AD$=CHR$(30) AND DA=1 THEN GOTO 6390
    lda     user + User::SC
    cmp     #17
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     game + Game::DA
    cmp     #1
    bne     :+
    ldx     #<Game_6390
    lda     #>Game_6390
    jmp     @goto
:

    ; IF SC=17 AND AD$=CHR$(8) AND DA=1 THEN 5530
    lda     user + User::SC
    cmp     #17
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::DA
    cmp     #1
    bne     :+
    ldx     #<Game_5530
    lda     #>Game_5530
    jmp     @goto
:

    ; IF SC=17 AND AD$=CHR$(8) THEN 5520
    lda     user + User::SC
    cmp     #17
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5520
    lda     #>Game_5520
    jmp     @goto
:

    ; IF SC=2 AND AD$=CHR$(30) AND D2=1 THEN SC=5:D2=0:GOTO 5170
    lda     user + User::SC
    cmp     #2
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     game + Game::D2
    cmp     #1
    bne     :+
    lda     #5
    sta     user + User::SC
    lda     #0
    sta     game + Game::D2
    ldx     #<Game_5170
    lda     #>Game_5170
    jmp     @goto
:

    ; IF SC=2 AND AD$=CHR$(8) AND D2=1 THEN 5070
    lda     user + User::SC
    cmp     #2
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::D2
    cmp     #1
    bne     :+
    ldx     #<Game_5070
    lda     #>Game_5070
    jmp     @goto
:

    ; IF SC=2 AND AD$=CHR$(8) THEN 5050
    lda     user + User::SC
    cmp     #2
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5050
    lda     #>Game_5050
    jmp     @goto
:

    ; IF SC=2 AND AD$=CHR$(28) THEN SC=4:GOTO 5150
    lda     user + User::SC
    cmp     #2
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #4
    sta     user + User::SC
    ldx     #<Game_5150
    lda     #>Game_5150
    jmp     @goto
:

    ; IF SC=17 AND AD$=CHR$(29) THEN SC=4:GOTO 5150
    lda     user + User::SC
    cmp     #17
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #4
    sta     user + User::SC
    ldx     #<Game_5150
    lda     #>Game_5150
    jmp     @goto
:

    ; IF SC=3 AND AD$=CHR$(28) THEN SC=2:GOTO 5050
    lda     user + User::SC
    cmp     #3
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #2
    sta     user + User::SC
    ldx     #<Game_5050
    lda     #>Game_5050
    jmp     @goto
:

    ; IF SC=4 AND AD$=CHR$(29) THEN SC=2:GOTO 5050
    lda     user + User::SC
    cmp     #4
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #2
    sta     user + User::SC
    ldx     #<Game_5050
    lda     #>Game_5050
    jmp     @goto
:

    ; IF SC=4 AND AD$=CHR$(8) THEN 5150
    lda     user + User::SC
    cmp     #4
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5150
    lda     #>Game_5150
    jmp     @goto
:

    ; IF SC=4 AND AD$=CHR$(28) THEN SC=17:GOTO 5520
    lda     user + User::SC
    cmp     #4
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #17
    sta     user + User::SC
    ldx     #<Game_5520
    lda     #>Game_5520
    jmp     @goto
:

    ; IF SC=3 AND AD$=CHR$(29) THEN SC=17:GOTO 5520
    lda     user + User::SC
    cmp     #3
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #17
    sta     user + User::SC
    ldx     #<Game_5520
    lda     #>Game_5520
    jmp     @goto
:

    ; IF SC=5 AND AD$=CHR$(29) THEN SC=6:GOTO 5200
    lda     user + User::SC
    cmp     #5
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #6
    sta     user + User::SC
    ldx     #<Game_5200
    lda     #>Game_5200
    jmp     @goto
:

    ; IF SC=5 AND AD$=CHR$(8) AND TA=1 THEN 1280
    lda     user + User::SC
    cmp     #5
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::TA
    cmp     #1
    bne     :+
    ldx     #<Game_1280
    lda     #>Game_1280
    jmp     @goto
:

    ; IF SC=5 AND AD$=CHR$(8) THEN 5170
    lda     user + User::SC
    cmp     #5
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5170
    lda     #>Game_5170
    jmp     @goto
:

    ; IF SC=6 AND AD$=CHR$(29) THEN SC=8:GOTO 5240
    lda     user + User::SC
    cmp     #6
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #8
    sta     user + User::SC
    ldx     #<Game_5240
    lda     #>Game_5240
    jmp     @goto
:

    ; IF SC=6 AND AD$=CHR$(8) THEN 5200
    lda     user + User::SC
    cmp     #6
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5200
    lda     #>Game_5200
    jmp     @goto
:

    ; IF SC=5 AND AD$=CHR$(28) THEN SC=7:GOTO 5220
    lda     user + User::SC
    cmp     #5
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #7
    sta     user + User::SC
    ldx     #<Game_5220
    lda     #>Game_5220
    jmp     @goto
:

    ; IF SC=5 AND AD$=CHR$(28) THEN SC=7:GOTO 5220
    lda     user + User::SC
    cmp     #5
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #7
    sta     user + User::SC
    ldx     #<Game_5220
    lda     #>Game_5220
    jmp     @goto
:

    ; IF SC=7 AND AD$=CHR$(28) THEN SC=8:GOTO 5240
    lda     user + User::SC
    cmp     #7
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #8
    sta     user + User::SC
    ldx     #<Game_5240
    lda     #>Game_5240
    jmp     @goto
:

    ; IF SC=7 AND AD$=CHR$(8) THEN 5220
    lda     user + User::SC
    cmp     #7
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5220
    lda     #>Game_5220
    jmp     @goto
:

    ; IF SC=7 AND AD$=CHR$(29) THEN SC=5:GOTO 5170
    lda     user + User::SC
    cmp     #7
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #5
    sta     user + User::SC
    ldx     #<Game_5170
    lda     #>Game_5170
    jmp     @goto
:

    ; IF SC=6 AND AD$=CHR$(28) THEN SC=5:GOTO 5170
    lda     user + User::SC
    cmp     #6
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #5
    sta     user + User::SC
    ldx     #<Game_5170
    lda     #>Game_5170
    jmp     @goto
:

    ; IF SC=8 AND AD$=CHR$(28) THEN SC=6:GOTO 5200
    lda     user + User::SC
    cmp     #8
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #6
    sta     user + User::SC
    ldx     #<Game_5200
    lda     #>Game_5200
    jmp     @goto
:

    ; IF SC=8 AND AD$=CHR$(29) THEN SC=7:GOTO 5220
    lda     user + User::SC
    cmp     #8
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #7
    sta     user + User::SC
    ldx     #<Game_5220
    lda     #>Game_5220
    jmp     @goto
:

    ; IF SC=9 AND AD$=CHR$(30) THEN SC=7:GOTO 5220
    lda     user + User::SC
    cmp     #9
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     #7
    sta     user + User::SC
    ldx     #<Game_5220
    lda     #>Game_5220
    jmp     @goto
:

    ; IF SC=8 AND AD$=CHR$(30) AND DB=1 THEN SC=17:DB=0:GOTO 5520
    lda     user + User::SC
    cmp     #8
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     game + Game::DB
    cmp     #1
    bne     :+
    lda     #17
    sta     user + User::SC
    lda     #0
    sta     game + Game::DB
    ldx     #<Game_5520
    lda     #>Game_5520
    jmp     @goto
:

    ; IF SC=8 AND AD$=CHR$(8) AND DB=1 THEN 5250
    lda     user + User::SC
    cmp     #8
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::DB
    cmp     #1
    bne     :+
    ldx     #<Game_5250
    lda     #>Game_5250
    jmp     @goto
:

    ; IF SC=8 AND AD$=CHR$(8) THEN 5240
    lda     user + User::SC
    cmp     #8
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5240
    lda     #>Game_5240
    jmp     @goto
:

    ; IF SC=6 AND AD$=CHR$(30) THEN SC=12:GOTO 5350
    lda     user + User::SC
    cmp     #6
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     #12
    sta     user + User::SC
    ldx     #<Game_5350
    lda     #>Game_5350
    jmp     @goto
:

    ; IF SC=12 AND AD$=CHR$(28) THEN SC=10:GOTO 5290
    lda     user + User::SC
    cmp     #12
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #10
    sta     user + User::SC
    ldx     #<Game_5290
    lda     #>Game_5290
    jmp     @goto
:

    ; IF SC=12 AND AD$=CHR$(8) AND RB=1 AND F1=1 THEN 810
    lda     user + User::SC
    cmp     #12
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::RB
    cmp     #1
    bne     :+
    lda     game + Game::F1
    cmp     #1
    bne     :+
    ldx     #<Game_0810
    lda     #>Game_0810
    jmp     @goto
:

    ; IF SC=12 AND AD$=CHR$(8) AND RB=1 THEN 810
    lda     user + User::SC
    cmp     #12
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::RB
    cmp     #1
    bne     :+
    ldx     #<Game_0810
    lda     #>Game_0810
    jmp     @goto
:

    ; IF SC=12 AND AD$=CHR$(8) AND F1=1 THEN 1130
    lda     user + User::SC
    cmp     #12
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::F1
    cmp     #1
    bne     :+
    ldx     #<Game_1130
    lda     #>Game_1130
    jmp     @goto
:

    ; IF SC=12 AND AD$=CHR$(8) THEN 5350
    lda     user + User::SC
    cmp     #12
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5350
    lda     #>Game_5350
    jmp     @goto
:

    ; IF SC=12 AND AD$=CHR$(29) THEN SC=11:GOTO 5320
    lda     user + User::SC
    cmp     #12
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #11
    sta     user + User::SC
    ldx     #<Game_5320
    lda     #>Game_5320
    jmp     @goto
:

    ; IF SC=10 AND AD$=CHR$(29) THEN SC=12:GOTO 5350
    lda     user + User::SC
    cmp     #10
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #12
    sta     user + User::SC
    ldx     #<Game_5350
    lda     #>Game_5350
    jmp     @goto
:

    ; IF SC=10 AND AD$=CHR$(28) THEN SC=9:GOTO 5270
    lda     user + User::SC
    cmp     #10
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #9
    sta     user + User::SC
    ldx     #<Game_5270
    lda     #>Game_5270
    jmp     @goto
:

    ; IF SC=10 AND AD$=CHR$(8) AND RA=1 THEN 800
    lda     user + User::SC
    cmp     #10
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::RA
    cmp     #1
    bne     :+
    ldx     #<Game_0800
    lda     #>Game_0800
    jmp     @goto
:

    ; IF SC=10 AND AD$=CHR$(8) THEN 5290
    lda     user + User::SC
    cmp     #10
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5290
    lda     #>Game_5290
    jmp     @goto
:

    ; IF SC=11 AND AD$=CHR$(29) THEN SC=9:GOTO 5270
    lda     user + User::SC
    cmp     #11
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #9
    sta     user + User::SC
    ldx     #<Game_5270
    lda     #>Game_5270
    jmp     @goto
:

    ; IF SC=11 AND AD$=CHR$(28) THEN SC=12:GOTO 5350
    lda     user + User::SC
    cmp     #11
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #12
    sta     user + User::SC
    ldx     #<Game_5350
    lda     #>Game_5350
    jmp     @goto
:

    ; IF SC=9 AND AD$=CHR$(28) THEN SC=11:GOTO 5320
    lda     user + User::SC
    cmp     #9
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #11
    sta     user + User::SC
    ldx     #<Game_5320
    lda     #>Game_5320
    jmp     @goto
:

    ; IF SC=9 AND AD$=CHR$(8) THEN 5270
    lda     user + User::SC
    cmp     #9
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5270
    lda     #>Game_5270
    jmp     @goto
:

    ; IF SC=9 AND AD$=CHR$(29) THEN SC=10:GOTO 5290
    lda     user + User::SC
    cmp     #9
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #10
    sta     user + User::SC
    ldx     #<Game_5290
    lda     #>Game_5290
    jmp     @goto
:

    ; IF SC=11 AND AD$=CHR$(30) AND D4=1 THEN SC=15:D4=0:GOTO 5460
    lda     user + User::SC
    cmp     #11
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     game + Game::D4
    cmp     #1
    bne     :+
    lda     #15
    sta     user + User::SC
    lda     #0
    sta     game + Game::D4
    ldx     #<Game_5460
    lda     #>Game_5460
    jmp     @goto
:

    ; IF SC=11 AND AD$=CHR$(8) AND D4=1 THEN 5330
    lda     user + User::SC
    cmp     #11
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::D4
    cmp     #1
    bne     :+
    ldx     #<Game_5330
    lda     #>Game_5330
    jmp     @goto
:

    ; IF SC=11 AND AD$=CHR$(8) THEN 5320
    lda     user + User::SC
    cmp     #11
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5320
    lda     #>Game_5320
    jmp     @goto
:

    ; IF SC=15 AND AD$=CHR$(28) THEN SC=13:GOTO 5390
    lda     user + User::SC
    cmp     #15
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #13
    sta     user + User::SC
    ldx     #<Game_5390
    lda     #>Game_5390
    jmp     @goto
:

    ; IF SC=15 AND AD$=CHR$(8) AND P1=1 THEN 1300
    lda     user + User::SC
    cmp     #15
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::P1
    cmp     #1
    bne     :+
    ldx     #<Game_1300
    lda     #>Game_1300
    jmp     @goto
:

    ; IF SC=15 AND AD$=CHR$(8) THEN 5460
    lda     user + User::SC
    cmp     #15
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5460
    lda     #>Game_5460
    jmp     @goto
:

    ; IF SC=15 AND AD$=CHR$(29) THEN SC=16:GOTO 5490
    lda     user + User::SC
    cmp     #15
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #16
    sta     user + User::SC
    ldx     #<Game_5490
    lda     #>Game_5490
    jmp     @goto
:

    ; IF SC=16 AND AD$=CHR$(28) THEN SC=15:GOTO 5460
    lda     user + User::SC
    cmp     #16
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #15
    sta     user + User::SC
    ldx     #<Game_5460
    lda     #>Game_5460
    jmp     @goto
:

    ; IF SC=16 AND AD$=CHR$(29) THEN SC=14:GOTO 5430
    lda     user + User::SC
    cmp     #16
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #14
    sta     user + User::SC
    ldx     #<Game_5430
    lda     #>Game_5430
    jmp     @goto
:

    ; IF SC=13 AND AD$=CHR$(29) THEN SC=15:GOTO 5460
    lda     user + User::SC
    cmp     #13
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #15
    sta     user + User::SC
    ldx     #<Game_5460
    lda     #>Game_5460
    jmp     @goto
:

    ; IF SC=13 AND AD$=CHR$(8) AND RC=1 THEN 820
    lda     user + User::SC
    cmp     #13
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::RC
    cmp     #1
    bne     :+
    ldx     #<Game_0820
    lda     #>Game_0820
    jmp     @goto
:

    ; IF SC=13 AND AD$=CHR$(8) THEN 5390
    lda     user + User::SC
    cmp     #13
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5390
    lda     #>Game_5390
    jmp     @goto
:

    ; IF SC=13 AND AD$=CHR$(28) THEN SC=14:GOTO 5430
    lda     user + User::SC
    cmp     #13
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #14
    sta     user + User::SC
    ldx     #<Game_5430
    lda     #>Game_5430
    jmp     @goto
:

    ; IF SC=14 AND AD$=CHR$(29) THEN SC=13:GOTO 5390
    lda     user + User::SC
    cmp     #14
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #13
    sta     user + User::SC
    ldx     #<Game_5390
    lda     #>Game_5390
    jmp     @goto
:

    ; IF SC=14 AND AD$=CHR$(28) THEN SC=16:GOTO 5490
    lda     user + User::SC
    cmp     #14
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #16
    sta     user + User::SC
    ldx     #<Game_5490
    lda     #>Game_5490
    jmp     @goto
:

    ; IF SC=14 AND AD$=CHR$(30) AND DD=1 THEN SC=10:DD=0:GOTO 5290
    lda     user + User::SC
    cmp     #14
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     game + Game::DD
    cmp     #1
    bne     :+
    lda     #10
    sta     user + User::SC
    lda     #0
    sta     game + Game::DD
    ldx     #<Game_5290
    lda     #>Game_5290
    jmp     @goto
:

    ; IF SC=14 AND AD$=CHR$(8) AND DD=1 THEN 5440
    lda     user + User::SC
    cmp     #14
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::DD
    cmp     #1
    bne     :+
    ldx     #<Game_5440
    lda     #>Game_5440
    jmp     @goto
:

    ; IF SC=14 AND AD$=CHR$(8) THEN 5430
    lda     user + User::SC
    cmp     #14
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5430
    lda     #>Game_5430
    jmp     @goto
:

    ; IF SC=16 AND AD$=CHR$(30) AND DC=1 THEN SC=4:DD=0:GOTO 5150
    lda     user + User::SC
    cmp     #16
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     game + Game::DC
    cmp     #1
    bne     :+
    lda     #4
    sta     user + User::SC
    lda     #0
    sta     game + Game::DC ;; Game::DD
    ldx     #<Game_5150
    lda     #>Game_5150
    jmp     @goto
:

    ; IF SC=16 AND AD$=CHR$(8) AND DC=1 THEN 5500
    lda     user + User::SC
    cmp     #16
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::DC
    cmp     #1
    bne     :+
    ldx     #<Game_5500
    lda     #>Game_5500
    jmp     @goto
:

    ; IF SC=16 AND AD$=CHR$(8) THEN 5490
    lda     user + User::SC
    cmp     #16
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5490
    lda     #>Game_5490
    jmp     @goto
:

    ; IF SC=18 AND AD$=CHR$(30) AND D5=1 THEN SC=28:D5=0:GOTO 5810
    lda     user + User::SC
    cmp     #18
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     game + Game::D5
    cmp     #1
    bne     :+
    lda     #28
    sta     user + User::SC
    lda     #0
    sta     game + Game::DC ;; Game::D5
    ldx     #<Game_5810
    lda     #>Game_5810
    jmp     @goto
:

    ; IF SC=18 AND AD$=CHR$(8) AND D5=1 THEN 5560
    lda     user + User::SC
    cmp     #18
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::D5
    cmp     #1
    bne     :+
    ldx     #<Game_5560
    lda     #>Game_5560
    jmp     @goto
:

    ; IF SC=18 AND AD$=CHR$(8) THEN 5550
    lda     user + User::SC
    cmp     #18
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5550
    lda     #>Game_5550
    jmp     @goto
:

    ; IF SC=18 AND AD$=CHR$(28) THEN SC=19:GOTO 5580
    lda     user + User::SC
    cmp     #18
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #19
    sta     user + User::SC
    ldx     #<Game_5580
    lda     #>Game_5580
    jmp     @goto
:

    ; IF SC=18 AND AD$=CHR$(29) THEN SC=21:GOTO 5630
    lda     user + User::SC
    cmp     #18
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #21
    sta     user + User::SC
    ldx     #<Game_5630
    lda     #>Game_5630
    jmp     @goto
:

    ; IF SC=19 AND AD$=CHR$(29) THEN SC=18:GOTO 5550
    lda     user + User::SC
    cmp     #19
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #18
    sta     user + User::SC
    ldx     #<Game_5550
    lda     #>Game_5550
    jmp     @goto
:

    ; IF SC=19 AND AD$=CHR$(28) THEN SC=20:GOTO 5610
    lda     user + User::SC
    cmp     #19
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #20
    sta     user + User::SC
    ldx     #<Game_5610
    lda     #>Game_5610
    jmp     @goto
:

    ; IF SC=19 AND AD$=CHR$(8) AND RD=1 THEN 850
    lda     user + User::SC
    cmp     #19
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     game + Game::RD
    cmp     #1
    bne     :+
    ldx     #<Game_0850
    lda     #>Game_0850
    jmp     @goto
:

    ; IF SC=19 AND AD$=CHR$(8) THEN 5580
    lda     user + User::SC
    cmp     #19
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5580
    lda     #>Game_5580
    jmp     @goto
:

    ; IF SC=20 AND AD$=CHR$(29) THEN SC=19:GOTO 5580
    lda     user + User::SC
    cmp     #20
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #19
    sta     user + User::SC
    ldx     #<Game_5580
    lda     #>Game_5580
    jmp     @goto
:

    ; IF SC=20 AND AD$=CHR$(28) THEN SC=21:GOTO 5630
    lda     user + User::SC
    cmp     #20
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #21
    sta     user + User::SC
    ldx     #<Game_5630
    lda     #>Game_5630
    jmp     @goto
:

    ; IF SC=20 AND AD$=CHR$(8) THEN 5610
    lda     user + User::SC
    cmp     #20
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5610
    lda     #>Game_5610
    jmp     @goto
:

    ; IF SC=21 AND AD$=CHR$(29) THEN SC=20:GOTO 5610
    lda     user + User::SC
    cmp     #21
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #20
    sta     user + User::SC
    ldx     #<Game_5610
    lda     #>Game_5610
    jmp     @goto
:

    ; IF SC=21 AND AD$=CHR$(28) THEN SC=18:GOTO 5550
    lda     user + User::SC
    cmp     #21
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #18
    sta     user + User::SC
    ldx     #<Game_5550
    lda     #>Game_5550
    jmp     @goto
:

    ; IF SC=21 AND AD$=CHR$(8) THEN 5630
    lda     user + User::SC
    cmp     #21
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5630
    lda     #>Game_5630
    jmp     @goto
:

    ; IF SC=21 AND AD$=CHR$(30) THEN SC=22:GOTO 5650
    lda     user + User::SC
    cmp     #21
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     #22
    sta     user + User::SC
    ldx     #<Game_5650
    lda     #>Game_5650
    jmp     @goto
:

    ; IF SC=22 AND AD$=CHR$(28) THEN SC=23:GOTO 5680
    lda     user + User::SC
    cmp     #22
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #23
    sta     user + User::SC
    ldx     #<Game_5680
    lda     #>Game_5680
    jmp     @goto
:

    ; IF SC=22 AND AD$=CHR$(8) AND RE=1 THEN 860
    lda     user + User::SC
    cmp     #22
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::RE
    cmp     #1
    bne     :+
    ldx     #<Game_0860
    lda     #>Game_0860
    jmp     @goto
:

    ; IF SC=22 AND AD$=CHR$(8) THEN 5650
    lda     user + User::SC
    cmp     #22
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5650
    lda     #>Game_5650
    jmp     @goto
:

    ; IF SC=22 AND AD$=CHR$(29) THEN SC=24:GOTO 5710
    lda     user + User::SC
    cmp     #22
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #24
    sta     user + User::SC
    ldx     #<Game_5710
    lda     #>Game_5710
    jmp     @goto
:

    ; IF SC=23 AND AD$=CHR$(28) THEN SC=25:GOTO 5740
    lda     user + User::SC
    cmp     #23
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #25
    sta     user + User::SC
    ldx     #<Game_5740
    lda     #>Game_5740
    jmp     @goto
:

    ; IF SC=23 AND AD$=CHR$(29) THEN SC=22:GOTO 5650
    lda     user + User::SC
    cmp     #23
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #22
    sta     user + User::SC
    ldx     #<Game_5650
    lda     #>Game_5650
    jmp     @goto
:

    ; IF SC=23 AND AD$=CHR$(8) AND P2=1 THEN 1310
    lda     user + User::SC
    cmp     #23
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::P2
    cmp     #1
    bne     :+
    ldx     #<Game_1310
    lda     #>Game_1310
    jmp     @goto
:

    ; IF SC=23 AND AD$=CHR$(8) THEN 5680
    lda     user + User::SC
    cmp     #23
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5680
    lda     #>Game_5680
    jmp     @goto
:

    ; IF SC=24 AND AD$=CHR$(28) THEN SC=22:GOTO 5650
    lda     user + User::SC
    cmp     #24
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #22
    sta     user + User::SC
    ldx     #<Game_5650
    lda     #>Game_5650
    jmp     @goto
:

    ; IF SC=24 AND AD$=CHR$(8) AND KK=1 AND D1=30 THEN 3510
    lda     user + User::SC
    cmp     #24
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::KK
    cmp     #1
    bne     :+
    lda     game + Game::D1
    cmp     #30
    bne     :+
    ldx     #<Game_3510
    lda     #>Game_3510
    jmp     @goto
:

    ; IF SC=24 AND AD$=CHR$(8) AND WA=1 AND D1=30 THEN 3570
    lda     user + User::SC
    cmp     #24
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::WA
    cmp     #1
    bne     :+
    lda     game + Game::D1
    cmp     #30
    bne     :+
    ldx     #<Game_3570
    lda     #>Game_3570
    jmp     @goto
:

    ; IF SC=24 AND AD$=CHR$(8) AND D1=30 THEN PN$="lad":GOTO 1290
    lda     user + User::SC
    cmp     #24
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::D1
    cmp     #30
    bne     :+
    lda     #'L'
    sta     game + Game::PN + $0000
    lda     #'A'
    sta     game + Game::PN + $0001
    lda     #'D'
    sta     game + Game::PN + $0002
    lda     #$00
    sta     game + Game::PN + $0003
    ldx     #<Game_1290
    lda     #>Game_1290
    jmp     @goto
:

    ; IF SC=24 AND AD$=CHR$(8) THEN 5710
    lda     user + User::SC
    cmp     #24
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5710
    lda     #>Game_5710
    jmp     @goto
:

    ; IF SC=24 AND AD$=CHR$(30) AND WA=1 THEN SC=26:GOTO 5760
    lda     user + User::SC
    cmp     #24
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     game + Game::WA
    cmp     #1
    bne     :+
    lda     #26
    sta     user + User::SC
    ldx     #<Game_5760
    lda     #>Game_5760
    jmp     @goto
:

    ; IF SC=24 AND AD$=CHR$(29) THEN SC=25:GOTO 5740
    lda     user + User::SC
    cmp     #24
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #25
    sta     user + User::SC
    ldx     #<Game_5740
    lda     #>Game_5740
    jmp     @goto
:

    ; IF SC=25 AND AD$=CHR$(29) THEN SC=23:GOTO 5680
    lda     user + User::SC
    cmp     #25
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #23
    sta     user + User::SC
    ldx     #<Game_5680
    lda     #>Game_5680
    jmp     @goto
:

    ; IF SC=25 AND AD$=CHR$(8) THEN 5740
    lda     user + User::SC
    cmp     #25
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5740
    lda     #>Game_5740
    jmp     @goto
:

    ; IF SC=25 AND AD$=CHR$(28) THEN SC=24:GOTO 5710
    lda     user + User::SC
    cmp     #25
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #24
    sta     user + User::SC
    ldx     #<Game_5710
    lda     #>Game_5710
    jmp     @goto
:

    ; IF SC=25 AND AD$=CHR$(30) THEN SC=19:GOTO 5580
    lda     user + User::SC
    cmp     #25
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     #19
    sta     user + User::SC
    ldx     #<Game_5580
    lda     #>Game_5580
    jmp     @goto
:

    ; IF SC=26 AND AD$=CHR$(31) THEN SC=27:GOTO 5790
    lda     user + User::SC
    cmp     #26
    bne     :+
    lda     game + Game::AD
    cmp     #31
    bne     :+
    lda     #27
    sta     user + User::SC
    ldx     #<Game_5790
    lda     #>Game_5790
    jmp     @goto
:

    ; IF SC=26 AND AD$=CHR$(8) AND RF=1 THEN 870
    lda     user + User::SC
    cmp     #26
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::RF
    cmp     #1
    bne     :+
    ldx     #<Game_0870
    lda     #>Game_0870
    jmp     @goto
:

    ; IF SC=26 AND AD$=CHR$(8) THEN 5760
    lda     user + User::SC
    cmp     #26
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5760
    lda     #>Game_5760
    jmp     @goto
:

    ; IF SC=26 AND AD$=CHR$(29) THEN SC=41:DDD=0:GOTO 5060
    lda     user + User::SC
    cmp     #26
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #41
    sta     user + User::SC
    lda     #0
    sta     game + Game::DDD
    ldx     #<Game_5060
    lda     #>Game_5060
    jmp     @goto
:

    ; IF SC=26 AND AD$=CHR$(28) THEN SC=40:GOTO 6540
    lda     user + User::SC
    cmp     #26
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #40
    sta     user + User::SC
    ldx     #<Game_6540
    lda     #>Game_6540
    jmp     @goto
:

    ; IF SC=27 AND AD$=CHR$(31) THEN SC=26:GOTO 5760
    lda     user + User::SC
    cmp     #27
    bne     :+
    lda     game + Game::AD
    cmp     #31
    bne     :+
    lda     #26
    sta     user + User::SC
    ldx     #<Game_5760
    lda     #>Game_5760
    jmp     @goto
:

    ; IF SC=27 AND AD$=CHR$(28) THEN SC=41:GOTO 5060
    lda     user + User::SC
    cmp     #27
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #41
    sta     user + User::SC
    ldx     #<Game_5060
    lda     #>Game_5060
    jmp     @goto
:

    ; IF SC=27 AND AD$=CHR$(29) THEN SC=40:GOTO 6540
    lda     user + User::SC
    cmp     #27
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #40
    sta     user + User::SC
    ldx     #<Game_6540
    lda     #>Game_6540
    jmp     @goto
:

    ; IF SC=27 AND AD$=CHR$(8) THEN 5790
    lda     user + User::SC
    cmp     #27
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5790
    lda     #>Game_5790
    jmp     @goto
:

    ; IF SC=27 AND AD$=CHR$(30) THEN SC=23:GOTO 5680
    lda     user + User::SC
    cmp     #27
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     #23
    sta     user + User::SC
    ldx     #<Game_5680
    lda     #>Game_5680
    jmp     @goto
:

    ; IF SC=28 AND AD$=CHR$(29) THEN SC=29:GOTO 5830
    lda     user + User::SC
    cmp     #28
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #29
    sta     user + User::SC
    ldx     #<Game_5830
    lda     #>Game_5830
    jmp     @goto
:

    ; IF SC=28 AND AD$=CHR$(8) THEN 5810
    lda     user + User::SC
    cmp     #28
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5810
    lda     #>Game_5810
    jmp     @goto
:

    ; IF SC=29 AND AD$=CHR$(29) THEN SC=30:GOTO 5850
    lda     user + User::SC
    cmp     #29
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #30
    sta     user + User::SC
    ldx     #<Game_5850
    lda     #>Game_5850
    jmp     @goto
:

    ; IF SC=29 AND AD$=CHR$(28) THEN SC=28:GOTO 5810
    lda     user + User::SC
    cmp     #29
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #28
    sta     user + User::SC
    ldx     #<Game_5810
    lda     #>Game_5810
    jmp     @goto
:

    ; IF SC=29 AND AD$=CHR$(8) THEN 5830
    lda     user + User::SC
    cmp     #29
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5830
    lda     #>Game_5830
    jmp     @goto
:

    ; IF SC=30 AND AD$=CHR$(28) THEN SC=29:GOTO 5830
    lda     user + User::SC
    cmp     #30
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #29
    sta     user + User::SC
    ldx     #<Game_5830
    lda     #>Game_5830
    jmp     @goto
:

    ; IF SC=30 AND AD$=CHR$(30) AND DE=1 THEN SC=20:GOTO 5610
    lda     user + User::SC
    cmp     #30
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     game + Game::DE
    cmp     #1
    bne     :+
    lda     #20
    sta     user + User::SC
    ldx     #<Game_5610
    lda     #>Game_5610
    jmp     @goto
:

    ; IF SC=30 AND AD$=CHR$(8) AND DE=1 THEN 5860
    lda     user + User::SC
    cmp     #30
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::DE
    cmp     #1
    bne     :+
    ldx     #<Game_5860
    lda     #>Game_5860
    jmp     @goto
:

    ; IF SC=30 AND AD$=CHR$(8) THEN 5850
    lda     user + User::SC
    cmp     #30
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5850
    lda     #>Game_5850
    jmp     @goto
:

    ; IF SC=28 AND AD$=CHR$(28) THEN 6300
    lda     user + User::SC
    cmp     #28
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    ldx     #<Game_6300
    lda     #>Game_6300
    jmp     @goto
:

    ; IF SC=30 AND AD$=CHR$(29) THEN 6300
    lda     user + User::SC
    cmp     #30
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    ldx     #<Game_6300
    lda     #>Game_6300
    jmp     @goto
:

    ; IF SC=33 AND AD$=CHR$(31) THEN SC=31:Z=0:GOTO 5880
    lda     user + User::SC
    cmp     #33
    bne     :+
    lda     game + Game::AD
    cmp     #31
    bne     :+
    lda     #31
    sta     user + User::SC
    lda     #0
    sta     game + Game::Z
    ldx     #<Game_5880
    lda     #>Game_5880
    jmp     @goto
:

    ; IF SC=33 AND AD$=CHR$(8) AND PC=1 THEN 3690
    lda     user + User::SC
    cmp     #33
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::PC
    cmp     #1
    bne     :+
    ldx     #<Game_3690
    lda     #>Game_3690
    jmp     @goto
:

    ; IF SC=33 AND AD$=CHR$(8) AND RG=1 THEN 880
    lda     user + User::SC
    cmp     #33
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::RG
    cmp     #1
    bne     :+
    ldx     #<Game_0880
    lda     #>Game_0880
    jmp     @goto
:

    ; IF SC=33 AND AD$=CHR$(8) AND RH=1 THEN 1320
    lda     user + User::SC
    cmp     #33
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::RH
    cmp     #1
    bne     :+
    ldx     #<Game_1320
    lda     #>Game_1320
    jmp     @goto
:

    ; IF SC=33 AND AD$=CHR$(8) THEN 5920
    lda     user + User::SC
    cmp     #33
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5920
    lda     #>Game_5920
    jmp     @goto
:

    ; IF SC=31 AND AD$=CHR$(31) THEN SC=33:GOTO 5920
    lda     user + User::SC
    cmp     #31
    bne     :+
    lda     game + Game::AD
    cmp     #31
    bne     :+
    lda     #33
    sta     user + User::SC
    ldx     #<Game_5920
    lda     #>Game_5920
    jmp     @goto
:

    ; IF SC=31 AND AD$=CHR$(8) THEN 5880
    lda     user + User::SC
    cmp     #31
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5880
    lda     #>Game_5880
    jmp     @goto
:

    ; IF SC=33 AND AD$=CHR$(30) AND PC=1 THEN SC=32:GOTO 5900
    lda     user + User::SC
    cmp     #33
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     game + Game::PC
    cmp     #1
    bne     :+
    lda     #32
    sta     user + User::SC
    ldx     #<Game_5900
    lda     #>Game_5900
    jmp     @goto
:

    ; IF SC=34 THEN 6360
    lda     user + User::SC
    cmp     #34
    bne     :+
    ldx     #<Game_6360
    lda     #>Game_6360
    jmp     @goto
:

    ; IF SC=41 AND AD$=CHR$(29) THEN SC=27:GOTO 5790
    lda     user + User::SC
    cmp     #41
    bne     :+
    lda     game + Game::AD
    cmp     #29
    bne     :+
    lda     #27
    sta     user + User::SC
    ldx     #<Game_5790
    lda     #>Game_5790
    jmp     @goto
:

    ; IF SC=41 AND AD$=CHR$(28) THEN SC=26:GOTO 5760
    lda     user + User::SC
    cmp     #41
    bne     :+
    lda     game + Game::AD
    cmp     #28
    bne     :+
    lda     #26
    sta     user + User::SC
    ldx     #<Game_5760
    lda     #>Game_5760
    jmp     @goto
:

    ; IF SC=41 AND AD$=CHR$(30) THEN SC=2:WA=0:GOTO 5050
    lda     user + User::SC
    cmp     #41
    bne     :+
    lda     game + Game::AD
    cmp     #30
    bne     :+
    lda     #2
    sta     user + User::SC
    ldx     #<Game_5050
    lda     #>Game_5050
    jmp     @goto
:

    ; IF SC=41 AND AD$=CHR$(8) AND DDD=1 THEN 5070
    lda     user + User::SC
    cmp     #41
    bne     :+
    lda     game + Game::AD
    bne     :+
    lda     game + Game::DDD
    cmp     #1
    bne     :+
    ldx     #<Game_5070
    lda     #>Game_5070
    jmp     @goto
:

    ; IF SC=41 AND AD$=CHR$(8) THEN 5050
    lda     user + User::SC
    cmp     #41
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5050
    lda     #>Game_5050
    jmp     @goto
:

    ; IF SC=32 AND AD$=CHR$(8) THEN 5900
    lda     user + User::SC
    cmp     #32
    bne     :+
    lda     game + Game::AD
    bne     :+
    ldx     #<Game_5900
    lda     #>Game_5900
    jmp     @goto
:

    ; GOTO 3320
    ldx     #<Game_3320
    lda     #>Game_3320
    jmp     @goto

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

.endproc

; MYS22.BAS / 3040 - 3170
;
.proc   Game_3040

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized

    ; VRAM　のクリア
    jsr     _IocsClearVram

    ; ヘルプの表示
    ldx     #<@help_0_arg
    lda     #>@help_0_arg
    jsr     _IocsDrawString
    ldx     #<@help_1_arg
    lda     #>@help_1_arg
    jsr     _IocsDrawString

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE
    beq     @end

    ; 処理の設定
    lda     #<Game_3180
    sta     APP_0_PROC_L
    lda     #>Game_3180
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; ヘルプ
@help_0_arg:

    .byte   $06, $00
    .word   @help_0_string

@help_1_arg:

    .byte   $06, $0e
    .word   @help_1_string

@help_0_string:

    ; "      めいれい の いちらん ひょう"
    ; "どうする ? と きかれたとき !"
    ; "  up...............あがる"
    ; "  down.............おりる "
    ; "  take.............とる"
    ; "  open.............あける"
    ; "  use..............つかう"
    ; "  move.............うごかす"
    ; "  search...........さがす "
    ; "  save.............ゲ-ム の セ-ブ"
    ; "  な ど............."
    ; "      hit any key !!!"
    .byte   "      ", hME, h_I, hRE, h_I, " ", hNO, " ", h_I, hTI, hRA, h_N, " ", hHI, hyo, h_U, "\n\n"
    .byte   hTO, _VM, h_U, hSU, hRU, " ? ", hTO, " ", hKI, hKA, hRE, hTA, hTO, hKI, " !\n\n"
    .byte   "  F,B,L,R..........", h_I, hTO, _VM, h_U, "\n\n"
    .byte   "  U,D..............", h_A, hKA, _VM, hRU, ",", h_O, hRI, hRU, "\n\n"
    .byte   "  TAKE.............", hTO, hRU, "\n\n"
    .byte   "  OPEN.............", h_A, hKE, hRU, "\n\n"
    .byte   "  USE..............", hTU, hKA, h_U
    .byte   $00

@help_1_string:

    .byte   "  MOVE.............", h_U, hKO, _VM, hKA, hSU, "\n\n"
    .byte   "  SEARCH...........", hSA, hKA, _VM, hSU, "\n\n"
    .byte   "  SAVE.............", kKE, _VM, _HF, kMU, " ", hNO, " ", kSE, _HF, kHU, _VM, "\n\n"
    .byte   "  ", hNA, hTO, _VM, "..............\n\n"
    .byte   "      hit any key !!!"
    .byte   $00

.endproc

; MYS22.BAS / 3180 - 3310
;
.proc   Game_3180

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized

    ; VRAM　のクリア
    jsr     _IocsClearVram

    ; ヘルプの表示
    ldx     #<@help_0_arg
    lda     #>@help_0_arg
    jsr     _IocsDrawString
    ldx     #<@help_1_arg
    lda     #>@help_1_arg
    jsr     _IocsDrawString

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE
    beq     @end

    ; どうする？のクリア
    lda     #$00
    sta     game + Game::AD

    ; 処理の設定
    lda     #<Game_1570
    sta     APP_0_PROC_L
    lda     #>Game_1570
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; ヘルプ
@help_0_arg:

    .byte   $06, $00
    .word   @help_0_string

@help_1_arg:

    .byte   $06, $0e
    .word   @help_1_string

@help_0_string:

    ; "なにを ? と きかれたとき !"
    ; "  door.............ドア"
    ; "  rack.............ラック"
    ; "  safe.............きんこ"
    ; "  candle...........ろうそく"
    ; "  picture..........え"
    ; "  table............テ-ブル"
    ; "  ladder...........はしご"
    ; "  vase.............かびん "
    ; "  fireplace........だんろ"
    ; "  など.............."
    ; "      hit any key !!!"
    .byte   hNA, hNI, hWO, " ? ", hTO, " ", hKI, hKA, hRE, hTA, hTO, hKI, " !\n\n"
    .byte   "  DOOR.............", kTO, _VM, k_A, "\n\n"
    .byte   "  RACK.............", kRA, ktu, kKU, "\n\n"
    .byte   "  SAFE.............", hKI, h_N, hKO, "\n\n"
    .byte   "  CANDLE...........", hRO, h_U, hSO, hKU, "\n\n"
    .byte   "  PICTURE..........", h_E, "\n\n"
    .byte   "  TABLE............", kTE, _HF, kHU, _VM, kRU
    .byte   $00

@help_1_string:

    .byte   "  LADDER...........", hHA, hSI, hKO, _VM, "\n\n"
    .byte   "  VASE.............", hKA, hHI, _VM, h_N, "\n\n"
    .byte   "  FIREPLACE........", hTA, _VM, h_N, hRO, "\n\n"
    .byte   "  ", hNA, hTO, _VM, "..............\n\n"
    .byte   "      hit any key !!!"
    .byte   $00

.endproc

; MYS22.BAS / 3320 - 3330
;
.proc   Game_3320

    ; テキストの表示
    ldx     #<@text_string
    lda     #>@text_string
    jsr     _LibPrintTextString

    ; BEEP の再生
    ldx     #<@beep_arg
    lda     #>@beep_arg
    jsr     _IocsBeepScore

    ; 処理の設定
    lda     #<Game_0310
    sta     APP_0_PROC_L
    lda     #>Game_0310
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; BEEP
@beep_arg:

    ; "O5L16GFEDC"
    .byte   _O5G, _L16
    .byte   _O5F, _L16
    .byte   _O5E, _L16
    .byte   _O5D, _L16
    .byte   _O5C, _L16
    .byte   IOCS_BEEP_END

; テキスト
@text_string:

    ; " だめです !"
    .byte   "\n"
    .byte   " ", hTA, _VM, hME, hTE, _VM, hSU, " !"
    .byte   $00

.endproc

; MYS22.BAS / 3340 - 3490
;
.proc   Game_3340

    ; candle の初期化
    jsr     _IocsGetRandomNumber
    cmp     #80
    bcs     :+
    lda     #10
    jmp     :+++
:
    cmp     #160
    bcs     :+
    lda     #13
    jmp     :++
:
    lda     #19
:
    sta     user + User::CA

    ; match の初期化
    jsr     _IocsGetRandomNumber
    cmp     #128
    bcs     :+
    lda     #12
    jmp     :++
:
    lda     #22
:
    sta     user + User::MA

    ; key の初期化
    jsr     _IocsGetRandomNumber
    cmp     #128
    bcs     :+
    lda     #12
    jmp     :++
:
    lda     #29
:
    sta     user + User::K1
    lda     #14
    sta     user + User::K2

    ; safe の初期化
    jsr     _IocsGetRandomNumber
    cmp     #128
    bcs     :+
    lda     #15
    jmp     :++
:
    lda     #23
:
    sta     user + User::S1
    jsr     _IocsGetRandomNumber
    cmp     #128
    bcs     :+
    lda     #12
    jmp     :++
:
    lda     #22
:
    sta     user + User::S2

    ; hammer の初期化
    jsr     _IocsGetRandomNumber
    cmp     #128
    bcs     :+
    lda     user + User::S1
    jmp     :++
:
    lda     user + User::S2
:
    sta     user + User::HA

    ; pick の初期化
    lda     #26
    sta     user + User::PI

    ; 終了
    rts

.endproc

; MYS22.BAS / 3510
;
.proc   Game_3510

    ; 画面処理
    jsr     Game_5730
    jsr     Game_4650
    jsr     Game_3520

    ; BEEP の再生
    ldx     #_O4Fp
    lda     #_L64
    jsr     _IocsBeepNote
    ldx     #_O4A
    lda     #_L64
    jsr     _IocsBeepNote

    ; 処理の設定
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

.endproc

; MYS22.BAS / 3520
;
.proc   Game_3520
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $01, 90, 100, 100, 120
    .byte   $01, 95, 115, 105,  90
    .byte   $01, 93, 110,  95, 105
    .byte   $00
.endproc

; MYS22.BAS / 3530 - 3560
;

; 3530 - 3540
.proc   Game_3530
.endproc

; 3550 - 3560
.proc   Game_3550

    ; キー入力
;   lda     IOCS_0_KEYCODE
;   beq     @end

    ; 処理の設定
    lda     #<Game_0330
    sta     APP_0_PROC_L
    lda     #>Game_0330
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

.endproc

; MYS22.BAS / 3570 - 3580
;
.proc   Game_3570

    ; 画面処理
    jsr     Game_5730
    jsr     Game_4650
    jsr     Game_4810
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    jsr     Game_7970

    ; 壁の更新
    lda     #1
    sta     game + Game::WA

    ; 処理の設定
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
    rts

; かべの むこうに へやが あるよ!
@text_arg:
    .byte   5 + 1, 6
    .word   @text_string
@text_string:
    .byte   hKA, hHE, _VM, hNO, " ", hMU, hKO, h_U, hNI, " ", hHE, hYA, hKA, _VM, h_A, hRU, hYO, "!"
    .byte   $00
.endproc

; MYS22.BAS / 3590
;
.proc   Game_3590
    lda     #1
    sta     game + Game::HS
    jsr     Game_4650
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; MYS22.BAS / 3600
;
.proc   Game_3600
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; MYS22.BAS / 3610 - 3680
;
.proc   Game_3610
    lda     APP_0_STATE
    bne     :+
    jsr     _IocsClearVram
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    inc     APP_0_STATE
:
    lda     IOCS_0_KEYCODE
    beq     :+
    lda     #$00
    sta     game + Game::AD
;   lda     #<Game_3530
    lda     #<Game_1560
    sta     APP_0_PROC_L
;   lda     #>Game_3530
    lda     #>Game_1560
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
:
    rts
@text_arg:
    .byte   7 + 1, 7
    .word   @text_string
@text_string:
    ; "♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥"
    ; "♥    M E M O    ♥"
    ; "♥               ♥"
    ; "♥ pick を みつけた ? ♥"
    ; "♥               ♥"
    ; "♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥♥"
    ; " Hit Any Key !!!"
    .byte   hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, "\n"
    .byte   hHT, "    M E M O    ", hHT, "\n"
    .byte   hHT, "               ", hHT, "\n"
    .byte   hHT, " PICK ", hWO, " ", hMI, hTU, hKE, hTA, " ? ", hHT, "\n"
    .byte   hHT, "               ", hHT, "\n"
    .byte   hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, "\n"
    .byte   "\n"
    .byte   " Hit Any Key !!!"
    .byte   $00
.endproc

; MYS22.BAS / 3690
;
.proc   Game_3690
    lda     #1
    sta     game + Game::PC
    jsr     Game_5410
    jsr     Game_4950
    jsr     Game_5030
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; MYS22.BAS / 3700 - 3720
;
.proc   Game_3700

    ; IF HA=S1 THEN HA=100:GOTO 6120
    lda     user + User::HA
    cmp     user + User::S1
    bne     :+
    lda     #100
    sta     user + User::HA
    ldx     #<Game_6120
    lda     #>Game_6120
    jmp     @goto
:

    ; IF HA=S2 THEN HA=100:GOTO 6120
    lda     user + User::HA
    cmp     user + User::S2
    bne     :+
    lda     #100
    sta     user + User::HA
    ldx     #<Game_6120
    lda     #>Game_6120
    jmp     @goto
:

    ; PRINT:PRINT" OK ":GOTO 310
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString
    ldx     #<Game_0310
    lda     #>Game_0310

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; OK
@ok_string:
    .byte   "\n"
    .byte   " OK"
    .byte   $00

.endproc

; MYS22.BAS / 3730
;
.proc   Game_3730
    ldx     #<@lock_string
    lda     #>@lock_string
    jsr     _LibPrintTextString
    lda     #<Game_0330
    sta     APP_0_PROC_L
    lda     #>Game_0330
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@lock_string:
    ; " かぎが かかって います。"
    .byte   "\n"
    .byte   " ", hKA, hKI, _VM, hKA, _VM, " ", hKA, hKA, htu, hTE, " ", h_I, hMA, hSU
    .byte   $00
.endproc

; MYS22.BAS / 3890
;
.proc   Game_3890
;   jsr     _IocsClearVram
    jsr     _LibClearShape
    rts
.endproc

; MYS22.BAS / 3900
;
.proc   Game_3900
;   jsr     _IocsClearVram
    jsr     _LibClearShape
    rts
.endproc

; MYS22.BAS / 3910 - 5030
;

; 3910
.proc   Game_3910
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $02, 5, 5, 250, 170
    .byte   $00
.endproc

; 3920
.proc   Game_3920
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 5, 30, 255, 150
    .byte   $00
.endproc

; 3930
.proc   Game_3930
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 40, 30, 215, 150
    .byte   $00
.endproc

; 3940
.proc   Game_3940
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $01,  5,   5, 40,  30
    .byte   $01, 40, 150,  5, 170
    .byte   $00
.endproc

; 3950
.proc   Game_3950
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $01, 250,   5, 215,  30
    .byte   $01, 215, 150, 250, 170
    .byte   $00
.endproc

; 3960 - 3980
.proc   Game_3960
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03,  75,  55, 180, 125
    .byte   $01,   5,   5,  75,  55
    .byte   $01, 250,   5, 180,  55
    .byte   $01, 180, 125, 250, 170
    .byte   $01,  75, 125,   5, 170
    .byte   $00
.endproc

; 3990
.proc   Game_3990
;   ldx     #<@shape_arg
;   lda     #>@shape_arg
;   jsr     _LibDrawShapes
    ; PSET(50, 180), 5
    ; PRINT#1, "  Hit any key !";CHR$(30)
;   ldx     #<@text_arg
;   lda     #>@text_arg
;   jsr     _IocsDrawString
    rts
@shape_arg:
    .byte   $03, 60, 175, 180, 190
    .byte   $00
@text_arg:
    .byte   13, 22
    .word   @text_string
@text_string:
    .byte   "Hit any key !"
    .byte   $00
.endproc

; 4000
.proc   Game_4000
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 104, 85, 145, 150
    .byte   $00
.endproc

; 4010 - 4020
.proc   Game_4010
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $02, 111,  90, 140, 110
    .byte   $02, 111, 120, 140, 145
    .byte   $05, 140, 116,   3
    .byte   $00
.endproc

; 4030 - 4040
.proc   Game_4030
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 106,  86, 144, 149
    .byte   $03,  85,  85, 103, 150
;-  .byte   $04,  91,  90, 102, 110
    .byte   $03,  91,  90, 102, 110 ;+
;-  .byte   $04,  92, 120, 102, 145
    .byte   $03,  92, 120, 102, 145 ;+
    .byte   $00
.endproc

; 4050
.proc   Game_4050
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $01,  5, 70, 10,  75
    .byte   $01, 10, 75, 10, 166
    .byte   $00
.endproc

; 4060
.proc   Game_4060
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $01, 250, 70, 245,  75
    .byte   $01, 245, 75, 245, 166
    .byte   $00
.endproc

; 4070
.proc   Game_4070
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $01, 250, 50, 235,  55
    .byte   $01, 235, 55, 235, 160
    .byte   $00
.endproc

; 4080
.proc   Game_4080
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $01,  5, 50, 20,  55
    .byte   $01, 20, 55, 20, 160
    .byte   $00
.endproc

; 4090 - 4120
.proc   Game_4090
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03,  96, 70, 160, 150
    .byte   $01, 107, 70, 102, 150
    .byte   $01, 151, 70, 156, 149
    ; FOR I = 80 TO 140 STEP 10
    ;   X = X + .5
    ;   LINE(107 - X, I)-(153 + X, I), 1
    ; NEXT
    ; X=0
    .byte   $01, 107 - 0,  80, 153 + 0,  80
    .byte   $01, 107 - 0,  90, 153 + 0,  90
    .byte   $01, 107 - 1, 100, 153 + 1, 100
    .byte   $01, 107 - 1, 110, 153 + 1, 110
    .byte   $01, 107 - 2, 120, 153 + 2, 120
    .byte   $01, 107 - 2, 130, 153 + 2, 130
    .byte   $01, 107 - 3, 140, 153 + 3, 140
    .byte   $00
.endproc

; 4130
.proc   Game_4130
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 5, 30, 215, 150
    .byte   $00
.endproc

; 4140
.proc   Game_4140
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 40, 30, 250, 150
    .byte   $00
.endproc

; 4150 - 4180
.proc   Game_4150
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $01,  90, 130, 160, 130
    .byte   $01, 160, 130, 165, 145
    .byte   $01, 165, 145,  85, 145
    .byte   $01,  90, 130,  85, 145
    ; PAINT(130, 140), 6
    .byte   $03, 150, 145, 153, 170
    .byte   $03, 100, 145, 102, 170
    .byte   $03, 145, 145, 148, 160
    .byte   $03, 105, 145, 107, 160
    .byte   $00
.endproc

; 4190 - 4200
.proc   Game_4190
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $02, 110, 118, 135, 120
    .byte   $01, 115, 120, 115, 130
    .byte   $01, 130, 120, 130, 130
    .byte   $00
.endproc

; 4210
.proc   Game_4210
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $02, 56, 85, 60, 136
    .byte   $00
.endproc

; 4220
.proc   Game_4220
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $02, 195, 85, 198, 136
    .byte   $00
.endproc

; 4230
.proc   Game_4230
    ; PSET(140, 98)
    ; PRINT#1, "v"
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    jmp     Game_4240
@text_arg:
    .byte   20 + 1, 12
    .word   @text_string
@text_string:
    .byte   "v", $00
.endproc

; 4240 - 4250
.proc   Game_4240
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 110, 105, 150, 126
    .byte   $01, 140, 105, 140, 126
;-  .byte   $04, 117, 110, 132, 125
    .byte   $03, 117, 110, 132, 125 ;+
    .byte   $00
.endproc

; 4260
.proc   Game_4260
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $04, 53, 120, 60, 137
    .byte   $03, 54, 121, 59, 136
    .byte   $00
.endproc

; 4270
.proc   Game_4270
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $04, 192, 120, 198, 137
    .byte   $03, 193, 121, 197, 136
    .byte   $00
.endproc

; 4280
.proc   Game_4280
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
;-  .byte   $03, 30, 135,  5, 170
    .byte   $04, 30, 135,  5, 170   ;+
    .byte   $01,  5, 140, 30, 135
    .byte   $01, 30, 135,  5, 135
    .byte   $01, 31, 135, 31, 170
    .byte   $00
.endproc

; 4310
.proc   Game_4310
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
;-  .byte   $03, 225, 135, 255, 170
    .byte   $04, 225, 135, 255, 170 ;+
    .byte   $01, 225, 135, 250, 135
    .byte   $01, 225, 135, 250, 140
    .byte   $01, 224, 135, 224, 170
    .byte   $00
.endproc

; 4330
.proc   Game_4330
    ; LINE( 95 + Z, 110)-(135 + Z, 155), 11, BF
    ; LINE( 95 + Z, 110)-(135 + Z, 155),  1, B
    ; LINE( 96 + Z, 110)-(134 + Z, 108),  1, B
    ; LINE( 97 + Z, 112)-(133 + Z, 153),  1, B
    ; LINE(103 + Z, 130)-(104 + Z, 135),  1, B
    lda     #95
    clc
    adc     game + Game::Z
    sta     @shape_arg + $0001
    sta     @shape_arg + $0006
    lda     #96
    clc
    adc     game + Game::Z
    sta     @shape_arg + $000b
    lda     #97
    clc
    adc     game + Game::Z
    sta     @shape_arg + $0010
    lda     #103
    clc
    adc     game + Game::Z
    sta     @shape_arg + $0015
    lda     #135
    clc
    adc     game + Game::Z
    sta     @shape_arg + $0003
    sta     @shape_arg + $0008
    lda     #134
    clc
    adc     game + Game::Z
    sta     @shape_arg + $000d
    lda     #133
    clc
    adc     game + Game::Z
    sta     @shape_arg + $0012
    lda     #104
    clc
    adc     game + Game::Z
    sta     @shape_arg + $0017
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03,  95, 110, 135, 155
    .byte   $02,  95, 110, 135, 155
    .byte   $02,  96, 110, 134, 108
    .byte   $02,  97, 112, 133, 153
    .byte   $02, 103, 130, 104, 135
    .byte   $00
.endproc

; 4360
.proc   Game_4360
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 88, 125, 135, 145
    .byte   $00
.endproc

; 4370 - 4430
.proc   Game_4370
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 70, 115, 155, 155
    .byte   $02, 71, 115, 155, 112
    ; FOR J = 115 TO 150 STEP 5
    ;   A = A + 1
    ;   FOR I = 70 TO 140 STEP 10
    ;     IF A / 2 = INT(A / 2) THEN AA = 5
    ;     LINE(I + AA, J)-(I + 10 + AA, J + 5), 1, B
    ;   NEXT I
    ;   AA = 0
    ; NEXT J
    .byte   $02,  70 + 0, 115,  70 + 10 + 0, 115 + 5
    .byte   $02,  80 + 0, 115,  80 + 10 + 0, 115 + 5
    .byte   $02,  90 + 0, 115,  90 + 10 + 0, 115 + 5
    .byte   $02, 100 + 0, 115, 100 + 10 + 0, 115 + 5
    .byte   $02, 110 + 0, 115, 110 + 10 + 0, 115 + 5
    .byte   $02, 120 + 0, 115, 120 + 10 + 0, 115 + 5
    .byte   $02, 130 + 0, 115, 130 + 10 + 0, 115 + 5
    .byte   $02, 140 + 0, 115, 140 + 10 + 0, 115 + 5
    .byte   $02,  70 + 5, 120,  70 + 10 + 5, 120 + 5
    .byte   $02,  80 + 5, 120,  80 + 10 + 5, 120 + 5
    .byte   $02,  90 + 5, 120,  90 + 10 + 5, 120 + 5
    .byte   $02, 100 + 5, 120, 100 + 10 + 5, 120 + 5
    .byte   $02, 110 + 5, 120, 110 + 10 + 5, 120 + 5
    .byte   $02, 120 + 5, 120, 120 + 10 + 5, 120 + 5
    .byte   $02, 130 + 5, 120, 130 + 10 + 5, 120 + 5
    .byte   $02, 140 + 5, 120, 140 + 10 + 5, 120 + 5
    .byte   $02,  70 + 0, 125,  70 + 10 + 0, 125 + 5
    .byte   $02,  80 + 0, 125,  80 + 10 + 0, 125 + 5
    .byte   $02,  90 + 0, 125,  90 + 10 + 0, 125 + 5
    .byte   $02, 100 + 0, 125, 100 + 10 + 0, 125 + 5
    .byte   $02, 110 + 0, 125, 110 + 10 + 0, 125 + 5
    .byte   $02, 120 + 0, 125, 120 + 10 + 0, 125 + 5
    .byte   $02, 130 + 0, 125, 130 + 10 + 0, 125 + 5
    .byte   $02, 140 + 0, 125, 140 + 10 + 0, 125 + 5
    .byte   $02,  70 + 5, 130,  70 + 10 + 5, 130 + 5
    .byte   $02,  80 + 5, 130,  80 + 10 + 5, 130 + 5
    .byte   $02,  90 + 5, 130,  90 + 10 + 5, 130 + 5
    .byte   $02, 100 + 5, 130, 100 + 10 + 5, 130 + 5
    .byte   $02, 110 + 5, 130, 110 + 10 + 5, 130 + 5
    .byte   $02, 120 + 5, 130, 120 + 10 + 5, 130 + 5
    .byte   $02, 130 + 5, 130, 130 + 10 + 5, 130 + 5
    .byte   $02, 140 + 5, 130, 140 + 10 + 5, 130 + 5
    .byte   $02,  70 + 0, 135,  70 + 10 + 0, 135 + 5
    .byte   $02,  80 + 0, 135,  80 + 10 + 0, 135 + 5
    .byte   $02,  90 + 0, 135,  90 + 10 + 0, 135 + 5
    .byte   $02, 100 + 0, 135, 100 + 10 + 0, 135 + 5
    .byte   $02, 110 + 0, 135, 110 + 10 + 0, 135 + 5
    .byte   $02, 120 + 0, 135, 120 + 10 + 0, 135 + 5
    .byte   $02, 130 + 0, 135, 130 + 10 + 0, 135 + 5
    .byte   $02, 140 + 0, 135, 140 + 10 + 0, 135 + 5
    .byte   $02,  70 + 5, 140,  70 + 10 + 5, 140 + 5
    .byte   $02,  80 + 5, 140,  80 + 10 + 5, 140 + 5
    .byte   $02,  90 + 5, 140,  90 + 10 + 5, 140 + 5
    .byte   $02, 100 + 5, 140, 100 + 10 + 5, 140 + 5
    .byte   $02, 110 + 5, 140, 110 + 10 + 5, 140 + 5
    .byte   $02, 120 + 5, 140, 120 + 10 + 5, 140 + 5
    .byte   $02, 130 + 5, 140, 130 + 10 + 5, 140 + 5
    .byte   $02, 140 + 5, 140, 140 + 10 + 5, 140 + 5
    .byte   $02,  70 + 0, 145,  70 + 10 + 0, 145 + 5
    .byte   $02,  80 + 0, 145,  80 + 10 + 0, 145 + 5
    .byte   $02,  90 + 0, 145,  90 + 10 + 0, 145 + 5
    .byte   $02, 100 + 0, 145, 100 + 10 + 0, 145 + 5
    .byte   $02, 110 + 0, 145, 110 + 10 + 0, 145 + 5
    .byte   $02, 120 + 0, 145, 120 + 10 + 0, 145 + 5
    .byte   $02, 130 + 0, 145, 130 + 10 + 0, 145 + 5
    .byte   $02, 140 + 0, 145, 140 + 10 + 0, 145 + 5
    .byte   $02,  70 + 5, 150,  70 + 10 + 5, 150 + 5
    .byte   $02,  80 + 5, 150,  80 + 10 + 5, 150 + 5
    .byte   $02,  90 + 5, 150,  90 + 10 + 5, 150 + 5
    .byte   $02, 100 + 5, 150, 100 + 10 + 5, 150 + 5
    .byte   $02, 110 + 5, 150, 110 + 10 + 5, 150 + 5
    .byte   $02, 120 + 5, 150, 120 + 10 + 5, 150 + 5
    .byte   $02, 130 + 5, 150, 130 + 10 + 5, 150 + 5
    .byte   $02, 140 + 5, 150, 140 + 10 + 5, 150 + 5
;-  .byte   $04, 88, 125, 135, 145
    .byte   $03, 88, 125, 135, 145  ;+
    .byte   $00
.endproc

; 4440 - 4450
.proc   Game_4440
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 152, 112, 185, 155
    .byte   $02, 152, 115, 185, 155
    .byte   $02, 152, 115, 184, 112
    .byte   $01, 160, 125, 160, 130
    .byte   $00
.endproc

; 4460 - 4470
.proc   Game_4460
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ; COLOR 9, 0
    ; PSET(170, 95), 4
    ; PRINT#1, "*"
    ; COLOR 1, 0
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    rts
@shape_arg:
;-  .byte   $04, 167, 108, 173, 113
    .byte   $03, 167, 108, 173, 113 ;+
    .byte   $01, 169, 110, 170, 100
    .byte   $00
@text_arg:
    .byte   24 + 1, 12
    .word   @text_string
@text_string:
    .byte   "*", $00
.endproc

; 4480 - 4490
.proc   Game_4480
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03,  97, 113, 152, 152
    .byte   $02, 133, 113, 152, 152
    .byte   $01,  97, 133, 133, 133
    .byte   $00
.endproc

; 4500
.proc   Game_4500
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 152, 116, 210, 154
    .byte   $02, 184, 116, 210, 154
    .byte   $00
.endproc

; 4510
.proc   Game_4510
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ; COLOR 12,0
    ; PSET(130, 73), 14
    ; PRINT#1, "え"
    ; COLOR 1,0
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    rts
@shape_arg:
    .byte   $03, 115, 65, 150, 90
    .byte   $03, 119, 67, 146, 88
    .byte   $00
@text_arg:
    .byte   18 + 1, 9
    .word   @text_string
@text_string:
    .byte   h_E, $00
.endproc

; 4520
.proc   Game_4520
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ; COLOR 12,0
    ; PSET(175, 73), 14
    ; PRINT#1, "え"
    ; COLOR 1,0
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    rts
@shape_arg:
    .byte   $03, 160, 65, 195, 90
    .byte   $03, 162, 67, 193, 88
    .byte   $00
@text_arg:
    .byte   25 + 1, 9
    .word   @text_string
@text_string:
    .byte   h_E, $00
.endproc

; 4530 - 4540
.proc   Game_4530
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
;-  .byte   $04, 50, 140, 65, 138
    .byte   $03, 50, 140, 65, 138   ;+
    .byte   $02, 47, 125, 50, 155
    .byte   $02, 60, 140, 63, 155
    .byte   $01, 49, 120, 53, 130
    .byte   $00
.endproc

; 4550 - 4580
.proc   Game_4550
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $02, 207, 140, 188, 138
    .byte   $02, 201, 130, 200, 138
    .byte   $02, 190, 140, 191, 152
    .byte   $02, 205, 140, 204, 152
    .byte   $02, 193, 140, 194, 150
    .byte   $02, 201, 140, 202, 150
    .byte   $02, 194, 130, 195, 138
    .byte   $02, 203, 125, 192, 130
    .byte   $00
.endproc

; 4590 - 4610
.proc   Game_4590
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ; PSET(112, 80), 4
    ; PRINT#1, "1 F"
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    rts
@shape_arg:
    .byte   $02, 100, 70, 150, 150
    .byte   $01, 125, 90, 125, 110
    .byte   $01, 125, 110, 120, 105
    .byte   $01, 125, 110, 130, 105
    .byte   $00
@text_arg:
    .byte   16 + 1, 10
    .word   @text_string
@text_string:
    .byte   "1 F", $00
.endproc

; 4620
.proc   Game_4620
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $02, 190, 80, 193, 90
    .byte   $00
.endproc

; 4630 - 4640
.proc   Game_4630
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $01, 250, 50, 235, 55
    .byte   $01, 235, 55, 235, 70
    .byte   $01, 235, 70, 250, 75
    .byte   $00
.endproc

; 4650 - 4670
.proc   Game_4650
    ; LINE(120 + D1, 30)-(140 + D1, 150), 1, B
    lda     game + Game::D1
    clc
    adc     #120
    sta     @rect_arg + $0000
    clc
    adc     #20
    sta     @rect_arg + $0002
    lda     #30
    sta     @rect_arg + $0001
    lda     #150
    sta     @rect_arg + $0003
    ldx     #<@rect_arg
    lda     #>@rect_arg
    jsr     _LibDrawRect
    ; FOR I = 30 TO 120 STEP 30
    ;   LINE(120 + D1, I)-(140 + D1, I + 15), 1, B
    ; NEXT I
    ; 'D1 = 0
;   lda     game + Game::D1
;   clc
;   adc     #120
;   sta     @rect_arg + $0000
;   clc
;   adc     #20
;   sta     @rect_arg + $0002
;   lda     #30
;   sta     @rect_arg + $0001
    lda     #45
    sta     @rect_arg + $0003
:
    ldx     #<@rect_arg
    lda     #>@rect_arg
    jsr     _LibDrawRect
    lda     @rect_arg + $0001
    cmp     #120
    beq     :+
    clc
    adc     #30
    sta     @rect_arg + $0001
    clc
    adc     #15
    sta     @rect_arg + $0003
    jmp     :-
:
    rts
@rect_arg:
    .byte   0, 0, 0, 0
.endproc

; 4680
.proc   Game_4680
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 120, 115, 130, 126
    .byte   $00
.endproc

; 4690 - 4700
.proc   Game_4690
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $02,  40, 110, 220, 150
    ; FOR I = 40 TO 220 STEP 15
    ;   LINE(I, 110)-(I, 150), 1
    ; NEXT I
    .byte   $01,  40, 110,  40, 150
    .byte   $01,  55, 110,  55, 150
    .byte   $01,  70, 110,  70, 150
    .byte   $01,  85, 110,  85, 150
    .byte   $01, 100, 110, 100, 150
    .byte   $01, 115, 110, 115, 150
    .byte   $01, 130, 110, 130, 150
    .byte   $01, 145, 110, 145, 150
    .byte   $01, 160, 110, 160, 150
    .byte   $01, 175, 110, 175, 150
    .byte   $01, 190, 110, 190, 150
    .byte   $01, 205, 110, 205, 150
    .byte   $01, 220, 110, 220, 150
    .byte   $00
.endproc

; 4710 - 4730
.proc   Game_4710
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ; FOR I = 5 TO 40 STEP 15
    ;   LINE(I, 115 - D2)-(I, 170 - D1), 1
    ;   D2 = D2 + 1.5
    ;   D1 = D1 + 8
    ; NEXT I
    ; D1 = 0
    ; D2 = 0
    lda     #5
    sta     @line_arg + $0000
    sta     @line_arg + $0002
    lda     #115
    sec
    sbc     game + Game::D2
    sta     @line_arg + $0001
    lda     #170
    sec
    sbc     game + Game::D1
    sta     @line_arg + $0003
    ldx     #<@line_arg
    lda     #>@line_arg
    jsr     _LibDrawLine
    lda     #20
    sta     @line_arg + $0000
    sta     @line_arg + $0002
    dec     @line_arg + $0001
    lda     @line_arg + $0003
    sec
    sbc     #8
    sta     @line_arg + $0003
    ldx     #<@line_arg
    lda     #>@line_arg
    jsr     _LibDrawLine
    lda     #35
    sta     @line_arg + $0000
    sta     @line_arg + $0002
    dec     @line_arg + $0001
    dec     @line_arg + $0001
    lda     @line_arg + $0003
    sec
    sbc     #8
    sta     @line_arg + $0003
    ldx     #<@line_arg
    lda     #>@line_arg
    jsr     _LibDrawLine
    lda     #0
    sta     game + Game::D1
    sta     game + Game::D2
    rts
@shape_arg:
    .byte   $01, 40, 110, 5, 115
    .byte   $01, 40, 150, 5, 170
    .byte   $00
@line_arg:
    .byte   0, 0, 0, 0
.endproc

; 4740 - 4760
.proc   Game_4740
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ; FOR I = 220 TO 250 STEP 15
    ;   LINE(I, 110 + D1)-(I, 150 + D2), 1
    ;   D1 = D1 + 2.5
    ;   D2 = D2 + 9
    ; NEXT I
    ; D1 = 0
    ; D2 = 0
    lda     #220
    sta     @line_arg + $0000
    sta     @line_arg + $0002
    lda     #110
    clc
    adc     game + Game::D1
    sta     @line_arg + $0001
    lda     #150
    clc
    adc     game + Game::D2
    sta     @line_arg + $0003
    ldx     #<@line_arg
    lda     #>@line_arg
    jsr     _LibDrawLine
    lda     #235
    sta     @line_arg + $0000
    sta     @line_arg + $0002
    lda     @line_arg + $0001
    clc
    adc     #2
    sta     @line_arg + $0001
    lda     @line_arg + $0003
    clc
    adc     #9
    sta     @line_arg + $0003
    ldx     #<@line_arg
    lda     #>@line_arg
    jsr     _LibDrawLine
    lda     #250
    sta     @line_arg + $0000
    sta     @line_arg + $0002
    lda     @line_arg + $0001
    clc
    adc     #3
    sta     @line_arg + $0001
    lda     @line_arg + $0003
    clc
    adc     #9
    sta     @line_arg + $0003
    ldx     #<@line_arg
    lda     #>@line_arg
    jsr     _LibDrawLine
    lda     #0
    sta     game + Game::D1
    sta     game + Game::D2
    rts
@shape_arg:
    .byte   $01, 220, 110, 250, 115
    .byte   $01, 220, 150, 250, 170
    .byte   $00
@line_arg:
    .byte   0, 0, 0, 0
.endproc

; 4770
.proc   Game_4770
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $01, 40,   5, 40, 150
    .byte   $01, 40, 150,  5, 170
    .byte   $00
.endproc

; 4780 - 4790
.proc   Game_4780
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $04, 100, 151, 160, 170 ;+
    .byte   $01, 109, 160, 146, 160
    .byte   $01, 104, 170, 151, 170
    .byte   $01, 109, 160, 104, 170
    .byte   $01, 146, 160, 151, 170
    ; PAINT(130, 165), 1
    .byte   $00
.endproc

; 4800
.proc   Game_4800
    ; PSET(36, 36)
    ; PRINT#1, "ちかしつ の いりぐち が あるよ !"
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    ; GOSUB 7970
    jsr     Game_7970
    rts
@text_arg:
    .byte   5 + 1, 5 ; 4
    .word   @text_string
@text_string:
    .byte   hTI, hKA, hSI, hTU, " ", hNO, " ", h_I, hRI, hKU, _VM, hTI, " ", hKA, _VM, " ", h_A, hRU, hYO, " !"
    .byte   $00
.endproc

; 4810 - 4830
.proc   Game_4810
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $01, 100, 100,  90, 110
    .byte   $01,  90, 110,  80, 130
    .byte   $01,  80, 130,  90, 135
    .byte   $01,  90, 135, 120, 120
    .byte   $01, 120, 120, 130, 108
    .byte   $01, 130, 108, 100, 100
    ; PAINT(95, 120), 14
    .byte   $00
.endproc

; 4840 - 4870
.proc   Game_4840
    ldx     #<@shape_0_arg
    lda     #>@shape_0_arg
    jsr     _LibDrawShapes
    ; IF S1 < SC OR S1 > SC THEN RETURN
    lda     user + User::S1
    cmp     user + User::SC
    bne     :+
    ldx     #<@shape_1_arg
    lda     #>@shape_1_arg
    jsr     _LibDrawShapes
    ; PSET(64, 32)
    ; PRINT#1, "safe が あるよ!"
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    ; GOSUB 7950
    jsr     Game_7950
:
    rts
@shape_0_arg:
    .byte   $04, 115, 65, 150, 90
    .byte   $00
@shape_1_arg:
    .byte   $02, 115, 65, 140, 80
    .byte   $03, 117, 67, 138, 78
;-  .byte   $04, 130, 72, 132, 74
    .byte   $03, 130, 72, 132, 74   ;+
    .byte   $00
@text_arg:
    .byte   9 + 1, 5 ; 4
    .word   @text_string
@text_string:
    .byte   "SAFE ", hKA, _VM, " ", h_A, hRU, hYO, "!"
    .byte   $00
.endproc

; 4880
.proc   Game_4880
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $02, 75, 55, 189, 125
    .byte   $00
.endproc

; 4890
.proc   Game_4890
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ; PSET(64, 32)
    ; PRINT#1, "safe が あるよ!"
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    ; GOSUB 7950
    jsr     Game_7950
    rts
@shape_arg:
    .byte   $04, 130, 72, 132, 74
    .byte   $00
@text_arg:
    .byte   9 + 1, 5 ; 4
    .word   @text_string
@text_string:
    .byte   "SAFE ", hKA, _VM, " ", h_A, hRU, hYO, "!"
    .byte   $00
.endproc

; 4900 - 4940
.proc   Game_4900
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ; PSET(120, 88)
    ; PRINT#1, "_ _"
;   ldx     #<@text_0_arg
;   lda     #>@text_0_arg
;   jsr     _IocsDrawString
    ; PSET(64, 32)
    ; PRINT#1, "safe が あるよ!"
    ldx     #<@text_1_arg
    lda     #>@text_1_arg
    jsr     _IocsDrawString
    ; GOSUB 7950
    jsr     Game_7950
    rts
@shape_arg:
    .byte   $03,  90,  70, 165, 155
    .byte   $03,  90,  70, 165, 155
    .byte   $02,  95,  75, 160, 150
;-  .byte   $04, 125,  73, 130, 153
    .byte   $03, 125,  73, 130, 153 ;+
    .byte   $02, 115, 100, 118, 110
    .byte   $02, 137, 100, 140, 110
    .byte   $02,  92,  67, 163,  70
    .byte   $01, 115,  95, 118,  95 ;+
    .byte   $01, 137,  95, 140,  95 ;+
    .byte   $00
@text_0_arg:
    .byte   17 + 1, 11
    .word   @text_0_string
@text_0_string:
    .byte   "_ _", $00
@text_1_arg:
    .byte   9 + 1, 5 ; 4
    .word   @text_1_string
@text_1_string:
    .byte   "SAFE ", hKA, _VM, " ", h_A, hRU, hYO, "!"
    .byte   $00
.endproc

; 4950 - 5020
.proc   Game_4950
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ; PSET(56, 32)
    ; PRINT#1, "かべの おくに へや が あるよ!"
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    ; GOSUB 7970
    jsr     Game_7970
    rts
@shape_arg:
    .byte   $04,  95, 151, 135, 155 ;+
    .byte   $03, 100, 110, 130, 150
    .byte   $01, 125, 150, 130, 150
    ; FOR J = 110 TO 145 STEP 5
    ;   A = A + 1
    ;   FOR I = 100 TO 115 STEP 10
    ;     IF A / 2 = INT(A / 2) THEN AA = 5
    ;     LINE(I + AA, J)-(I + 10 + AA, J + 5), 1, B
    ;   NEXT I
    ;   AA = 0
    ; NEXT J
    .byte   $02, 100 + 0, 110, 100 + 10 + 0, 110 + 5
    .byte   $02, 110 + 0, 110, 110 + 10 + 0, 110 + 5
    .byte   $02, 100 + 5, 115, 100 + 10 + 5, 115 + 5
    .byte   $02, 110 + 5, 115, 110 + 10 + 5, 115 + 5
    .byte   $02, 100 + 0, 120, 100 + 10 + 0, 120 + 5
    .byte   $02, 110 + 0, 120, 110 + 10 + 0, 120 + 5
    .byte   $02, 100 + 5, 125, 100 + 10 + 5, 125 + 5
    .byte   $02, 110 + 5, 125, 110 + 10 + 5, 125 + 5
    .byte   $02, 100 + 0, 130, 100 + 10 + 0, 130 + 5
    .byte   $02, 110 + 0, 130, 110 + 10 + 0, 130 + 5
    .byte   $02, 100 + 5, 135, 100 + 10 + 5, 135 + 5
    .byte   $02, 110 + 5, 135, 110 + 10 + 5, 135 + 5
    .byte   $02, 100 + 0, 140, 100 + 10 + 0, 140 + 5
    .byte   $02, 110 + 0, 140, 110 + 10 + 0, 140 + 5
    .byte   $02, 100 + 5, 145, 100 + 10 + 5, 145 + 5
    .byte   $02, 110 + 5, 145, 110 + 10 + 5, 145 + 5
    .byte   $00
@text_arg:
    .byte   8 + 1, 5 ; 4
    .word   @text_string
@text_string:
    .byte   hKA, hHE, _VM, hNO, " ", h_O, hKU, hNI, " ", hHE, hYA, " ", hKA, _VM, " ", h_A, hRU, hYO, "!"
    .byte   $00
.endproc

; 5030
.proc   Game_5030
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    rts
@shape_arg:
    .byte   $03, 106, 116, 119, 144
    .byte   $00
.endproc

; MYS22.BAS / 5050 - 5940
;

; 5050
.proc   Game_5050 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4050
    jsr     Game_4070
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5060
.proc   Game_5060 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5070
.proc   Game_5070 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4050
    jsr     Game_4070
    jsr     Game_3990
    jsr     Game_4030
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5080
.proc   Game_5080 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_3990
    jsr     Game_4030
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5090
.proc   Game_5090 
    jsr     Game_3900
    jsr     Game_3920
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_3990
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5100
.proc   Game_5100 
    jsr     Game_3900
    jsr     Game_3920
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_3990
    jsr     Game_4030
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5110
.proc   Game_5110 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4050
    jsr     Game_4070
    jsr     Game_3990
    rts
.endproc

; 5120
.proc   Game_5120 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4050
    jsr     Game_4060
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5130
.proc   Game_5130 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4050
    jsr     Game_4060
    jsr     Game_3990
    jsr     Game_4030
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5140
.proc   Game_5140 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4050
    jsr     Game_4060
    jsr     Game_3990
    rts
.endproc

; 5150 - 5160
.proc   Game_5150 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4090
    jsr     Game_4050
    jsr     Game_4060
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5170 - 5180
.proc   Game_5170 
    jsr     Game_3900
    jsr     Game_4130
    jsr     Game_3950
    jsr     Game_4150
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5190
.proc   Game_5190 
    jsr     Game_4130
    jsr     Game_3950
    jsr     Game_4800
    jsr     Game_3990
    rts
.endproc

; 5200 - 5210
.proc   Game_5200 
    jsr     Game_3900
    jsr     Game_3960
    jsr     Game_4050
    jsr     Game_4210
    jsr     Game_4230
    jsr     Game_4050
    jsr     Game_4270
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5220 - 5230
.proc   Game_5220 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4150
    jsr     Game_4060
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5240
.proc   Game_5240 
    jsr     Game_3900
    jsr     Game_4140
    jsr     Game_3940
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5250
.proc   Game_5250 
    jsr     Game_3900
    jsr     Game_4140
    jsr     Game_3940
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_3990
    jsr     Game_4030
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5260
.proc   Game_5260 
    jsr     Game_4140
    jsr     Game_3940
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_3990
    rts
.endproc

; 5270 - 5280
.proc   Game_5270 
    jsr     Game_3900
    jsr     Game_3960
    jsr     Game_4190
    jsr     Game_4060
    jsr     Game_4220
    jsr     Game_4280
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5290 - 5300
.proc   Game_5290 
    jsr     Game_3900
    jsr     Game_4140
    jsr     Game_3940
    jsr     Game_4330
    jsr     Game_4280
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5310
.proc   Game_5310 
    jsr     Game_4140
    jsr     Game_3940
    jsr     Game_4330
    jsr     Game_4280
    jsr     Game_3990
    rts
.endproc

; 5320
.proc   Game_5320 
    jsr     Game_3900
    jsr     Game_4130
    jsr     Game_3950
    jsr     Game_4310
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5330
.proc   Game_5330 
    jsr     Game_3900
    jsr     Game_4130
    jsr     Game_3950
    jsr     Game_4310
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_3990
    jsr     Game_4030
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5340
.proc   Game_5340 
    jsr     Game_4130
    jsr     Game_3950
    jsr     Game_4310
    jsr     Game_4000
    jsr     Game_3990
    rts
.endproc

; 5350 - 5360
.proc   Game_5350 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4370
    jsr     Game_4440
    jsr     Game_4050
    jsr     Game_4460
    jsr     Game_4310
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5370
.proc   Game_5370 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4370
    jsr     Game_4440
    jsr     Game_4050
    jsr     Game_4460
    jsr     Game_4310
    jsr     Game_3990
    rts
.endproc

; 5380
.proc   Game_5380 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4370
    jsr     Game_4440
    jsr     Game_4360
    jsr     Game_4050
    jsr     Game_4460
    jsr     Game_4310
    jsr     Game_3990
    rts
.endproc

; 5390 - 5400
.proc   Game_5390 
    lda     #$ff
    jsr     PRBYTE
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4330
    jsr     Game_4060
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5410
.proc   Game_5410 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4330
    jsr     Game_4060
    jsr     Game_3990
    rts
.endproc

; 5420
.proc   Game_5420 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4330
    jsr     Game_4060
    jsr     Game_3990
    rts
.endproc

; 5430
.proc   Game_5430 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4550
    jsr     Game_4280
    jsr     Game_4060
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5440
.proc   Game_5440 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4550
    jsr     Game_4280
    jsr     Game_4060
    jsr     Game_3990
    jsr     Game_4030
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5450
.proc   Game_5450 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4550
    jsr     Game_4280
    jsr     Game_4060
    jsr     Game_3990
    rts
.endproc

; 5460 - 5470
.proc   Game_5460 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4510
    jsr     Game_4310
    jsr     Game_4050
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5480
.proc   Game_5480 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4510
    jsr     Game_4310
    jsr     Game_4050
    jsr     Game_3990
    rts
.endproc

; 5490
.proc   Game_5490 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4530
    jsr     Game_4050
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5500
.proc   Game_5500 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4530
    jsr     Game_4050
    jsr     Game_3990
    jsr     Game_4030
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5510
.proc   Game_5510 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4530
    jsr     Game_4050
    jsr     Game_3990
    rts
.endproc

; 5520
.proc   Game_5520 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4060
    jsr     Game_4080
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5530
.proc   Game_5530 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4060
    jsr     Game_4080
    jsr     Game_3990
    jsr     Game_4030
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5540
.proc   Game_5540 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4060
    jsr     Game_4080
    jsr     Game_3990
    rts
.endproc

; 5550
.proc   Game_5550 
    jsr     Game_3900
    jsr     Game_4130
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4310
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5560
.proc   Game_5560 
    jsr     Game_3900
    jsr     Game_4130
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4310
    jsr     Game_3990
    jsr     Game_4030
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5570
.proc   Game_5570 
    jsr     Game_4130
    jsr     Game_3950
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4310
    jsr     Game_3990
    rts
.endproc

; 5580 - 5490
.proc   Game_5580 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4330
    jsr     Game_4070
    jsr     Game_4050
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5600
.proc   Game_5600 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4330
    jsr     Game_4070
    jsr     Game_4050
    jsr     Game_3990
    rts
.endproc

; 5610 - 5620
.proc   Game_5610 
    jsr     Game_3900
    jsr     Game_4140
    jsr     Game_3940
    jsr     Game_4590
    jsr     Game_4280
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5630 - 5640
.proc   Game_5630 
    jsr     Game_3900
    jsr     Game_3960
    jsr     Game_4080
    jsr     Game_4210
    jsr     Game_4240
    jsr     Game_4620
    jsr     Game_4060
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5650 - 5660
.proc   Game_5650 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4370
    jsr     Game_4630
    jsr     Game_4440
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5670
.proc   Game_5670 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4370
    jsr     Game_4630
    jsr     Game_4440
    jsr     Game_3990
    rts
.endproc

; 5680 - 5690
.proc   Game_5680 
    jsr     Game_3900
    jsr     Game_4140
    jsr     Game_3940
    jsr     Game_4510
    jsr     Game_4280
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5700
.proc   Game_5700 
    jsr     Game_4140
    jsr     Game_3940
    jsr     Game_4510
    jsr     Game_4280
    jsr     Game_3990
    rts
.endproc

; 5710 - 5720
.proc   Game_5710 
    jsr     Game_3900
    jsr     Game_4130
    jsr     Game_3950
    jsr     Game_4310
    jsr     Game_4650
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5730
.proc   Game_5730 
    jsr     Game_4130
    jsr     Game_3950
    jsr     Game_4310
    jsr     Game_3990
    rts
.endproc

; 5740 - 5750
.proc   Game_5740 
    jsr     Game_3900
    jsr     Game_3960
    jsr     Game_4220
    jsr     Game_4210
    jsr     Game_4680
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5760 - 5770
.proc   Game_5760 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4330
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5780
.proc   Game_5780 
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4330
    jsr     Game_3990
    rts
.endproc

; 5790 - 5800
.proc   Game_5790 
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4810
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5810 - 5820
.proc   Game_5810 
    jsr     Game_3900
    jsr     Game_4690
    jsr     Game_4710
    jsr     Game_4280
    jsr     Game_4740
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5830 - 5840
.proc   Game_5830 
    jsr     Game_3900
    jsr     Game_4690
    jsr     Game_4440
    jsr     Game_4460
    jsr     Game_4770
    jsr     Game_4740
    jsr     Game_4050
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5850
.proc   Game_5850
    jsr     Game_3900
    jsr     Game_4710
    ldx     #<@line_arg
    lda     #>@line_arg
    jsr     _LibDrawLine
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4740
    jsr     Game_4310
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@line_arg:
    .byte   40, 150, 220, 150
.endproc

; 5860
.proc   Game_5860
    jsr     Game_3900
    jsr     Game_4710
    ldx     #<@line_arg
    lda     #>@line_arg
    jsr     _LibDrawLine
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4740
    jsr     Game_4310
    jsr     Game_3990
    jsr     Game_4030
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@line_arg:
    .byte   40, 150, 220, 150
.endproc

; 5870
.proc   Game_5870
    jsr     Game_4710
    ldx     #<@line_arg
    lda     #>@line_arg
    jsr     _LibDrawLine
    jsr     Game_4000
    jsr     Game_4010
    jsr     Game_4740
    jsr     Game_4310
    jsr     Game_3990
    rts
@line_arg:
    .byte   40, 150, 220, 150
.endproc

; 5880 - 5890
.proc   Game_5880
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4650
    jsr     Game_3990
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5900 - 5910
.proc   Game_5900
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4900
    jsr     Game_3990
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5920 - 5930
.proc   Game_5920
    jsr     Game_3900
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4330
    jsr     Game_3990
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
.endproc

; 5940
.proc   Game_5940
    jsr     Game_3930
    jsr     Game_3940
    jsr     Game_3950
    jsr     Game_4330
    jsr     Game_3990
    rts
.endproc

; MYS22.BAS / 5950 - 6280
;

; 5950 - 5960
.proc   Game_5950
    jsr     Game_3900
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    jsr     Game_3990
    lda     #<Game_3530
    sta     APP_0_PROC_L
    lda     #>Game_3530
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@text_arg:
    .byte   5 + 1, 4
    .word   @text_string
@text_string:
    ; "まっくらで なにも みえません!"
    .byte   hMA, htu, hKU, hRA, hTE, _VM, " ", hNA, hNI, hMO, " ", hMI, h_E, hMA, hSE, h_N, "!"
    .byte   $00
.endproc

; 5970 - 6020
.proc   Game_5970
    jsr     Game_3900
;   jsr     Game_3910
    jsr     Game_4880
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    jsr     Game_7950
    ;; SPRITE$(16)=A2$(7)
    jsr     Game_3990
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@shape_arg:
    .byte   $02, 125, 80, 135, 120
    .byte   $01, 128, 80, 130,  78
    .byte   $01, 132, 80, 130,  78
    .byte   $01, 130, 78, 132,  73
    .byte   $00
@text_arg:
    .byte   10 + 1, 5 ; 4
    .word   @text_string
@text_string:
    ; "candle が あるよ !!!"
    .byte   "CANDLE ", hKA, _VM, " ", h_A, hRU, hYO, " !!!"
    .byte   $00
.endproc

; 6030 - 6050
.proc   Game_6030
    jsr     Game_3900
;   jsr     Game_3910
    jsr     Game_4880
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ldx     #<@text_0_arg
    lda     #>@text_0_arg
    jsr     _IocsDrawString
    ldx     #<@text_1_arg
    lda     #>@text_1_arg
    jsr     _IocsDrawString
    jsr     Game_7950
    jsr     Game_3990
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@shape_arg:
    .byte   $02, 100, 85, 165, 120
    .byte   $00
@text_0_arg:
    .byte   17 + 1, 12
    .word   @text_0_string
@text_0_string:
    ; "MATCH"
    .byte   "MATCH"
    .byte   $00
@text_1_arg:
    .byte   10 + 1, 5 ; 4
    .word   @text_1_string
@text_1_string:
    ; "match が あるよ!"
    .byte   "MATCH ", hKA, _VM, " ", h_A, hRU, hYO, "!"
    .byte   $00
.endproc

; 6060 - 6080
.proc   Game_6060
    jsr     Game_4360
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    jsr     Game_7950
    jsr     Game_3990
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@shape_arg:
    .byte   $02,  92, 127, 133, 143
    .byte   $03, 128, 133, 130, 138
    .byte   $00
@text_arg:
    .byte   10 + 1, 5 ; 4
    .word   @text_string
@text_string:
    ; "safe が あるよ!"
    .byte   "SAFE ", hKA, _VM, " ", h_A, hRU, hYO, "!"
    .byte   $00
.endproc

; 6090 - 6110
.proc   Game_6090
    jsr     Game_3900
;   jsr     Game_3910
    jsr     Game_4880
    ;; SPRITE$(9)=CHR$(0)+CHR$(0)+CHR$(&HE0)+CHR$(&H9F)+CHR$(&H9F)+CHR$(&HE3)+CHR$(0)+CHR$(0)
    ;; PUT SPRITE 9, (120, 80), 15
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    jsr     Game_7950
    jsr     Game_3990
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@shape_arg:
    .byte   $01, 120, 84, 125, 84
    .byte   $01, 120, 85, 125, 85
    .byte   $02, 120, 86, 121, 86
    .byte   $02, 120, 87, 121, 87
    .byte   $02, 120, 88, 121, 88
    .byte   $02, 120, 89, 121, 89
    .byte   $02, 120, 90, 125, 90
    .byte   $02, 120, 91, 125, 91
    .byte   $02, 126, 86, 135, 86
    .byte   $02, 126, 87, 135, 87
    .byte   $02, 126, 88, 135, 88
    .byte   $02, 126, 89, 135, 89
    .byte   $02, 132, 90, 135, 90
    .byte   $02, 132, 91, 135, 91
    .byte   $00
@text_arg:
    .byte   10 + 1, 5 ; 4
    .word   @text_string
@text_string:
    ; "key が あるよ!"
    .byte   "KEY ", hKA, _VM, " ", h_A, hRU, hYO, "!"
    .byte   $00
.endproc

; 6120 - 6140
.proc   Game_6120
    jsr     Game_3900
;   jsr     Game_3910
    jsr     Game_4880
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    jsr     Game_7950
    jsr     Game_3990
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@shape_arg:
    .byte   $02, 100, 90, 155,  95
    .byte   $03, 102, 80, 110, 105
    .byte   $00
@text_arg:
    .byte   10 + 1, 5 ; 4
    .word   @text_string
@text_string:
    ; "hammer が あるよ!"
    .byte   "HAMMER ", hKA, _VM, " ", h_A, hRU, hYO, "!"
    .byte   $00
.endproc

; 6150 - 6170
.proc   Game_6150
    jsr     Game_3900
;   jsr     Game_3910
    jsr     Game_4880
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    jsr     Game_7950
    jsr     Game_3990
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@shape_arg:
    .byte   $02, 100, 90, 170,  95
    .byte   $01, 110, 70, 110, 115
    .byte   $01, 105, 93, 110,  70
    .byte   $01, 105, 93, 110, 115
    .byte   $00
@text_arg:
    .byte   10 + 1, 5 ; 4
    .word   @text_string
@text_string:
    ; "pick が あるよ!"
    .byte   "PICK ", hKA, _VM, " ", h_A, hRU, hYO, "!"
    .byte   $00
.endproc

; 6190
.proc   Game_6190
    jsr     Game_3900
;   jsr     Game_3910
;   jsr     Game_4880
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    jsr     Game_7950
    jsr     Game_3990
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@shape_arg:
    .byte   $03, 100, 90, 180, 140
    .byte   $00
@text_arg:
    .byte   9 + 1, 5 ; 4
    .word   @text_string
@text_string:
    ; "memo が あるよ!"
    .byte   "MEMO ", hKA, _VM, " ", h_A, hRU, hYO, "!"
    .byte   $00
.endproc

; 6200 - 6280
.proc   Game_6200
    jsr     Game_3890
    lda     #1
    sta     user + User::DI
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    jsr     Game_7980
    jsr     Game_3990
    lda     #<Game_3550
    sta     APP_0_PROC_L
    lda     #>Game_3550
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@shape_arg:
    .byte   $01, 125, 125,  75, 75
    .byte   $01, 125, 125, 100, 75
    .byte   $01, 125, 125, 125, 75
    .byte   $01, 125, 125, 155, 75
    .byte   $01, 125, 125, 175, 75
    .byte   $01, 100,  50,  75, 75
    .byte   $01, 100,  50, 100, 75
    .byte   $01, 100,  50, 125, 75
    .byte   $01, 150,  50, 125, 75
;   .byte   $01,  75,  75, 175, 75
    .byte   $01, 150,  50, 150, 75
;   .byte   $01,  75,  75, 175, 75
    .byte   $01, 150,  50, 175, 75
    .byte   $01,  75,  75, 175, 75
    .byte   $01, 100,  50, 150, 50
    .byte   $00
@text_arg:
    .byte   10 + 1, 3
    .word   @text_string
@text_string:
    ; "ダイヤモンド が ありました。"
    .byte   kTA, _VM, k_I, kYA, kMO, k_N, kTO, _VM, " ", hKA, _VM, " ", h_A, hRI, hMA, hSI, hTA
    .byte   $00
.endproc

; MYS22.BAS / 6300 - 6430
;

; 6300 - 6310
.proc   Game_6300
    ldx     #<@text_string
    lda     #>@text_string
    jmp     Game_6420
@text_string:
    ; "   あなた は ベランダ から おちて"
    ; "   しにました......"
    .byte   "   ", h_A, hNA, hTA, " ", hHA, " ", kHE, _VM, kRA, k_N, kTA, _VM, " ", hKA, hRA, " ", h_O, hTI, hTE, "\n"
    .byte   "   ", hSI, hNI, hMA, hSI, hTA, "......"
    .byte   $00
.endproc

; 6360 - 6380
.proc   Game_6360
    ldx     #<@text_string
    lda     #>@text_string
    jmp     Game_6420
@text_string:
    ; "   あなた は rack に あたまを ぶつけて"
    ; "   しにました......"
    .byte   "   ", h_A, hNA, hTA, " ", hHA, " RACK ", hNI, " ", h_A, hTA, hMA, hWO, " ", hHU, _VM, hTU, hKE, hTE, "\n"
    .byte   "   ", hSI, hNI, hMA, hSI, hTA, "......"
    .byte   $00
.endproc

; 6390 - 6410
.proc   Game_6390
    ldx     #<@text_string
    lda     #>@text_string
    jmp     Game_6420
@text_string:
    ; "   あなた は そとに でて くるま に ひかれ"
    ; "   しにました......"
    .byte   "   ", h_A, hNA, hTA, " ", hHA, " ", hSO, hTO, hNI, " ", hTE, _VM, hTE, " ", hKU, hRU, hMA, " ", hNI, " ", hHI, hKA, hRE, "\n"
    .byte   "   ", hSI, hNI, hMA, hSI, hTA, "......"
    .byte   $00
.endproc

; 6420 - 6430
.proc   Game_6420
    stx     @text_arg + $0002
    sta     @text_arg + $0003
    jsr     _IocsClearVram
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString
    lda     #<Game_6320
    sta     APP_0_PROC_L
    lda     #>Game_6320
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE
    rts
@text_arg:
    .byte   1, 10
    .word   $0000
.endproc

; 6320 - 6350
.proc   Game_6320

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized

    ; GAME OVER の描画
    ldx     #<@over_arg
    lda     #>@over_arg
    jsr     _IocsDrawString

    ; BEEP の再生
    jsr     Game_7960

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE
    beq     @end

    ; 処理の設定
    lda     #<_TitleEntry
    sta     APP_0_PROC_L
    lda     #>_TitleEntry
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; GAME_OVER
@over_arg:
    .byte   8 + 1, 14
    .word   @over_string
@over_string:
    .byte   "GAME OVER !\n"
    .byte   "\n"
    .byte   "HIT ANY KEY!"
    .byte   $00

.endproc

; MYS22.BAS / 6440 - 6510
;
.proc   Game_6440

    ; 画面のクリア
    jsr     _IocsClearVram

    ; テキストの描画
    ldx     #<@text_0_arg
    lda     #>@text_0_arg
    jsr     _IocsDrawString
    ldx     #<@text_1_arg
    lda     #>@text_1_arg
    jsr     _IocsDrawString
    ldx     #<@text_2_arg
    lda     #>@text_2_arg
    jsr     _IocsDrawString
    ldx     #<@text_3_arg
    lda     #>@text_3_arg
    jsr     _IocsDrawString
    ldx     #<@text_4_arg
    lda     #>@text_4_arg
    jsr     _IocsDrawString
    ldx     #<@text_5_arg
    lda     #>@text_5_arg
    jsr     _IocsDrawString

    ; BEEP の再生
    ldx     #_O5A
    lda     #_L32
    jsr     _IocsBeepNote

    ; 処理の設定
    lda     #<Game_7430
    sta     APP_0_PROC_L
    lda     #>Game_7430
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; "VERY  GOOD !!! "
@text_0_arg:
    .byte   11 + 1, 2
    .word   @text_0_string
@text_0_string:
    .byte   "VERY  GOOD !!!"
    .byte   $00
; "GAME OVER"
@text_1_arg:
    .byte   13 + 1, 4
    .word   @text_1_string
@text_1_string:
    .byte   "GAME  OVER"
    .byte   $00
; "あなたは 大金もちに  なりました 。"
@text_2_arg:
    .byte   9 + 1, 6
    .word   @text_2_string
@text_2_string:
    .byte   h_A, hNA, hTA, hHA, " ", $1d, $05, hMO, hTI, hNI, "  ", hNA, hRI, hMA, hSI, hTA, " ", _PR
    .byte   $00
; "せいさく...."
@text_3_arg:
    .byte   2 + 1, 21
    .word   @text_3_string
@text_3_string:
    .byte   hSE, h_I, hSA, hKU, "...."
    .byte   $00
; "せかい の ｱﾄﾞﾍﾞﾝﾁｬ- GAME を ﾘ-ﾄﾞする"
@text_4_arg:
    .byte   3 + 1, 22
    .word   @text_4_string
@text_4_string:
    .byte   hSE, hKA, h_I, " ", hNO, " ", k_A, kTO, _VM, kHE, _VM, k_N, kTI, kya, _HF, " GAME ", hWO, " ", kRI, _HF, kTO, _VM, hSU, hRU
    .byte   $00
; " MICRO CABIN "
@text_5_arg:
    .byte   11 + 1, 23
    .word   @text_5_string
@text_5_string:
    .byte   "MICRO CABIN"
    .byte   $00
.endproc

; 6520 - 6530
.proc Game_6520
    ; IF F1=1 THEN 6060
    lda     game + Game::F1
    cmp     #1
    bne     :+
    jmp     Game_6060
:
    rts
.endproc

; MYS22.BAS / 6540 - 
.proc   Game_6540

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized

    ; VRAM のクリア
    jsr     _IocsClearVram

    ; 図形の描画
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes

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
    lda     #<_TitleEntry
    sta     APP_0_PROC_L
    lda     #>_TitleEntry
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; お化け
@shape_arg:
    ; DATA.BIN / &H1C00
    .byte   $01, $24 + 100, $0a + 30, $1e + 100, $0f + 30   ;, $0f
    .byte   $01, $1e + 100, $0f + 30, $1b + 100, $14 + 30   ;, $0f
    .byte   $01, $1b + 100, $14 + 30, $16 + 100, $1e + 30   ;, $0f
    .byte   $01, $16 + 100, $1e + 30, $13 + 100, $28 + 30   ;, $0f
    .byte   $01, $13 + 100, $28 + 30, $11 + 100, $32 + 30   ;, $0f
    .byte   $01, $11 + 100, $32 + 30, $10 + 100, $3c + 30   ;, $0f
    .byte   $01, $10 + 100, $3c + 30, $11 + 100, $42 + 30   ;, $0f
    .byte   $01, $23 + 100, $4b + 30, $1e + 100, $44 + 30   ;, $0f
    .byte   $01, $1e + 100, $44 + 30, $14 + 100, $41 + 30   ;, $0f
    .byte   $01, $14 + 100, $41 + 30, $11 + 100, $42 + 30   ;, $0f
    .byte   $01, $11 + 100, $42 + 30, $0c + 100, $46 + 30   ;, $0f
    .byte   $01, $0c + 100, $46 + 30, $09 + 100, $50 + 30   ;, $0f
    .byte   $01, $09 + 100, $50 + 30, $08 + 100, $5a + 30   ;, $0f
    .byte   $01, $08 + 100, $5a + 30, $0a + 100, $61 + 30   ;, $0f
    .byte   $01, $0a + 100, $61 + 30, $0c + 100, $64 + 30   ;, $0f
    .byte   $01, $0c + 100, $64 + 30, $0f + 100, $64 + 30   ;, $0f
    .byte   $01, $0f + 100, $64 + 30, $11 + 100, $5d + 30   ;, $0f
    .byte   $01, $11 + 100, $5d + 30, $14 + 100, $59 + 30   ;, $0f
    .byte   $01, $14 + 100, $59 + 30, $17 + 100, $5a + 30   ;, $0f
    .byte   $01, $17 + 100, $5a + 30, $19 + 100, $5e + 30   ;, $0f
    .byte   $01, $19 + 100, $5e + 30, $1a + 100, $6e + 30   ;, $0f
    .byte   $01, $1a + 100, $6e + 30, $1b + 100, $82 + 30   ;, $0f
    .byte   $01, $1b + 100, $82 + 30, $1e + 100, $87 + 30   ;, $0f
    .byte   $01, $1e + 100, $87 + 30, $28 + 100, $8c + 30   ;, $0f
    .byte   $01, $28 + 100, $8c + 30, $50 + 100, $90 + 30   ;, $0f
    .byte   $01, $50 + 100, $90 + 30, $62 + 100, $8c + 30   ;, $0f
    .byte   $01, $62 + 100, $8c + 30, $76 + 100, $7d + 30   ;, $0f
    .byte   $01, $76 + 100, $7d + 30, $64 + 100, $7f + 30   ;, $0f
    .byte   $01, $64 + 100, $7f + 30, $5e + 100, $7d + 30   ;, $0f
    .byte   $01, $5e + 100, $7d + 30, $5a + 100, $7b + 30   ;, $0f
    .byte   $01, $5a + 100, $7b + 30, $56 + 100, $78 + 30   ;, $0f
    .byte   $01, $56 + 100, $78 + 30, $50 + 100, $70 + 30   ;, $0f
    .byte   $01, $50 + 100, $70 + 30, $4d + 100, $64 + 30   ;, $0f
    .byte   $01, $4d + 100, $64 + 30, $4e + 100, $46 + 30   ;, $0f
    .byte   $01, $4e + 100, $46 + 30, $4b + 100, $32 + 30   ;, $0f
    .byte   $01, $4b + 100, $32 + 30, $46 + 100, $23 + 30   ;, $0f
    .byte   $01, $46 + 100, $23 + 30, $3f + 100, $14 + 30   ;, $0f
    .byte   $01, $3f + 100, $14 + 30, $3c + 100, $10 + 30   ;, $0f
    .byte   $01, $3c + 100, $10 + 30, $35 + 100, $0a + 30   ;, $0f
    .byte   $01, $35 + 100, $0a + 30, $30 + 100, $09 + 30   ;, $0f
    .byte   $01, $30 + 100, $09 + 30, $35 + 100, $08 + 30   ;, $0f
    .byte   $01, $35 + 100, $08 + 30, $24 + 100, $0a + 30   ;, $0f
    ; DATA.BIN / &H1D00
    .byte   $01, $3c + 100, $4e + 30, $32 + 100, $47 + 30   ;, $01
    .byte   $01, $32 + 100, $47 + 30, $2d + 100, $47 + 30   ;, $01
    .byte   $01, $2d + 100, $47 + 30, $28 + 100, $4b + 30   ;, $01
    .byte   $01, $28 + 100, $4b + 30, $25 + 100, $50 + 30   ;, $01
    .byte   $01, $25 + 100, $50 + 30, $26 + 100, $5a + 30   ;, $01
    .byte   $01, $26 + 100, $5a + 30, $27 + 100, $64 + 30   ;, $01
    .byte   $01, $27 + 100, $64 + 30, $29 + 100, $66 + 30   ;, $01
    .byte   $01, $29 + 100, $66 + 30, $2c + 100, $64 + 30   ;, $01
    .byte   $01, $2c + 100, $64 + 30, $30 + 100, $61 + 30   ;, $01
    .byte   $01, $30 + 100, $61 + 30, $33 + 100, $64 + 30   ;, $01
    .byte   $01, $33 + 100, $64 + 30, $38 + 100, $6e + 30   ;, $01
    .byte   $01, $38 + 100, $6e + 30, $3c + 100, $72 + 30   ;, $01
    .byte   $01, $3c + 100, $72 + 30, $46 + 100, $77 + 30   ;, $01
    ; DATA.BIN / &H1D80
    .byte   $01, $1a + 100, $2b + 30, $1f + 100, $31 + 30   ;, $08
    .byte   $01, $1f + 100, $31 + 30, $24 + 100, $33 + 30   ;, $08
    .byte   $01, $24 + 100, $33 + 30, $28 + 100, $34 + 30   ;, $08
    .byte   $01, $28 + 100, $34 + 30, $2d + 100, $33 + 30   ;, $08
    .byte   $01, $2d + 100, $33 + 30, $32 + 100, $32 + 30   ;, $08
    .byte   $01, $32 + 100, $32 + 30, $37 + 100, $2f + 30   ;, $08
    .byte   $01, $1f + 100, $31 + 30, $1f + 100, $3a + 30   ;, $08
    .byte   $01, $1f + 100, $3a + 30, $21 + 100, $40 + 30   ;, $08
    .byte   $01, $21 + 100, $40 + 30, $25 + 100, $44 + 30   ;, $08
    .byte   $01, $25 + 100, $44 + 30, $28 + 100, $45 + 30   ;, $08
    .byte   $01, $28 + 100, $45 + 30, $2b + 100, $43 + 30   ;, $08
    .byte   $01, $2b + 100, $43 + 30, $2e + 100, $3d + 30   ;, $08
    .byte   $01, $2e + 100, $3d + 30, $32 + 100, $32 + 30   ;, $08
    ; DATA 40,52,39,60,1,39,60,40,66,1
    .byte   $01, 40 + 100, 52 + 30, 39 + 100, 60 + 30   ;, 1
    .byte   $01, 39 + 100, 60 + 30, 40 + 100, 66 + 30   ;, 1
    ; CIRCLE(40+L,33+M),10,1,,,2
;   .byte   $05, 40 + 100, 33 + 30, 10
    .byte   $01, 40 + 100 - 1, 33 + 30 - 10, 40 + 100 - 3, 33 + 30 - 8
    .byte   $01, 40 + 100 + 0, 33 + 30 - 10, 40 + 100 + 2, 33 + 30 - 8
    .byte   $01, 40 + 100 - 4, 33 + 30 -  7, 40 + 100 - 4, 33 + 30 - 5
    .byte   $01, 40 + 100 + 3, 33 + 30 -  7, 40 + 100 + 3, 33 + 30 - 5
    .byte   $01, 40 + 100 - 5, 33 + 30 -  4, 40 + 100 - 5, 33 + 30 + 3
    .byte   $01, 40 + 100 + 4, 33 + 30 -  4, 40 + 100 + 4, 33 + 30 + 3
    .byte   $01, 40 + 100 - 4, 33 + 30 +  4, 40 + 100 - 4, 33 + 30 + 6
    .byte   $01, 40 + 100 + 3, 33 + 30 +  4, 40 + 100 + 3, 33 + 30 + 6
    .byte   $01, 40 + 100 - 3, 33 + 30 +  7, 40 + 100 - 1, 33 + 30 + 9
    .byte   $01, 40 + 100 + 2, 33 + 30 +  7, 40 + 100 + 0, 33 + 30 + 9
    ; CIRCLE(40+L,33+M),3,15
    .byte   $05, 40 + 100, 33 + 30, 3
    .byte   $00

; MYSSP0.BIN
;
; 00011100 00000000
; 00111000 00000000
; 01111000 00000000
; 11111110 00000000
; 11111111 00000000
; 11111111 00000000
; 01111100 00000000
; 00111100 00000000
;
; 00000000 00000000
; 00000000 00000000
; 00000000 00000000
; 00000000 00000000
; 00000000 00000000
; 00000000 00000000
; 00000000 00000000
; 00000000 00000000

; "あなた は"
; "ゆうれいに のろわれて "
; "しにました。"
; "GAME END"
@text_0_arg:

    .byte   4 + 1, 3
    .word   @text_0_string

@text_0_string:

    .byte   " ", h_A, hNA, hTA, " ", hHA, "\n"
    .byte   "\n"
    .byte   "\n"
    .byte   "\n"
    .byte   hYU, h_U, hRE, h_I, hNI, " ", hNO, hRO, hWA, hRE, hTE, "\n"
    .byte   "\n"
    .byte   "\n"
    .byte   "\n"
    .byte   "  ", hSI, hNI, hMA, hSI, hTA, _PR, "\n"
    .byte   "\n"
    .byte   "\n"
    .byte   "\n"
    .byte   "\n"
    .byte   "  GAME END"
    .byte   $00

; "Hit ant key !"
@text_1_arg:

    .byte   13, 22
    .word   @text_1_string

@text_1_string:

    .byte   "Hit any key !"
    .byte   $00

.endproc

; MYS22.BAS / 7230 - 7280
;
.proc   Game_7230

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized

    ; VRAM のクリア
    jsr     _IocsClearVram

    ; テキストの描画
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE
    beq     @end
    cmp     #'Z'
    bne     :+
    ldx     #<Game_7290
    lda     #>Game_7290
    jmp     @goto
:
    lda     #$00
    sta     game + Game::AD
    ldx     #<Game_1560
    lda     #>Game_1560

    ; 処理の設定
@goto:
    stx     APP_0_PROC_L
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; "いまから GAME DATA を "
; "セーブ してもいいですか ?"
; "よければ Z キー を  "
; "セーブしないのなら なにか ほかの キー を  "
; "おしてください。"
@text_arg:

    .byte   3 + 1, 8
    .word   @text_string

@text_string:

    .byte   h_I, hMA, hKA, hRA, " GAME DATA ", hWO, "\n"
    .byte   "\n"
    .byte   kSE, _HF, kHU, _VM, " ", hSI, hTE, hMO, h_I, h_I, hTE, _VM, hSU, hKA, " ?\n"
    .byte   "\n"
    .byte   hYO, hRO, hSI, hKE, hRE, hHA, _VM, " Z ", kKI, _HF, " ", hWO, "\n"
    .byte   "\n"
    .byte   kSE, _HF, kHU, _VM, hSI, hNA, h_I, hNO, hNA, hRA, " ", hNA, hNI, hKA, " ", hHO, hKA, hNO, " ", kKI, _HF, " ", hWO, "\n"
    .byte   h_O, hSI, hTE, hKU, hTA, _VM, hSA, h_I, _PR
    .byte   $00

.endproc

; MYS22.BAS / 7290 - 7360
;
.proc   Game_7290

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized

    ; VRAM のクリア
    jsr     _IocsClearVram

    ; テキストの描画
    ldx     #<@text_arg
    lda     #>@text_arg
    jsr     _IocsDrawString

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE
    beq     @end

    ; user のファイルへの書き込み
    ldx     #<@file_arg
    lda     #>@file_arg
    jsr     _IocsBsave

    ; OK の表示
    ldx     #<@ok_string
    lda     #>@ok_string
    jsr     _LibPrintTextString

    ; どうする？のクリア
    lda     #$00
    sta     game + Game::AD

    ; 処理の設定
    lda     #<Game_1560
    sta     APP_0_PROC_L
    lda     #>Game_1560
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; "TAPE の じゅんび はできましたか ?"
; "できたら なにか キー を おして ください。"
@text_arg:

    .byte   3 + 1, 10
    .word   @text_string

@text_string:
    .byte   "DISK ", hNO, " ", hSI, _VM, hyu, h_N, hHI, _VM, " ", hHA, hTE, _VM, hKI, hMA, hSI, hTA, hKA, " ?\n"
    .byte   "\n"
    .byte   hTE, _VM, hKI, hTA, hRA, " ", hNA, hNI, hKA, " ", kKI, _HF, " ", hWO, " ", h_O, hSI, hTE, " ", hKU, hTA, _VM, hSA, h_I, _PR
    .byte  $00

; ファイル
@file_arg:

    .word   @file_name
    .word   user
    .word   .sizeof(User)

@file_name:

    .asciiz "MYSDAT"

; OK
@ok_string:

    .byte   "\n"
    .byte   " OK"
    .byte   $00

.endproc

; MYS22.BAS / 7430 - 7880
;
.proc   Game_7430

    ; 初期化
    lda     APP_0_STATE
    bne     @initialized

    ; 図形の描画
    ldx     #<@shape_arg
    lda     #>@shape_arg
    jsr     _LibDrawShapes

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE
    beq     @end

    ; 処理の設定
    lda     #<Game_7890
    sta     APP_0_PROC_L
    lda     #>Game_7890
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; MYSSP1.BIN
; 95       111               127           143      159
; 00000001 00000000 01111111 11111111 00000001 00000000 80
; 00000011 10000000 01111111 11111111 00000011 10000000
; 00000011 10000000 00111111 11111110 00000011 10000000
; 00000111 11000000 00111111 11111110 00000111 11000000
; 00000111 11000000 00111111 11111110 00000111 11000000
; 00001111 11100000 00011111 11111100 00001111 11100000
; 00001111 11100000 00011111 11111100 00001111 11100000
; 00011111 11110000 00001111 11111000 00011111 11110000
; 
; 00011111 11110000 00001111 11111000 00011111 11110000
; 00111111 11111000 00000111 11110000 00111111 11111000
; 00111111 11111000 00000111 11110000 00111111 11111000
; 01111111 11111100 00000011 11100000 01111111 11111100
; 01111111 11111100 00000011 11100000 01111111 11111100
; 01111111 11111100 00000001 11000000 01111111 11111100
; 11111111 11111110 00000001 11000000 11111111 11111110
; 11111111 11111110 00000000 10000000 11111111 11111110
; 
; 11111111 00000000 01111111 11111110 00000000 11111111 112
; 01111111 10000000 00111111 11111100 00000001 11111110
; 00111111 10000000 00111111 11111100 00000001 11111100
; 00011111 11000000 00011111 11111000 00000011 11111000
; 00011111 11000000 00011111 11111000 00000011 11111000
; 00001111 11100000 00001111 11110000 00000111 11110000
; 00000111 11100000 00001111 11110000 00000111 11100000
; 00000011 11110000 00000111 11100000 00001111 11000000

; 00000001 11110000 00000111 11100000 00001111 10000000
; 00000000 11111000 00000011 11000000 00011111 10000000
; 00000000 11111000 00000011 11000000 00011111 00000000
; 00000000 01111100 00000011 11000000 00111110 00000000
; 00000000 00111100 00000001 10000000 00111100 00000000
; 00000000 00011110 00000001 10000000 01111000 00000000
; 00000000 00001110 00000001 10000000 01111000 00000000
; 00000000 00000111 00000001 10000000 11100000 00000000 143

; 図形
@shape_arg:

    .byte   $01, 111,  80,  95, 112
    .byte   $01, 111,  80, 127, 112
    .byte   $01, 143,  80, 159, 112
    .byte   $01, 143,  80, 127, 112
    .byte   $01,  95, 112, 127, 143
    .byte   $01, 111, 112, 127, 143
    .byte   $01, 143, 112, 127, 143
    .byte   $01, 159, 112, 127, 143
    .byte   $01, 111,  80, 143,  80
    .byte   $01,  95, 112, 159, 112
    .byte   $00

.endproc

; MYS22.BAS / 7890 - 7940
;
.proc   Game_7890

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
    ldx     #<@text_2_arg
    lda     #>@text_2_arg
    jsr     _IocsDrawString

    ; 初期化の完了
    inc     APP_0_STATE
@initialized:

    ; キー入力
    lda     IOCS_0_KEYCODE
    beq     @end

    lda     #<Game_6440
    sta     APP_0_PROC_L
    lda     #>Game_6440
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

    ; 終了
@end:
    rts

; "ﾀﾞｲﾔﾓﾝﾄﾞｱﾄﾞへﾞﾝﾁｬ-"
@text_0_arg:

    .byte   7 + 1, 6
    .word   @text_0_string

@text_0_string:

    .byte   kTA, _VM, k_I, kYA, kMO, k_N, kTO, _VM, k_A, kTO, _VM, kHE, _VM, k_N, kTI, kya, _HF
    .byte   $00

; " も おもしろいよ!!!"
@text_1_arg:

    .byte   16 + 1, 9
    .word   @text_1_string

@text_1_string:

    .byte   " ", hMO, " ", h_O, hMO, hSI, hRO, h_I, hYO, "!!!"
    .byte   $00

; "♥♥♥♥♥♥♥♥♥♥♥♥♥"
; "♥HIT ANY KEY♥"
; "♥♥♥♥♥♥♥♥♥♥♥♥♥"
@text_2_arg:

    .byte   9 + 1, 14
    .word   @text_2_string

@text_2_string:

    .byte   hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, "\n"
    .byte   hHT, "HIT ANY KEY", hHT, "\n"
    .byte   hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, hHT, "\n"
    .byte   $00

.endproc

; MYS22.BAS / 7950 - 7980
;

; 7950
.proc   Game_7950
    ldx     #<@beep_arg
    lda     #>@beep_arg
    jsr     _IocsBeepScore
    rts
@beep_arg:
    ; "T240L10O4D8R64D8R64D8R64D8R64O3B4"
    .byte   _O4D, _L16
    .byte   _R,   _L128
    .byte   _O4D, _L16
    .byte   _R,   _L128
    .byte   _O4D, _L16
    .byte   _R,   _L128
    .byte   _O4D, _L16
    .byte   _R,   _L128
    .byte   _O3B, _L8
    .byte   IOCS_BEEP_END
.endproc

; 7960
.proc   Game_7960
    ldx     #<@beep_arg
    lda     #>@beep_arg
    jsr     _IocsBeepScore
    rts
@beep_arg:
    ; "T220O4L8AGFEGFEDEDC+4D4"
    .byte   _O4A,  _L16
    .byte   _O4G,  _L16
    .byte   _O4F,  _L16
    .byte   _O4E,  _L16
    .byte   _O4G,  _L16
    .byte   _O4F,  _L16
    .byte   _O4E,  _L16
    .byte   _O4D,  _L16
    .byte   _O4E,  _L16
    .byte   _O4D,  _L16
    .byte   _O4Cp, _L8
    .byte   _O4D,  _L8
    .byte   IOCS_BEEP_END
.endproc

; 7970
.proc   Game_7970
    ldx     #<@beep_arg
    lda     #>@beep_arg
    jsr     _IocsBeepScore
    rts
@beep_arg:
    ; "O4T200L8EFF+GG+AA+BL4O5C"
    .byte   _O4E,  _L16
    .byte   _O4F,  _L16
    .byte   _O4Fp, _L16
    .byte   _O4G,  _L16
    .byte   _O4Gp, _L16
    .byte   _O4A,  _L16
    .byte   _O4Ap, _L16
    .byte   _O4B,  _L16
    .byte   _O5C,  _L8
    .byte   IOCS_BEEP_END
.endproc

; 7980
.proc   Game_7980
    ldx     #<@beep_arg
    lda     #>@beep_arg
    jsr     _IocsBeepScore
    rts
@beep_arg:
    ; "O3L4AO3L8A+O3L8B+"
    ; "O4L4CO4L8CO4L8D"
    ; "O4L4F+O4L8GO4L8G+"
    .byte   _O4Fp, _L8
    .byte   _O4G,  _L16
    .byte   _O4Gp, _L16
    .byte   IOCS_BEEP_END
.endproc

; どうする？の文字列を比較する
;
.proc   GameCmpAv

    ; IN
    ;   ax = 文字列
    ; OUT
    ;   cf = 1: 一致, 0: 不一致
    ; WORK
    ;   APP_0_WORK_0..3

    ; 文字列の取得
    stx     APP_0_WORK_0
    sta     APP_0_WORK_1
    lda     #<(game + Game::AV)
    sta     APP_0_WORK_2
    lda     #>(game + Game::AV)
    sta     APP_0_WORK_3

    ; 3 文字の比較
    ldy     #$00
    lda     (APP_0_WORK_0), y
    cmp     (APP_0_WORK_2), y
    bne     @error
    iny
    lda     (APP_0_WORK_0), y
    cmp     (APP_0_WORK_2), y
    bne     @error
    iny
    lda     (APP_0_WORK_0), y
    cmp     (APP_0_WORK_2), y
    bne     @error

    ; 一致
    sec
    rts

    ; 不一致
@error:
    clc
    rts

.endproc

; なにを？の文字列を比較する
;
.proc   GameCmpPn

    ; IN
    ;   ax = 文字列
    ; OUT
    ;   cf = 1: 一致, 0: 不一致
    ; WORK
    ;   APP_0_WORK_0..3

    ; 文字列の取得
    stx     APP_0_WORK_0
    sta     APP_0_WORK_1
    lda     #<(game + Game::PN)
    sta     APP_0_WORK_2
    lda     #>(game + Game::PN)
    sta     APP_0_WORK_3

    ; 3 文字の比較
    ldy     #$00
    lda     (APP_0_WORK_0), y
    cmp     (APP_0_WORK_2), y
    bne     @error
    iny
    lda     (APP_0_WORK_0), y
    cmp     (APP_0_WORK_2), y
    bne     @error
    iny
    lda     (APP_0_WORK_0), y
    cmp     (APP_0_WORK_2), y
    bne     @error

    ; 一致
    sec
    rts

    ; 不一致
@error:
    clc
    rts

.endproc

; ユーザーを表示する
;
.proc   GamePrintUser

    ; 改行
    jsr     CROUT1

    ; CA
    lda     #'C' + $80
    jsr     COUT1
    lda     user + User::CA
    jsr     PRBYTE
    lda     #' ' + $80
    jsr     COUT1
    
    ; MA
    lda     #'M' + $80
    jsr     COUT1
    lda     user + User::MA
    jsr     PRBYTE
    lda     #' ' + $80
    jsr     COUT1
    
    ; HA
    lda     #'H' + $80
    jsr     COUT1
    lda     user + User::HA
    jsr     PRBYTE
    lda     #' ' + $80
    jsr     COUT1
    
    ; PI
    lda     #'P' + $80
    jsr     COUT1
    lda     user + User::PI
    jsr     PRBYTE
    lda     #' ' + $80
    jsr     COUT1

    ; K1
    lda     #'K' + $80
    jsr     COUT1
    lda     user + User::K1
    jsr     PRBYTE
    lda     #' ' + $80
    jsr     COUT1
    
     ; K2
    lda     #'K' + $80
    jsr     COUT1
    lda     user + User::K2
    jsr     PRBYTE
    lda     #' ' + $80
    jsr     COUT1
    
    ; ME
    lda     #'M' + $80
    jsr     COUT1
    lda     user + User::ME
    jsr     PRBYTE
    lda     #' ' + $80
    jsr     COUT1
    
    ; DI
    lda     #'D' + $80
    jsr     COUT1
    lda     user + User::DI
    jsr     PRBYTE
    lda     #' ' + $80
    jsr     COUT1
    
    ; S1
    lda     #'S' + $80
    jsr     COUT1
    lda     user + User::S1
    jsr     PRBYTE
    lda     #' ' + $80
    jsr     COUT1
    
    ; S2
    lda     #'S' + $80
    jsr     COUT1
    lda     user + User::S2
    jsr     PRBYTE
    lda     #' ' + $80
    jsr     COUT1

    ; RA
    lda     #'R' + $80
    jsr     COUT1
    lda     game + Game::RA
    jsr     PRBYTE
    lda     game + Game::RB
    jsr     PRBYTE
    lda     game + Game::RC
    jsr     PRBYTE
    lda     game + Game::RD
    jsr     PRBYTE
    lda     game + Game::RE
    jsr     PRBYTE
    lda     game + Game::RF
    jsr     PRBYTE
    lda     game + Game::RG
    jsr     PRBYTE
    lda     game + Game::RH
    jsr     PRBYTE
    
    ; 終了
    rts

.endproc


; データの定義
;
.segment    "BSS"

; ゲーム情報
;
.global game
game:

    .tag    Game

; ユーザーデータ
;
.global user
user:

    .tag    User

