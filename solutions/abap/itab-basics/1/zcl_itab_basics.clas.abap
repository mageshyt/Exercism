CLASS zcl_itab_basics DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    " --- Type definitions ---
    TYPES group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_type,
             group       TYPE group,
             number      TYPE i,
             description TYPE string,
           END OF initial_type,
           itab_data_type TYPE STANDARD TABLE OF initial_type WITH EMPTY KEY.

    DATA : lt_itab TYPE itab_data_type.

    " --- Methods ---
    METHODS fill_itab
      RETURNING
        VALUE(initial_data) TYPE itab_data_type.

    METHODS add_to_itab
      IMPORTING
        initial_data TYPE itab_data_type
      RETURNING
        VALUE(updated_data) TYPE itab_data_type.

    METHODS sort_itab
      IMPORTING
        initial_data TYPE itab_data_type
      RETURNING
        VALUE(updated_data) TYPE itab_data_type.

    METHODS search_itab
      IMPORTING
        initial_data TYPE itab_data_type
      RETURNING
        VALUE(result_index) TYPE i.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_itab_basics IMPLEMENTATION.

  " --- Step 1: Fill with 6 records ---
METHOD fill_itab.
  DATA wa_itab TYPE initial_type.
  DATA lt_temp TYPE itab_data_type.  " local table

  wa_itab-group = 'A'.
  wa_itab-number = 10.
  wa_itab-description = 'Group A-2'.
  APPEND wa_itab TO lt_temp.

  wa_itab-group = 'B'.
  wa_itab-number = 5.
  wa_itab-description = 'Group B'.
  APPEND wa_itab TO lt_temp.

  wa_itab-group = 'A'.
  wa_itab-number = 6.
  wa_itab-description = 'Group A-1'.
  APPEND wa_itab TO lt_temp.

  wa_itab-group = 'C'.
  wa_itab-number = 22.
  wa_itab-description = 'Group C-1'.
  APPEND wa_itab TO lt_temp.

  wa_itab-group = 'A'.
  wa_itab-number = 13.
  wa_itab-description = 'Group A-3'.
  APPEND wa_itab TO lt_temp.

  wa_itab-group = 'C'.
  wa_itab-number = 500.
  wa_itab-description = 'Group C-2'.
  APPEND wa_itab TO lt_temp.

  " Return the local table
  initial_data = lt_temp.
ENDMETHOD.


  " --- Step 2: Add new record ---
  METHOD add_to_itab.
    updated_data = initial_data.

    DATA wa_row TYPE initial_type.
    wa_row-group = 'A'.
    wa_row-number = 19.
    wa_row-description = 'Group A-4'.

    APPEND wa_row TO updated_data.
  ENDMETHOD.


  " --- Step 3: Sort table ---
  METHOD sort_itab.
    updated_data = initial_data.
    SORT updated_data BY group ASCENDING number DESCENDING.
  ENDMETHOD.


  " --- Step 4: Search for record where NUMBER = 6 ---
  METHOD search_itab.
    DATA wa_itab TYPE initial_type.

    LOOP AT initial_data INTO wa_itab.
      IF wa_itab-number = 6.
        result_index = sy-tabix. " return index of found record
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
