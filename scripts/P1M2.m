% p1m2.m : Phase 2 de la Mission 1
% 
% Creation 11/10/2023
% 
%test
% SANCHEZ Arthur - Novembre 2023

clear all;
close all;
clc;




% %
% ********** Declaration des constantes ************
% Dans cette zone sont initialisees TOUTES les constantes necessaires a
% l'execution du script
% 

CheminFussak='/home/arthur/Documents/ENSISA/2324/Project-On-Antarctica/ressources/ENDURANCE_carto_fussak.mat' ;
CheminManchot='/home/arthur/Documents/ENSISA/2324/Project-On-Antarctica/ressources/ENDURANCE_carto_manchot.mat';

%%
%********** Acquisition/Generation des signaux ****
% Dans cette zone sont declares TOUS les signaux autres que les constantes

load(CheminManchot);
load(CheminFussak);

[I,J] = find(carto_manchot == 1);           
[K,L] = find(carto_manchot == 2);
[M,N] = find(carto_manchot == 3);
[O,P] = find(carto_manchot == 4);
[Q,R] = find(carto_manchot == 5);
[S,T] = find(carto_manchot == 6);          % emplacements des gorfous

Empereur = carto_manchot==1;
Adelie = carto_manchot==2;
Papou = carto_manchot==3;
Royal = carto_manchot==4;
Jugulaire = carto_manchot==5;
Gorfu = carto_manchot==6;

[x1E,y1E]=find(Empereur==1)
[x0E,y0E]=find(Empereur==0)

[x1A,y1A]=find(Adelie==1)
[x0A,y0A]=find(Adelie==0)


%%
%********** Traitement des signaux ****************
% Dans cette zone sont effectues tous les calculs et traitements des
% grandeurs etudiees



%%
%********** Visualisation des données *************
% Cette zone permet de regrouper toutes les instructions relatives au trace
% des courbes


scatter(J,I,'x','black');
hold on;
scatter(L,K,'x','b');
scatter(N,M,'x','r');
scatter(P,O,'+','m');
scatter(R,Q,'o','g');
scatter(T,S,'o','red');
hold off;

subplot(3,2,1)
scatter(y1E,x1E,'x');
hold on;
scatter(y0E,x0E,'o');

subplot(3,2,2)
scatter(y1A,x1A,'x')
scatter(y0A,x0A)

