.data
	prompt: .asciiz	"Insira o raio do circulo: "
	out: 	.asciiz	"A area eh: "
	raio:	.double	0.0
	pi:	.double 3.141592653589793
	area:	.double 0.0
.text
main:
	li $v0, 4              # Código da syscall para imprimir uma string (syscall 4)
	la $a0, prompt         # Carrega o endereço da mensagem
	syscall                # Executa a syscall para exibir a mensagem
    
	li $v0, 5              # Código da syscall para ler um número inteiro (syscall 5)
	syscall                # Executa a syscall para ler o número
	mtc1 $v0, $f0	       # Move o valor inteiro lido para registrador de ponto flutuante $f0
	cvt.d.w $f0, $f0       # Converte o valor word para double
	
	s.d $f0, raio
	
	jal calcular_area_do_circulo
	
	li $v0, 4              # Código da syscall para imprimir string (syscall 4)
    	la $a0, out            # Carrega o endereço da mensagem "A area eh: "
    	syscall                # Executa a syscall para imprimir

	l.d $f12, area
	
	li $v0, 3              # Código da syscall para imprimir float
    	syscall                # Executa a syscall para imprimir a area

	li $v0, 10             # Código da syscall para terminar o programa (syscall 10)
	syscall                # Executa a syscall para sair do programa
	
calcular_area_do_circulo:
	l.d $f0, raio
	l.d $f2, pi
	
	mul.d $f4, $f0, $f0	# raio^2
	mul.d $f6, $f4, $f2	# raio^2 * pi
	
	s.d $f6, area
	
	jr $ra