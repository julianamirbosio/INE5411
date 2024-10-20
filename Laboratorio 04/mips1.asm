.data
	matriz: .space 1024
	n: 	.word 16		# Dimensões da matriz
	msg: 	.asciiz "\n"        	# Quebra de linha
	space: 	.asciiz " "
.text
main: 
	la $s0, matriz			# Endereço base da matriz
	li $s1, 0			# Valor inicial a ser armazenado na matriz (Value)
	
	lw $t0, n			# i = 16;
	
	li $t3, 0			# Contador de elementos na linha

loop_i:					# loop para linhas
	beqz $t0, imprimir		# Se i == 0, fim do loop 
	lw $t1, n			# j = 16;
	
loop_j:					# loop para colunas
	beqz $t1, proxima_linha 	# Se j == 0, proxima linha 
	
	# Calcular o endereço da matriz: matriz[i][j]
	mul $t4, $t3, 4        		# Calcular o deslocamento (t3 * 4 bytes por inteiro)
    	add $t5, $s0, $t4       	# Calcular o endereço da posição matriz[i][j]
    	
    	# Armazenar valor em matriz[i][j]
    	sw $s1, 0($t5)          	# Armazenar o valor de $s1 no endereço calculado
    	addi $s1, $s1, 1       	 	# Value++;
    	
	addi $t1, $t1, -1		# j--;
	addi $t3, $t3, 1        	# Incrementar o contador de elementos
    	j loop_j                 	# Voltar para o loopj
	
proxima_linha:
	addi $t0, $t0, -1		# i--;
	j loop_i			# Próxima linha
	
	
imprimir:	
	li $t3, 0			# Contador para impressão
    	lw $t0, n               	# Carregar o valor de n para o contador de linhas

print_loop_i:
	beqz $t0, fim           	# Se $t0 (i) for 0, fim do loop de impressão
    	lw $t1, n               	# j = 16;
    	
print_loop_j:
	beqz $t1, print_novalinha
	mul $t4, $t3, 4			# Calcular deslocamento
	add $t5, $s0, $t4        	# Calcular o endereço da posição matriz[i][j]
    	lw $a0, 0($t5)           	# Carregar o valor de matriz[i][j] em $a0
    	li $v0, 1                	# Chamada de impressão de inteiros
    	syscall                  	# Imprime o valor
    	
    	li $v0, 4                	# Chamada de impressão de string
    	la $a0, space             	# Endereço da string " "
    	syscall

    	addi $t1, $t1, -1		# Incrementar o contador de elemento
    	addi $t3, $t3, 1		# j--;
    	j print_loop_j            	# Continuar o loop de impressão

print_novalinha:
    	li $v0, 4                	# Chamada de impressão de string
    	la $a0, msg              	# Endereço da string de nova linha
    	syscall                  	# Imprime a nova linha
    	addi $t0, $t0, -1        	# i--;
    	j print_loop_i            	# Volta para o loop de impressão de linhas
    
fim:
	li $v0, 10              	# Finaliza o programa
    	syscall
