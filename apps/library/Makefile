TOOLCHAIN_PREFIX = /c/Users/gilya/AppData/Roaming/xpack-riscv-none-embed-gcc-10.1.0-1.1/bin/riscv-none-embed
CC = ${TOOLCHAIN_PREFIX}-gcc
CPP = ${TOOLCHAIN_PREFIX}-cpp
LD = ${TOOLCHAIN_PREFIX}-ld
AR = ${TOOLCHAIN_PREFIX}-ar
OBJDUMP = ${TOOLCHAIN_PREFIX}-objdump
OBJCOPY = ${TOOLCHAIN_PREFIX}-objcopy

ARCH := rv32i
ABI := ilp32

PREFIX := $(CONFIG)/$(ARCH)/$(ABI)

BASE_CFLAGS := -Iinclude -ffreestanding -march=$(ARCH) -mabi=$(ABI) -nostdinc -nostartfiles -std=c11

override CFLAGS := $(BASE_CFLAGS) $(DEFINES) $(CFLAGS)
override LDFLAGS := -Tout/$(PREFIX)/lib/librvc_link.lds -nostdlib -m elf32lriscv $(LDFLAGS)

LIB_INCLUDES := -Iinclude

LIB_CFLAGS := $(CFLAGS) $(LIB_INCLUDES) $(LIB_DEFINES)

override CPPFLAGS := -P $(CPPFLAGS)

all: librvc out/$(PREFIX)/bin/cr_api_test

librvc: out/$(PREFIX)/lib/librvc_link.lds out/$(PREFIX)/lib/librvc.a out/$(PREFIX)/lib/librvc_crt0.a

out/$(PREFIX)/lib/librvc_link.lds: build/link.common.ld
	mkdir -p `dirname $@`
	$(CPP) $(CFLAGS) $(CPPFLAGS) $^ -o $@

obj/$(PREFIX)/crt0.o: src/crt0.s
	@mkdir -p `dirname $@`
	$(CC) $(LIB_CFLAGS) -c -o $@ $^

out/$(PREFIX)/lib/librvc_crt0.a: obj/$(PREFIX)/crt0.o
	@mkdir -p `dirname $@`
	$(AR) -csr $@ $^
	cp -f $^ $@

obj/$(PREFIX)/cr_api.o: src/cr_api.c
	@mkdir -p `dirname $@`
	$(CC) $(LIB_CFLAGS) -c -o $@ $^

out/$(PREFIX)/lib/librvc.a: obj/$(PREFIX)/cr_api.o
	@mkdir -p `dirname $@`
	$(AR) -csr $@ $^
	cp -f $^ $@

obj/$(PREFIX)/cr_api_test.o: examples/cr_api_test.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

out/$(PREFIX)/bin/cr_api_test: out/$(PREFIX)/lib/librvc_crt0.a obj/$(PREFIX)/cr_api_test.o
	@mkdir -p `dirname $@`
	$(LD) $(LDFLAGS) -Lout/$(PREFIX)/lib $^ -lrvc -o $@
	$(OBJDUMP) -gd $@ > $@.txt
	$(OBJCOPY)  --srec-len 1 --output-target=verilog $@ $@.sv

out/$(PREFIX)/bin/cr_api_test: .EXTRA_PREREQS = librvc

clean:
	rm -rf out/$(PREFIX)/* obj/$(PREFIX)/*

cleanall:
	rm -rf out/* obj/*