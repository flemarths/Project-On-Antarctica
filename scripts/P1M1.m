% TP1.m : Premier TD de l'ann�e bas� sur Phase_1_Antarctica.pdf
% 
% 
% TP matlab - Phase 1 Mission 1
% 09/11 Mission 1 
% 
% SANCHEZ Arthur - Octobre 2023

clear all ;
close all ;
clc ;

%%
% ********** Declaration des constantes ************
% Dans cette zone sont initialisees TOUTES les constantes necessaires a
% l'execution du script
% 

DossierTravail = '/home/arthur/Documents/ENSISA/2324/ProjectOnAntarctica';

T = load("ENDURANCE_temperature.mat")  ;              %importation des donn�es
[tmax,jmax] = max(T.temperature);                 %recherche de la temp�rature maximale et du jour correspondant
[tmin,jmin] = min(T.temperature) ;                %recherche de la temp�rature minimale et du jour correspondant
[z,jz] = min(abs(T.temperature)) ;             %recherche de la temp�rature la plus proche de z�ro et du jour correspondant

%%
%********** Acquisition/Generation des signaux ****
% Dans cette zone sont declares TOUS les signaux autres que les constantes


%%
%********** Traitement des signaux ****************
% Dans cette zone sont effectues tous les calculs et traitements des
% grandeurs etudiees

Bruit = rand(1,100)-0.5;         %g�n�ration du bruit
Tbruit = T.temperature + Bruit  ; %cr�artion d'une liste de temp�ratures bruit�es
Tajustee1 = Tbruit ; 
Tajustee1(Tajustee1<0.3 & Tajustee1>-0.2)=0 ; %cr�ation du vecteur aux valeurs ajust�es pr�s de 0�
Tajustee2 = Tajustee1 ;

%%
%********** Visualisation des donn�es *************
% Cette zone permet de regrouper toutes les instructions relatives au trace
% des courbes


plot(T.temps,T.temperature,'-o','LineWidth',2) ;     %affichage de la temp�rature en fonction du temps
hold on;
plot(T.temps,Tbruit,'g','LineWidth',2);                %affichage de la temp�rature bruit�e en fonction du temps
hold on;
plot(T.temps,Tajustee1,'black','LineWidth',2);          %affichage de la temp�rature ajust�e pr�s de O�
hold on;

    
