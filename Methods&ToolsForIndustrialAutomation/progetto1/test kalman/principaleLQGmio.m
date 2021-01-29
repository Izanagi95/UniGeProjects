clear;
clc;

campionamento=1;
orizzonte=100;
dimensione=orizzonte/campionamento+1;
T=0:campionamento:orizzonte;
A=[0.8 0 0;
   -0.5 1 0;
   0 -1 2];
B=[1 0 ;
   0 1
   1 1];
C=[0 1 1
   1 0 0];
x0=[1 2 3]';
%matrice di covarianza su modello
Q_varianza=eye(3);
%matrice di covarianza su misura
R_varianza=eye(2);
%generare rumore per modello e misura normrnd
system=ss(A,B,C,0);


%% sistema con kalman
SIGMA_varianza=eye(3);
[sigma, k]=kalman_mio(A,C,Q_varianza,R_varianza,SIGMA_varianza,T);
[L,S,e] = dlqr(A,B,Q_varianza,R_varianza);
X=zeros(3,dimensione);
Y=zeros(2,dimensione);
U=zeros(2,dimensione);
mu=X;
%all'inizio la stima migliore è il valore medio di X;
mu(:,1)=x0;
X(:,1)=x0;
%rumore_misura=normrnd(0,sigma);
%rumore_stato=normrnd(0,sigma);
rumore_misura=ones(2,101);
rumore_stato=ones(3,101);

for i=1:dimensione-1
    rumore_misura(:,i)=rumore_misura(:,i)*normrnd(0,0.1);
    rumore_stato(:,i)=rumore_stato(:,i)*normrnd(0,0.5);
end

for t=1:dimensione-1
    U(:,t)=L*mu(:,t);
    %rumore su modello;
    X(:,t+1)=A*X(:,t)+B*U(:,t)+rumore_stato(:,t);
    %diag(rumore_stato(:,:,t));
    %rumore su misura;
    Y(:,t+1)= C*X(:,t+1)+rumore_misura(:,t);
    %diag(rumore_misura(:,:,t));
    mu(:,t+1)=A*mu(:,t)+B*U(:,t)+k(:,:,t+1)*(Y(:,t+1)-C*(A*mu(:,t)+B*U(:,t)));
end
%Y(:,dimensione)=C*X(:,t);

figure(1);
subplot(3,1,1);
plot(T,X(1,:),T,mu(1,:));
title('X1');
legend('stato vero','stato stimato');
subplot(3,1,2);
plot(T,X(2,:),T,mu(2,:));
title('X2');
subplot(3,1,3);
plot(T,X(3,:),T,mu(3,:));
title('X3');


