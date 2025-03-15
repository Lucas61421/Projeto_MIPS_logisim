.data
    tabuleiro: .word 1, 2, 3, 4,       # matriz com os elementos pareados
                     1, 2, 3, 4,
                     5, 6, 7, 8,
                     5, 6, 7, 8
    
    revelado: .word 0, 0, 0, 0,        # matriz com os elementos escondidos
                      0, 0, 0, 0,
                      0, 0, 0, 0,
                      0, 0, 0, 0
    tabuleiro_atual: .asciiz "Configuracao Atual do Tabuleiro:\n"
    mensagem_escondida: .asciiz "* "
    espaco: .asciiz " "
    TAM: .word 4                      # variavel tamanho
    mensagem_linha: .asciiz "Digite a linha da carta: "
    mensagem_coluna: .asciiz "Digite a coluna da carta: "
    mensagem_acerto: .asciiz "Par encontrado!\n"
    mensagem_erro: .asciiz "Par incorreto.\n"
    mensagem_final: .asciiz "Parabéns, você ganhou o jogo.\n"

.text
main:
    li $t8, 8       # pares de cartas restantes
    
loop_principal:
    bgtz $t8, jogar
    li $v0, 4       # imprimir o tabuleiro
    syscall
    j fim
    
jogar:
    jal mostrar_tabuleiro      # exibir o tabuleiro
    
    # coordenas carta 1
    li $v0, 4
    la $a0, mensagem_linha
    syscall
    jal ler_numero
    move $s0, $v0           # recebe linha da carta 1
    
    li $v0, 4
    la $a0, mensagem_coluna
    syscall
    jal ler_numero
    move $s1, $v0           # recebe coluna da carta 1
    
    
    # coordenadas carta 2
    li $v0, 4
    la $a0, mensagem_linha
    syscall
    jal ler_numero
    move $s2, $v0           # recebe linha da carta 2
    
    li $v0, 4
    la $a0, mensagem_coluna
    syscall
    jal ler_numero
    move $s3, $v0           # recebe coluna da carta 2
    
    # revela par
    jal revelar_cartas
    jal mostrar_tabuleiro
    
    # checa par
    jal checar_par
    beqz $v0, par_errado
    
    # par encontrado 
    subi $t8, $t8, 1        # pares restantes -= 1
    li $v0, 4
    la $a0, mensagem_acerto
    syscall
    j loop_principal

par_errado:
    li $v0, 4           # imprimir string
    la $a0, mensagem_erro
    syscall
    jal esconder_cartas
    j loop_principal
    
ler_numero:
    li $v0, 5
    syscall
    jr $ra
            
revelar_cartas:
    lw $t1, TAM
    
    # Revelar primeira carta
    mul $t2, $s0, $t1      # linha * TAM
    add $t2, $t2, $s1      # (linha * TAM) + coluna
    sll $t2, $t2, 2        # formatação para 4 bytes
    la $t3, revelado
    add $t3, $t3, $t2
    li $t4, 1              # revelado = 1
    sw $t4, 0($t3)
    
    # Revelar segunda carta
    mul $t2, $s2, $t1      # linha * TAM
    add $t2, $t2, $s3      # (linha * TAM) + coluna
    sll $t2, $t2, 2        # formatação para 4 bytes
    la $t3, revelado
    add $t3, $t3, $t2
    li $t4, 1              # revelado = 1
    sw $t4, 0($t3)
    
    jr $ra

esconder_cartas:
    lw $t1, TAM
    
    # Esconder carta 1
    mul $t2, $s0, $t1
    add $t2, $t2, $s1
    sll $t2, $t2, 2
    la $t3, revelado
    add $t3, $t3, $t2
    sw $zero, 0($t3)
    
    # Esconder carta 2
    mul $t2, $s2, $t1
    add $t2, $t2, $s3
    sll $t2, $t2, 2
    la $t3, revelado
    add $t3, $t3, $t2
    sw $zero, 0($t3)
    jr $ra
        
checar_par:
    lw $t1, TAM
    
    # carta 1
    mul $t2, $s0, $t1
    add $t2, $t2, $s1
    sll $t2, $t2, 2
    la $t3, tabuleiro
    add $t3, $t3, $t2
    lw $t4, 0($t3)         # carrega valor da carta 1
    
    # carta 2
    mul $t2, $s2, $t1
    add $t2, $t2, $s3
    sll $t2, $t2, 2
    la $t3, tabuleiro
    add $t3, $t3, $t2
    lw $t5, 0($t3)         # carrega valor da carta 2
    
    seq $v0, $t4, $t5       # Se são iguais $v0 = 1, caso contrário $v0 = 0
    jr $ra

mostrar_tabuleiro:
    li $v0, 4
    la $a0, tabuleiro_atual
    syscall
    li $t0, 0       # Inicializa o contador de linhas

loop_linhas:
    bge $t0, 4, parar_exibicao     #Não imprime mais que 4 linhas
    li $t1, 0       # Inicializa o contador de colunas
    
loop_colunas:
    bge $t1, 4, prox_linha
    lw $t2, TAM
    mul $t3, $t0, $t2
    add $t3, $t3, $t1
    sll $t3, $t3, 2
    la $t4, revelado
    add $t4, $t4, $t3
    lw $t5, 0($t4)
    beqz $t5, tabuleiro_escondido
    
    # Imprimir valor da carta revelada
    la $t4, tabuleiro
    add $t4, $t4, $t3
    lw $a0, 0($t4)
    li $v0, 1
    syscall

    # Adicionar espaçamento após número
    li $v0, 4
    la $a0, espaco
    syscall

    j iteracao_coluna

tabuleiro_escondido:
    li $v0, 4
    la $a0, mensagem_escondida
    syscall
    
iteracao_coluna:
    addi $t1, $t1, 1
    j loop_colunas

prox_linha:
    li $v0, 11
    li $a0, 10         # \n em ASCII
    syscall
    addi $t0, $t0, 1  # Incrementa o contador de linhas
    j loop_linhas

parar_exibicao:       #fim da exibição do tabuleiro
	jr $ra

fim:
    la $a0, mensagem_final
    li $v0, 4
    syscall
    li $v0, 10
    syscall
