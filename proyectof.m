%Proyecto Final Laboratorio de Sistemas de Imagagenología Médica
%Ernesto Sevin Enriquez
%Segmentación de pulmones
%

%Se limpian todas las variables, el script y se cierran las ventanas
clc;clear all;close all;
%Se lee el stack que se va a utilizar
n = 150;
m = 200;
for i = n:m
    filename = sprintf('1-%03d.dcm',i);
    X(:,:,1,i) = dicomread(filename);
end

Y = double(X);
Y = Y ./max(max(max(Y))); %%Se hace la nomrmalizacion del stack
Y = squeeze(Y);
for i = n:m
    [histcomp(i,:), grayLevels]= imhist(Y(:,:,i), 2^16);
end
[a,b] = meshgrid(1:(2^16),n:m);% Se genera un mesh para la superficie de el histograma
%figure, surf(a,b,histcomp);
shading interp;
for i = n:m
   Y1(:,:,i) = imadjust(Y(:,:,i), [0 0.63]);%% Se hace la equializacion con el valor encontrado con la herramienta imtool
end
for i = n:m
    [histcompeq(i,:), grayLevels]= imhist(Y1(:,:,i), 2^16);
end
[c,d] = meshgrid(1:(2^16),n:m);
%figure, surf(c,d,histcompeq);
shading interp;
A = 20;
h = [-1 -1 -1;-1 A -1; -1 -1 -1] * 1/A;
for i = n:m
    sfilt(:,:,i) =  imfilter(Y1(:,:,i),h);
end
e = min(min(min(sfilt)));
f = max(max(max(sfilt)));
for i = n:m
    sfilt2(:,:,i) = (sfilt(:,:,i) - e)/(f-e);
end

for i = n:m
    %suma(:,:,i) = sfilt2(:,:,i) - Y1(:,:,i);
   sfilt3(:,:,i) = im2bw(sfilt2(:,:,i),0.5);%Se eligio este valor de binarizacion porque es un valor relevante en la zona de interes
   % sfilt4(:,:,i) = imcomplement(sfilt3(:,:,i));
end

figure, imshow(Y1(:,:,m));
figure, imshow(sfilt(:,:,m));
%imfilt2 = im2bw(imfilt1, 0.145);
figure, imshow(sfilt2(:,:,m));
figure, imshow(sfilt3(:,:,m));
%figure, imshow(sfilt4(:,:,m-25));
pr1 = sfilt3(:,:,m);
s0 = strel('line',11,75);
rp = imerode(pr1,s0,4);
ro = bwmorph(rp, 'open');
rpp = imdilate(ro,s0);
figure, imshow(rpp);
prueba = imfill(rpp, 'holes');
figure, imshow(prueba);
r3 = imcomplement(rpp);
aver = r3 .* prueba;
figure, imshow(aver);
%Z = (Y .* 254) +1;
%map = [[0:0.01:1]' [0:0.01:1]' [0:0.01:1]'];
%mov = immovie(Z, map);
%implay(sfilt)