	.text
main:
        lui t0, 0011111110011001
        nop
        nop
        nop
        ori t0, 1001100110011010
        nop
        nop
        nop
        mtc f0, t0
        nop
        nop
        nop
        lui t1, 0011111100011001
        nop
        nop
        nop
        ori t1, 1001100110011010
        nop
        nop
        nop
        mtc f1, t1
        nop
        nop
        nop
        add.s $f2, $f1, $f0
        nop
        nop
        nop
        add.s $f3, $f2, $f0
        nop
        nop
        nop
        sub.s $f4, $f3, $f1
        nop
        nop
        nop
        addi $v0, $zero, 0
        nop
        nop
        nop
        syscall