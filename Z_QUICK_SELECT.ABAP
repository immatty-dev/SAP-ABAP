*&---------------------------------------------------------------------*
*& Report  Z_QUICK_SELECT
*&---------------------------------------------------------------------*
REPORT z_quick_select.

TYPES tt_array TYPE TABLE OF i WITH NON-UNIQUE KEY table_line.

CLASS z_quick_select DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS:

      main_logic IMPORTING iv_left         TYPE i
                           iv_right        TYPE i
                           iv_kth_n        TYPE i
                 CHANGING  iv_table        TYPE tt_array
                 RETURNING VALUE(rv_value) TYPE i,

      find_pos IMPORTING iv_left       TYPE i
                         iv_right      TYPE i
               CHANGING  iv_table      TYPE tt_array
               RETURNING VALUE(rv_pos) TYPE i.
ENDCLASS.
CLASS z_quick_select IMPLEMENTATION.

  METHOD main_logic.

    IF iv_left LE iv_right.

      DATA(lv_pos) = z_quick_select=>find_pos( EXPORTING iv_left  = iv_left
                                                 iv_right = iv_right
                                        CHANGING iv_table = iv_table ).

      IF iv_kth_n EQ lv_pos.
        rv_value = iv_table[ lv_pos ].
      ELSEIF iv_kth_n < lv_pos.

        rv_value = z_quick_select=>main_logic( EXPORTING iv_left  = iv_left
                                                     iv_right = lv_pos - 1
                                                     iv_kth_n = iv_kth_n
                                                   CHANGING iv_table = iv_table  ).
      ELSE.
        rv_value = z_quick_select=>main_logic( EXPORTING iv_left  = lv_pos + 1
                                                     iv_right = iv_right
                                                     iv_kth_n = iv_kth_n
                                                   CHANGING iv_table = iv_table  ).
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD find_pos.

    DATA(x) = iv_table[ iv_right ]. " pivot
    DATA(i) = iv_left - 1.
    DATA(j) = iv_left.

    WHILE j LE iv_right.
      IF iv_table[ j ] LE x.
        ADD 1 TO i.
        DATA(lv_temp) = iv_table[ i ].
        iv_table[ i ] = iv_table[ j ].
        iv_table[ j ] = lv_temp.
      ENDIF.
      ADD 1 TO j.
    ENDWHILE.

    rv_pos = i.

  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.

  BREAK-POINT.

  DATA(lv_kth)   = 3. " KTH VALUE
  DATA(lt_array) = VALUE tt_array( ( 28 ) ( 37 ) ( 51 ) ( 78 ) ( 6 ) ( 83 ) ( 5 ) ( 4 ) ).
  
  DESCRIBE TABLE lt_array LINES DATA(lv_lenght).

  DATA(lv_value) = z_quick_select=>main_logic( EXPORTING iv_left  = 1
                                                     iv_right = lv_lenght
                                                     iv_kth_n = lv_kth
                                            CHANGING iv_table = lt_array  ).

  IF lv_value IS NOT INITIAL.
    WRITE: 'Kth value is:', lv_value.
  ENDIF.
