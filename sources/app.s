; app.s - アプリケーション
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


; コードの定義
;
.segment    "APP"

; アプリケーションのエントリポイント
;
.proc   AppEntry

    ; アプリケーションの初期化

    ; VRAM のクリア
    jsr     _IocsClearVram

    ; 画面モードの設定
    sta     HIRES
    sta     LOWSCR
    sta     MIXCLR
    sta     TXTCLR

    ; ゼロページのクリア
    ldy     #APP_0
    lda     #$00
:
    sta     $00, y
    iny
    bne     :-

    ; 処理の設定
    lda     #<_TitleEntry
    sta     APP_0_PROC_L
    lda     #>_TitleEntry
    sta     APP_0_PROC_H
    lda     #$00
    sta     APP_0_STATE

.endproc

; アプリケーションを更新する
;
.proc   AppUpdate

    ; 処理の繰り返し
@loop:

    ; IOCS の更新
    jsr     _IocsUpdate

    ; 処理の実行
    lda     #>(:+ - $0001)
    pha
    lda     #<(:+ - $0001)
    pha
    jmp     (APP_0_PROC)
:

;   ; デバッグ
;   lda     IOCS_0_KEYCODE
;   cmp     #$1b    ; ESC
;   bne     :++
;   lda     @debug
;   beq     :+
;   sta     MIXCLR
;   dec     @debug
;   jmp     :++
;:
;   sta     MIXSET
;   inc     @debug
;:

    ; ループ
    jmp     @loop

; デバッグ
@debug:

    .byte   $00

.endproc


; データの定義
;
.segment    "BSS"

