dnl# wget/confiugre.ac                                    -*- Autoconf -*-
dnl# Template file for GNU Autoconf
dnl# Copyright (C) 1995, 1996, 1997, 2001, 2007, 2008, 2009, 2010, 2011
dnl# Free Software Foundation, Inc.

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
dnl# Process this file with autoconf to produce a configure script.
dnl#

AC_INIT([wget],[m4_esyscmd(build-aux/git-version-gen .tarball-version)],
        [bug-wget@gnu.org])dnl
AC_PREREQ([2.69])dnl
AC_SUBST([PACKAGE_NAME])dnl
AC_SUBST([PACKAGE_VERSION])dnl
AS_IF([test "x${VERSION}" != "x"],[dnl
	test ! -z "${VERSION}"
	AC_SUBST([VERSION])dnl
],[dnl
	AS_IF([test "x${PACKAGE_VERSION}" != "x"],[dnl
		test ! -z "${PACKAGE_VERSION}"
		test -z "${VERSION}" && export VERSION="${PACKAGE_VERSION}"
		test ! -z "${VERSION}"
		AC_SUBST([VERSION])dnl
	])dnl
])dnl

dnl#
dnl# What version of Wget are we building?
dnl#
AC_MSG_NOTICE([configuring for GNU Wget ${PACKAGE_VERSION}])dnl

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_AUX_DIR([build-aux])dnl

AC_CONFIG_SRCDIR([src/wget.h])dnl

dnl#
dnl# Get cannonical host (called by finding the target)
dnl#
AC_MSG_CHECKING([system])
AC_MSG_RESULT([ ])
AC_CANONICAL_TARGET
AC_DEFINE_UNQUOTED([OS_TYPE],["${host_os}"],
                   [Define to be the name of the operating system.])dnl

dnl# other system-related checks
AC_OBJEXT
AC_EXEEXT
AC_USE_SYSTEM_EXTENSIONS
AC_SEARCH_LIBS([strerror],[cposix])dnl

dnl# Check for large file support. This check needs to come fairly
dnl# early because it could (in principle) affect whether functions and
dnl# headers are available, whether they work, etc.
AC_SYS_LARGEFILE
AC_CHECK_SIZEOF([off_t])
AC_CHECK_ALIGNOF([off_t])dnl

dnl# Deal with specific hosts
case ${host_os} in
  *mingw32* )
    dnl# FIXME: Replace `main' with a function in `-lws2_32':
    AC_CHECK_LIB([ws2_32],[main])
    LIBS+=' -lws2_32'
    AC_LIBOBJ([mswindows])
    ;;
esac

case ${host} in
  *msdosdjgpp)
     ac_cv_func_pipe=no
     skipcheck_pipe=yes
     AC_MSG_NOTICE([skip check for pipe on msdosdjgpp])
    ;;
esac

dnl#
dnl# Automake setup
dnl#
AC_MSG_CHECKING([automake stuff])
AC_MSG_RESULT([ ])
AM_INIT_AUTOMAKE([1.9 dejagnu dist-bzip2 dist-lzip dist-xz dist-zip gnu tar-ustar -Wall -Wno-portability -Wno-obsolete -Wno-override])
AM_MAINTAINER_MODE
AM_SANITY_CHECK
AM_MAKE_INCLUDE

dnl#
dnl# Process features.
dnl#

AC_ARG_WITH([ssl],
[AS_HELP_STRING([--with-ssl={gnutls,openssl}],
                [specify the SSL backend. GNU TLS is the default.])])dnl

AC_ARG_WITH([zlib],
[AS_HELP_STRING([--without-zlib],[disable zlib])])dnl

AC_ARG_ENABLE([opie],
[AS_HELP_STRING([--disable-opie],[disable support for opie or s/key FTP login])],
[ENABLE_OPIE=$enableval],[ENABLE_OPIE=yes])
test x"${ENABLE_OPIE}" = xyes && AC_DEFINE([ENABLE_OPIE],[1],
   [Define if you want the Opie support for FTP compiled in.])dnl

AC_ARG_ENABLE([digest],
[AS_HELP_STRING([--disable-digest],
                [disable support for HTTP digest authorization])],
[ENABLE_DIGEST=${enableval}],[ENABLE_DIGEST=yes])
test x"${ENABLE_DIGEST}" = x"yes" && AC_DEFINE([ENABLE_DIGEST],[1],
   [Define if you want the HTTP Digest Authorization compiled in.])dnl

AC_ARG_ENABLE([ntlm],
[AS_HELP_STRING([--disable-ntlm],[disable support for NTLM authorization])],[ENABLE_NTLM=${enableval}],[ENABLE_NTLM=auto])dnl

AC_ARG_ENABLE([debug],
[AS_HELP_STRING([--disable-debug],[disable support for debugging output])],[ENABLE_DEBUG=${enableval}],[ENABLE_DEBUG=yes])
test x"${ENABLE_DEBUG}" = x"yes" && AC_DEFINE([ENABLE_DEBUG],[1],
   [Define if you want the debug output support compiled in.])dnl

dnl#
dnl# Find the compiler
dnl#

AC_MSG_CHECKING([compilers])
AC_MSG_RESULT([ ])

dnl# We want these before the checks, so that the checks can modify
dnl# their values.
test -z "${CFLAGS}" && CFLAGS= auto_cflags=1
test -z "${CC}" && cc_specified=yes

AS_IF([test "x${CC}" = "x"],[dnl
	test -z "${CC}"
	AC_PROG_CC
	if test "x${CC_C_O}" = "x"; then
		test -z "${CC_C_O}"
		AM_PROG_CC_C_O
	fi
],[dnl
	test ! -z "${CC}" && export CC
	AC_SUBST([CC])dnl
])dnl

gl_EARLY

AC_PROG_CXX
AC_PROG_CXXCPP
AC_PROG_GCC_TRADITIONAL
AM_PROG_LEX
AC_PROG_YACC

dnl# Turn on optimization by default.  Specifically:
dnl#
dnl# if the user has NOT specified CFLAGS, then
dnl#   if compiler is gcc, then
dnl#     use -O2 and some warning flags
dnl#   else
dnl#     use os-specific flags or -O
if test -n "${auto_cflags}"; then
  if test -n "${GCC}"; then
    CFLAGS="${CFLAGS} -O2 -Wall"
  else
    case "${host_os}" in
      *hpux*)  CFLAGS="${CFLAGS} +O3"                      ;;
      *ultrix* | *osf*) CFLAGS="${CFLAGS} -O -Olimit 2000" ;;
      *)       CFLAGS="${CFLAGS} -O" ;;
    esac
  fi
fi

AC_MSG_CHECKING([for other programs])
AC_MSG_RESULT([ ])
AM_PROG_AR
AC_PROG_LN_S
AC_PROG_MKDIR_P
AM_MISSING_PROG([GIT],[git])
AM_MISSING_PROG([RSYNC],[rsync])dnl

AS_IF([test "x${RANLIB}" = "x"],[dnl
	test -z "${RANLIB}"
	AC_PROG_RANLIB
],[dnl
	test ! -z "${RANLIB}" && export RANLIB
	AC_SUBST([RANLIB])dnl
])dnl

AS_IF([test "x${SED}" = "x"],[dnl
	test -z "${SED}"
	AC_PROG_SED
],[dnl
	test ! -z "${SED}" && export SED
	AC_SUBST([SED])dnl
])dnl

dnl#
dnl# Gettext
dnl#
AC_MSG_CHECKING([gettext stuff])
AC_MSG_RESULT([ ])
AM_GNU_GETTEXT([external],[need-ngettext])
AM_GNU_GETTEXT_VERSION([0.18.3])
AC_SUBST([CHARSETALIASDIR])dnl

dnl#
dnl# Checks for basic C compiler characteristics.
dnl#
AC_MSG_CHECKING([basic C compiler characteristics])
AC_MSG_RESULT([ ])
AC_C_BIGENDIAN
AC_C_CONST
AC_C_INLINE
AC_C_PROTOTYPES
AC_C_RESTRICT
AC_C_VOLATILE
AC_C__GENERIC
AX_C___ATTRIBUTE__

dnl# AC_HEADER_STDC is called by other macros, so it is no longer
dnl# necessary to call it separately
dnl# We can use a hack to "require" it though
AC_DEFUN([AC_REQUIRE_HEADER_STDC],[
  AC_REQUIRE([AC_HEADER_STDC])dnl
])dnl
AC_REQUIRE_HEADER_STDC

dnl#
dnl# Checks for system header files that might be missing.
dnl#
AC_MSG_CHECKING([for system header files that might be missing])
AC_MSG_RESULT([ ])
AC_HEADER_MAJOR
AC_HEADER_STAT
AC_HEADER_STDBOOL dnl# calls "AC_CHECK_HEADER_STDBOOL"
AC_SUBST([ac_cv_header_stdbool_h])dnl
AC_HEADER_SYS_WAIT
AC_HEADER_TIME
AC_CHECK_HEADERS([_Noreturn.h OS.h argz.h arg-nonnull.h arpa/inet.h \
                  c++defs.h ctype.h endian.h fcntl.h fenv.h float.h \
                  fs_info.h langinfo.h libc-config.h limits.h locale.h \
                  mach/mach.h math.h malloc.h malloc/malloc.h memcopy.h \
                  mntent.h mnttab.h netdb.h nl_types.h nlist.h pwd.h regex.h \
                  signal.h stddef.h stdio.h stdio_ext.h sys/acl.h sys/file.h \
                  sys/filsys.h sys/fs/s5param.h sys/fs_types.h sys/fstyp.h \
                  sys/ioctl.h sys/mntent.h sys/mount.h sys/param.h sys/socket.h \
                  sys/statfs.h sys/statvfs.h sys/systeminfo.h sys/time.h \
                  sys/timeb.h sys/vfs.h sys/utime.h termio.h termios.h time.h \
                  utime.h utmp.h utmpx.h warn-on-use.h wchar.h wctype.h])dnl

if test "x${ac_cv_header_inttypes_h}" = "x"; then
  test -z "${ac_cv_header_inttypes_h}"
  AC_CHECK_HEADERS([inttypes.h])
fi
if test "x${ac_cv_header_strings_h}" = "x"; then
  test -z "${ac_cv_header_strings_h}"
  AC_CHECK_HEADERS([strings.h])
fi
if test "x${ac_cv_header_unistd_h}" = "x"; then
  test -z "${ac_cv_header_unistd_h}"
  AC_CHECK_HEADERS([unistd.h])
fi

AC_CHECK_DECLS([h_errno],[],[],[#include <netdb.h>])dnl

dnl#
dnl# Check sizes of integer types.  These are used to find n-bit
dnl# integral types on older systems that fail to provide intN_t and
dnl# uintN_t typedefs.
dnl#
AC_MSG_CHECKING([size and alignment of integer types])
AC_MSG_RESULT([ ])
AC_CHECK_SIZEOF([short])
AC_CHECK_ALIGNOF([short])
AC_CHECK_SIZEOF([int])
AC_CHECK_ALIGNOF([int])
AC_CHECK_SIZEOF([long])
AC_CHECK_ALIGNOF([long])
AC_CHECK_SIZEOF([long long])
AC_CHECK_ALIGNOF([long long])
AC_CHECK_SIZEOF([void *])
AC_CHECK_ALIGNOF([void *])dnl

dnl#
dnl# Checks for non-universal or system-specific types.
dnl#
AC_MSG_CHECKING([non-universal and system-specific types])
AC_MSG_RESULT([ ])
# check for bool type
AC_CHECK_TYPE([bool],[
  AC_DEFINE([HAVE_BOOL_T],[1],
    [Define to 1 if bool is an available type.])dnl
],[],[
#ifdef HAVE_SYS_TYPES_H
# include <sys/types.h>
#else
# if defined(__GNUC__) && !defined(__STRICT_ANSI__)
#  warning "conftest for bool expects <sys/types.h> to be included."
# endif /* __GNUC__ && !__STRICT_ANSI__ */
#endif /* HAVE_SYS_TYPES_H */
#ifdef HAVE_STDBOOL_H
# include <stdbool.h>
#else
# if defined(__GNUC__) && !defined(__STRICT_ANSI__)
#  warning "conftest for bool expects <stdbool.h> to be included."
# endif /* __GNUC__ && !__STRICT_ANSI__ */
#endif /* HAVE_STDBOOL_H */
])
AC_TYPE_SIZE_T
AC_CHECK_SIZEOF([size_t])
AC_CHECK_ALIGNOF([size_t])
# check for ssize_t
AC_CHECK_TYPE([ssize_t],[dnl
    AC_SUBST([ssize_t])dnl
    test -n "${ssize_t}" && export ssize_t
],[dnl
    AC_CHECK_DECLS([int])dnl
    AC_DEFINE([ssize_t],[int],[the signed version of size_t])dnl
    AC_SUBST([ssize_t],[int])dnl
])dnl
  ## don't do AS_IF for this one; it breaks the following off_t test:
if test "x${ssize_t}" = "x"; then
	test -z "${ssize_t}"
	AC_TYPE_SSIZE_T
fi
AC_TYPE_OFF_T
# size and alignment of off_t are checked above
AC_TYPE_PID_T
AC_TYPE_UID_T
AC_TYPE_INT8_T
AC_TYPE_INT16_T
AC_TYPE_INT32_T
AC_TYPE_INT64_T
AC_CHECK_TYPES([intptr_t])
AC_TYPE_MODE_T
AC_CHECK_SIZEOF([time_t])
AC_CHECK_ALIGNOF([time_t])
AC_TYPE_UINT8_T
AC_TYPE_UINT16_T
AC_TYPE_UINT32_T
AC_TYPE_UINT64_T
AC_CHECK_TYPES([uintptr_t])
AC_CHECK_TYPES([ptrdiff_t])
AC_CHECK_TYPES([sig_atomic_t],[],[],[
#include <stdio.h>
#include <sys/types.h>
#if HAVE_INTTYPES_H
# include <inttypes.h>
#else
# if defined(__GNUC__) && !defined(__STRICT_ANSI__)
#  warning "conftest for sig_atomic_t expects <inttypes.h> to be included."
# endif /* __GNUC__ && !__STRICT_ANSI__ */
#endif /* HAVE_INTTYPES_H */
#include <signal.h>
])dnl
AC_CHECK_TYPE([long long],
   [AC_DEFINE([HAVE_LONGLONG],[1],
      [Define to 1 if the compiler supports the 'long long' data type.])
   longlong="yes"])dnl

if test "xyes" = "x${longlong}"; then
  if test "x${SIZEOF_LONG_LONG}" = "x"; then
    test -z "${SIZEOF_LONG_LONG}"
    AC_CHECK_SIZEOF([long long])
  fi
  AC_MSG_CHECKING([if numberLL works])
  AC_LANG_PUSH([C])
  AC_COMPILE_IFELSE([
    AC_LANG_PROGRAM([[
    ]],[[
      long long val = 1000LL;
    ]])dnl
  ],[dnl
    AC_MSG_RESULT([yes])dnl
    AC_DEFINE([HAVE_LL],[1],[if your compiler supports LL])dnl
  ],[dnl
    AC_MSG_RESULT([no])dnl
  ]) ## (allow newline)
  AC_LANG_POP
fi


dnl#
dnl# Checks for structs and members
dnl#

AC_MSG_CHECKING([structs and members])
AC_MSG_RESULT([ ])
AC_CHECK_MEMBERS([struct stat.st_blksize])
AC_STRUCT_ST_BLOCKS
AC_CHECK_MEMBERS([struct stat.st_rdev])
AC_STRUCT_TIMEZONE dnl# calls "AC_STRUCT_TM"
AC_CHECK_MEMBERS([struct sockaddr_in6.sin6_scope_id])dnl

# gnulib
AC_MSG_CHECKING([gnulib stuff])
AC_MSG_RESULT([ ])
gl_INIT

dnl#
dnl# Checks for library functions.
dnl#
AC_MSG_CHECKING([functions])
AC_MSG_RESULT([ ])
AC_FUNC_ALLOCA
AC_FUNC_CHOWN
AC_FUNC_ERROR_AT_LINE
AC_FUNC_FORK
AC_FUNC_FSEEKO
AC_FUNC_GETGROUPS
AC_FUNC_GETMNTENT
AC_FUNC_LSTAT dnl# calls "AC_FUNC_LSTAT_FOLLOWS_SLASHED_SYMLINK"
AC_FUNC_MALLOC
AC_FUNC_MBRTOWC
AC_FUNC_MEMCMP
AC_FUNC_MKTIME
AC_FUNC_MMAP
AC_FUNC_OBSTACK
AC_FUNC_REALLOC
AC_FUNC_SELECT_ARGTYPES
AC_FUNC_STAT
AC_FUNC_STRCOLL
AC_FUNC_STRERROR_R
AC_FUNC_STRNLEN
AC_FUNC_STRTOD
AC_FUNC_UTIME_NULL
AC_FUNC_VPRINTF
AC_CHECK_FUNCS([__argz_count __argz_next __argz_stringify __fpending acl \
                alarm atexit btowc drand48 dup2 endgrent endpwent \
                euidaccess fchdir fdatasync floor fs_stat_dev ftello \
                ftruncate getcwd getwd getdelim gethostname gethrtime \
                getmntent getmntinfo getpass gettimeofday getusershell \
                hasmntopt isascii iswprint lchown listmntent localeconv \
                localtime_r mblen mbrlen mbtowc memchr memmove mempcpy \
                memrchr memset mkdir mkfifo modf munmap next next_dev \
                nl_langinfo pathconf pow printf pstat_getdynamic putenv \
                re_comp regcomp rint rmdir rpmatch select setenv \
                sethostname setlocale sigblock sigsetjmp socket sleep \
                sqrt stime stpcpy strchr strcspn strdup strerror strndup \
                strpbrk strptime strrchr strspn strstr strtol strtoll \
                strtoul strtoull strtoumax strverscmp symlink sysinfo \
                system timegm tzset uname usleep utime vasprintf \
                vsnprintf wcwidth])dnl

if test x"${ENABLE_OPIE}" = x"yes"; then
  AC_LIBOBJ([ftp-opie])
fi

if test "x${ac_cv_func_getpagesize}" = "x"; then
  test -z "${ac_cv_func_getpagesize}"
  AC_CHECK_FUNCS([getpagesize])
fi

dnl# resolve lib?
AC_CHECK_FUNC([strcasecmp],[],[AC_CHECK_LIB([resolve],[strcasecmp])])dnl

if test "x${ac_cv_lib_resolve_strcasecmp}" = "x${ac_cv_func_strcasecmp}"; then
  AC_CHECK_LIB([resolve],[strcasecmp],
               [LIBS="-lresolve ${LIBS}"],
               [],
               [-lnsl])
fi
ac_cv_func_strcasecmp="no"
AC_SUBST([ac_cv_func_strcasecmp])dnl

dnl# We expect to have these functions on Unix-like systems configure
dnl# runs on. The defines are provided to get them in config.h.in so
dnl# Wget can still be ported to non-Unix systems (such as Windows)
dnl# that lack some of these functions.
AC_DEFINE([HAVE_STRCASECMP],[1],
          [Define to 1 if you have the `strcasecmp' function.])dnl
AC_DEFINE([HAVE_STRNCASECMP],[1],
          [Define to 1 if you have the `strncasecmp' function.])dnl
AC_DEFINE([HAVE_STRDUP],[1],[Define to 1 if you have the `strdup' function.])dnl
AC_DEFINE([HAVE_ISATTY],[1],[Define to 1 if you have the `isatty' function.])dnl

dnl#
dnl# Call Wget-specific macros defined in aclocal.
dnl#
AC_MSG_CHECKING([wget-specific stuff])
AC_MSG_RESULT([ ])
WGET_STRUCT_UTIMBUF
WGET_FNMATCH
WGET_NANOSLEEP
WGET_POSIX_CLOCK
WGET_NSL_SOCKET

dnl#
dnl# Checks for libraries.
dnl#

AC_MSG_CHECKING([libraries])
AC_MSG_RESULT([ ])
AC_CHECK_LIB([c],[printf])
# FIXME: Replace `main' with a function in `-lcurl':
AC_CHECK_LIB([curl],[main])
dnl# FIXME: Replace `main' with a function in `-lne':
AC_CHECK_LIB([ne],[main])dnl

AS_IF([test x"${with_zlib}" != x"no"],[
  AC_CHECK_LIB([z],[compress])dnl
  AC_CHECK_HEADER([zlib.h])dnl
])dnl

AS_IF([test x"${with_ssl}" = x"openssl"],[dnl
    dnl# some versions of openssl use zlib compression
    AC_CHECK_LIB([z],[compress])dnl

    dnl# As of this writing (OpenSSL 0.9.6), the libcrypto shared library
    dnl# does not record its dependency on libdl, so we need to make sure
    dnl# -ldl ends up in LIBS on systems that have it.  Most OSes use
    dnl# dlopen(), but HP-UX uses shl_load().
    AC_CHECK_LIB([dl],[dlopen],[],[
      AC_CHECK_LIB([dl],[shl_load])dnl
    ])dnl

    ssl_found=no
    case ${host_os} in
      *mingw32* )
        dnl# prefer link to openssl dlls if possible. If not, then fallback on
        dnl# static libs. If not, then error out.
        
        AC_CHECK_LIB([eay32],[EVP_MD_CTX_init])
        if test x"${ac_cv_lib_eay32_EVP_MD_CTX_init}" != x"no"
        then
          AC_CHECK_LIB([ssl32],[SSL_connect],[
            ssl_found=yes
            AC_MSG_NOTICE([Enabling support for SSL via OpenSSL (shared)])
            AC_LIBOBJ([openssl])
            LIBS="${LIBS} -lssl32"
            AC_DEFINE([HAVE_LIBSSL32],[1],
                      [Define to 1 if you have the `ssl32' library (-lssl32).])dnl
          ],
          [AC_MSG_ERROR([openssl not found: shared lib eay32 found but ssl32 not found])])
          
        else
          dnl# FIXME: Replace `main' with a function in `-lgdi32':
          AC_CHECK_LIB([gdi32],[main])
          LIBS+=' -lgdi32'
          dnl# fallback and test static libs
        fi
        dnl# TODO(?): add zdll lib as dep for above tests?
      ;;
    esac

AS_IF([test "x${ssl_found}" != "xyes"],
[
  dnl# Now actually check for -lssl if it was not already found
    AC_CHECK_HEADERS_ONCE([openssl/ssl.h openssl/x509.h openssl/err.h \
                           openssl/rand.h openssl/des.h openssl/md4.h \
                           openssl/md5.h])
    AC_CHECK_FUNCS([SSL_library_init])
    AC_CHECK_LIB([ssl],[SSL_library_init])
    AC_LIB_HAVE_LINKFLAGS([ssl],[crypto z],[
  #include <openssl/ssl.h>
  #include <openssl/x509.h>
  #include <openssl/err.h>
  #include <openssl/rand.h>
  #include <openssl/des.h>
  #include <openssl/md4.h>
  #include <openssl/md5.h>
    ],[SSL_library_init ()])
    if test x"${LIBSSL}" != x""
    then
      ssl_found=yes
      AC_MSG_NOTICE([compiling in support for SSL via OpenSSL])
      AC_LIBOBJ([openssl])
      LIBS="${LIBSSL} ${LIBS}"
    elif test x"${with_ssl}" != x""
    then
      AC_MSG_ERROR([--with-ssl=openssl was given, but SSL is not available.])
    fi
])dnl

],[
  dnl# --with-ssl is not gnutls: check if it is "no"
  AS_IF([test x"${with_ssl}" != x"no"],[
    dnl# Now actually check for -lssl

    dnl# FIXME: Replace `main' with a function in `-lssl':
    AC_CHECK_LIB([ssl],[main])
    if test "x$(echo ${LIBS} | grep \"-lz\" -)" = "x"; then
      AC_CHECK_LIB([z],[gzread])
    else
      test ! -z "${LIBS}"
      LIBS="`echo $(echo ${LIBS} | tr \  \\n | uniq | sort | uniq | tr \\n \ )`"
    fi
    AC_CHECK_LIB([gpg-error],[gpg_err_init])
    AC_CHECK_LIB([gcrypt],[gcry_control])

  dnl# Now actually check for -lssl
  AC_CHECK_HEADERS_ONCE([gnutls/gnutls.h])
  AC_CHECK_FUNCS([gnutls_global_init])
  AC_CHECK_LIB([gnutls],[gnutls_global_init])
  AC_LIB_HAVE_LINKFLAGS([gnutls],[],[
#include <gnutls/gnutls.h>
  ],[gnutls_global_init()])
  if test x"${LIBGNUTLS}" != x""
  then
    ssl_found=yes
    AC_MSG_NOTICE([compiling in support for SSL via GnuTLS])
    AC_LIBOBJ([gnutls])
    LIBS="${LIBGNUTLS} ${LIBS}"
  else
    AC_MSG_ERROR([--with-ssl was given (possibly implicitly), but GNUTLS is not available.])
  fi

  AC_CHECK_FUNCS([gnutls_priority_set_direct])
  ]) # endif: --with-ssl == no?
]) # endif: --with-ssl == openssl?

dnl# Enable NTLM if requested and if SSL is available.
if test x"${LIBSSL}" != x"" || test x"${ac_cv_lib_ssl32_SSL_connect}" = x"yes"
then
  if test x"${ENABLE_NTLM}" != x"no"
  then
    AC_DEFINE([ENABLE_NTLM],[1],
     [Define if you want the NTLM authorization support compiled in.])dnl
    AC_LIBOBJ([http-ntlm])
  fi
else
  AC_CHECK_LIB([nettle],[nettle_md4_init],[HAVE_NETTLE=yes],[HAVE_NETTLE=no; AC_MSG_WARN([*** libnettle was not found. You will not be able to use NTLM. ***])])

  if test x"${HAVE_NETTLE}" = x"yes"
  then
    AC_SUBST([NETTLE_LIBS],["-lnettle"])dnl
    AC_DEFINE([HAVE_NETTLE],[1],[Use libnettle])
    if test x"${ENABLE_NTLM}" != x"no"
    then
      AC_DEFINE([ENABLE_NTLM],[1],
       [Define if you want the NTLM authorization support compiled in.])dnl
      AC_LIBOBJ([http-ntlm])
      LIBS="${NETTLE_LIBS} ${LIBS}"
    fi
  else
    dnl# If SSL is unavailable and the user explicitly requested NTLM,
    dnl# abort.
    if test x"${ENABLE_NTLM}" = x"yes"
    then
      AC_MSG_ERROR([NTLM authorization requested and SSL not enabled; aborting])
    fi
  fi
fi

dnl#**********************************************************************
dnl# Checks for IPv6
dnl#**********************************************************************

dnl#
dnl# We test for IPv6 by checking, in turn, for availability of
dnl# presence of the INET6 address/protocol family and the existence of
dnl# struct sockaddr_in6.  If any of them is missing, IPv6 is disabled,
dnl# and the code reverts to old-style gethostbyname.
dnl#
dnl# If --enable-ipv6 is explicitly specified on the configure command
dnl# line, we check for IPv6 and abort if not found.  If --disable-ipv6
dnl# is specified, we disable IPv6 and don't check for it.  The default
dnl# is to autodetect IPv6 and use it where available.
dnl#

AC_ARG_ENABLE([ipv6],
  [AS_HELP_STRING([--disable-ipv6],[disable IPv6 support])],
  [case "${enable_ipv6}" in
    no)
      AC_MSG_NOTICE([disabling IPv6 at user request])
      dnl# Disable IPv6 checking
      ipv6=no
      ;;
    yes)
      dnl# IPv6 explicitly enabled: force its use (abort if unavailable).
      ipv6=yes
      force_ipv6=yes
      ;;
    auto)
      dnl# Auto-detect IPv6, i.e. check for IPv6, but don't force it.
      ipv6=yes
      ;;
    *)
      AC_MSG_ERROR([Invalid --enable-ipv6 argument `$enable_ipv6'])
      ;;
    esac
  ],[
    dnl# If nothing is specified, assume auto-detection.
    ipv6=yes
  ])dnl

if test "X${ipv6}" = "Xyes"; then
  PROTO_INET6([],[
    AC_MSG_NOTICE([Disabling IPv6 support: your system does not support the PF_INET6 protocol family])
    ipv6=no
  ])
fi

if test "X${ipv6}" = "Xyes"; then
  TYPE_STRUCT_SOCKADDR_IN6([],[
    AC_MSG_NOTICE([Disabling IPv6 support: your system does not support `struct sockaddr_in6'])
    ipv6=no
  ])
  if test "X${ipv6}" = "Xyes"; then
    WGET_STRUCT_SOCKADDR_STORAGE
    MEMBER_SIN6_SCOPE_ID
  fi
fi

if test "X${ipv6}" = "Xyes"; then
  AC_DEFINE([ENABLE_IPV6],[1],[Define if IPv6 support is enabled.])dnl
  AC_MSG_NOTICE([Enabling support for IPv6.])
elif test "x${force_ipv6}" = "xyes"; then
  AC_MSG_ERROR([IPv6 support requested but not found; aborting])
fi

dnl#
dnl# Check for IDN/IRIs
dnl#

AC_ARG_ENABLE([iri],
  [AS_HELP_STRING([--disable-iri],[disable IDN/IRIs support])],
  [case "${enable_iri}" in
    no)
      dnl# Disable IRIs checking
      AC_MSG_NOTICE([disabling IRIs at user request])
      iri=no
      ;;
    yes)
      dnl# IRIs explicitly enabled
      iri=yes
      force_iri=yes
      ;;
    auto)
      dnl# Auto-detect IRI
      iri=yes
      ;;
    *)
      AC_MSG_ERROR([Invalid --enable-iri argument `${enable_iri}'])
      ;;
    esac
  ],[
    dnl# If nothing is specified, assume auto-detection
    iri=yes
  ])dnl

AC_ARG_WITH([libidn],[AS_HELP_STRING([--with-libidn=[DIR]],
                                   [Support IDN/IRIs (needs GNU Libidn)])],
                                   [libidn=${withval}],[libidn=""])dnl
AS_IF([test "X${iri}" != "Xno"],[
  AM_ICONV

  if test "X${am_cv_func_iconv}" != "Xyes"; then
    iri=no
    if test "X${force_iri}" = "Xyes"; then
      AC_MSG_ERROR([Libiconv is required for IRIs support])
    else
      AC_MSG_NOTICE([disabling IRIs because libiconv was not found])
    fi
  fi
],[dnl# else
   dnl# For some reason (i.e. the gettext checks), this seems to be set even 
   dnl# when we do not check. Explicitly unset.
  LIBICONV=""
])dnl

if test "X${iri}" != "Xno"; then
  if test "X${libidn}" != "X"; then
    LDFLAGS="${LDFLAGS} -L${libidn}/lib"
    CPPFLAGS="${CPPFLAGS} -I${libidn}/include"
  fi

  # If idna.h cannot be found, check to see if it was installed under
  # /usr/include/idn (OpenSolaris, at least, places it there).
  # Check for idn-int.h in that case, because idna.h will not find
  # idn-int.h until we have decided to add -I/usr/include/idn.
  AC_CHECK_HEADER([idna.h],[],
    [AC_CHECK_HEADER([idn/idn-int.h],
                    [CPPFLAGS="${CPPFLAGS} -I/usr/include/idn"],
                    [iri=no])])dnl

  if test "X${iri}" != "Xno"; then
    AC_CHECK_LIB([idn],[stringprep_check_version],
      [iri=yes LIBS="${LIBS} -lidn"],[iri=no])
  fi

  if test "X${iri}" != "Xno" ; then
    AC_DEFINE([ENABLE_IRI],[1],[Define if IRI support is enabled.])dnl
    AC_MSG_NOTICE([Enabling support for IRI.])
  else
    AC_MSG_WARN([Libidn not found])
  fi
fi

dnl#
dnl# Check for UUID
dnl#

AC_CHECK_HEADER([uuid/uuid.h],
                [AC_CHECK_LIB([uuid],[uuid_generate],
                  [LIBS="${LIBS} -luuid"
                   AC_DEFINE([HAVE_LIBUUID],[1],
                             [Define if libuuid is available.])dnl
                  ],[AC_CHECK_LIB([uuid],[main])dnl
                  ])dnl
])dnl

dnl#
dnl# Check for PCRE
dnl#

AC_CHECK_HEADER([pcre.h],
                [AC_CHECK_LIB([pcre],[pcre_compile],
                  [LIBS="${LIBS} -lpcre"
                   AC_DEFINE([HAVE_LIBPCRE],[1],
                             [Define if libpcre is available.])dnl
                  ])dnl
])dnl

dnl# Needed by src/Makefile.am
AM_CONDITIONAL([IRI_IS_ENABLED],[test "X${iri}" != "Xno"])dnl

dnl#
dnl# Documentation tools
dnl#

AC_MSG_CHECKING([for documentation tools])
AC_MSG_RESULT([ ])dnl

dnl#
dnl# Find makeinfo.  We used to provide support for Emacs processing
dnl# Texinfo using `emacs -batch -eval ...' where makeinfo is
dnl# unavailable, but that broke with the addition of makeinfo-specific
dnl# command-line options, such as `-I'.  Now we depend on makeinfo to
dnl# build the Info documentation.
dnl#

AC_CHECK_PROGS([MAKEINFO],[makeinfo],[true])dnl
AM_MISSING_PROG([EMACSBIN],[emacs])dnl
AM_PATH_LISPDIR
AM_MISSING_PROG([INSTALLINFO],[install-info])dnl
AS_IF([test "x${INSTALLINFO}" = "x"],[dnl
	test -z "${INSTALLINFO}"
	AC_PATH_PROG([INSTALLINFO],[install-info])
],[dnl
	test ! -z "${INSTALLINFO}" && export INSTALLINFO
	AC_SUBST([INSTALLINFO])dnl
])dnl
AM_MISSING_PROG([MYDVIPS],[dvips])dnl
AS_IF([test "x${DVIPS}" = "x"],[dnl
	test -z "${DVIPS}" && test -z "${MYDVIPS}"
	AC_PATH_PROG([MYDVIPS],[dvips])dnl
],[dnl
	test ! -z "${DVIPS}" && export DVIPS
])dnl
AM_MISSING_PROG([MYTEXI2DVI],[texi2dvi])dnl
AS_IF([test "x${TEXI2DVI}" = "x"],[dnl
	test -z "${TEXI2DVI}" && test -z "${MYTEXI2DVI}"
	AC_PATH_PROG([MYTEXI2DVI],[texi2dvi])dnl
])dnl
AM_MISSING_PROG([TEXI2HTML],[texi2html])dnl
AS_IF([test "x${TEXI2HTML}" = "x"],[dnl
	test -z "${TEXI2HTML}"
	AC_PATH_PROG([TEXI2HTML],[texi2html])dnl
],[dnl
	test ! -z "${TEXI2HTML}" && export TEXI2HTML
	AC_SUBST([TEXI2HTML])dnl
])dnl
AM_MISSING_PROG([MYTEXI2PDF],[texi2pdf])dnl
AS_IF([test "x${TEXI2PDF}" = "x"],[dnl
	test -z "${TEXI2PDF}" && test -z "${MYTEXI2PDF}"
	AC_PATH_PROG([MYTEXI2PDF],[texi2pdf])dnl
])dnl
AM_MISSING_PROG([TEXI2POD],[texi2pod])dnl
AS_IF([test "x${TEXI2POD}" = "x"],[dnl
	test -z "${TEXI2POD}"
	AC_PATH_PROG([TEXI2POD],[texi2pod])dnl
],[dnl
	test ! -z "${TEXI2POD}" && export TEXI2POD
	AC_SUBST([TEXI2POD])dnl
])dnl
AM_MISSING_PROG([NROFF],[nroff])dnl
AS_IF([test "x${NROFF}" = "x"],[dnl
	test -z "${NROFF}"
	AC_PATH_PROG([NROFF],[nroff])dnl
],[dnl
	test ! -z "${NROFF}" && export NROFF
	AC_SUBST([NROFF])dnl
])dnl

dnl#
dnl# Find perl and pod2man
dnl#

AC_PATH_PROGS([PERL],[perl5 perl],[no])
AC_PATH_PROG([POD2MAN],[pod2man],[no])dnl

if test "x${POD2MAN}" = xno; then
  COMMENT_IF_NO_POD2MAN="# "
else
  COMMENT_IF_NO_POD2MAN=""
fi
AC_SUBST([COMMENT_IF_NO_POD2MAN])dnl
AC_SUBST([POD2MAN])dnl

AS_IF([test "x${PERL}" = "x"],[
  AC_PATH_PROG([PERL],[perl],[],
    [${PATH}:/usr/local/bin/perl:/usr/bin:/usr/local/bin])dnl
  AC_SUBST([PERL])dnl
],[
  test ! -z "${PERL}" && export PERL
  AC_SUBST([PERL])dnl
])dnl

AC_PATH_PROGS([AM_NROFF],[gnroff nroff],[],
  [${PATH}:/usr/bin:/usr/local/bin])dnl
AC_SUBST([AM_NROFF])dnl

AS_IF([test -n "${AM_NROFF}"],[
  dnl# only check for nroff options if an nroff command was found

  AC_MSG_CHECKING([how to use *nroff to get plain text from man pages])
  MANOPT="-man"
  mancheck=`echo foo | ${AM_NROFF} ${MANOPT} 2>/dev/null`
  if test -z "${mancheck}"; then
    MANOPT="-mandoc"
    mancheck=`echo foo | ${AM_NROFF} ${MANOPT} 2>/dev/null`
    if test -z "${mancheck}"; then
      MANOPT=""
      AC_MSG_RESULT([failed])
      AC_MSG_WARN([found no *nroff option to get plaintext from man pages])
    else
      AC_MSG_RESULT([${MANOPT}])
    fi
  else
    AC_MSG_RESULT([${MANOPT}])
  fi
  AC_SUBST([MANOPT])dnl
])dnl

if test -z "${MANOPT}"
then
  dnl# if no nroff tool was found, or no option that could convert
  dnl# manpages was found, then disable the built-in manual stuff
  AC_MSG_WARN([disabling built-in manual])
  USE_MANUAL="no";
fi

dnl# If the manual variable still is set, then we go with providing a
dnl# built-in manual

if test "${USE_MANUAL}" = "1"; then
  AC_DEFINE([USE_MANUAL],[1],[If you want to build wget with the built-in manual])
  wget_manual_msg="enabled"
fi

dnl# output
AC_MSG_NOTICE([doing output now])dnl

UPDATED=`build-aux/mdate-sh doc/wget.texi`
AC_SUBST([UPDATED])dnl
UPDATEDMONTH=`build-aux/mdate-sh doc/wget.texi | cut -d\  -f2,3`
AC_SUBST([UPDATEDMONTH])dnl

AH_BOTTOM([
  #ifdef HAVE_ALLOCA_H
  # include <alloca.h>
  #endif /* HAVE_ALLOCA_H */
  #ifdef HAVE_FCNTL_H
  # include <fcntl.h>
  #endif /* HAVE_FCNTL_H */
  #ifdef HAVE_GETOPT_H
  # include <getopt.h>
  #endif /* HAVE_GETOPT_H */
  #ifdef HAVE_ICONV_H
  # include <iconv.h>
  #endif /* HAVE_ICONV_H */
  #ifdef HAVE_LIBC_CONFIG_H
  # include <libc-config.h>
  #endif /* HAVE_LIBC_CONFIG_H */
  #ifdef HAVE_NETDB_H
  # include <netdb.h>
  #endif /* HAVE_NETDB_H */
  #ifdef HAVE_REGEX_H
  # include <regex.h>
  #endif /* HAVE_REGEX_H */
  #ifdef HAVE_SIGNAL_H
  # include <signal.h>
  #endif /* HAVE_SIGNAL_H */
  #ifdef HAVE_STDBOOL_H
  # include <stdbool.h>
  #endif /* HAVE_STDBOOL_H */
  #ifdef HAVE_STDIO_H
  # include <stdio.h>
  #endif /* HAVE_STDIO_H */
  #ifdef HAVE_STDLIB_H
  # include <stdlib.h>
  #endif /* HAVE_STDLIB_H */
  #ifdef HAVE_STRING_H
  # include <string.h>
  #endif /* HAVE_STRING_H */
  #ifdef HAVE_SYS_IOCTL_H
  # include <sys/ioctl.h>
  #endif /* HAVE_SYS_IOCTL_H */
  #ifdef HAVE_SYS_SELECT_H
  # include <sys/select.h>
  #endif /* HAVE_SYS_SELECT_H */
  #ifdef HAVE_SYS_SOCKET_H
  # include <sys/socket.h>
  #endif /* HAVE_SYS_SOCKET_H */
  #ifdef HAVE_SYS_STAT_H
  # include <sys/stat.h>
  #endif /* HAVE_SYS_STAT_H */
  #ifdef HAVE_TIME_H
  #include <time.h>
  #endif /* HAVE_TIME_H */
  #ifdef HAVE_UNISTD_H
  # include <unistd.h>
  #endif /* HAVE_UNISTD_H */
  #if HAVE_ICONV
  # include <iconv.h>
  #endif /* HAVE_ICONV */
])dnl

dnl#
dnl# Create output
dnl#
AC_CONFIG_FILES([Makefile \
                 src/Makefile \
                 doc/Makefile \
                 doc/version.texi \
                 util/Makefile \
                 po/Makefile.in \
                 tests/Makefile \
                 tests/WgetTest.pm \
                 lib/Makefile])
AC_CONFIG_HEADERS([src/config.h])
AC_OUTPUT
