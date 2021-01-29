function [sigma, k]=kalman_mio(A,C,Q_varianza,R_varianza,SIGMA_varianza,T)
%Q_varianza della normale del rumore sullo stato x
%R_varianza della normale del rumore sulla misura y,
%SIGMA_varianza della normale dello stato all'istante 0
orizz=length(T);
sigma(:,:,1)=inv(inv(SIGMA_varianza)+C'*inv(R_varianza)*C);

for i=1:orizz
k(:,:,i)=sigma(:,:,i)*C'*inv(R_varianza);
sigma(:,:,i+1)=inv(inv(A*sigma(:,:,i)*A'+Q_varianza)+C'*inv(R_varianza)*C);
end


end
