.text
    ###############################################
    #Boot Loader para Assembly MIPS
    #Grupo 1 - OAC 2014/2

    #s4 = endereco do ktext
    #s5 = endereco do kdata
    #s6 = endereco do text
    #s7 = endereco do data

    #k0 = endereco do byte vindo da rs-232
    #k1 = endereco do controle da rs-232
    #s0 = byte recebido (padrao)
    #s1 = bits do controle (padrao)

    #gp = word formada por 4 bytes recebidos
    #fp = posicao de memoria da word atual
    #t9 = arquivo atual que esta lendo
    #t8 = quantidade de bytes/words do aplicativo
    ###########################################

    #Definicao dos enderecos padroes
    ###############################################
   # nop			# s� para liberar o endere�o zero para o break
    li      $s4, 0x80000000         # Endereço inicial para System Code Memory  t9 = 0
    li      $s5, 0x90000000         # Endereço inicial para System Data Memory  t9 = 1
    li      $s6, 0x00400000         # Endereço inicial para User Code Memory    t9 = 2
    li      $s7, 0x10010000         # Endereço inicial para User Data Memory    t9 = 3

    li      $k0, 0xFFFF0120         # Endereço para leitura do byte recebido
    li      $k1, 0xFFFF0122         # Endereço para leitura do controle da RS-232
    ###########################################

    move    $t9, $zero              # indica que o bootloader esta no ktext     (data = 0)
    move    $fp, $s4                # coloca no fp a posicao inicial do arquivo (posx = syscode )
    ###############################################
    #for1( t9 = 0; t9 < 4; t9++)
for1:
    sltiu   $t8, $t9, 4             # if arquivo atual < 4 (ainda esta lendo arquivos)
    beq     $t8, $zero, FIMBL
    ###########################################

    #le o tamanho do arquivo
    jal     leWordRS232
    move    $t8, $gp                # coloca o tamanha do arquivo em t8 (regx = <tam do arquivo>)
    sll     $t8, $t8, 2             # divide o numero por 4, dando assim o numero de words, e nao de bytes
    move    $t1, $zero

        ###############################################
        #for2 (i = 0; i    < tam_do_arq ; i++)
    for2:
        sltu    $t0, $t1, $t8       # if t1 < t8 (se ja leu a quantidade de words do arquivo)
        beq     $t0, $zero, FIMFOR2 # se t0 == zero entao acabou de ler as words do arquivo

        jal     leWordRS232         # le a word do arquivo
        sw      $gp, 0($fp)         # salva na memoria a intrucao
        addiu   $fp, $fp, 4         # vai para o prox endereco de memoria
        addiu   $t1, $t1, 1         # i = i + 1
        j       for2
        #fim do for2
        ###########################################

FIMFOR2:

    beq     $t9, 0, SYSDATA         #se t9 = 0 entao acabou de ler o syscode
    beq     $t9, 1, USRCODE         #se t9 = 1 entao acabou de ler o sysdata
    beq     $t9, 2, USRDATA         #se t9 = 2 entao acabou de ler o usercode

SYSDATA:                            # coloca no fp a posicao inicial do arquivo (posx = sysdata )
    move    $fp, $s5
    addiu   $t9, $t9, 1
    j       for1
USRCODE:                            # coloca no fp a posicao inicial do arquivo (posx = usercode )
    move    $fp, $s6
    addiu   $t9, $t9, 1
    j       for1
USRDATA:                            # coloca no fp a posicao inicial do arquivo (posx = userdata )
    move    $fp, $s7
    addiu   $t9, $t9, 1
    j       for1

    #fim do for1
    ###############################################
FIMBL:
    li      $t4, 0x00400000
    jr      $t4                     # vai para o codigo do usuario



    ###############################################
    leWordRS232:
        lbu     $s1, 0($k1)         # load nos bits de controle
        srl     $t0, $s1, 2         # t0 = bit de read
        beq     $t0, $zero, leWordRS232     # se o bit de read = 0 (nao pode ler) vai para o loop1
        #entra aqui se s0 = 1, ou seja, pode ler o byte

        lbu     $s0, 0($k0)         # da load no byte
        move    $gp, $s0            # move para o gp o byte
        sll     $gp, $gp, 8         # move para a esquerda 8 bits

    espera2:
        lbu     $s1, 0($k1)         # espera o segundo byte da word
        srl     $t0, $s1, 2
        beq     $t0, $zero, espera2

        lbu     $s0, 0($k0)
        addu    $gp, $gp, $s0
        sll     $gp, $gp, 8

    espera3:
        lbu     $s1, 0($k1)         # espera o terceiro byte da word
        srl     $t0, $s1, 2
        beq     $t0, $zero, espera3

        lbu     $s0, 0($k0)
        addu    $gp, $gp, $s0
        sll     $gp, $gp, 8

    espera4:
        lbu     $s1, 0($k1)         # espera o quarto byte da word
        srl     $t0, $s1, 2
        beq     $t0, $zero, espera4

        lbu     $s0, 0($k0)
        addu    $gp, $gp, $s0
        jr      $ra                 # aqui a word ja esta montada no gp
    ###########################################
