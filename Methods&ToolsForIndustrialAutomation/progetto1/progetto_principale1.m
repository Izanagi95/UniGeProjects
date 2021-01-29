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
%C=eye(2);
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


%% avanzamento di stato
Y = zeros(2,dimensione);
X = zeros(2,dimensione);
Z = ones(2,dimensione);
U = zeros(1,dimensione);
X(:,1) = x0;
mu=X;
%all'inizio la stima migliore è il valore medio di X;
mu(:,1)=x0;


for t=1:dimensione-1
    Z(:,t)=Z(:,t).*y(t);
end

R=0.01;
Q(1,1)=1;
Q(2,2)=1;
Qf=Q;
SIGMA_varianza=eye(2);
SIGMA_varianza(1,1)=0.5;
SIGMA_varianza(2,2)=0.1;
[L,G,Lg] = Riccati_K_G(Ad,Bd,C,Q,Qf,R,tempo-1,Z);
[sigma, k]=kalman_mio(Ad,C,Q,R,SIGMA_varianza,tempo);
rumore_misura=ones(2,dimensione);
rumore_stato=ones(2,dimensione);

for i=1:dimensione
    rumore_stato(:,i)=rumore_stato(:,i)*normrnd(0,0.5);
    rumore_misura(:,i)=rumore_misura(:,i)*normrnd(0,0.1);
end

for t=1:dimensione-1
    U(:,t)=L(:,:,t)*mu(:,t)+Lg(:,:,t)*G(:,:,t+1);
    %rumore su modello;
    X(:,t+1)=Ad*X(:,t)+Bd*U(:,t)+rumore_stato(:,t);
    %rumore su misura;
    Y(:,t+1)= C*X(:,t+1)+rumore_misura(:,t);
    mu(:,t+1)=Ad*mu(:,t)+Bd*U(:,t)+k(:,:,t+1)*(Y(:,t+1)-C*(Ad*mu(:,t)+Bd*U(:,t)));
end

figure(1);
subplot(3,1,1);
plot(tempo,y(:));
title("segnale di riferimento 4sen(2t+10)");
subplot(3,1,2);
plot(tempo,X(1,:),tempo,mu(1,:));
title('X1');
legend('originale','predetto');
subplot(3,1,3);
plot(tempo,X(2,:),tempo,mu(2,:));
title('X2');



