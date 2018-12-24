close all;
clear all;

%Citire imagine
[file, path]=uigetfile({'*.jpg;*.jpeg;*.tiff;*.png','Images (*.jpg;*.jpeg;*.tiff;*.png)';
                        '*.jpg','JPG format (*.jpg)';
                        '*.jpeg','JPEG format (*.jpeg)';
                        '*.tiff','TIFF format (*.tiff)';
                        '*.png','PNG format (*.png)'},'Select Input Image');
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end
path=[path file];
img=imread(path);

imagesc(img)
imgD = double (img);
imwrite (uint8(imgD),'backup.jpg');

tic
R    = imgD(:, :, 1);
G    = imgD(:, :, 2);
B    = imgD(:, :, 3);

%Implementare proprie SVD
% [UR, SR, VR] = SVD_Implementation(R);
% [UG, SG, VG] = SVD_Implementation(G);
% [UB, SB, VB] = SVD_Implementation(B);

[UR, SR, VR] = svd(R);
[UG, SG, VG] = svd(G);
[UB, SB, VB] = svd(B);

%Initializare valori pentru generarea graficelor
dispEr = [];
numSVals = [];
filesSize = [];

%Initializare valori pentru alegerea valorilor singulare (k)
kStart = 2;
kStop = 250;
kValues = kStart;
k = kStart;
kValues = k;

while k < kStop
    
    D = reconstruire_imagine(UR, SR, VR, UG, SG, VG, UB, SB, VB,k);
       
%     figure;
%     buffer = sprintf('Outputul folosind %d singular values', k)
%     imshow(uint8(D));
%     title(buffer);
    
    newFile = sprintf('[SVD_implementation] compresie cu %d valori singulare.jpg',k);
    imwrite(uint8(D), newFile);
    
    %Calcul erori
    error=sum(sum((R-D(:,:,1)).^2) + sum((G-D(:,:,2)).^2) + sum((B-D(:,:,3)).^2));
%   error=sum(sum((R-DR).^2) + sum((G-DG).^2) + sum((B-DB).^2));
    dispEr = [dispEr; error];
    numSVals = [numSVals; k];
    
    %Calcul dimensiuni fisier
    fileInfo = dir(newFile);
    fileSize = fileInfo.bytes / 1024;
    filesSize = [filesSize; fileSize];
    
    %Generare valori singulare (k)     
    k = (length(kValues) + 1)^3;
    
    kValues = [kValues k];
end
timp_main = toc;

%Grafic erori

figure; 
title('Erori in compresie');
plot(numSVals, dispEr);
grid on
xlabel('Numar de valori singulare');
ylabel('Erori');
title('Comparatia erorilor dintre imaginea initiala si cele procesate');

%Grafic dimensiuni fisiere
originalImgInfo = dir(file);
originalImgSize = originalImgInfo.bytes / 1024;

backupImgInfo = dir('backup.jpg');
backupImgSize = backupImgInfo.bytes / 1024;

figure; 
plot ([0 kStop],[originalImgSize originalImgSize],'r');
hold on;
plot ([0 kStop],[backupImgSize backupImgSize],'y');
hold on;
plot(numSVals, filesSize,'b');
legend('Dimensiune imagine originala','Dimensiune fisier backup','Dimensiune fisier dupa comprimare');
grid on
xlabel('Numar de valori singulare');
ylabel('Dimensiuni fisiere dupa procesare (kb)');
title('Comparatie dimensiuni fisiere');

% timp_comparatie = comparatie(numeImagine,imgD,kValues);
% % comparatie_svds(numeImagine,imgD,kValues)
% timp_main
% timp_comparatie
% figure; 
% plot (timp_main,'X')
% hold on;
% plot (timp_comparatie,'O')

