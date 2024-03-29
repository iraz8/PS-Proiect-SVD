function [c_totalTime, c_executionTimes,c_numSVals,c_dispEr,c_filesSize,c_peaksnr,c_snr] = comparatie_functie_SVD_default(fileName,imgD,kValues)
tic
R    = imgD(:, :, 1);
G    = imgD(:, :, 2);
B    = imgD(:, :, 3);

[UR, SR, VR] = svd(R);
[UG, SG, VG] = svd(G);
[UB, SB, VB] = svd(B);
 disp('[5].SVD (functie default) calculat!');
%Initializare valori pentru generarea graficelor
c_dispEr = [];
c_numSVals = [];
c_filesSize = [];
c_executionTimes = [];
c_peaksnr = [];
c_snr = [];
index = 1;
while index <= length(kValues) 
    tic
    k = kValues(index);
    D = reconstruire_imagine(UR, SR, VR, UG, SG, VG, UB, SB, VB,k);
       
%     figure;
%     buffer = sprintf('Outputul folosind %d singular values', k)
%     imshow(uint8(D));
%     title(buffer);
    
    newFile = sprintf('[functie SVD] compresie cu %d valori singulare.jpg',k);
    imwrite(uint8(D), newFile);
    
    %Calcul erori
    error = sum(sum((R-D(:,:,1)).^2) + sum((G-D(:,:,2)).^2) + sum((B-D(:,:,3)).^2));
    c_dispEr = [c_dispEr; error];
    c_numSVals = [c_numSVals; k];
    
    %Calcul dimensiuni fisier
    fileInfo = dir(newFile);
    fileSize = fileInfo.bytes / 1024;
    c_filesSize = [c_filesSize; fileSize];
     
    t = toc;
    c_executionTimes = [c_executionTimes t];
    
    [temp_peaksnr,temp_snr] = psnr(D, imgD);
    c_peaksnr = [c_peaksnr temp_peaksnr];
    c_snr = [c_snr temp_snr];
    
    
    index = index + 1;

end
c_totalTime = toc;
disp('[6].Final functie comparatie');
