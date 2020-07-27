clc
close all
clear all
for i =1:11
    a = 'D:\Dropbox\acads\7th sem\EE 610 Image Processing\project\project\cell_operated\';
    b = '.jpg';
    c = num2str(i);
    path = strcat(a,c,b);
    I1 = imread(path);
    I1 = imresize(I1, 0.5);
    j = i+1;
    d = num2str(j);
    path1 = strcat(a,d,b);
    I2 = imread(path1);
    I2 = imresize(I2, 0.5);
    I1 = double(I1);
    I2 = double(I2);
    imdiff = abs(I1 - I2);
    imdiff = uint8(imdiff);
    e = 'D:\Dropbox\acads\7th sem\EE 610 Image Processing\project\project\xor\';
    path2 = strcat(e,c,b);
    imwrite(imdiff,path2);
    [m, n] = size(imdiff);
end

    final_image = zeros(m,n);
    final_image = double(final_image);
for i = 1:11
    b = '.jpg';
    e = 'D:\Dropbox\acads\7th sem\EE 610 Image Processing\project\project\xor\';
    c = num2str(i);
    path4 = strcat(e,c,b);
    image_i = imread(path4);
    image_i = double(image_i);
    final_image = final_image + image_i;
   
end

final_image = final_image/11;   
final_image = uint8(final_image);
figure(1)
imshow(final_image);

figure(2)
hist_final_image = imhist(final_image);
bar(hist_final_image);
title('Histogram of Average Image');
xlabel('Gray value of pixel');
ylabel('Number of pixels');
I = final_image;
J = imadjust(I,stretchlim(I),[]);

figure(3)
imshow(J);
hist_J = imhist(J);
figure(4)
bar(hist_J);
title('Histogram stretching output of Average Image');
xlabel('Gray value of pixel');
ylabel('Number of pixels');

J = im2bw(J,0.95);
figure(5)
imshow(J);
title('Image after thresholding');
originalBW = J;
se = strel('disk',1);
closedBW = imclose(originalBW,se);
figure(6)
imshow(closedBW);
se = strel('disk',1);        
erodedBW = imopen(closedBW,se);
figure(7)
imshow(erodedBW);
title('Morphological opening');
se = strel('disk',2);  
bw2 = imdilate(erodedBW,se);
figure(8)
imshow(bw2);
title('Dilated Image');
se = strel('disk',5); 
closedbw2 = imclose(bw2,se);
figure(9)
imshow(closedbw2);
title('Morphological Closing after dilation');
se = strel('disk',7);        
erodedbw2 = imopen(closedbw2,se);
figure(10)
imshow(erodedbw2);
title('Final Morphological opening');
cc = bwconncomp(erodedbw2, 4);
No_obj = cc.NumObjects;
x = zeros(No_obj,1);
y = x;
for i=1:No_obj
cell = false(size(erodedbw2));
cell(cc.PixelIdxList{i}) = true;
[m,n] = size(cell);
flag = 0;
for k=1:m
    for j=1:n
    if(cell(k,j)==1)
        if(flag==0)
        x(i) = k;
        y(i) = j;
        flag = 1;
        else
            x(i)= (x(i) + k)/2;
            y(i)= (y(i) + j)/2;
        end
    end 
    end
end
end
[m1,n1] = size(erodedbw2);
new_path = zeros(size(erodedbw2));
x = round(x);
y = round(y);
d=length(x);
for i=1:1:d
        new_path(x(i),y(i))=1;
end

npoint=length(x);

for j=1:1:npoint-1
   for i=1:1:npoint-1
        if (x(i)>x(i+1))
            temp_x=x(i);
            x(i)=x(i+1);
            x(i+1)=temp_x;
             temp_y=y(i);
            y(i)=y(i+1);
            y(i+1)=temp_y;
        end
    end
end

euclid=ones(npoint-1)*inf;
for i=1:npoint-1
    for j=i+1:npoint
    euclid(i,j-1) = sqrt((x(i)-x(j))^2 + (y(i)-y(j))^2);
    end
end
 euclid=euclid';
 mindist=min(euclid);
 
 for i=1:npoint-1
     for j=1:npoint-1
         if(mindist(i)==euclid(j,i))
         nextindex(i)=j+1;
         end
     end
 end
 
erodedbw2=im2bw(erodedbw2,0.5);
[xrange,yrange]=size(erodedbw2);
se = strel('disk',3); 
erodedbw2= imclose(erodedbw2,se);
figure(11)
imshow(erodedbw2)
bw=erodedbw2;
cc = bwconncomp(erodedbw2, 8);
No_obj = cc.NumObjects;
graindata = regionprops(cc, 'Area');
grain_areas = [graindata.Area];

count=1;
count1=1;
for i=2:No_obj-1
if(grain_areas(i)<270)
    
    pathx(count)=x(i);
    pathy(count)=y(i);
    count=count+1;
    
else
    path2x(count1)=x(i);
    path2y(count1)=y(i);
    count1=count1+1;
end
end

p = polyfit(pathx,pathy,11);
p2 = polyfit(path2x,path2y,8);





