; game.inc - ゲーム / MYS22.BAS
; 


; ゼロページ
;
GAME_0                              :=  APP_0_USER
GAME_0_INKEY                        :=  GAME_0 + $00

; 文字入力
;
GAME_INKEY_SIZE                     =   $10

; ゲーム
;

; ゲーム情報
;
.struct Game

    TIME        .byte               ; ゲームの経過時間（MSX BASIC の命令）
    AD          .byte               ; どうする？で入力された 1 文字
    AV          .byte   $11         ; どうする？
    PD          .byte               ; なにを？で入力された 1 文字
    PN          .byte   $11         ; なにを？
    RA          .byte               ; rack
    RB          .byte               ; rack
    RC          .byte               ; rack
    RD          .byte               ; rack
    RE          .byte               ; rack
    RF          .byte               ; rack
    RG          .byte               ; rack
    RH          .byte               ; rack
    TA          .byte               ; table
    P1          .byte               ; picture
    P2          .byte               ; picture
    F1          .byte               ; fireplace
    F2          .byte               ; fireplace
    I           .byte               ; カウンタ
    D1          .byte               ; door
    D2          .byte               ; door
    D3          .byte               ; door
    D4          .byte               ; door
    D5          .byte               ; door
    DA          .byte               ; door
    DB          .byte               ; door
    DC          .byte               ; door
    DD          .byte               ; door
    DDD         .byte               ; door
    DE          .byte               ; door
    HS          .byte               ; 
    KK          .byte               ;
    Z           .byte               ; rack の位置
    WA          .byte               ; 壁
    PC          .byte               ; 

.endstruct

; ユーザーデータ
;
.struct User

    SC          .byte               ; シーン
    CA          .byte               ; candle
    MA          .byte               ; match
    HA          .byte               ; hammer
    PI          .byte               ; pick
    K1          .byte               ; key
    K2          .byte               ; key
    ME          .byte               ; memo
    DI          .byte               ; diamond
    S1          .byte               ; safe
    S2          .byte               ; safe

.endstruct
