
% function mecpar: defines the mechanical parameters of the structure

function [dPar,slender_el,section_height]=mecpar(Leng_Elem,nElem)

% Matrix of the geometric and mechanical parameters of the beams dPar:
% the ne-th row of dPar collects the parameters for the ne-th beam:
%   - Young modulus of the material (E);
%   - area of the cross section (A);
%   - moment of inertia of the cross section (I);
% dPar(ne,:)=[E, A, I]
  dE=21*(10^7); %KN/m^2 %similar for the all structural steel elements

  %Chosen profile for the beams HEA 240 %%%%%%%%
  dA_beam=76.84*(10^(-4)); %m^2 
  dI_beam=7763*(10^(-8)); %m^4
  i_beam=6*(10^(-2)); %m %minimum radius of gyration 
  height_beam=230*(10^(-3)); %m

  %Chosen profile for the inclined roof beams HEA 140 
  dA_incl_roof_beam=31.42*(10^(-4)); %m^2 
  dI_incl_roof_beam=1033*(10^(-8)); %m^4
  i_incl_roof_beam=3.52*(10^(-2)); %m %minimum radius of gyration
  height_incl_roof_beam=133*(10^(-3)); %m

  %Chosen profile for the columns HEB 160 
  dA_column=54.25*(10^(-4)); %m^2 
  dI_column=2492*(10^(-8)); %m^4
  i_column=4.05*(10^(-2)); %m %minimum radius of gyration
  height_column=160*(10^(-3)); %m

  %Square tube profile for the truss members 70*3
  dA_truss=8.04*(10^(-4)); %m^2
  dI_truss=60.27*(10^(-8)); %m^4
  i_truss=2.74*(10^(-2)); %m %minimum radius of gyration
  height_truss=70*(10^(-3)); %m

  dPar=[dE, dA_column, dI_column;%1 
        dE, dA_column, dI_column;%2
        dE, dA_column, dI_column;%3
        dE, dA_column, dI_column;%4
        dE, dA_column, dI_column;%5
        dE, dA_column, dI_column;%6
        dE, dA_column, dI_column;%7
        dE, dA_column, dI_column;%8 %FROM 1 TO 8 COLUMN ELEMNTS
        dE, dA_incl_roof_beam, dI_incl_roof_beam;%9
        dE, dA_incl_roof_beam, dI_incl_roof_beam;%10 FROM 9 TO 10 INCLINED ROOF BEAM ELEMNTS
        dE, dA_beam, dI_beam;%11 BEAM
        dE, dA_beam, dI_beam;%12 BEAM
        dE, dA_beam, dI_beam;%13 BEAM
        dE, dA_truss, dI_truss;%14 TRUSS
        dE, dA_incl_roof_beam, dI_incl_roof_beam;%15
        dE, dA_truss, dI_truss;%16
        dE, dA_truss, dI_truss;%17
        dE, dA_truss, dI_truss;%18
        dE, dA_truss, dI_truss;];%19 FROM 16 TO 19 AND 14 ARE TRUSS ELEMNTS

 %Modified Part of the MATLAB CODE in order to find element slenderness
 slender_el=zeros(1,nElem);
 slender_el(1,1:8)=Leng_Elem(1,1:8)/i_column; %Column element slenderness 
 slender_el(1,9:10)=Leng_Elem(1,9:10)/i_incl_roof_beam; %Inclined roof beams element slenderness
 slender_el(1,11:13)=Leng_Elem(1,11:13)/i_beam; %Beam element slenderness
 slender_el(1,14)=Leng_Elem(1,14)/i_truss; %Truss element slenderness
 slender_el(1,15)=Leng_Elem(1,15)/i_incl_roof_beam; %Inclined roof beams element slenderness
 slender_el(1,16:19)=Leng_Elem(1,16:19)/i_truss; %Truss element slenderness


 %Height of each element to be used in the mod_HMstress.m -> in order to
 %get the distance of neutral axis from the top of cross sections

section_height=[height_column;%1
                height_column;%2
                height_column;%3
                height_column;%4
                height_column;%5
                height_column;%6
                height_column;%7
                height_column;%8
                height_incl_roof_beam;%9
                height_incl_roof_beam;%10
                height_beam;%11
                height_beam;%12
                height_beam;%13
                height_truss;%14
                height_incl_roof_beam;%15
                height_truss;%16
                height_truss;%17
                height_truss;%18
                height_truss];%19













%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%