.data
    valores: .half 0, 0, 0, 0   # Armazena os valores half-word
.text
main:
    la $s0, valores        # Carrega o endereço base de 'valores' no registrador $s0
    
    li $t0, 1              # Carregar o valor 1
    sh $t0, 0($s0)         # Armazenar em valores[0]
    
    li $t0, 2              # Carregar o valor 2
    sh $t0, 2($s0)         # Armazenar em valores[1]
    
    li $t0, -2             # Carregar o valor -2
    sh $t0, 4($s0)         # Armazenar em valores[2]
    
    li $t0, -3             # Carregar o valor -3
    sh $t0, 6($s0)         # Armazenar em valores[3]
    
    # Encerrar o programa
    li $v0, 10           
    syscall
