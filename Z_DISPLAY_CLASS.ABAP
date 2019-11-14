*&---------------------------------------------------------------------*
*& Report  CODING_EXCERCISE
*&---------------------------------------------------------------------*
REPORT coding_exercise.

CLASS coding_exercise DEFINITION.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_bbva_vendor,
             include TYPE zfi_bbva_vendor,
           END OF ty_bbva_vendor,
           tt_bbva_vendor TYPE STANDARD TABLE OF ty_bbva_vendor.

    CLASS-METHODS: display CHANGING iv_table TYPE ANY TABLE.

ENDCLASS.

CLASS coding_exercise IMPLEMENTATION.
  METHOD display.
    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = DATA(alv)
                                CHANGING  t_table      = iv_table ).
      CATCH cx_salv_msg INTO DATA(bummer).
        MESSAGE bummer TYPE 'E'.
    ENDTRY.
    alv->display( ).
  ENDMETHOD.

ENDCLASS.

*// DECLARING GLOBAL STRUCTURES/VARIABLES
TYPES: BEGIN OF ty_array,
         pos TYPE i,
       END   OF ty_array.
TYPES: tt_array TYPE TABLE OF ty_array WITH NON-UNIQUE KEY table_line.

TYPES ty_itab TYPE TABLE OF i WITH NON-UNIQUE KEY table_line.

DATA: gt_hash TYPE HASHED TABLE OF i WITH UNIQUE KEY table_line.

*------------------------------------------------------------------------
INITIALIZATION.
*------------------------------------------------------------------------

  DATA(itab)  = VALUE ty_itab( ( 5 ) ( -2 ) ( 3 ) ( 5 ) ( 3 ) ( 2 ) ).
  DATA(itab2) = VALUE tt_array( ( pos = 3 ) ( pos = 2 ) ( pos = 1 ) ( pos = 5 ) ).

*------------------------------------------------------------------------
START-OF-SELECTION.
*------------------------------------------------------------------------

*------------------------------------------------------------------------
* ---------------- SHOW USING CLASS-METHODS -----------------------------
*------------------------------------------------------------------------
  SELECT * FROM zfi_bbva_vendor
  INTO TABLE @DATA(lt_bbva_vendor).
  coding_exercise=>display( CHANGING iv_table = lt_bbva_vendor ).

*------------------------------------------------------------------------
* --------------- SHOW USING WRITE STATEMENT ----------------------------
*------------------------------------------------------------------------
  LOOP AT itab INTO DATA(ls_itab).
    READ TABLE gt_hash INTO DATA(ls_hash)
    WITH TABLE KEY table_line = ls_itab.
    INSERT ls_itab INTO TABLE gt_hash.
*    cl_demo_output=>display( ls_itab ).
    WRITE: ls_itab.
  ENDLOOP.

*------------------------------------------------------------------------
* --------------- SHOW USING DEMO OUTPUT TEXT ---------------------------
*------------------------------------------------------------------------
  cl_demo_output=>new('TEXT')->display( gt_hash ).

*------------------------------------------------------------------------
* --------------- SHOW USING DEMO OUTPUT WEB ----------------------------
*------------------------------------------------------------------------
  DATA(html) = cl_demo_output=>get( itab2 ).
  cl_abap_browser=>show_html( html_string = html ).
