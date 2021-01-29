clear;
clc;

%% Parametri del sistema da simulare
orizzonte=10;
campionamento=0.1;
dimensione=(orizzonte/campionamento)+1;
tempo=0:campionamento:orizzonte;
x0=[0 1]';
A=[0 1; -1 0];
B=[0 1]';
C=[0 1
   0 0];
D=0;
sys = ss(A,B,C,D);
sysd = c2d(sys,campionamento);
Ad=sysd.A;
Bd=sysd.B;

%% seno
x=1:campionamento:orizzonte+1;
y = zeros(1,length(x));
for i=1:length(x)
    y(i) = 4*sin(2*x(i)+10);
end

%% prova
Y = zeros(3,dimensione);
X = zeros(2,dimensione);
X_ = zeros(3,dimensione);
Z = ones(2,dimensione);
U = zeros(1,dimensione-1);
W = zeros(1,dimensione-1);
Ad_=[Ad Bd;
    0 eye(size(U,1),size(Ad,2))];
Bd_=[Bd' size(U,1)]';
C_=[C zeros(length(C),1);
    zeros(1,length(C)) 0];
X(:,1) = x0;
X_(:,1) = [X(:,1)' 0]';
mu=X_;

for t=1:dimensione-1
    Z(:,t)=Z(:,t).*y(t);
end
Z_=[Z; zeros(1,dimensione)];

R=1;
Q(1,1)=100;
Q(2,2)=100;
Qf=Q;

Q_=[Q zeros(length(Q),length(R));
    zeros(length(R),length(Q)) R];
QF_=[Qf zeros(length(Qf),1);
    zeros(1,length(Qf)), R];
R_=R;

SIGMA_varianza=eye(2);
SIGMA_varianza(1,1)=0.5;
SIGMA_varianza(2,2)=0.1;
[L,G,Lg] = Riccati_K_G(Ad_,Bd_,C_,Q_,QF_,R_,tempo-1,Z_);
[sigma, k]=kalman_mio(Ad,C,Q,R,SIGMA_varianza,tempo);
rumore_misura=zeros(3,dimensione);
rumore_stato=zeros(3,dimensione);

for i=1:dimensione
    rumore_stato(1:2,i)=ones(2,1)*normrnd(0,0.5);
    rumore_misura(1:2,i)=ones(2,1)*normrnd(0,0.1);
end

for t=1:dimensione-1
    U(:,t)=L(:,:,t)*mu(:,t)+Lg(:,:,t)*G(:,:,t+1);
    if t==1
        W(:,t)=U(:,t);
    else 
        W(:,t)=U(:,t)-U(:,t-1);
        X_(3,t)=U(:,t-1);
    end
    %rumore su modello;
    X_(:,t+1)=Ad_*X_(:,t)+Bd_*W(:,t)+rumore_stato(:,t);
    
    %rumore su misura;
    Y(:,t+1)= C_*X_(:,t+1)+rumore_misura(:,t);
    K=[k(:,:,t+1) zeros(2,1);
        zeros(1,2) 0];
    mu(:,t+1)=Ad_*mu(:,t)+Bd_*U(:,t)+K*(Y(:,t+1)-C_*(Ad_*mu(:,t)+Bd_*U(:,t)));
end


figure(2);
subplot(3,1,1);
plot(tempo,y(:));
title("prova segnale di riferimento 4sen(2t+10)");
subplot(3,1,2);
plot(tempo,X_(1,:),tempo,mu(1,:));
title('X1');
legend('originale','predetto');
subplot(3,1,3);
plot(tempo,X_(2,:),tempo,mu(2,:));
title('X2');

