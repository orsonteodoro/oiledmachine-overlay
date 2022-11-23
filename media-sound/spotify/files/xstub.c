// See https://gist.github.com/jamesob/7a71cff391b71582ef154f4db923ac4b
#include <stdio.h>

#define X_FN(f) int f() { return 0; }
X_FN(XInternAtoms)
X_FN(XChangeProperty)
X_FN(XGetGeometry)
X_FN(XInternAtom)
X_FN(XMoveResizeWindow)
X_FN(XSendEvent)
X_FN(XSetClassHint)
X_FN(XSetErrorHandler)
X_FN(XSetIOErrorHandler)
X_FN(XStoreName)
X_FN(XTranslateCoordinates)
