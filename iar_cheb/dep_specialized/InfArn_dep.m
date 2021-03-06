function [ V, H ] = InfArn_dep( nep, v1, m )
%INFARN naive implementation
%   Naive imprementation of Infinite Arnoldi
%   Date: 13 May 2014
%   Giampaolo Mele
%   
%   INPUT
%   M is the matrix-function that defines the NLEP
%   m is the number of steps of the algorithm
%
%   OUTPUT
%   Ritz is the vector containig the Ritz values

% inizialization
M0 = nep.Mdd(0);
n=size(M0,1);   % size of the problem

V=v1/norm(v1);                  % basis of Krylov space
H=zeros(1,1);                   % Hessenberg matrix

LL = @(k) L(k)*(nep.b-nep.a)/4;
a=nep.a; b=nep.b;

P=P_mat(m+1,2/(b-a),(a+b)/(a-b));
Pinv=Pinv_mat(m+1,2/(b-a),(a+b)/(a-b));


% iterations of the algorithm
for k=1:m
    fprintf("Iteration %d\n",k);
    % COMPUTING NEXT VECTOR OF THE ARNOLDI SEQUENCE
    

    % dep version
    y=zeros(n,k+1);
    x=reshape(V(:,k),n,k);
    y(:,2:end)=x*LL(k);
    y(:,1)=dep_y0(x,y,nep);
    y=reshape(y,(k+1)*n,1);

    
    % expand V
    V=[V ; zeros(n,k)];
    
    % double orthogonalization
    h=V'*y;    y=y-V*h;
    g=V'*y;    y=y-V*g;
    H(:,k)=h+g;
    
    
    H(k+1,k)=norm(y);
    V(:,k+1)=y/H(k+1,k);
    
    
    
    
end



end

% matrix needed to the expansion
function Lmat=L(k)
    if k==1
        Lmat=2;
    else
        Lmat=diag([2, 1./(2:k)])+diag(-1./(1:(k-2)),-2);
    end
end


function y0=dep_y0(x,y,nep)
    T=@(i,x) cos(i*acos(x));
    
    a=nep.a;    b=nep.b;
    A1=nep.A1;
    A2=nep.A2;
    A0=nep.A0;  
    c=(a+b)/(a-b);
    k=2/(b-a);
    tau1=nep.tau1;
    tau2=nep.tau2;
    

    N=size(x,2);
    n=size(x,1);

    
    y0=zeros(n,1);
    for i=1:N+1
        y0=y0-T(i-1,c)*(A0*y(:,i));
    end
    
    for i=1:N
        y0=y0+T(i-1,c)*x(:,i);
    end  
    
    for i=1:N+1
        y0=y0-T(i-1,-k*tau1+c)*(A1*y(:,i));
    end
    
    for i=1:N+1
        y0=y0-T(i-1,-k*tau2+c)*(A2*y(:,i));
    end
    
    y0=(A0+A1+A2)\y0;
    
end



