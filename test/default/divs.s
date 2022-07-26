	    .text
        .set noreorder
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
        div f2,f0,f1
        nop
        nop
        nop
        round f2,f2
        nop
        nop
        nop
        addiu $v0, $zero, 0xa
        syscall