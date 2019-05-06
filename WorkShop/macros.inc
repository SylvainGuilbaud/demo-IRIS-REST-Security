ROUTINE WorkShop.macros [Type=INC]
#Define CompTS ##Expression("""Compiled: " _ $ZDATETIME($HOROLOG,3) _ """")
  WRITE $$$CompTS