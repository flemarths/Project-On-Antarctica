%P2M1.M : Phase 2 du premier module de TP matlab
% 
%
% Création le 24/10
% Mission 2 et 3 le 25/10
%
% SANCHEZ Arthur - Octobre 2023
 
clear all; close all; clc;


% %
% ********** Declaration des constantes ************
% Dans cette zone sont initialisees TOUTES les constantes necessaires a
% l'execution du script
% 

chemin_datagps = "/home/arthur/Documents/ENSISA/2324/Project-On-Antarctica/ressources/IRIMAS_voiture/dataGps.mat";

chemin_dataCapt = "/home/arthur/Documents/ENSISA/2324/Project-On-Antarctica/ressources/IRIMAS_voiture/dataCapt.mat";

Tech=0.02;
x0=0;
y0=0;
psi0=-2.18;

Q = [0.001,0,0;0,0.001,0;0,0,0.0001*pi/180];
Rgps=[0.015^2,0;0,0.015^2];
Rpro=[8*10^(-7),0,0;0,7.87*10^(-7),0;0,0,4.17*10^(-6)];
C=[1,0,0;0,1,0];
P=[Rgps(1,1),0,0;0,Rgps(2,2),0;0,0,pi/3];
I=[1,0,0;0,1,0;0,0,1];


%%
%********** Acquisition/Generation des signaux ****
% Dans cette zone sont declares TOUS les signaux autres que les constantes

load(chemin_datagps)
dataGpsEch=dataGps(1,:);

for i = 2:size(dataGps,1)
    if dataGps(i,5)~=dataGps(i-1,5)
        dataGpsEch(end+1,:)=dataGps(i,:);
    end
end

Tgps=dataGpsEch(:,1);
Xgps=dataGpsEch(:,2);
Ygps=dataGpsEch(:,3);
Qgps=dataGpsEch(:,4);
DataOk=dataGpsEch(:,5);

for i = 1:size(Xgps)-1
    Resolution(i)=sqrt((Xgps(i+1)-Xgps(i))^2+(Ygps(i+1)-Ygps(i))^2);
end

Dtot=sum(Resolution);

GpsOk=dataGpsEch(find(dataGpsEch(:,4)==18),2:3);
GpsNo=dataGpsEch(find(dataGpsEch(:,4)~=18),2:3);


load(chemin_dataCapt)

Tcapt=dataCapt(:,1);
Vt=dataCapt(:,2);
Vl=dataCapt(:,3);
Psip=dataCapt(:,4);

biais=mean(dataCapt(1:(10/0.2+1),4));
PsipC=Psip - biais;

Psi=(psi0);
PsiC=(psi0);
XCapt=(x0);
YCapt=(y0);

for i=1:size(Psip)-1
    Psi(i+1,1)=Psi(i)+Tech*Psip(i);
    PsiC(i+1,1)=PsiC(i)+Tech*PsipC(i);
    XCapt(i+1,1)=XCapt(i)+Tech*(Vl(i)*cos(PsiC(i))-Vt(i)*sin(PsiC(i)));
    YCapt(i+1,1)=YCapt(i)+Tech*(Vl(i)*sin(PsiC(i))+Vt(i)*cos(PsiC(i)));
end

X=[x0;y0;psi0];


for i=2:size(Tcapt)
    A=[1,2,(-Tech).*(Vt(i-1).*cos(PsiC(i-1))+Vl(i-1).*sin(PsiC(i-1)));
        0,1,Tech.*(Vl(i-1).*cos(PsiC(i-1))-Vt(i-1).*sin(PsiC(i-1)));
        0,0,1];
    B=[Tech*cos(PsiC(i-1)),-Tech.*sin(PsiC(i-1)),0;Tech.*sin(PsiC(i-1)),Tech.*cos(PsiC(i-1)),0;0,0,Tech];
    X(:,i)=[X(1,i-1)+Tech*(Vl(i-1)*cos(PsiC(i-1))-Vt(i-1)*sin(PsiC(i-1))),X(2,i-1)+Tech*(Vl(i-1)*sin(PsiC(i-1))+Vt(i-1)*cos(PsiC(i-1))),PsiC(i-1)];   
    P=A*P*A.'*+B*Rpro*B.'+Q;
    if dataGps(i,1)~=dataGps(i-1,1) && dataGps(i,4)==18
        K=P*C.'*(C*P*C.'+Rgps)^-1;
        mesures_gps=[dataGps(i,2);dataGps(i,3)];
        X(:,i)=X(:,i)+K*(mesures_gps-C*X(:,i));
        P=(I-K*C)*P;
    end
end


%%
%********** Traitement des signaux ****************
% Dans cette zone sont effectues tous les calculs et traitements des
% grandeurs etudiees


%%,
%********** Visualisation des données *************
% Cette zone permet de regrouper toutes les instructions relatives au trace
% des courbes


figure(1)
plot(Xgps,Ygps)
xlabel('position en X')
ylabel('position en Y')
title("trajectoire non interpolée")
legend('trajectoire')




figure(2)
plot(Tgps(1:end-1),Resolution)
xlabel('temps en secondes')
ylabel('resolution')
title("évolution de la résolution au cours du temps")
legend('résolution')

figure(3)
scatter(GpsOk(:,1),GpsOk(:,2),'green','filled');
hold on;
scatter(GpsNo(:,1),GpsNo(:,2),'red','filled');
xlabel('position en X')
ylabel('position en Y')
title("identification des parties fiables de la trajectoire")
legend('trajectoire fiable','trajectoire non fiable')


fprintf('la distance totale parcourue est de %f mètres\n',Dtot);

fprintf("le biais est de %f\n",biais);

figure(4)
hold on;
plot(Tcapt,PsipC,'k');
plot(Tcapt,Psip,'r');
xlabel('temps (s)')
ylabel('vitesse de lacet (rad/s)')
title("évolution de la vitesse de lacet au cours du temps")
legend('signal compensé','signal biaisé')

figure(5)
hold on;
plot(Tcapt,Psi,'r');
plot(Tcapt,PsiC,'k');
xlabel('temps (s)');
ylabel('cap psi (rad)')
title('évolution du cap au cours du temps')
legend('signal biaisé','signal compensé')

figure(6)
hold on;
plot(Xgps,Ygps,'LineWidth',2);
plot(XCapt,YCapt,'LineWidth',2);
xlabel('position selon x')
ylabel('position selon y')
title('comparatif des trajectoires Gps et Capteur')
legend('trajectoire Gps','trajectoire Capteur (non biaisée)')

figure(7)
plot(X(1,:),X(2,:))
xlabel('position selon x')
ylabel('position selon y')
title('trajectoire corrigée')
legend('trajectoire corrigée Gps + Capt')