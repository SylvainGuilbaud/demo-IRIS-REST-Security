ROUTINE WorkShop.macros [Type=INC]
#dim a as WorkShop.Patient
#Define CompTS ##Expression("""Compiled: " _ $ZDATETIME($HOROLOG,3) _ """")
  WRITE $$$CompTS