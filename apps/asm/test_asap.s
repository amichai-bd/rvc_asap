	.file	"test_asap.c"
	.option nopic
	.text
	.section	.rodata
	.align	2
.LC0:
	.word	80
	.word	200
	.word	60
	.word	300
	.word	100
	.word	70
	.word	90
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	sw	s1,36(sp)
	addi	s0,sp,48
	lui	a5,%hi(.LC0)
	addi	a5,a5,%lo(.LC0)
	lw	a6,0(a5)
	lw	a0,4(a5)
	lw	a1,8(a5)
	lw	a2,12(a5)
	lw	a3,16(a5)
	lw	a4,20(a5)
	lw	a5,24(a5)
	sw	a6,-48(s0)
	sw	a0,-44(s0)
	sw	a1,-40(s0)
	sw	a2,-36(s0)
	sw	a3,-32(s0)
	sw	a4,-28(s0)
	sw	a5,-24(s0)
	addi	a5,s0,-48
	li	a1,7
	mv	a0,a5
	call	bubbleSort
	sw	zero,-20(s0)
	j	.L2
.L3:
	lw	a5,-20(s0)
	slli	a4,a5,2
	li	a5,4096
	add	a4,a4,a5
	lw	a5,-20(s0)
	slli	a5,a5,2
	addi	a3,s0,-16
	add	a5,a3,a5
	lw	a5,-32(a5)
	sw	a5,0(a4)
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L2:
	lw	a4,-20(s0)
	li	a5,6
	ble	a4,a5,.L3
	li	a5,4096
	addi	s1,a5,28
	li	a0,9
	call	fibonacci
	mv	a5,a0
	sw	a5,0(s1)
	li	a5,4096
	addi	s1,a5,32
	li	a1,16
	li	a0,24
	call	gcd
	mv	a5,a0
	sw	a5,0(s1)
	li	a5,0
	mv	a0,a5
	lw	ra,44(sp)
	lw	s0,40(sp)
	lw	s1,36(sp)
	addi	sp,sp,48
	jr	ra
	.size	main, .-main
	.globl	__modsi3
	.align	2
	.globl	gcd
	.type	gcd, @function
gcd:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a5,-24(s0)
	beq	a5,zero,.L6
	lw	a5,-20(s0)
	lw	a1,-24(s0)
	mv	a0,a5
	call	__modsi3
	mv	a5,a0
	mv	a1,a5
	lw	a0,-24(s0)
	call	gcd
	mv	a5,a0
	j	.L7
.L6:
	lw	a5,-20(s0)
.L7:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	gcd, .-gcd
	.align	2
	.type	fibonacci, @function
fibonacci:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	sw	s1,20(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a4,-20(s0)
	li	a5,1
	bgtu	a4,a5,.L9
	lw	a5,-20(s0)
	j	.L10
.L9:
	lw	a5,-20(s0)
	addi	a5,a5,-1
	mv	a0,a5
	call	fibonacci
	mv	s1,a0
	lw	a5,-20(s0)
	addi	a5,a5,-2
	mv	a0,a5
	call	fibonacci
	mv	a5,a0
	add	a5,s1,a5
.L10:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	addi	sp,sp,32
	jr	ra
	.size	fibonacci, .-fibonacci
	.align	2
	.globl	swap
	.type	swap, @function
swap:
	addi	sp,sp,-48
	sw	s0,44(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	lw	a5,-36(s0)
	lw	a5,0(a5)
	sw	a5,-20(s0)
	lw	a5,-40(s0)
	lw	a4,0(a5)
	lw	a5,-36(s0)
	sw	a4,0(a5)
	lw	a5,-40(s0)
	lw	a4,-20(s0)
	sw	a4,0(a5)
	nop
	lw	s0,44(sp)
	addi	sp,sp,48
	jr	ra
	.size	swap, .-swap
	.align	2
	.globl	bubbleSort
	.type	bubbleSort, @function
bubbleSort:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	sw	zero,-20(s0)
	j	.L13
.L17:
	sw	zero,-24(s0)
	j	.L14
.L16:
	lw	a5,-24(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	lw	a4,0(a5)
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	lw	a3,-36(s0)
	add	a5,a3,a5
	lw	a5,0(a5)
	ble	a4,a5,.L15
	lw	a5,-24(s0)
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a3,a4,a5
	lw	a5,-24(s0)
	addi	a5,a5,1
	slli	a5,a5,2
	lw	a4,-36(s0)
	add	a5,a4,a5
	mv	a1,a5
	mv	a0,a3
	call	swap
.L15:
	lw	a5,-24(s0)
	addi	a5,a5,1
	sw	a5,-24(s0)
.L14:
	lw	a4,-40(s0)
	lw	a5,-20(s0)
	sub	a5,a4,a5
	addi	a5,a5,-1
	lw	a4,-24(s0)
	blt	a4,a5,.L16
	lw	a5,-20(s0)
	addi	a5,a5,1
	sw	a5,-20(s0)
.L13:
	lw	a5,-40(s0)
	addi	a5,a5,-1
	lw	a4,-20(s0)
	blt	a4,a5,.L17
	nop
	nop
	lw	ra,44(sp)
	lw	s0,40(sp)
	addi	sp,sp,48
	jr	ra
	.size	bubbleSort, .-bubbleSort
	.ident	"GCC: (xPack GNU RISC-V Embedded GCC, 64-bit) 10.1.0"
