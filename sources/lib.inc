; lib.inc - ライブラリ
; 


; ゼロページ
;
LIB_0                               :=  $10

; WORK
LIB_0_WORK_0                        :=  IOCS_0_WORK_0
LIB_0_WORK_1                        :=  IOCS_0_WORK_1
LIB_0_WORK_2                        :=  IOCS_0_WORK_2
LIB_0_WORK_3                        :=  IOCS_0_WORK_3

; SHAPE
LIB_0_SHAPE_ARG                     :=  LIB_0 + $00
LIB_0_SHAPE_ARG_L                   :=  LIB_0 + $00
LIB_0_SHAPE_ARG_H                   :=  LIB_0 + $01
LIB_0_SHAPE_ADDR                    :=  LIB_0 + $02
LIB_0_SHAPE_ADDR_L                  :=  LIB_0 + $02
LIB_0_SHAPE_ADDR_H                  :=  LIB_0 + $03
LIB_0_SHAPE_INDEX                   :=  LIB_0 + $04
LIB_0_SHAPE_BIT                     :=  LIB_0 + $05

; LINE
LIB_0_LINE_X_1                      :=  LIB_0 + $06
LIB_0_LINE_Y_1                      :=  LIB_0 + $07
LIB_0_LINE_X_2                      :=  LIB_0 + $08
LIB_0_LINE_Y_2                      :=  LIB_0 + $09
LIB_0_LINE_DX                       :=  LIB_0 + $0a
LIB_0_LINE_DY                       :=  LIB_0 + $0b
LIB_0_LINE_LENGTH                   :=  LIB_0 + $0c
LIB_0_LINE_S                        :=  LIB_0 + $0d

; RECT
LIB_0_RECT_X_1                      :=  LIB_0 + $06
LIB_0_RECT_Y_1                      :=  LIB_0 + $07
LIB_0_RECT_X_2                      :=  LIB_0 + $08
LIB_0_RECT_Y_2                      :=  LIB_0 + $09
LIB_0_RECT_DX                       :=  LIB_0 + $0a
LIB_0_RECT_DY                       :=  LIB_0 + $0b
LIB_0_RECT_LENGTH                   :=  LIB_0 + $0c
LIB_0_RECT_ADDR_L                   :=  LIB_0 + $0d
LIB_0_RECT_BIT                      :=  LIB_0 + $0e

; CIRCLE
LIB_0_CIRCLE_OX                     :=  LIB_0 + $06
LIB_0_CIRCLE_OY                     :=  LIB_0 + $07
LIB_0_CIRCLE_R                      :=  LIB_0 + $08
LIB_0_CIRCLE_X                      :=  LIB_0 + $09
LIB_0_CIRCLE_Y                      :=  LIB_0 + $0a

; テキスト
LIB_0_TEXT_ARG                      :=  LIB_0 + $00
LIB_0_TEXT_ARG_L                    :=  LIB_0 + $00
LIB_0_TEXT_ARG_H                    :=  LIB_0 + $01
LIB_0_TEXT_SRC                      :=  LIB_0 + $02
LIB_0_TEXT_DST                      :=  LIB_0 + $03

; テキスト
;
LIB_TEXT_SIZE_X                     =   37
LIB_TEXT_SIZE_Y                     =   2
LIB_TEXT_X                          =   1
LIB_TEXT_Y                          =   22
LIB_TEXT_Y_UPPER                    =   22
LIB_TEXT_Y_LOWER                    =   23

