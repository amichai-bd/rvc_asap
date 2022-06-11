TOOLCHAIN_PREFIX = /c/Users/gilya/AppData/Roaming/xpack-riscv-none-embed-gcc-10.1.0-1.1/bin/riscv-none-embed
CC = ${TOOLCHAIN_PREFIX}-gcc
LD = ${TOOLCHAIN_PREFIX}-ld
AR = ${TOOLCHAIN_PREFIX}-ar
OBJDUMP = ${TOOLCHAIN_PREFIX}-objdump
OBJCOPY = ${TOOLCHAIN_PREFIX}-objcopy

DEBUG_BUILD ?= 0

ifeq ($(DEBUG_BUILD), 0)
    CONFIG = release
else
    CONFIG = debug
endif

ARCH := rv32i

BASE_CFLAGS := -Iinclude -march=$(ARCH) -nostartfiles -D__riscv__ -ffreestanding

ifeq ($(DEBUG_BUILD), 0)
    BASE_CFLAGS += -O3
else
    BASE_CFLAGS += -g -DDEBUG
endif

CFLAGS := $(BASE_CFLAGS)

all: librvc out/bin/cr_api_test.elf

librvc: out/lib/librvc.a obj/crt0.o

obj/crt0.o: src/crt0.s
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

obj/cr_api.o: src/cr_api.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

out/lib/librvc.a: obj/cr_api.o
	@mkdir -p `dirname $@`
	$(AR) -csr $@ $^
	cp -f $^ $@

obj/cr_api_test.o: examples/cr_api_test.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

out/bin/cr_api_test.elf: obj/crt0.o obj/cr_api_test.o
	@mkdir -p `dirname $@`
	$(LD) -T linker/link.common.ld -m elf32lriscv $^ -lrvc -Lout/lib -o $@

clean:
	rm -rf out/* obj/*