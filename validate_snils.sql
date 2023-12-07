CREATE OR REPLACE FUNCTION validate_snils(
	snils_input character varying)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
  snils_digits INTEGER[];
  control_sum INTEGER := 0;
  calculated_check_digit INTEGER;
  last_two_digits INTEGER;
BEGIN
  IF LENGTH(snils_input) <> 11 OR NOT snils_input ~ '^\d+$' THEN
    RETURN FALSE;
  END IF;
  snils_digits := ARRAY(SELECT CAST(digit AS INTEGER) FROM UNNEST(REGEXP_SPLIT_TO_ARRAY(snils_input, '')) digit);
  FOR i IN 1..9 LOOP
    control_sum := control_sum + snils_digits[i] * (10 - i);
  END LOOP;
  IF control_sum < 100 THEN
    calculated_check_digit := control_sum;
  ELSIF control_sum = 100 THEN
    calculated_check_digit := 0;
  ELSE
    calculated_check_digit := control_sum % 101;
    IF calculated_check_digit = 100 THEN
      calculated_check_digit := 0;
    END IF;
  END IF;
  last_two_digits := snils_digits[10] * 10 + snils_digits[11];
  RETURN calculated_check_digit = last_two_digits;
END;
$BODY$;
