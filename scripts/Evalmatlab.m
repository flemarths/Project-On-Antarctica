%EvalMatlab.M : Dernière séance de matlab (évaluée)
% 
% 
% Création le 07/11
%
% 
%
% SANCHEZ Arthur - Novembre 2023
 
clear all; close all; clc;


% %
% ********** Declaration des constantes ************
% Dans cette zone sont initialisees TOUTES les constantes necessaires a
% l'execution du script
% 

chemin_crash='ENDURANCE_crash_exam.mat'; %chemin d'accès
Te=0.5;
T=0.2;
%%
%********** Acquisition/Generation des signaux ****
% Dans cette zone sont declares TOUS les signaux autres que les constantes

load(chemin_crash)      %importation des données


Temp_mot=R05_data(:,1);         %acquisition de la température
pixels_cam=R05_data(:,2);       % idem pixels
qlt_GPS=R05_data(:,3);          % idem qualité gps
Pola_EM=R05_data(:,4);          % idem Polarisation





%%
%********** Traitement des signaux ****************
% Dans cette zone sont effectues tous les calculs et traitements des
% grandeurs etudiees

DataNonCoherentes=find(Temp_mot<-16 & Temp_mot>110);  % recherche d'éventuelles données non cohérentes

[DeltaCrit,tPola_Crit]=min(abs(Pola_EM+5));
Pola_Crit=Pola_EM(tPola_Crit);

Temp=0;

for i=2:size(Temp_mot)
    Temp(i)=Temp(i-1)+Te.*Temp_mot(i);
end

Tcrash=find(Temp>1500);

DetectErr=0;

for i =2:size(Temp_mot)
    DetectErr(i)=((Temp_mot(i)-Temp_mot(i-1))/T)>abs(mean(Temp));
end


%%
%********** Visualisation des données *************
% Cette zone permet de regrouper toutes les instructions relatives au trace
% des courbes

disp("Il n'y a aucune donnée en-dessous de -16°C et au dessus de 110°C dans les mesures de température," + ...
    "les données sont donc cohérentes")  % affichage de l'étude de la cohérence des températures moteur

disp("La valeur la plus proche de la valeur critique est de "+Pola_Crit+" et elle est atteinte pour t="+tPola_Crit+"s") % affichage de la valeur critique de polarité EM

disp("la température est supérieure à 1500°C pour t dans Tcrash, c'est-à-dire à partir de t=73")



figure(1)                                   % Tracé de la température au cours du temps
plot(temps,Temp_mot,'ks');
title("évolution de la température du moteur au cours du temps")
xlabel("temps en secondes")
ylabel("température en °C")
legend("température")

figure(2)                                   %Tracé de Pola_EM
plot(temps,Pola_EM);
title("tracé de la polarité électromagnétique au cours du temps")
xlabel("temps en secondes")
ylabel("Polarité EM (sans unité)")
legend("Polarité EM")


figure(3)
subplot(2,2,1)                      %tracé température
plot(temps,Temp_mot,'ks');
title("évolution de la température du moteur au cours du temps")
xlabel("temps en secondes")
ylabel("température en °C")
legend("température")

subplot(2,2,2)                  %tracé des pixels
plot(temps,pixels_cam);
title("évolution des pixels de la camera")
xlabel("temps en secondes")
ylabel("pixels de la caméra")
legend("pixels")

subplot(2,2,3)                   %tracé de la qualité gps
plot(temps,qlt_GPS);
title("évolution de la qualité gps au cours du temps")
xlabel("temps en secondes")
ylabel("qualité gps")
legend("qualité gps")

subplot(2,2,4)                                 %Tracé de Pola_EM
plot(temps,Pola_EM);
title("tracé de la polarité électromagnétique au cours du temps")
xlabel("temps en secondes")
ylabel("Polarité EM (sans unité)")
legend("Polarité EM")

