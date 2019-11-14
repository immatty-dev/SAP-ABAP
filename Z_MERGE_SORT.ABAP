*&---------------------------------------------------------------------*
*& Report  Z_MERGE_SORT
*&---------------------------------------------------------------------*
REPORT z_merge_sort.

TYPES tt_table TYPE TABLE OF i WITH NON-UNIQUE KEY table_line.

CLASS zcl_mergesort DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS:

      sort   IMPORTING iv_table        TYPE abadr_tab_int4
             RETURNING VALUE(rv_table) TYPE abadr_tab_int4,

      cut    IMPORTING iv_origin       TYPE abadr_tab_int4
                       iv_start        TYPE int4
                       iv_end          TYPE int4
             RETURNING VALUE(rv_sub)   TYPE abadr_tab_int4,

      merge  CHANGING  cv_left          TYPE abadr_tab_int4
                       cv_right         TYPE abadr_tab_int4
             RETURNING VALUE(rv_merged) TYPE abadr_tab_int4 .

ENDCLASS.

CLASS zcl_mergesort IMPLEMENTATION.

  METHOD cut.
    LOOP AT iv_origin ASSIGNING FIELD-SYMBOL(<item>) FROM iv_start TO iv_end.
      APPEND <item> TO rv_sub.
    ENDLOOP.
  ENDMETHOD.

  METHOD sort.

    IF lines( iv_table ) = 1.
      rv_table = iv_table.
      RETURN.
    ENDIF.

    DATA(lv_middle) = lines( iv_table ) DIV 2.

    DATA(lv_left) = cut( iv_origin = iv_table
                         iv_start  = 1
                         iv_end = lv_middle ).

    DATA(lv_right) = cut( iv_origin = iv_table
                          iv_start  = lv_middle + 1
                          iv_end    = lines( iv_table ) ).

    DATA(lv_left_sorted) = sort( lv_left ).
    DATA(lv_right_sorted) = sort( lv_right ).

    rv_table = merge( CHANGING cv_left  = lv_left_sorted
                               cv_right = lv_right_sorted ).

  ENDMETHOD.

  METHOD merge.
    DATA:lv_shift TYPE int4.

    WHILE lines( cv_left ) > 0 AND lines( cv_right ) > 0.
      IF cv_left[ 1 ] < cv_right[ 1 ].
        lv_shift = cv_left[ 1 ].
        DELETE cv_left INDEX 1.
      ELSE.
        lv_shift = cv_right[ 1 ].
        DELETE cv_right INDEX 1.
      ENDIF.
      APPEND lv_shift TO rv_merged.
    ENDWHILE.

    APPEND LINES OF cv_left  TO rv_merged.
    APPEND LINES OF cv_right TO rv_merged.

    CLEAR: cv_left, cv_right.
  ENDMETHOD.

ENDCLASS.

INITIALIZATION.

  DATA lt_sorted TYPE tt_table.
  DATA(lt_table) = VALUE tt_table( ( 28 ) ( 37 ) ( 51 ) ( 78 ) ( 6 ) ( 83 ) ( 5 ) ).

  BREAK-POINT.

  zcl_mergesort=>sort( EXPORTING iv_table = lt_table RECEIVING rv_table = lt_sorted ).

  BREAK-POINT.
