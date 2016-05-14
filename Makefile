# wdmenu - dynamic menu
# See LICENSE file for copyright and license details.

include config.mk

SRC = wdmenu.c draw.c lsx.c
OBJ = ${SRC:.c=.o}

all: options wdmenu lsx

options:
	@echo wdmenu build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	@echo CC -c $<
	@${CC} -c $< ${CFLAGS}

${OBJ}: config.mk

wdmenu: dmenu.o draw.o
	@echo CC -o $@
	@${CC} -o $@ dmenu.o draw.o ${LDFLAGS}

lsx: lsx.o
	@echo CC -o $@
	@${CC} -o $@ lsx.o ${LDFLAGS}

clean:
	@echo cleaning
	@rm -f wdmenu lsx ${OBJ} wdmenu-${VERSION}.tar.gz

dist: clean
	@echo creating dist tarball
	@mkdir -p wdmenu-${VERSION}
	@cp LICENSE Makefile README config.mk wdmenu.1 draw.h wdmenu_run lsx.1 ${SRC} wdmenu-${VERSION}
	@tar -cf wdmenu-${VERSION}.tar wdmenu-${VERSION}
	@gzip wdmenu-${VERSION}.tar
	@rm -rf wdmenu-${VERSION}

install: all
	@echo installing executables to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	@cp -f wdmenu wdmenu_run lsx ${DESTDIR}${PREFIX}/bin
	@chmod 755 ${DESTDIR}${PREFIX}/bin/wdmenu
	@chmod 755 ${DESTDIR}${PREFIX}/bin/wdmenu_run
	@chmod 755 ${DESTDIR}${PREFIX}/bin/lsx

uninstall:
	@echo removing executables from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/wdmenu
	@rm -f ${DESTDIR}${PREFIX}/bin/wdmenu_run
	@rm -f ${DESTDIR}${PREFIX}/bin/lsx

.PHONY: all options clean dist install uninstall
