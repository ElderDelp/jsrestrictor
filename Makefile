# SPDX-FileCopyrightText: 2019 Martin Timko
# SPDX-FileCopyrightText: 2019-2021 Libor Polčák
# SPDX-FileCopyrightText: 2020 Peter Horňák
# SPDX-FileCopyrightText: 2021 Giorgio Maone
#
# SPDX-License-Identifier: GPL-3.0-or-later

DEBUG=0

all: firefox chrome

.PHONY: firefox chrome clean get_csv docs
firefox: firefox_JSR.zip
chrome: chrome_JSR.zip

COMMON_FILES = $(shell find common/) \
			   LICENSES/ \
			   Makefile \
			   $(shell find firefox/) \
			   $(shell find chrome/)

PROJECT_NAME = $(shell grep ^PROJECT_NAME doxyfile | cut -f2 -d'"')

debug=1

get_csv:
	wget -q -N https://www.iana.org/assignments/locally-served-dns-zones/ipv4.csv
	cp ipv4.csv common/ipv4.dat
	wget -q -N https://www.iana.org/assignments/locally-served-dns-zones/ipv6.csv
	cp ipv6.csv common/ipv6.dat

submodules:
	git submodule init
	git submodule update

%_JSR.zip: $(COMMON_FILES) get_csv submodules
	@rm -rf $*_JSR/ $@
	@cp -r common/ $*_JSR/
	@cp -r $*/* $*_JSR/
	@cp -r LICENSES $*_JSR/
	@./fix_manifest.sh $*_JSR/manifest.json
	@nscl/include.sh $*_JSR
	@if [ $(DEBUG) -eq 0 ]; \
	then \
		find $*_JSR/ -type f -name "*.js" -exec sed -i '/console\.debug/d' {} + ; \
	fi
	@rm -f $*_JSR/.*.sw[pno]
	@rm -f $*_JSR/img/makeicons.sh
	@find $*_JSR/ -name '*.license' -delete
	@cd $*_JSR/ && zip -q -r ../$@ ./* --exclude \*.sw[pno]
	@echo "LOG-WARNING: Number of lines in $*_JSR with console.log:"
	@grep -re 'console.log' $*_JSR | wc -l

debug: DEBUG=1
debug: all

clean:
	rm -rf firefox_JSR.zip
	rm -rf firefox_JSR
	rm -rf chrome_JSR.zip
	rm -rf chrome_JSR
	rm -rf common/ipv4.dat
	rm -rf common/ipv6.dat
	rm -rf ipv4.csv
	rm -rf ipv6.csv
	rm -rf doxygen/
