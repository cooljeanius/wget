dnl# Wget-specific Autoconf macros.
dnl# Copyright (C) 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003,
dnl# 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011 Free Software
dnl# Foundation, Inc.

dnl# This program is free software; you can redistribute it and/or modify
dnl# it under the terms of the GNU General Public License as published by
dnl# the Free Software Foundation; either version 3 of the License, or
dnl# (at your option) any later version.

dnl# This program is distributed in the hope that it will be useful,
dnl# but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl# GNU General Public License for more details.

dnl# You should have received a copy of the GNU General Public License
dnl# along with this program.  If not, see <http://www.gnu.org/licenses/>.

dnl# Additional permission under GNU GPL version 3 section 7

dnl# If you modify this program, or any covered work, by linking or
dnl# combining it with the OpenSSL project's OpenSSL library (or a
dnl# modified version of that library), containing parts covered by the
dnl# terms of the OpenSSL or SSLeay licenses, the Free Software Foundation
dnl# grants you additional permission to convey the resulting work.
dnl# Corresponding Source for a non-source form of such a combination
dnl# shall include the source code for the parts of OpenSSL used as well
dnl# as that of the covered work.

dnl#
dnl# Check for `struct utimbuf'.
dnl#

AC_DEFUN([WGET_STRUCT_UTIMBUF],[
  AC_CHECK_HEADERS_ONCE([stdio.h sys/types.h utime.h])
  AC_CHECK_TYPES([struct utimbuf],[],[],[
#include <stdio.h>
#if HAVE_SYS_TYPES_H
# include <sys/types.h>
#endif
#if HAVE_UTIME_H
# include <utime.h>
#endif
  ])
])

dnl# Check whether fnmatch.h can be included.  This doesn't use
dnl# AC_FUNC_FNMATCH because Wget is already careful to only use
dnl# fnmatch on certain OS'es.  However, fnmatch.h is sometimes broken
dnl# even on those because Apache installs its own fnmatch.h to
dnl# /usr/local/include (!), which GCC uses before /usr/include.

AC_DEFUN([WGET_FNMATCH],[
  AC_CHECK_HEADERS_ONCE([fnmatch.h])
  AC_MSG_CHECKING([for working fnmatch.h])
  AC_COMPILE_IFELSE([AC_LANG_SOURCE([[#include <fnmatch.h>
                    ]])],[
    AC_MSG_RESULT([yes])
    AC_DEFINE([HAVE_WORKING_FNMATCH_H],[1],
              [Define if fnmatch.h can be included.])
  ],[
    AC_MSG_RESULT([no])
  ])
])

dnl# Check for nanosleep.  For nanosleep to work on Solaris, we must
dnl# link with -lrt (recently) or with -lposix4 (older releases).

AC_DEFUN([WGET_NANOSLEEP],[
  AC_CHECK_FUNCS([nanosleep],[],[
    AC_CHECK_LIB([rt],[nanosleep],[
      AC_DEFINE([HAVE_NANOSLEEP],[1],
                [Define if you have the nanosleep function.])
      LIBS="-lrt $LIBS"
    ],[
      AC_CHECK_LIB([posix4],[nanosleep],[
	AC_DEFINE([HAVE_NANOSLEEP],[1],
		  [Define if you have the nanosleep function.])
	LIBS="-lposix4 $LIBS"
      ])
    ])
  ])
])

AC_DEFUN([WGET_POSIX_CLOCK],[
  AC_CHECK_FUNCS([clock_gettime],[],[
    AC_CHECK_LIB([rt],[clock_gettime])
  ])
])

dnl# Check whether we need to link with -lnsl and -lsocket, as is the
dnl# case on e.g. Solaris.

AC_DEFUN([WGET_NSL_SOCKET],[
  dnl# On Solaris, -lnsl is needed to use gethostbyname.  But checking
  dnl# for gethostbyname is not enough because on "NCR MP-RAS 3.0"
  dnl# gethostbyname is in libc, but -lnsl is still needed to use
  dnl# -lsocket, as well as for functions such as inet_ntoa.  We look
  dnl# for such known offenders and if one of them is not found, we
  dnl# check if -lnsl is needed.
  wget_check_in_nsl=NONE
  AC_CHECK_FUNCS([gethostbyname],[HAVE_GETHOSTBYNAME="1"],[
    wget_check_in_nsl=gethostbyname
  ])
  AC_CHECK_FUNCS([inet_ntoa],[HAVE_INET_NTOA="1"],[
    wget_check_in_nsl=inet_ntoa
  ])
  if test $wget_check_in_nsl != NONE; then
    AC_CHECK_LIB([nsl],[$wget_check_in_nsl],[
                  HAVE_GETHOSTBYNAME="1"
                  LIBS="$LIBS -lnsl"])
  fi
  AC_CHECK_LIB([socket],[socket],[],[
                if test "$HAVE_GETHOSTBYNAME" != "1"
                then
                  dnl# gethostbyname in the socket lib?
                  AC_CHECK_LIB([socket],[gethostbyname],[
                                HAVE_GETHOSTBYNAME="1"
                                LIBS="$LIBS -lsocket"])
                fi])

  if test "$HAVE_GETHOSTBYNAME" != "1"
  then
    dnl# gethostbyname in the watt lib?
    AC_CHECK_LIB([watt],[gethostbyname],[
                  HAVE_GETHOSTBYNAME="1"
                  CPPFLAGS="-I/dev/env/WATT_ROOT/inc"
                  LDFLAGS="-L/dev/env/WATT_ROOT/lib"
                  LIBS="$LIBS -lwatt"])
  fi

  dnl# At least one system has been identified to require BOTH nsl and
  dnl# socket libs at the same time to link properly.
  if test "$HAVE_GETHOSTBYNAME" != "1"
  then
    AC_MSG_CHECKING([for gethostbyname with both nsl and socket libs])
    my_ac_save_LIBS=$LIBS
    LIBS="-lnsl -lsocket $LIBS"
    AC_LANG_PUSH([C])
    AC_LINK_IFELSE([
      AC_LANG_PROGRAM([[
      ]],[[
        gethostbyname();
      ]])
    ],[
      AC_MSG_RESULT([yes])
      HAVE_GETHOSTBYNAME="1"
    ],[
      AC_MSG_RESULT([no])
      LIBS=$my_ac_save_LIBS
    ])
    AC_LANG_POP
  fi

  if test "$HAVE_GETHOSTBYNAME" != "1"
  then
    dnl# This is for winsock systems
    AC_CHECK_HEADERS_ONCE([windows.h winsock.h winsock2.h])
    if test "$ac_cv_header_windows_h" = "yes"; then
      if test "$ac_cv_header_winsock_h" = "yes"; then
        case $host in
          *-*-mingw32ce*)
            winsock_LIB="-lwinsock"
            ;;
          *)
            winsock_LIB="-lwsock32"
            ;;
        esac
      fi
      if test "$ac_cv_header_winsock2_h" = "yes"; then
        winsock_LIB="-lws2_32"
      fi
      if test ! -z "$winsock_LIB"; then
        my_ac_save_LIBS=$LIBS
        LIBS="$winsock_LIB $LIBS"
        AC_MSG_CHECKING([for gethostbyname in $winsock_LIB])
        AC_LANG_PUSH([C])
        AC_LINK_IFELSE([
          AC_LANG_PROGRAM([[
#ifdef HAVE_WINDOWS_H
#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif
#include <windows.h>
#ifdef HAVE_WINSOCK2_H
#include <winsock2.h>
#else
#ifdef HAVE_WINSOCK_H
#include <winsock.h>
#endif
#endif
#endif
          ]],[[
            gethostbyname("www.dummysite.com");
          ]])
        AC_LANG_POP
        ],[
          AC_MSG_RESULT([yes])
          HAVE_GETHOSTBYNAME="1"
        ],[
          AC_MSG_RESULT([no])
          winsock_LIB=""
          LIBS=$my_ac_save_LIBS
        ])
      fi
    fi
  fi

  if test "$HAVE_GETHOSTBYNAME" != "1"
  then
    dnl# This is for Minix 3.1
    AC_CHECK_HEADERS_ONCE([netdb.h net/gen/netdb.h])
    AC_MSG_CHECKING([for gethostbyname for Minix 3])
    AC_LANG_PUSH([C])
    AC_LINK_IFELSE([
      AC_LANG_PROGRAM([[
/* Older Minix versions may need <net/gen/netdb.h> here instead */
#include <netdb.h>
      ]],[[
        gethostbyname("www.dummysite.com");
      ]])
    AC_LANG_POP
    ],[
      AC_MSG_RESULT([yes])
      HAVE_GETHOSTBYNAME="1"
    ],[
      AC_MSG_RESULT([no])
    ])
  fi

  if test "$HAVE_GETHOSTBYNAME" != "1"
  then
    dnl# This is for eCos with a stubbed DNS implementation
    AC_CHECK_HEADERS_ONCE([netdb.h stdio.h])
    AC_MSG_CHECKING([for gethostbyname for eCos])
    AC_LANG_PUSH([C])
    AC_LINK_IFELSE([
      AC_LANG_PROGRAM([[
#include <stdio.h>
#include <netdb.h>
      ]],[[
        gethostbyname("www.dummysite.com");
      ]])
    AC_LANG_POP([C])
    ],[
      AC_MSG_RESULT([yes])
      HAVE_GETHOSTBYNAME="1"
    ],[
      AC_MSG_RESULT([no])
    ])
  fi

  if test "$HAVE_GETHOSTBYNAME" != "1"
  then
    dnl# gethostbyname in the network lib - for Haiku OS
    AC_CHECK_LIB([network],[gethostbyname],[
                  HAVE_GETHOSTBYNAME="1"
                  LIBS="$LIBS -lnetwork"])
  fi

  if test "$HAVE_GETHOSTBYNAME" != "1"
  then
    dnl# gethostbyname in the net lib - for BeOS
    AC_CHECK_LIB([net],[gethostbyname],[
                  HAVE_GETHOSTBYNAME="1"
                  LIBS="$LIBS -lnet"])
  fi

  if test "$HAVE_GETHOSTBYNAME" != "1"; then
    AC_MSG_WARN([could not find libraries for gethostbyname()])
  fi
])


dnl#************************************************************
dnl# START OF IPv6 AUTOCONFIGURATION SUPPORT MACROS
dnl#************************************************************

AC_DEFUN([TYPE_STRUCT_SOCKADDR_IN6],[
  wget_have_sockaddr_in6=
  AC_CHECK_HEADERS_ONCE([sys/types.h sys/socket.h netinet/in.h \
                         winsock2.h ws2tcpip.h])
  AC_CHECK_TYPES([struct sockaddr_in6],[
    wget_have_sockaddr_in6=yes
  ],[
    wget_have_sockaddr_in6=no
  ],[
#include <sys/types.h>
#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif
#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif
#ifdef HAVE_WINSOCK2_H
#include <winsock2.h>
#endif
#ifdef HAVE_WS2TCPIP_H
#include <ws2tcpip.h>
#endif
  ])

  if test "X$wget_have_sockaddr_in6" = "Xyes"; then :
    $1
  else :
    $2
  fi
])


AC_DEFUN([MEMBER_SIN6_SCOPE_ID],[
  AC_REQUIRE([TYPE_STRUCT_SOCKADDR_IN6])

  wget_member_sin6_scope_id=
  if test "X$wget_have_sockaddr_in6" = "Xyes"; then
    AC_CHECK_HEADERS_ONCE([sys/types.h sys/socket.h netinet/in.h \
                           winsock2.h ws2tcpip.h])
    AC_CHECK_MEMBER([struct sockaddr_in6.sin6_scope_id],[
      wget_member_sin6_scope_id=yes
    ],[
      wget_member_sin6_scope_id=no
    ],[
#include <sys/types.h>
#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif
#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif
#ifdef HAVE_WINSOCK2_H
#include <winsock2.h>
#endif
#ifdef HAVE_WS2TCPIP_H
#include <ws2tcpip.h>
#endif
    ])
  fi

  if test "X$wget_member_sin6_scope_id" = "Xyes"; then
    AC_DEFINE([HAVE_SOCKADDR_IN6_SCOPE_ID],[1],
      [Define if struct sockaddr_in6 has the sin6_scope_id member])
    $1
  else :
    $2
  fi
])


AC_DEFUN([PROTO_INET6],[
  AC_REQUIRE([AC_PROG_CPP])
  AC_CHECK_HEADERS_ONCE([sys/types.h sys/socket.h netinet/in.h \
                         winsock2.h ws2tcpip.h])
  AC_CHECK_DECLS([PF_INET6])
  AC_CHECK_DECLS([AF_INET6])
  AC_CACHE_CHECK([for INET6 protocol support],[wget_cv_proto_inet6],[
    AC_TRY_CPP([
#include <sys/types.h>
#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif
#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif
#ifdef HAVE_WINSOCK2_H
#include <winsock2.h>
#endif
#ifdef HAVE_WS2TCPIP_H
#include <ws2tcpip.h>
#endif
#ifndef PF_INET6
#error Missing PF_INET6
#endif
#ifndef AF_INET6
#error Missing AF_INET6
#endif
    ],[
      wget_cv_proto_inet6=yes
    ],[
      wget_cv_proto_inet6=no
    ])
  ])

  if test "X$wget_cv_proto_inet6" = "Xyes"; then :
    $1
  else :
    $2
  fi
  AC_MSG_CHECKING([for ipv6 enable-age])
  AC_LANG_PUSH([C])
  AC_RUN_IFELSE([AC_LANG_SOURCE([[ /* is AF_INET6 available? */
#include <sys/types.h>
#include <sys/socket.h>
main()
{
 if (socket(AF_INET6, SOCK_STREAM, 0) < 0)
   exit(1);
 else
   exit(0);
}
  ]])],[
  AC_MSG_RESULT([yes])
  ipv6=yes],[AC_MSG_RESULT([no])
  ipv6=no],[AC_MSG_RESULT([no])
  ipv6=no])
  AC_LANG_POP
])


AC_DEFUN([WGET_STRUCT_SOCKADDR_STORAGE],[
  AC_CHECK_HEADERS_ONCE([sys/types.h sys/socket.h winsock2.h])
  AC_CHECK_TYPES([struct sockaddr_storage],[],[],[
#include <sys/types.h>
#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif
#ifdef HAVE_WINSOCK2_H
#include <winsock2.h>
#endif
  ])
  AC_CHECK_HEADERS_ONCE([netinet/in.h])
  AC_MSG_CHECKING([if struct sockaddr_in6 has sin6_scope_id member])
  AC_LANG_PUSH([C])
  AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
#include <sys/types.h>
#include <netinet/in.h> ]],[[struct sockaddr_in6 s; s.sin6_scope_id = 0; ]])],[have_sin6_scope_id=yes],[])
  if test "$have_sin6_scope_id" = yes; then
    AC_MSG_RESULT([yes])
    AC_DEFINE([HAVE_SOCKADDR_IN6_SIN6_SCOPE_ID],[1],[Define to 1 if struct sockaddr_in6 has the sin6_scope_id member])
  else
    AC_MSG_RESULT([no])
  fi
  AC_LANG_POP
])

dnl#************************************************************
dnl# END OF IPv6 AUTOCONFIGURATION SUPPORT MACROS
dnl#************************************************************

dnl# AM_PATH_PROG_WITH_TEST([VARIABLE],[PROG-TO-CHECK-FOR],
dnl#   [TEST-PERFORMED-ON-FOUND_PROGRAM],[VALUE-IF-NOT-FOUND],[PATH])
AC_DEFUN([AM_PATH_PROG_WITH_TEST],[
dnl# Extract the first word of "$2", so it can be a program name with args.
set dummy $2; ac_word=[$]2
AC_MSG_CHECKING([for $ac_word])
AC_CACHE_VAL([ac_cv_path_$1],
[case "[$]$1" in
  /*)
  ac_cv_path_$1="[$]$1" # Let the user override the test with a path.
  ;;
  *)
  IFS="${IFS= 	}"; ac_save_ifs="$IFS"; IFS="${IFS}:"
  for ac_dir in ifelse([$5], , $PATH, [$5]); do
    test -z "$ac_dir" && ac_dir=.
    if test -f $ac_dir/$ac_word; then
      if [$3]; then
	ac_cv_path_$1="$ac_dir/$ac_word"
	break
      fi
    fi
  done
  IFS="$ac_save_ifs"
dnl# If no 4th arg is given, leave the cache variable unset,
dnl# so AC_PATH_PROGS will keep looking.
ifelse([$4],[],[],[  test -z "[$]ac_cv_path_$1" && ac_cv_path_$1="$4"
])dnl
  ;;
esac])dnl
$1="$ac_cv_path_$1"
if test -n "[$]$1"; then
  AC_MSG_RESULT([$]$1)
else
  AC_MSG_RESULT([no])
fi
AC_SUBST([$1])dnl
])

