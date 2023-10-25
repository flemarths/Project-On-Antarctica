%P2M1.M : Mission 1 de la Phase 2 du premier module de TP matlab
% 
%
% Création le 24/10
% 
%
% SANCHEZ Arthur - Octobre 2023
 
clear all; close all; clc;


% %
% ********** Declaration des constantes ************
% Dans cette zone sont initialisees TOUTES les constantes necessaires a
% l'execution du script
% 

chemin_datagps = "/home/arthur/Documents/ENSISA/2324/Project-On-Antarctica/ressources/IRIMAS_voiture/dataGps.mat";

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


%%
%********** Traitement des signaux ****************
% Dans cette zone sont effectues tous les calculs et traitements des
% grandeurs etudiees


%%
%********** Visualisation des données *************
% Cette zone permet de regrouper toutes les instructions relatives au trace
% des courbes


figure('Name','trajectoire non interpolée')
plot(Xgps,Ygps)
xlabel('position en X')
ylabel('position en Y')
title("trajectoire non interpolée")
legend('trajectoire')




figure('Name','Evolution de la résolution')
plot(Tgps(1:end-1),Resolution)
xlabel('temps en secondes')
ylabel('resolution')
title("évolution de la résolution au cours du temps")
legend('résolution')

figure('Name','identification des parties fiables de la trajectoire')
scatter(GpsOk(:,1),GpsOk(:,2),'green','filled');
hold on;
scatter(GpsNo(:,1),GpsNo(:,2),'red','filled');
xlabel('position en X')
ylabel('position en Y')
title("identification des parties fiables de la trajectoire")
legend('trajectoire fiable','trajectoire non fiable')


fprintf('la distance totale parcourue est de %f mètres\n',Dtot);