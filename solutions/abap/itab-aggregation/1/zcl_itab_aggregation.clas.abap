CLASS zcl_itab_aggregation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES group TYPE c LENGTH 1.
    TYPES: BEGIN OF initial_numbers_type,
             group  TYPE group,
             number TYPE i,
           END OF initial_numbers_type,
           initial_numbers TYPE STANDARD TABLE OF initial_numbers_type WITH EMPTY KEY.

    TYPES: BEGIN OF aggregated_data_type,
             group   TYPE group,
             count   TYPE i,
             sum     TYPE i,
             min     TYPE i,
             max     TYPE i,
             average TYPE f,
           END OF aggregated_data_type,
           aggregated_data TYPE STANDARD TABLE OF aggregated_data_type WITH EMPTY KEY.

    METHODS perform_aggregation
      IMPORTING
        initial_numbers        TYPE initial_numbers
      RETURNING
        VALUE(aggregated_data) TYPE aggregated_data.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.
CLASS zcl_itab_aggregation IMPLEMENTATION.
  METHOD perform_aggregation.
    DATA wa_input TYPE initial_numbers_type.
    DATA wa_result TYPE aggregated_data_type.

    LOOP AT initial_numbers INTO wa_input.
      " Check if group already exists in result
      READ TABLE aggregated_data INTO wa_result
        WITH KEY group = wa_input-group.

      IF sy-subrc = 0.
        " Update existing group entry
        wa_result-count   += 1.
        wa_result-sum     += wa_input-number.
        wa_result-min      = nmin( val1 = wa_result-min val2 = wa_input-number ).
        wa_result-max      = nmax( val1 = wa_result-max val2 = wa_input-number ).
        wa_result-average  = wa_result-sum / wa_result-count.
        MODIFY aggregated_data FROM wa_result INDEX sy-tabix.
      ELSE.
        " Create new entry for this group
        CLEAR wa_result.
        wa_result-group   = wa_input-group.
        wa_result-count   = 1.
        wa_result-sum     = wa_input-number.
        wa_result-min     = wa_input-number.
        wa_result-max     = wa_input-number.
        wa_result-average = wa_input-number.
        APPEND wa_result TO aggregated_data.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
