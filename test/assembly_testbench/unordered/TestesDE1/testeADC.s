# ####################################### #
# #  Teste da interface ADC		# #
# #   Endereçoos de Acesso:		# #
# #  CH0: 0xFF20 0200			# #
# #  ..					# #
# #  CH7: 0xFF20 021C			# #
# ####################################### #


.text

li t0,0xFF200200		# endereco do CH0

LOOP: lw x8,0(t0)
      lw x9,4(t0)
      lw x10,8(t0)
      lw x11,12(t0)      
      lw x12,16(t0)
      lw x13,20(t0)
      lw x14,24(t0)
      lw x15,28(t0)
      j LOOP
