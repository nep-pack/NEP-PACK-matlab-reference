
randn('seed',0);
n=5;

A0=randn(n,n);
A1=randn(n,n);
A2=randn(n,n);

M=@(s) A0+A1*s+A2*s^2;




