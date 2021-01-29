clear;
clc;

%% Parametri
orizzonte=10;
campionamento=0.1;
dimensione=(orizzonte/campionamento) +1;
x0=[0 1]';
A=[0 1; -1 0];
B=[0 1]';
C=eye(2);
D=[0 0]';
sys = ss(A,B,C,D);
sysd = c2d(sys,campionamento);
Ad=sysd.A;
Bd=sysd.B;

%% Segnale seno di riferimento
x = 1:0.1:orizzonte+1;
y = zeros(1,length(x));

for i=1:length(x)
    y(i) = 4*sin(2*x(i)+10);
end


%% tracking del segnale
tempo=0:campionamento:orizzonte;
Y = zeros(2,dimensione);
X = zeros(2,dimensione);
X(:,1) = [0 1]';
U = zeros(1,dimensione-1);
Z = ones(2,dimensione);
for t=1:dimensione-1
    Z(:,t)=Z(:,t).*y(:,t);
end

R=0.001;
Q(1,1)=10000000;
Q(2,2)=10000;
Qf=Q;
[K,G,Lg] = Riccati_K_G(Ad,Bd,C,Q,Qf,R,tempo-1,Z);
for t=1:dimensione-1
    U(:,t)= K(:,:,t)*X(:,t)+Lg(:,:,t)*G(:,:,t+1);
    Y(:,t) = C*X(:,t);
    X(:,t+1) = Ad*X(:,t)+Bd*U(:,t);
end
Y(:,dimensione) = C*X(:,dimensione);


%% stampa dei grafici
figure(6);
subplot(3,1,1);
stairs(tempo(1,:),Y(1,:));
title('y1 tracking verso 4sen(2t+10)');

subplot(3,1,2);
stairs(tempo(1,:),Y(2,:));
title('y2 tracking verso 4sen(2t+10)');  

subplot(3,1,3);
stairs(tempo(1,:),y(1,:));
title('4sen(2t+10)'); 


