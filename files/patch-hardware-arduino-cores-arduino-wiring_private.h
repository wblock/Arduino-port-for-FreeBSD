--- hardware/arduino/cores/arduino/wiring_private.h.orig	2010-09-20 08:54:45.000000000 -0700
+++ hardware/arduino/cores/arduino/wiring_private.h	2011-02-16 10:52:54.000000000 -0800
@@ -27,7 +27,7 @@
 
 #include <avr/io.h>
 #include <avr/interrupt.h>
-#include <avr/delay.h>
+#include <util/delay.h>
 #include <stdio.h>
 #include <stdarg.h>
 
