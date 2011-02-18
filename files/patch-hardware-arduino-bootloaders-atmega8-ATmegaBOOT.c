--- hardware/arduino/bootloaders/atmega8/ATmegaBOOT.c.orig	2010-09-20 08:54:44.000000000 -0700
+++ hardware/arduino/bootloaders/atmega8/ATmegaBOOT.c	2011-02-16 10:49:29.000000000 -0800
@@ -36,7 +36,7 @@
 #include <avr/pgmspace.h>
 #include <avr/eeprom.h>
 #include <avr/interrupt.h>
-#include <avr/delay.h>
+#include <util/delay.h>
 
 //#define F_CPU			16000000
 
