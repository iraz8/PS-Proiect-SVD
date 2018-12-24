function D = reconstruire_imagine(UR, SR, VR, UG, SG, VG, UB, SB, VB,k)
    SRtemp = SR;
    SGtemp = SG;
    SBtemp = SB;
    SRtemp(k+1:end,:)=0;
    SRtemp(:,k+1:end)=0;
    SGtemp(k+1:end,:)=0;
    SGtemp(:,k+1:end)=0;
    SBtemp(k+1:end,:)=0;
    SBtemp(:,k+1:end)=0;
    DR=UR*SRtemp*VR';
    DG=UG*SGtemp*VG';
    DB=UB*SBtemp*VB';
    D = cat(3,DR,DG,DB);
end

