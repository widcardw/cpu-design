lw s1, zero, 0      // s1=1H
lw s2, zero, 1      // s2=fH
add s4, s0, s2      // s4=fH
sub s5, s0, s1      // s5=FFFFFFFFH
add s6, s5, s4      // s6=eH
slt t0, s1, s2      // s1<s2, t0=1
subu s7, s4, s1     // s7=fH-1H=eH
sub s3, s1, s2      // s3=1h-fh=fffffff2H
addiu s4, s5, b     // s4=aH
sltu t1, s7, s3     // (u)s5<(u)s3, t1=1
ori s5, s0, 0F00    // s5=0 | f00H=0000 0f00H
addiu t2, zero, 2   // t2=2H
beq s4, zero, 2     // if (s7==0) goto sw else s7--
sub s4, s4, s1 
sub s4, s4, s1
j c                 // goto line 12
sw s6, zero, 10     // store 
lw s5, zero, 10     // s5=10H