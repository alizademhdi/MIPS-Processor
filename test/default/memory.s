        # Basic LW/SW test
	.text
main:
        #;;  Set a base address
        lui $8, 0x1000 # 0
        nop
	nop
	nop
        ori $8 ,0xE100 # 4
        lui $9, 0x1000 # 8
        nop
	nop
	nop
        ori $9 ,0x6100 # 12


        addiu  $10, $zero, 255 # 16
        nop
	nop
	nop
        add    $11, $10, $10 # 20
        nop
	nop
	nop
        add    $12, $11, $11 # 24
        nop
	nop
	nop
        add    $13, $11, $12 # 28

        #;; Place a test pattern in memory
        sw $10 , 0($8) #miss to save # 32
        sw $11 , 0($8) #hit to save # 36
        lw $14 , 0($8) #hit to load # 40
        sw $13 , 0($9) #miss to save , dirty bit = 1 44
        lw $15 , 0($8) #miss to load , dirty bit = 1 48
        lw $24 , 0($9) #miss to load , dirty bit = 0 52

        nop
	nop
	nop
        #;; Calculate a "checksum" for easy comparison
        add    $s0, $15, $24 # 56

        #;;  Quit out
        addiu $v0, $zero, 0xa
        nop
	nop
	nop
        syscall

