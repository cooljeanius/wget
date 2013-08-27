# Makefile for `wget' utility
# Copyright (C) 1995, 1996, 1997, 2007, 2008, 2009, 2010, 2011 Free
# Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#
# Version: @VERSION@
#

# Program to convert DVI files to PostScript
MYDVIPS = @DVIPS@ -D 300
# Program to convert texinfo files to html
TEXI2HTML = @TEXI2HTML@ -expandinfo -split_chapter

@COMMENT_IF_NO_POD2MAN@manext = 1
RM = rm -f

TEXI2POD     = $(srcdir)/texi2pod.pl
@COMMENT_IF_NO_POD2MAN@POD2MAN      = @POD2MAN@
@COMMENT_IF_NO_POD2MAN@MAN          = wget.$(manext)
@COMMENT_IF_NO_POD2MAN@NROFF        = @NROFF@
WGETRC       = $(sysconfdir)/wgetrc
SAMPLERCTEXI = sample.wgetrc.munged_for_texi_inclusion

#
# Dependencies for building
#

@COMMENT_IF_NO_POD2MAN@man_MANS = $(MAN)

all: wget.info @COMMENT_IF_NO_POD2MAN@$(MAN)

everything: all wget_us.ps wget_a4.ps wget_toc.html

$(SAMPLERCTEXI): $(srcdir)/sample.wgetrc
	sed s/@/@@/g $? > $@

info_TEXINFOS = wget.texi
wget_TEXINFOS = fdl.texi sample.wgetrc.munged_for_texi_inclusion version.texi

EXTRA_DIST = sample.wgetrc \
	     $(SAMPLERCTEXI) \
	     texi2pod.pl

wget.pod: $(srcdir)/wget.texi version.texi
	$(TEXI2POD) -D VERSION="$(VERSION)" $(srcdir)/wget.texi $@

@COMMENT_IF_NO_POD2MAN@$(MAN): wget.pod
@COMMENT_IF_NO_POD2MAN@	$(POD2MAN) --center="GNU Wget" --release="GNU Wget @VERSION@" $? > $@

@COMMENT_IF_NO_POD2MAN@wget.cat: $(MAN)
@COMMENT_IF_NO_POD2MAN@	$(NROFF) -man $? > $@

wget_us.ps: wget.dvi
	$(MYDVIPS) -t letter -o $@ wget.dvi

wget_a4.ps: wget.dvi
	$(MYDVIPS) -t a4 -o $@ wget.dvi

wget_toc.html: $(srcdir)/wget.texi
	$(TEXI2HTML) $(srcdir)/wget.texi

#
# Dependencies for installing
#

# install all the documentation
install-data-local: install.wgetrc @COMMENT_IF_NO_POD2MAN@install.man

# uninstall all the documentation
uninstall-local: @COMMENT_IF_NO_POD2MAN@uninstall.man


# install man page, creating install directory if necessary
@COMMENT_IF_NO_POD2MAN@install.man: $(MAN)
@COMMENT_IF_NO_POD2MAN@	$(mkinstalldirs) $(DESTDIR)$(mandir)/man$(manext)
@COMMENT_IF_NO_POD2MAN@	$(INSTALL_DATA) $(MAN) $(DESTDIR)$(mandir)/man$(manext)/$(MAN)

# install sample.wgetrc
install.wgetrc: $(srcdir)/sample.wgetrc
	$(mkinstalldirs) $(DESTDIR)$(sysconfdir)
	@if test -f $(DESTDIR)$(WGETRC); then \
	  if cmp -s $(srcdir)/sample.wgetrc $(DESTDIR)$(WGETRC); then echo ""; \
	     else \
	     echo ' $(INSTALL_DATA) $(srcdir)/sample.wgetrc $(DESTDIR)$(WGETRC).new'; \
	     $(INSTALL_DATA) $(srcdir)/sample.wgetrc $(DESTDIR)$(WGETRC).new; \
	     echo; \
	     echo "WARNING: Differing \`$(DESTDIR)$(WGETRC)'"; \
	     echo "         exists and has been spared.  You might want to"; \
	     echo "         consider merging in the new lines from"; \
	     echo "         \`$(DESTDIR)$(WGETRC).new'."; \
	     echo; \
	  fi; \
	else \
	  $(INSTALL_DATA) $(srcdir)/sample.wgetrc $(DESTDIR)$(WGETRC); \
	fi

# uninstall man page
@COMMENT_IF_NO_POD2MAN@uninstall.man:
@COMMENT_IF_NO_POD2MAN@	$(RM) $(DESTDIR)$(mandir)/man$(manext)/$(MAN)

#
# Dependencies for cleanup
#

CLEANFILES = *~ *.bak *.cat *.pod
@COMMENT_IF_NO_POD2MAN@DISTCLEANFILES = $(MAN)
