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

%% Stabilità
autovalori_continuo=eig(A);
autovalori_discreto=abs(eig(sysd.A));
figure(1);
initial(sysd,x0,orizzonte);

%% Ottimizzazione
Q=eye(2)*2;
Qf=Q;
R=0.25;
[K,S,E] = dlqr(Ad,Bd,Q,R);

%% Stabilità ciclo chiuso
Ad_chiuso=Ad-Bd*K;
autovalori_discreto_chiuso=abs(eig(Ad_chiuso));
sysd_chiuso=ss(Ad_chiuso,Bd,C,D,campionamento);
figure(2);
initial(sysd_chiuso,x0,orizzonte);


%% seno
x = 1:0.1:11;
t = 0:0.1:10;
y = zeros(1,length(x));
y_disturbato = zeros(1,length(x));
media=0;
sigma=0.5;
random=media+sigma*randn(1,length(x));

for i=1:length(x)
    y(i) = 4*sin(2*x(i)+10);
    y_disturbato(i) = y(i)+random(i);
end

figure(3);
plot(t,y,t,y_disturbato);
title("4sen(2t+10)");
legend('originale','disturbato');


%% grafico libero a mano
tempo=0:campionamento:orizzonte;
Y = zeros(2,dimensione);
X = zeros(2,dimensione);
X(:,1) = [0 1]';

for t=1:dimensione-1
    Y(:,t) = C*X(:,t);
    X(:,t+1) = Ad*X(:,t);
end
Y(:,dimensione) = C*X(:,dimensione);
figure(4);
subplot(2,1,1);
%y=interp1(Y(1,:),tempo);
stairs(tempo(1,:),Y(1,:));
title('y1');

subplot(2,1,2);
%y=interp1(Y(2,:),tempo);
stairs(tempo(1,:),Y(2,:));
title('y2');


%% grafico controllato a mano
tempo=0:campionamento:orizzonte;
Y = zeros(2,dimensione);
X = zeros(2,dimensione);
U = zeros(1,dimensione-1);
X(:,1) = [0 1]';

for t=1:dimensione-1
    U(:,t)= -K*X(:,t);
    Y(:,t) = C*X(:,t);
    X(:,t+1) = Ad*X(:,t)+Bd*U(:,t);
end
Y(:,dimensione) = C*X(:,dimensione);
figure(5);
subplot(2,1,1);
%y=interp1(Y(1,:),tempo);
stairs(tempo(1,:),Y(1,:));
title('y1 controllato');

subplot(2,1,2);
%y=interp1(Y(2,:),tempo);
stairs(tempo(1,:),Y(2,:));
title('y2 controllato');


%% LQT di z fisso
tempo=0:campionamento:orizzonte;
Y = zeros(2,dimensione);
X = zeros(2,dimensione);
U = zeros(1,dimensione-1);
X(:,1) = [0 1]';
Zbase = [1,2]';
Z = ones(2,dimensione).*Zbase;
Q(1,1)=0.001;
Q(2,2)=0.18;
[K,G,Lg] = Riccati_K_G(Ad,Bd,C,Q,Qf,R,tempo-1,Z);
for t=1:dimensione-1
    U(:,t)= K(:,:,t)*X(:,t)+Lg(:,:,t)*G(:,:,t+1);
    Y(:,t) = C*X(:,t);
    X(:,t+1) = Ad*X(:,t)+Bd*U(:,t);
end
Y(:,dimensione) = C*X(:,dimensione);
figure(5);
subplot(2,1,1);
stairs(tempo(1,:),Y(1,:));
title('y1 tracking verso z(1)=1');

subplot(2,1,2);
stairs(tempo(1,:),Y(2,:));
title('y2 tracking verso z(2)=2');  


%% LQT di z variabile
tempo=0:campionamento:orizzonte;
Y = zeros(2,dimensione);
X = zeros(2,dimensione);
U = zeros(1,dimensione-1);
X(:,1) = [0 1]';

Z = ones(2,dimensione);
for t=1:dimensione-1
    Z(:,t)=Z(:,t).*y(:,t);
end

R=0.001;
Q(1,1)=1;
Q(2,2)=1000;
[K,G,Lg] = Riccati_K_G(Ad,Bd,C,Q,Qf,R,tempo-1,Z);
for t=1:dimensione-1
    U(:,t)= K(:,:,t)*X(:,t)+Lg(:,:,t)*G(:,:,t+1);
    Y(:,t) = C*X(:,t);
    X(:,t+1) = Ad*X(:,t)+Bd*U(:,t);
end
Y(:,dimensione) = C*X(:,dimensione);
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




