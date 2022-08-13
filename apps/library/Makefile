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

all: librvc out/bin/cr_api_test.elf out/bin/graphic_screen_api_test.elf out/bin/fpga_io_test.elf

librvc: out/lib/librvc.a obj/crt0.o

obj/crt0.o: ../crt0.s
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

obj/cr_api.o: src/cr_api.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

obj/graphic_screen_api.o: src/graphic_screen_api.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

out/lib/librvc.a: obj/cr_api.o obj/graphic_screen_api.o
	@mkdir -p `dirname $@`
	$(AR) -csr $@ $^

obj/cr_api_test.o: examples/cr_api_test.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

obj/fpga_io_test.o: examples/fpga_io_test.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

obj/graphic_screen_api_test.o: examples/graphic_screen_api_test.c
	@mkdir -p `dirname $@`
	$(CC) $(CFLAGS) -c -o $@ $^

out/bin/cr_api_test.elf: obj/crt0.o obj/cr_api_test.o
	@mkdir -p `dirname $@`
	$(LD) -T ../link.common.ld -m elf32lriscv $^ -lrvc -Lout/lib -o $@

out/bin/fpga_io_test.elf: obj/crt0.o obj/fpga_io_test.o
	@mkdir -p `dirname $@`
	$(LD) -T ../link.common.ld -m elf32lriscv $^ -lrvc -Lout/lib -o $@

out/bin/graphic_screen_api_test.elf: obj/crt0.o obj/graphic_screen_api_test.o
	@mkdir -p `dirname $@`
	$(LD) -T ../link.common.ld -m elf32lriscv $^ -lrvc -Lout/lib -o $@

clean:
	rm -rf out/* obj/*