% P1M1.m : Premier TD de l'année basé sur Phase_1_Antarctica.pdf
% 
% 
% TP matlab - Phase 1 Mission 1
% 09/10 Mission 1 début (questions 1 à 5)
% 14/10 fin de la Mission 1 
% SANCHEZ Arthur - Octobre 2023

clear all ;
close all ;
clc ;

%%
% ********** Declaration des constantes ************
% Dans cette zone sont initialisees TOUTES les constantes necessaires a
% l'execution du script
% 

CheminTemperature= '/home/arthur/Documents/ENSISA/2324/Project-On-Antarctica/ressources/ENDURANCE_temperature.mat';


%%
%********** Acquisition/Generation des signaux ****
% Dans cette zone sont declares TOUS les signaux autres que les constantes

T = load(CheminTemperature)  ;              %importation des données
[tmax,jmax] = max(T.temperature);                 %recherche de la température maximale et du jour correspondant
[tmin,jmin] = min(T.temperature) ;                %recherche de la température minimale et du jour correspondant
[z,jz] = min(abs(T.temperature)) ;             %recherche de la température la plus proche de zéro et du jour correspondant


%%
%********** Traitement des signaux ****************
% Dans cette zone sont effectues tous les calculs et traitements des
% grandeurs etudiees

Bruit = rand(1,100)-0.5;         %génération du bruit
Tbruit = T.temperature + Bruit  ; %créartion d'une liste de températures bruitées
Tajustee1 = Tbruit ; 
Tajustee1(Tajustee1<0.3 & Tajustee1>-0.2)=0 ; %création du vecteur aux valeurs ajustées près de 0°
Tajustee2 = Tajustee1 ;
for i = 2:99
    if Tajustee2(i)<-80
        Tajustee2(i)=Tajustee2(i)-(Tajustee2(i-1)+Tajustee2(i+1))/2;
    end
end
SommeTemp=0;
for i =1:100
    SommeTemp=SommeTemp+abs(Tajustee2(i));
end

%%
%********** Visualisation des données *************
% Cette zone permet de regrouper toutes les instructions relatives au trace
% des courbes

disp("la température maximale est "+tmax+" et elle a été atteinte au jour "+jmax)
disp("la température minimale est "+tmin+" et elle a été atteinte au jour "+jmin)
disp("la température la plus proche de zéro est "+z+" et elle a été atteinte au jour "+jz)

plot(T.temps,T.temperature,'-o','LineWidth',2) ; %affichage de la température en fonction du temps
hold on;
plot(T.temps,Tbruit,"g");                %affichage de la température bruitée en fonction du temps
plot(T.temps,Tajustee1,"k");          %affichage de la température ajustée près de O°
plot(T.temps,Tajustee2,"r")
legend("temperatures non corrigées","temperatures avec bruit","temperatures avec bruit corrigées près de 0°","temperature avec bruit corrigées près de 0° et de -80°")
xlabel("Temps (jours)")
ylabel("Température (°)")
title("Evolution de la température au cours du temps")
%fontsize(gca,20,"pixels")
hold off;

display("le capteur à accumulé "+SommeTemp+"° en valeur absolue, il n'est donc plus fonctionel")




