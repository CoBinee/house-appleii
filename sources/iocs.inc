; iocs.inc - Input/Output Control System
; 


; サブセット
;
IOCS_CATALOG                        =   0
IOCS_MASKED                         =   0
IOCS_LAYERED                        =   0
IOCS_TILEMAP                        =   1
IOCS_SPRITE                         =   IOCS_LAYERED
IOCS_KANA                           =   0
IOCS_BEEP                           =   1
IOCS_TRIGONOMETRIC                  =   0

; ゼロページ
;

; $00..$1f : IOCS で使用
; $e0..$ff : アプリケーションで使用

; IOCS
IOCS_0_ARG                          :=  $00
IOCS_0_ARG_L                        :=  $00
IOCS_0_ARG_H                        :=  $01
IOCS_0_DOS_PARAM                    :=  $02
IOCS_0_DOS_PARAM_L                  :=  $02
IOCS_0_DOS_PARAM_H                  :=  $03
IOCS_0_KEYCODE                      :=  $04
IOCS_0_RANDOM                       :=  $05
IOCS_0_RANDOM_L                     :=  $05
IOCS_0_RANDOM_H                     :=  $06
IOCS_0_BEEP                         :=  $07
IOCS_0_BEEP_L                       :=  $07
IOCS_0_BEEP_H                       :=  $08
IOCS_0_BEEP_INDEX                   :=  $09
IOCS_0_BEEP_COUNT                   :=  $0a
IOCS_0_0B                           :=  $0b

; WORK
IOCS_0_WORK_0                       :=  $0c
IOCS_0_WORK_1                       :=  $0d
IOCS_0_WORK_2                       :=  $0e
IOCS_0_WORK_3                       :=  $0f

; DOS
IOCS_0_DOS_BUFFER                   :=  $10
IOCS_0_DOS_BUFFER_L                 :=  $10
IOCS_0_DOS_BUFFER_H                 :=  $11
IOCS_0_DOS_FILENAME                 :=  $12
IOCS_0_DOS_FILENAME_L               :=  $12
IOCS_0_DOS_FILENAME_H               :=  $13
IOCS_0_DOS_HEADER                   :=  $14
IOCS_0_DOS_ADDRESS                  :=  $14
IOCS_0_DOS_ADDRESS_L                :=  $14
IOCS_0_DOS_ADDRESS_H                :=  $15
IOCS_0_DOS_LENGTH                   :=  $16
IOCS_0_DOS_LENGTH_L                 :=  $16
IOCS_0_DOS_LENGTH_H                 :=  $17
IOCS_0_DOS_FILETYPE                 :=  $18
IOCS_0_DOS_FLAG                     :=  $19

; HGR - 7x8
IOCS_0_HGR_SRC                      :=  $10
IOCS_0_HGR_SRC_L                    :=  $10
IOCS_0_HGR_SRC_H                    :=  $11
IOCS_0_HGR_DST                      :=  $12
IOCS_0_HGR_DST_L                    :=  $12
IOCS_0_HGR_DST_H                    :=  $13
IOCS_0_HGR_MASK                     :=  $14
IOCS_0_HGR_MASK_L                   :=  $14
IOCS_0_HGR_MASK_H                   :=  $15
IOCS_0_HGR_BASE                     :=  $16
IOCS_0_HGR_BASE_L                   :=  $16
IOCS_0_HGR_BASE_H                   :=  $17

; HGR - String
IOCS_0_HGR_STRING                   :=  $14
IOCS_0_HGR_STRING_L                 :=  $14
IOCS_0_HGR_STRING_H                 :=  $15
IOCS_0_HGR_STRING_INDEX             :=  $16
IOCS_0_HGR_STRING_VRAM_X            :=  $17
IOCS_0_HGR_STRING_VRAM_Y            :=  $18

; HGR - Tileset
IOCS_0_HGR_TILESET                  :=  $18
IOCS_0_HGR_TILESET_L                :=  $18
IOCS_0_HGR_TILESET_H                :=  $19
IOCS_0_HGR_TILESET_X                :=  $1a
IOCS_0_HGR_TILESET_Y                :=  $1b
IOCS_0_HGR_TILESET_VRAM_X           :=  $1c
IOCS_0_HGR_TILESET_VRAM_Y           :=  $1d

; HGR - Tilemap
IOCS_0_HGR_TILEMAP                  :=  $14
IOCS_0_HGR_TILEMAP_L                :=  $14
IOCS_0_HGR_TILEMAP_H                :=  $15
IOCS_0_HGR_TILEMAP_WIDTH            :=  $16
IOCS_0_HGR_TILEMAP_NEXTLINE         :=  $17
IOCS_0_HGR_TILEMAP_X                :=  $18
IOCS_0_HGR_TILEMAP_Y                :=  $19
IOCS_0_HGR_TILEMAP_TILESET          :=  $1a
IOCS_0_HGR_TILEMAP_TILESET_L        :=  $1a
IOCS_0_HGR_TILEMAP_TILESET_H        :=  $1b
IOCS_0_HGR_TILEMAP_VRAM_X           :=  $1c
IOCS_0_HGR_TILEMAP_VRAM_Y           :=  $1d

; HGR - Sprite
IOCS_0_HGR_SPRITE_TILEMAP           :=  $18
IOCS_0_HGR_SPRITE_TILEMAP_L         :=  $18
IOCS_0_HGR_SPRITE_TILEMAP_H         :=  $19
IOCS_0_HGR_SPRITE_TILEMAP_WIDTH     :=  $1a
IOCS_0_HGR_SPRITE_TILEMAP_NEXTLINE  :=  $1b
IOCS_0_HGR_SPRITE_TILEMAP_X         :=  $1c
IOCS_0_HGR_SPRITE_TILEMAP_Y         :=  $1d
IOCS_0_HGR_SPRITE_VRAM_X            :=  $1e
IOCS_0_HGR_SPRITE_VRAM_Y            :=  $1f

; BEEP
IOCS_0_BEEP_LENGTH                  :=  $10
IOCS_0_BEEP_SCORE                   :=  $11
IOCS_0_BEEP_SCORE_L                 :=  $11
IOCS_0_BEEP_SCORE_H                 :=  $12
IOCS_0_BEEP_SCORE_INDEX             :=  $13

; TRIGONOMETRIC
IOCS_0_ATAN2_X                      :=  $10
IOCS_0_ATAN2_Y                      :=  $11
IOCS_0_ATAN2_FLAG                   :=  $12
IOCS_0_ATAN2_ANGLE                  :=  $13

; CPU
;
IOCS_CYCLE                          =   1020484

; BEEP
;
IOCS_BEEP_END                       =   $ff
IOCS_BEEP_R                         =   $7f
IOCS_BEEP_C                         =   $00
IOCS_BEEP_Cp                        =   $01
IOCS_BEEP_Dm                        =   $01
IOCS_BEEP_D                         =   $02
IOCS_BEEP_Dp                        =   $03
IOCS_BEEP_Em                        =   $03
IOCS_BEEP_E                         =   $04
IOCS_BEEP_F                         =   $05
IOCS_BEEP_Fp                        =   $06
IOCS_BEEP_Gm                        =   $06
IOCS_BEEP_G                         =   $07
IOCS_BEEP_Gp                        =   $08
IOCS_BEEP_Am                        =   $08
IOCS_BEEP_A                         =   $09
IOCS_BEEP_Ap                        =   $0a
IOCS_BEEP_Bm                        =   $0a
IOCS_BEEP_B                         =   $0b
IOCS_BEEP_O3                        =   $00
IOCS_BEEP_O3C                       =   IOCS_BEEP_O3 + IOCS_BEEP_C
IOCS_BEEP_O3Cp                      =   IOCS_BEEP_O3 + IOCS_BEEP_Cp
IOCS_BEEP_O3Dm                      =   IOCS_BEEP_O3 + IOCS_BEEP_Dm
IOCS_BEEP_O3D                       =   IOCS_BEEP_O3 + IOCS_BEEP_D
IOCS_BEEP_O3Dp                      =   IOCS_BEEP_O3 + IOCS_BEEP_Dp
IOCS_BEEP_O3Em                      =   IOCS_BEEP_O3 + IOCS_BEEP_Em
IOCS_BEEP_O3E                       =   IOCS_BEEP_O3 + IOCS_BEEP_E
IOCS_BEEP_O3F                       =   IOCS_BEEP_O3 + IOCS_BEEP_F
IOCS_BEEP_O3Fp                      =   IOCS_BEEP_O3 + IOCS_BEEP_Fp
IOCS_BEEP_O3Gm                      =   IOCS_BEEP_O3 + IOCS_BEEP_Gm
IOCS_BEEP_O3G                       =   IOCS_BEEP_O3 + IOCS_BEEP_G
IOCS_BEEP_O3Gp                      =   IOCS_BEEP_O3 + IOCS_BEEP_Gp
IOCS_BEEP_O3Am                      =   IOCS_BEEP_O3 + IOCS_BEEP_Am
IOCS_BEEP_O3A                       =   IOCS_BEEP_O3 + IOCS_BEEP_A
IOCS_BEEP_O3Ap                      =   IOCS_BEEP_O3 + IOCS_BEEP_Ap
IOCS_BEEP_O3Bm                      =   IOCS_BEEP_O3 + IOCS_BEEP_Bm
IOCS_BEEP_O3B                       =   IOCS_BEEP_O3 + IOCS_BEEP_B
IOCS_BEEP_O4                        =   $0c
IOCS_BEEP_O4C                       =   IOCS_BEEP_O4 + IOCS_BEEP_C
IOCS_BEEP_O4Cp                      =   IOCS_BEEP_O4 + IOCS_BEEP_Cp
IOCS_BEEP_O4Dm                      =   IOCS_BEEP_O4 + IOCS_BEEP_Dm
IOCS_BEEP_O4D                       =   IOCS_BEEP_O4 + IOCS_BEEP_D
IOCS_BEEP_O4Dp                      =   IOCS_BEEP_O4 + IOCS_BEEP_Dp
IOCS_BEEP_O4Em                      =   IOCS_BEEP_O4 + IOCS_BEEP_Em
IOCS_BEEP_O4E                       =   IOCS_BEEP_O4 + IOCS_BEEP_E
IOCS_BEEP_O4F                       =   IOCS_BEEP_O4 + IOCS_BEEP_F
IOCS_BEEP_O4Fp                      =   IOCS_BEEP_O4 + IOCS_BEEP_Fp
IOCS_BEEP_O4Gm                      =   IOCS_BEEP_O4 + IOCS_BEEP_Gm
IOCS_BEEP_O4G                       =   IOCS_BEEP_O4 + IOCS_BEEP_G
IOCS_BEEP_O4Gp                      =   IOCS_BEEP_O4 + IOCS_BEEP_Gp
IOCS_BEEP_O4Am                      =   IOCS_BEEP_O4 + IOCS_BEEP_Am
IOCS_BEEP_O4A                       =   IOCS_BEEP_O4 + IOCS_BEEP_A
IOCS_BEEP_O4Ap                      =   IOCS_BEEP_O4 + IOCS_BEEP_Ap
IOCS_BEEP_O4Bm                      =   IOCS_BEEP_O4 + IOCS_BEEP_Bm
IOCS_BEEP_O4B                       =   IOCS_BEEP_O4 + IOCS_BEEP_B
IOCS_BEEP_O5                        =   $18
IOCS_BEEP_O5C                       =   IOCS_BEEP_O5 + IOCS_BEEP_C
IOCS_BEEP_O5Cp                      =   IOCS_BEEP_O5 + IOCS_BEEP_Cp
IOCS_BEEP_O5Dm                      =   IOCS_BEEP_O5 + IOCS_BEEP_Dm
IOCS_BEEP_O5D                       =   IOCS_BEEP_O5 + IOCS_BEEP_D
IOCS_BEEP_O5Dp                      =   IOCS_BEEP_O5 + IOCS_BEEP_Dp
IOCS_BEEP_O5Em                      =   IOCS_BEEP_O5 + IOCS_BEEP_Em
IOCS_BEEP_O5E                       =   IOCS_BEEP_O5 + IOCS_BEEP_E
IOCS_BEEP_O5F                       =   IOCS_BEEP_O5 + IOCS_BEEP_F
IOCS_BEEP_O5Fp                      =   IOCS_BEEP_O5 + IOCS_BEEP_Fp
IOCS_BEEP_O5Gm                      =   IOCS_BEEP_O5 + IOCS_BEEP_Gm
IOCS_BEEP_O5G                       =   IOCS_BEEP_O5 + IOCS_BEEP_G
IOCS_BEEP_O5Gp                      =   IOCS_BEEP_O5 + IOCS_BEEP_Gp
IOCS_BEEP_O5Am                      =   IOCS_BEEP_O5 + IOCS_BEEP_Am
IOCS_BEEP_O5A                       =   IOCS_BEEP_O5 + IOCS_BEEP_A
IOCS_BEEP_O5Ap                      =   IOCS_BEEP_O5 + IOCS_BEEP_Ap
IOCS_BEEP_O5Bm                      =   IOCS_BEEP_O5 + IOCS_BEEP_Bm
IOCS_BEEP_O5B                       =   IOCS_BEEP_O5 + IOCS_BEEP_B
IOCS_BEEP_Ox                        =   $24
IOCS_BEEP_PI                        =   IOCS_BEEP_Ox + $00
IOCS_BEEP_PO                        =   IOCS_BEEP_Ox + $01
IOCS_BEEP_L1                        =   $00
IOCS_BEEP_L2                        =   $80
IOCS_BEEP_L2p                       =   $c0
IOCS_BEEP_L4                        =   $40
IOCS_BEEP_L4p                       =   $60
IOCS_BEEP_L8                        =   $20
IOCS_BEEP_L8p                       =   $30
IOCS_BEEP_L16                       =   $10
IOCS_BEEP_L16p                      =   $18
IOCS_BEEP_L32                       =   $08
IOCS_BEEP_L32p                      =   $0c
IOCS_BEEP_L64                       =   $04
IOCS_BEEP_L64p                      =   $06
IOCS_BEEP_L128                      =   $02
IOCS_BEEP_L128p                     =   $03
IOCS_BEEP_L256                      =   $01
IOCS_BEEP_CYCLE_O3C                 =   IOCS_CYCLE / 131 / 2
IOCS_BEEP_CYCLE_O3Cp                =   IOCS_CYCLE / 139 / 2
IOCS_BEEP_CYCLE_O3D                 =   IOCS_CYCLE / 147 / 2
IOCS_BEEP_CYCLE_O3Dp                =   IOCS_CYCLE / 156 / 2
IOCS_BEEP_CYCLE_O3E                 =   IOCS_CYCLE / 165 / 2
IOCS_BEEP_CYCLE_O3F                 =   IOCS_CYCLE / 175 / 2
IOCS_BEEP_CYCLE_O3Fp                =   IOCS_CYCLE / 185 / 2
IOCS_BEEP_CYCLE_O3G                 =   IOCS_CYCLE / 196 / 2
IOCS_BEEP_CYCLE_O3Gp                =   IOCS_CYCLE / 208 / 2
IOCS_BEEP_CYCLE_O3A                 =   IOCS_CYCLE / 220 / 2
IOCS_BEEP_CYCLE_O3Ap                =   IOCS_CYCLE / 233 / 2
IOCS_BEEP_CYCLE_O3B                 =   IOCS_CYCLE / 247 / 2
IOCS_BEEP_CYCLE_O4C                 =   IOCS_CYCLE / 262 / 2
IOCS_BEEP_CYCLE_O4Cp                =   IOCS_CYCLE / 277 / 2
IOCS_BEEP_CYCLE_O4D                 =   IOCS_CYCLE / 294 / 2
IOCS_BEEP_CYCLE_O4Dp                =   IOCS_CYCLE / 311 / 2
IOCS_BEEP_CYCLE_O4E                 =   IOCS_CYCLE / 330 / 2
IOCS_BEEP_CYCLE_O4F                 =   IOCS_CYCLE / 349 / 2
IOCS_BEEP_CYCLE_O4Fp                =   IOCS_CYCLE / 370 / 2
IOCS_BEEP_CYCLE_O4G                 =   IOCS_CYCLE / 392 / 2
IOCS_BEEP_CYCLE_O4Gp                =   IOCS_CYCLE / 415 / 2
IOCS_BEEP_CYCLE_O4A                 =   IOCS_CYCLE / 440 / 2
IOCS_BEEP_CYCLE_O4Ap                =   IOCS_CYCLE / 466 / 2
IOCS_BEEP_CYCLE_O4B                 =   IOCS_CYCLE / 494 / 2
IOCS_BEEP_CYCLE_O5C                 =   IOCS_CYCLE / 523 / 2
IOCS_BEEP_CYCLE_O5Cp                =   IOCS_CYCLE / 554 / 2
IOCS_BEEP_CYCLE_O5D                 =   IOCS_CYCLE / 587 / 2
IOCS_BEEP_CYCLE_O5Dp                =   IOCS_CYCLE / 622 / 2
IOCS_BEEP_CYCLE_O5E                 =   IOCS_CYCLE / 659 / 2
IOCS_BEEP_CYCLE_O5F                 =   IOCS_CYCLE / 698 / 2
IOCS_BEEP_CYCLE_O5Fp                =   IOCS_CYCLE / 740 / 2
IOCS_BEEP_CYCLE_O5G                 =   IOCS_CYCLE / 784 / 2
IOCS_BEEP_CYCLE_O5Gp                =   IOCS_CYCLE / 831 / 2
IOCS_BEEP_CYCLE_O5A                 =   IOCS_CYCLE / 880 / 2
IOCS_BEEP_CYCLE_O5Ap                =   IOCS_CYCLE / 932 / 2
IOCS_BEEP_CYCLE_O5B                 =   IOCS_CYCLE / 988 / 2
IOCS_BEEP_CYCLE_PI                  =   IOCS_CYCLE / 2000 / 2
IOCS_BEEP_CYCLE_PO                  =   IOCS_CYCLE / 1000 / 2
IOCS_BEEP_CYCLE_BASE                =   8 + 4 + 12
IOCS_BEEP_CYCLE_LOOP                =   17
IOCS_BEEP_CYCLE_L256_MSEC           =   8
IOCS_BEEP_CYCLE_L256                =   IOCS_CYCLE * IOCS_BEEP_CYCLE_L256_MSEC / 1000

; 音階
;
_O3C    =   IOCS_BEEP_O3C
_O3Cp   =   IOCS_BEEP_O3Cp
_O3Dm   =   IOCS_BEEP_O3Dm
_O3D    =   IOCS_BEEP_O3D
_O3Dp   =   IOCS_BEEP_O3Dp
_O3Em   =   IOCS_BEEP_O3Em
_O3E    =   IOCS_BEEP_O3E
_O3F    =   IOCS_BEEP_O3F
_O3Fp   =   IOCS_BEEP_O3Fp
_O3Gm   =   IOCS_BEEP_O3Gm
_O3G    =   IOCS_BEEP_O3G
_O3Gp   =   IOCS_BEEP_O3Gp
_O3Am   =   IOCS_BEEP_O3Am
_O3A    =   IOCS_BEEP_O3A
_O3Ap   =   IOCS_BEEP_O3Ap
_O3Bm   =   IOCS_BEEP_O3Bm
_O3B    =   IOCS_BEEP_O3B
_O4C    =   IOCS_BEEP_O4C
_O4Cp   =   IOCS_BEEP_O4Cp
_O4Dm   =   IOCS_BEEP_O4Dm
_O4D    =   IOCS_BEEP_O4D
_O4Dp   =   IOCS_BEEP_O4Dp
_O4Em   =   IOCS_BEEP_O4Em
_O4E    =   IOCS_BEEP_O4E
_O4F    =   IOCS_BEEP_O4F
_O4Fp   =   IOCS_BEEP_O4Fp
_O4Gm   =   IOCS_BEEP_O4Gm
_O4G    =   IOCS_BEEP_O4G
_O4Gp   =   IOCS_BEEP_O4Gp
_O4Am   =   IOCS_BEEP_O4Am
_O4A    =   IOCS_BEEP_O4A
_O4Ap   =   IOCS_BEEP_O4Ap
_O4Bm   =   IOCS_BEEP_O4Bm
_O4B    =   IOCS_BEEP_O4B
_O5C    =   IOCS_BEEP_O5C
_O5Cp   =   IOCS_BEEP_O5Cp
_O5Dm   =   IOCS_BEEP_O5Dm
_O5D    =   IOCS_BEEP_O5D
_O5Dp   =   IOCS_BEEP_O5Dp
_O5Em   =   IOCS_BEEP_O5Em
_O5E    =   IOCS_BEEP_O5E
_O5F    =   IOCS_BEEP_O5F
_O5Fp   =   IOCS_BEEP_O5Fp
_O5Gm   =   IOCS_BEEP_O5Gm
_O5G    =   IOCS_BEEP_O5G
_O5Gp   =   IOCS_BEEP_O5Gp
_O5Am   =   IOCS_BEEP_O5Am
_O5A    =   IOCS_BEEP_O5A
_O5Ap   =   IOCS_BEEP_O5Ap
_O5Bm   =   IOCS_BEEP_O5Bm
_O5B    =   IOCS_BEEP_O5B
_R      =   IOCS_BEEP_R

; 音長
;
_L1     =   IOCS_BEEP_L1
_L2     =   IOCS_BEEP_L2
_L2p    =   IOCS_BEEP_L2p
_L4     =   IOCS_BEEP_L4
_L4p    =   IOCS_BEEP_L4p
_L8     =   IOCS_BEEP_L8
_L8p    =   IOCS_BEEP_L8p
_L16    =   IOCS_BEEP_L16
_L16p   =   IOCS_BEEP_L16p
_L32    =   IOCS_BEEP_L32
_L32p   =   IOCS_BEEP_L32p
_L64    =   IOCS_BEEP_L64
_L64p   =   IOCS_BEEP_L64p
_L128   =   IOCS_BEEP_L128
_L128p  =   IOCS_BEEP_L128p
_L256   =   IOCS_BEEP_L256

; カタカナ
;
_SP     =   $80     ; 
_PR     =   $81     ; 。
_OB     =   $82     ; 「
_CB     =   $83     ; 」
_CM     =   $84     ; 、
_BP     =   $85     ; ・
kWO     =   $86     ; ヲ
k_a     =   $87     ; ァ
k_i     =   $88     ; ィ
k_u     =   $89     ; ゥ
k_e     =   $8a     ; ェ
k_o     =   $8b     ; ォ
kya     =   $8c     ; ャ
kyu     =   $8d     ; ュ
kyo     =   $8e     ; ョ
ktu     =   $8f     ; ッ
_HF     =   $90     ; ー
k_A     =   $91     ; ア
k_I     =   $92     ; イ
k_U     =   $93     ; ウ
k_E     =   $94     ; エ
k_O     =   $95     ; オ
kKA     =   $96     ; カ
kKI     =   $97     ; キ
kKU     =   $98     ; ク
kKE     =   $99     ; ケ
kKO     =   $9a     ; コ
kSA     =   $9b     ; サ
kSI     =   $9c     ; シ
kSU     =   $9d     ; ス
kSE     =   $9e     ; セ
kSO     =   $9f     ; ソ
kTA     =   $a0     ; タ
kTI     =   $a1     ; チ
kTU     =   $a2     ; ツ
kTE     =   $a3     ; テ
kTO     =   $a4     ; ト
kNA     =   $a5     ; ナ
kNI     =   $a6     ; ニ
kNU     =   $a7     ; ヌ
kNE     =   $a8     ; ネ
kNO     =   $a9     ; ノ
kHA     =   $aa     ; ハ
kHI     =   $ab     ; ヒ
kHU     =   $ac     ; フ
kHE     =   $ad     ; ヘ
kHO     =   $ae     ; ホ
kMA     =   $af     ; マ
kMI     =   $b0     ; ミ
kMU     =   $b1     ; ム
kME     =   $b2     ; メ
kMO     =   $b3     ; モ
kYA     =   $b4     ; ヤ
kYU     =   $b5     ; ユ
kYO     =   $b6     ; ヨ
kRA     =   $b7     ; ラ
kRI     =   $b8     ; リ
kRU     =   $b9     ; ル
kRE     =   $ba     ; レ
kRO     =   $bb     ; ロ
kWA     =   $bc     ; ワ
k_N     =   $bd     ; ン
_VM     =   $be     ; ゛
_PM     =   $bf     ; ゜
hSP     =   $c0     ; スペード
hHT     =   $c1     ; ハート
hKL     =   $c2     ; クローバー
hDA     =   $c3     ; ダイヤ
hCL     =   $c4     ; ○
hCF     =   $c5     ; ●
hWO     =   $c6     ; を
h_a     =   $c7     ; ぁ
h_i     =   $c8     ; ぃ
h_u     =   $c9     ; ぅ
h_e     =   $ca     ; ぇ
h_o     =   $cb     ; ぉ
hya     =   $cc     ; ゃ
hyu     =   $cd     ; ゅ
hyo     =   $ce     ; ょ
htu     =   $cf     ; っ
_D0     =   $d0     ; 
h_A     =   $d1     ; あ
h_I     =   $d2     ; い
h_U     =   $d3     ; う
h_E     =   $d4     ; え
h_O     =   $d5     ; お
hKA     =   $d6     ; か
hKI     =   $d7     ; き
hKU     =   $d8     ; く
hKE     =   $d9     ; け
hKO     =   $da     ; こ
hSA     =   $db     ; さ
hSI     =   $dc     ; し
hSU     =   $dd     ; す
hSE     =   $de     ; せ
hSO     =   $df     ; そ
hTA     =   $e0     ; た
hTI     =   $e1     ; ち
hTU     =   $e2     ; つ
hTE     =   $e3     ; て
hTO     =   $e4     ; と
hNA     =   $e5     ; な
hNI     =   $e6     ; に
hNU     =   $e7     ; ぬ
hNE     =   $e8     ; ね
hNO     =   $e9     ; の
hHA     =   $ea     ; は
hHI     =   $eb     ; ひ
hHU     =   $ec     ; ふ
hHE     =   $ed     ; へ
hHO     =   $ee     ; ほ
hMA     =   $ef     ; ま
hMI     =   $f0     ; み
hMU     =   $f1     ; む
hME     =   $f2     ; め
hMO     =   $f3     ; も
hYA     =   $f4     ; や
hYU     =   $f5     ; ゆ
hYO     =   $f6     ; よ
hRA     =   $f7     ; ら
hRI     =   $f8     ; り
hRU     =   $f9     ; る
hRE     =   $fa     ; れ
hRO     =   $fb     ; ろ
hWA     =   $fc     ; わ
h_N     =   $fd     ; ん
_FE     =   $fe     ; 
_FF     =   $ff     ; 
