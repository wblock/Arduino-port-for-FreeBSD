# $FreeBSD: head/devel/arduino/Makefile 301609 2012-07-27 12:58:30Z scheidell $

PORTNAME=	arduino
PORTVERSION=	1.0.1
PORTREVISION=	2
PORTEPOCH=	1
CATEGORIES=	devel java lang
MASTER_SITES=	GOOGLE_CODE
DISTNAME=	${PORTNAME}-${PORTVERSION}-linux
EXTRACT_SUFX=	.tgz

MAINTAINER=	wblock@freebsd.org
COMMENT=	Open-source electronics prototyping platform

RUN_DEPENDS=	${JAVA_HOME}/jre/lib/ext/RXTXcomm.jar:${PORTSDIR}/comms/rxtx \
		${LOCALBASE}/bin/avrdude:${PORTSDIR}/devel/avrdude \
		${LOCALBASE}/avr/include/avr/io.h:${PORTSDIR}/devel/avr-libc

WRKSRC=		${WRKDIR}/${PORTNAME}-${PORTVERSION}
USE_DOS2UNIX=	yes

USE_JAVA=	1.6+
NO_BUILD=	yes
USE_LDCONFIG=	${PREFIX}/arduino/lib

SUB_FILES=	arduino pkg-message
SUB_LIST=	PORTNAME=${PORTNAME}

REINPLACE_ARGS=	-i ""

DESKTOP_ENTRIES=	"Arduino" "Arduino IDE" \
			${PREFIX}/${PORTNAME}/logo.png \
			"arduino" "Development;IDE;" "false"

OPTIONS_DEFINE+=	ATMEGA644 DOCS EXAMPLES
ATMEGA644_DESC=	 	Patch boards.txt adding ATmega644 values
DOCS_DESC=	 	Install the reference documents

INSLIST=	arduino hardware lib libraries logo.png revisions.txt tools

.include <bsd.port.options.mk>

.if ${PORT_OPTIONS:MATMEGA644}
EXTRA_PATCHES+=	${FILESDIR}/extrapatch-hardware-arduino-boards.txt
.endif

.if empty(PORT_OPTIONS:MDOCS)
PLIST_SUB+=	REFDOCS="@comment "
.else
PLIST_SUB+=	REFDOCS=""
INSLIST+=	reference
.endif

.if empty(PORT_OPTIONS:MEXAMPLES)
PLIST_SUB+=	EXAMPLES="@comment "
FIND_EXCLUDE=	"! -path */examples ! -path */examples/* -prune"
.else
PLIST_SUB+=	EXAMPLES=""
FIND_EXCLUDE=
INSLIST+=	examples
.endif

post-patch:
	@${RM} ${WRKSRC}/hardware/arduino/bootloaders/atmega8/ATmegaBOOT.c.orig
	@${RM} ${WRKSRC}/hardware/arduino/cores/arduino/HardwareSerial.cpp.orig
.if ${PORT_OPTIONS:MATMEGA644}
	@${RM} ${WRKSRC}/hardware/arduino/boards.txt.orig
.endif
	@${RM} -rf ${WRKSRC}/hardware/tools/
	@${RMDIR} ${WRKSRC}/hardware/arduino/firmwares/arduino-usbserial/.dep
	@${MKDIR} ${WRKSRC}/hardware/tools/avr/
	@${LN} -s ${PREFIX}/bin ${WRKSRC}/hardware/tools/avr/bin
	@${LN} -s ${PREFIX}/etc ${WRKSRC}/hardware/tools/avr/etc

	@${RM} ${WRKSRC}/lib/RXTXcomm.jar
	@${LN} -s ${JAVA_HOME}/lib/ext/RXTXcomm.jar ${WRKSRC}/lib/RXTXcomm.jar

	@${MV} ${WRKSRC}/reference/img/logo.png ${WRKSRC}/
	@${RM} -rf ${WRKSRC}/reference/img/

do-install:
	@${MKDIR} ${PREFIX}/${PORTNAME}
	@(cd ${WRKSRC}/ && ${COPYTREE_SHARE} "${INSLIST}" ${PREFIX}/${PORTNAME} ${FIND_EXCLUDE})
	@${INSTALL_SCRIPT} ${WRKDIR}/arduino ${PREFIX}/bin/

post-install:
	@${CAT} ${PKGMESSAGE}

.include <bsd.port.mk>
