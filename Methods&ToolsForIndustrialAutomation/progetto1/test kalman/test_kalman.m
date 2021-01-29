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

%% Ottimizzazione

%% variazione di stato
X=zeros(2,dimensione);
Y=zeros(2,dimensione);
U=zeros(1,dimensione-1);
tempo=0:campionamento:orizzonte;
X(:,1)=x0;
media=0;
sigma=0.5;
random_state=media+sigma*randn(1,length(X(1,:)));
sigma=0.1;
random_measure=media+sigma*randn(1,length(X(1,:)));
for t=1:dimensione-1
    Y(:,t)=C*X(:,t)+random_measure(t);
    X(:,t+1)=Ad*X(:,t)+Bd*U(:,t)+random_state(t); 
end
Y(:,dimensione)=C*X(:,dimensione);

%{
figure(1);
subplot(2,1,1);
plot(tempo,Y(1,:));
subplot(2,1,2);
plot(tempo,Y(2,:));
%}

%% filtro di kalman
Xneg=zeros(2,dimensione);
Xpos=zeros(2,dimensione);
Y_=zeros(2,dimensione);

tempo=0:campionamento:orizzonte;
X(:,1)=x0;
Xpos(:,1)=x0;
%inizializzazione
Ppos=zeros(2,2,dimensione);
Ppos(:,1)=[1 1]';
Pneg=zeros(2,2,dimensione);
L=zeros(2,2,dimensione);
Q=eye(2)*0.5;
R=eye(2)*0.1;
%{
Q=zeros(2,2,dimensione);
R=zeros(2,2,dimensione);
Q(:,:,1)=cov(random_state(1));
R(:,:,1)=cov(random_measure(1));
%}
e=zeros(2,dimensione);
for t=1:dimensione-1
    %aggiornamento dello stato
    Xneg(:,t+1)=A*Xpos(:,t);
    %Pneg(:,:,t+1)=A*Ppos(:,:,t)*A'+Q(:,:,t);
    %aggiornamento varianza errore sullo stato
    Pneg(:,:,t+1)=A*Ppos(:,:,t)*A'+Q;
    %L(:,:,t+1)=Pneg(:,:,t+1)*C'*inv(C*Pneg(:,:,t+1)*C'+R(:,:,t));
    %aggiornamento matrice di correzione dello stato
    L(:,:,t+1)=Pneg(:,:,t+1)*C'*inv(C*Pneg(:,:,t+1)*C'+R);
    e(:,t+1)=(Y(:,t+1)-C*Xneg(:,t+1));
    %aggiornamento della stima dello stato
    Xpos(:,t+1)=Xneg(:,t+1)+L(:,:,t+1)*e(:,t+1);
    %aggiornamento varianza disturbi dello stato
    Ppos(:,:,t+1)=(eye(2)-L(:,:,t+1)*C)*Pneg(:,:,t+1);
end
Y(:,dimensione)=C*X(:,dimensione);

figure(2);
subplot(2,1,1);
plot(tempo,Y(1,:));
hold on;
plot(tempo,Xpos(1,:),'Color','red');
legend('reale','predetto');
hold off;
subplot(2,1,2);
plot(tempo,Y(2,:));
hold on;
plot(tempo,Xpos(2,:),'Color','red');
legend('reale','predetto');
hold off;


