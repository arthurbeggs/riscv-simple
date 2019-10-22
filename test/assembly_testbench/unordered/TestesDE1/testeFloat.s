.data
F0: .float -1
F1: .float 2

.text
la t0,F0
flw ft0,0(t0)
flw ft1,4(t0)
fadd.s ft2,ft0,ft1
nop
feq.s t1,ft0,ft0
