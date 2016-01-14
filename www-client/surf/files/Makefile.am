VERSION = 0.6
ACLOCAL_AMFLAGS = -I m4

bin_PROGRAMS = surf

AM_CFLAGS = 
AM_LDFLAGS = 

surf_SOURCES = surf.c
surf_CPPFLAGS = -DVERSION=\"$(VERSION)\" -D_DEFAULT_SOURCE
surf_CFLAGS = -std=c99 -pedantic -Wall -I. -I/usr/include $(X11_CFLAGS) $(GTK_CFLAGS) $(GTHREAD_CFLAGS) $(WEBKIT2GTK_CFLAGS) -DSURF_WEB_EXTENSIONS_DIR=\""$(libdir)/surf/web-extension\"" 
surf_LDFLAGS = $(X11_LIBS) $(GTK_LIBS) $(GTHREAD_LIBS) $(WEBKIT2GTK_LIBS)

surfext_LTLIBRARIES = libsurfext.la
surfextdir = $(libdir)/surf/web-extension
libsurfext_la_SOURCES = surfext.c
libsurfext_la_CFLAGS = $(WEBKIT2GTKEXT_CFLAGS) $(JSONGLIB_CFLAGS) $(LIBSOUP_CFLAGS)
libsurfext_la_LIBADD = $(WEBKIT2GTKEXT_LIBS) $(JSONGLIB_LIBS) $(LIBSOUP_LIBS)
libsurfext_la_LDFLAGS = -module -avoid-version -no-undefined
