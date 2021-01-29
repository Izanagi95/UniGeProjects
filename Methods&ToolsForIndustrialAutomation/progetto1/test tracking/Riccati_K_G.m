function [K,G,Lg] = Riccati_K_G(A,B,C,Q,Qf,R,T,Z)
N=length(T)-1;
%calcolo K a tempo finito
P(:,:,N+1)=Qf; %P è settata come matrice a 3 dimensioni per far avere evoluzione temporale
for i=N:-1:1 % ne calcoliamo uno in più, dovrebbe essere fino a 1
P(:,:,i)=Q+A'*P(:,:,i+1)*A-A'*P(:,:,i+1)*B*...
     (inv(R+B'*P(:,:,i+1)*B))*B'*P(:,:,i+1)*A;
end

%calcolo guadagno
for i=1:N
K(:,:,i)=-inv(R + B'*P(:,:,i+1)*B)*...
          B'*P(:,:,i+1)*A;
end

%calcolo G
G=zeros(size(P,1),1,N+1);
G(:,:,N+1)=C'*Qf*Z(:,N+1);
W=C'*Q;
E=B*inv(R)*B';
for i=N:-1:1
 %  G(:,:,i)=(A'-A'*P(:,:,i+1)*...
 %  inv(eye(size(P,1),1)+E*P(:,:,i+1))*E)*G(:,:,i+1)+W*Z(:,i);
    G(:,:,i)=A'*(eye(2)-inv(inv(P(:,:,i+1))+E)*E)*G(:,:,i+1)+W*Z(:,i);
end

%calcolo LG
for i=1:N
   Lg(:,:,i)=inv(R+B'*P(:,:,i+1)*B)*B';
end

end
