% p1m2.m : Phase 2 de la Mission 1
% 
% Creation 11/10
% Modif 14/10 
%
% SANCHEZ Arthur - Novembre 2023

clear all;
close all;
clc;




% %
% ********** Declaration des constantes ************
% Dans cette zone sont initialis>> ees TOUTES les constantes necessaires a
% l'execution du script
% 

CheminFussak="/home/arthur/Documents/ENSISA/2324/Project-On-Antarctica/ressources/ENDURANCE_carto_fussak.mat" ;
CheminManchot="/home/arthur/Documents/ENSISA/2324/Project-On-Antarctica/ressources/ENDURANCE_carto_manchot.mat";

ListeNomEspeces= ["Manchot Empereur","Manchot Adélie","Manchot Papou","Manchot Royal","Manchot à Jugulaire","Gorfou Doré"];

optn = ["xk","xb","xr","+m","og","or"];


%%
%********** Acquisition/Generation des signaux ****
% Dans cette zone sont declares TOUS les signaux autres que les constantes

load(CheminManchot);
load(CheminFussak);

[yG,xG]=find(carto_manchot==6);
yG = 13 - yG;

Empereur = carto_manchot==1;
Adelie = carto_manchot==2;
Papou = carto_manchot==3;
Royal = carto_manchot==4;
Jugulaire = carto_manchot==5;
Gorfu = carto_manchot==6;

ListeManchots=[Empereur Adelie Papou Royal Jugulaire Gorfu];



%%
%********** Traitement des signaux ****************
% Dans cette zone sont effectues tous les calculs et traitements des
% grandeurs etudiees

CalibreRef = carto_manchot(1,:)*carto_fussak(1,:)';

FussakCalibre = carto_fussak + CalibreRef/(10^3);
FussakCalibre(FussakCalibre>100)=100;

CEmpereur = Empereur .* FussakCalibre ;
CAdelie = Adelie .* FussakCalibre ;
CPapou = Papou .* FussakCalibre ;
CRoyal = Royal .* FussakCalibre ;
CJugulaire = Jugulaire .* FussakCalibre ;
CGorfu = Gorfu .* FussakCalibre ;

ListeCE = [CEmpereur CAdelie CPapou CRoyal CJugulaire CGorfu];

CEmin=min(CEmpereur(CEmpereur>0),[],'all');
CEmax=max(CEmpereur,[],'all');

CAmin=min(CAdelie(CAdelie>0),[],'all');
CAmax=max(CAdelie,[],'all');

CPmin=min(CPapou(CPapou>0),[],'all');
CPmax=max(CPapou,[],'all');

CRmin=min(CRoyal(CRoyal>0),[],'all');
CRmax=max(CRoyal,[],'all');

CJmin=min(CJugulaire(CJugulaire>0),[],'all');
CJmax=max(CJugulaire,[],'all');

CGmin=min(CGorfu(CGorfu>0),[],'all');
CGmax=max(CGorfu,[],'all');

ListeCMaxMin =[CEmax CEmin ; CAmax CAmin ; CPmax CPmin ;CRmax CRmin; CJmax CJmin ; CGmax CGmin];


%********** Visualisation des données *************
% Cette zone permet de regrouper toutes les instructions relatives au trace
% des courbes

figure (1)
for i = 1:6
    [x,y] = find(carto_manchot==i);
    x = 13 - x ;
    scatter(y,x,optn(i))
    hold on
end
axis ([0 16 0 16])
title("Cartographie faunique des espèces de manchots")
legend(ListeNomEspeces)
hold off


disp("les coordonnées (x,y) des gourfous dorés sont : ")
disp([xG,yG])


figure (2)
for i = 1:6
    incr = 14*(i-1);
    [x1,y1]=find(ListeManchots(:,1+incr:14+incr)==1);
    [x0,y0]=find(ListeManchots(:,1+incr:14+incr)==0);
    x1 = 13 - x1;
    x0 = 13 - x0;
    subplot(3,3,3+i)
    scatter(y1,x1,'x');
    hold on;
    scatter(y0,x0,'o');
    axis padded
    title(ListeNomEspeces(i))
end

subplot(3,3,2)
ax = subplot(3,3,2,'Visible','off');
axPos = ax.Position;
delete(ax)
hL = legend("espèce présente","espèce absente");
hL.Position(1:2) = axPos(1:2);
hold off;

figure (3)
for i = 1:6
    incr = 14*(i-1);
    subplot(3,2,i)
    surf(1:14,1:12,ListeCE(:,1+incr:14+incr))
    hold on;
    title(ListeNomEspeces(i))
end

for i = 1:6
    disp("le maximum de corrélation de l'espèce "+ ListeNomEspeces(i)+" est " + ListeCMaxMin(i,1)+ " et le minimum est " + ListeCMaxMin(i,2))
end

