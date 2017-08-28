
clc
clear all
close all
I = imread('ImgA000001.tif');
[m,n,L] = size(I);        % 
if L>1        
    I = rgb2gray(I);
end
BW1 = edge(I,'sobel');    %

figure(1)
subplot(121)
imshow(BW1); title('????');
se = strel('square',2);
BW=imdilate(BW1,se);    %

hough_circle=zeros(m,n,3);
[Limage, num] = bwlabel(BW,8);   %




for N=1:num
    
    %[rows,cols] = find(BW);  % ?????????????????????????????[rows,cols]  ?????
      [rows,cols] = find(Limage==N);  % ?????????????????????????????[rows,cols]  ?????
      pointL=length(rows);      %??????,?????

        max_distan=zeros(m,n);
        distant=zeros(1,pointL);
        for i=1:m  
            for j=1:n
                for k=1:pointL
                    distant(k)=sqrt((i-rows(k))^2+(j-cols(k))^2); %????? ??????????
                end
            max_distan(i,j)=max(distant);  %?i?j????????????
            end
        end
        min_distan=min(min(max_distan));   %???????????????? ????????????????? ????????


        [center_yy,center_xx] = find(min_distan==max_distan);  %???????????
        center_y=(min(center_yy)+max(center_yy))/2;            %?????????????????????????
        center_x=(min(center_xx)+max(center_xx))/2;            %center_x?center_y??????
        a=min_distan;                                          %a??????
    %%  ????Hough??  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        hough_space = zeros(round(a+1),180);     %Hough??
        for k=1:pointL
            for w=1:180      %theta
                G=w*pi/180; %???????
                XX=((cols(k)-center_x)*cos(G)+(rows(k)-center_y)*sin(G))^2/(a^2);
                YY=(-(cols(k)-center_x)*sin(G)+(rows(k)-center_y)*cos(G))^2;
                B=round(sqrt(abs(YY/(1-XX)))+1);
                if(B>0&&B<=a)   %  ????B???????????????
                     hough_space(B,w)=hough_space(B,w)+1;
                end
            end
        end

     %%  ??????????
        max_para = max(max(max(hough_space)));  % ???????

        [bb,ww] = find(hough_space>=max_para);  %????????hough_space??????????b? theta?
        if(max_para<=pointL*0.33*0.25)     % ??????? ???????  ????????
           disp('No ellipse'); 
           return ;
        end
        b=max(bb);                   %  b??????
        W=min(ww);                          % %theta
        theta=W*pi/180;


      %% ????
       
      for k=1:pointL
                XXX=((cols(k)-center_x)*cos(theta)+(rows(k)-center_y)*sin(theta))^2/(a^2);
                YYY=(-(cols(k)-center_x)*sin(theta)+(rows(k)-center_y)*cos(theta))^2/(b^2);
                if((XXX+YYY)<=1)   %????
                 %if((XXX+YYY)<=1.1&&(XXX+YYY)>=0.99)  % ????
                    hough_circle(rows(k),cols(k),1) = 255;
                    
                end
      end
     
end
   subplot(122)
   imshow(hough_circle);title('????');title('????');