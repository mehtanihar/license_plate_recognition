rgb_image=imread('merc.jpg');
imshow(rgb_image);
%% 

orig_image=rgb2gray(rgb_image);

[row,col]=size(image);

imshow(orig_image);
%% 

image=contrast_stretch(orig_image);
imshow(image);
%% 

image1=medfilt2(image);
imshow(image1);
%% 


h=[0 -1/4 0; 
   -1/4 2 -1/4;
   0 -1/4 0];
image2 = imfilter(image1,h);

imshow(image2);

%% 

se = strel('rectangle',[2,2]);
image3=imopen(image2,se);
imshow(image3);
%% 

image4 = edge(image3,'Canny',0.001);

imshow(image4);
%% 

stats=regionprops(image4,'BoundingBox');
imshow(orig_image);
hold on
l=[];
count=0;
for k = 1 : length(stats)
  thisBB = stats(k).BoundingBox;
  len=thisBB(3);
  breadth=thisBB(4);
  if((len/breadth)>1.5 && (len/breadth)<10 && len<(row*0.7) && (len>row/10))
    l=[l ; thisBB(1) thisBB(2) thisBB(3) thisBB(4)];
    count=count+1;
        rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
  'EdgeColor','r','LineWidth',2 )
  end
end
hold off
%% 

 imshow(orig_image);
 hold on

 final=[];
 type=0;
for i=1:count
    im=(image(ceil(l(i,2)):ceil(l(i,2))+floor(l(i,4)),ceil(l(i,1)):ceil(l(i,1))+floor(l(i,3))));
    im1=(orig_image(ceil(l(i,2)):ceil(l(i,2))+floor(l(i,4)),ceil(l(i,1)):ceil(l(i,1))+floor(l(i,3))));
    
    stats=regionprops(im,'BoundingBox');
    results = ocr(im);
    regularExpr = '\S';
    digits = regexp(results.Text, regularExpr, 'match');
    if(length(digits)>5)

         rectangle('Position', [l(i,1),l(i,2),l(i,3),l(i,4)],...
  'EdgeColor','r','LineWidth',2 )

        final=[final i];
    else
        stats=regionprops(im1,'BoundingBox');
        results = ocr(im1);
        regularExpr = '\S';
        new_digits = regexp(results.Text, regularExpr, 'match');
        if(length(new_digits)>5)
             rectangle('Position', [l(i,1),l(i,2),l(i,3),l(i,4)],...
      'EdgeColor','r','LineWidth',2 )
            final=[final i];
        end
           
    end
    
end
hold off
%% 

for iter=1:length(final)
    i=final(iter);
    cropped_im=(orig_image(ceil(l(i,2)):ceil(l(i,2))+floor(l(i,4)),ceil(l(i,1)):ceil(l(i,1))+floor(l(i,3))));
    
    imshow(cropped_im);
    
    im = imresize(cropped_im,10)>100;
    [r,c]=size(im);
     se = strel('rectangle',[5 5]);
     im=1-imerode(1-im,se);
     
    
     %Horizontal scanning
    rowsum=sum(im,2);
    rowpeak=median(findpeaks(rowsum));
    rowsum=rowsum>rowpeak;
    check=0;
    j=1;
    top=0;
    while(j<length(rowsum) && check==0)
        count=0;
        while(rowsum(j)==1)
            count=count+1;
            j=j+1;
        end
        if(count>10)
           top=j-floor(count/2);
           check=1;
        else
            count=0;
            j=j+1;
        end
        
    end
    
    j=length(rowsum);
    check=0;
    bottom=j;
    while(j>0 && check==0)
        count=0;
        
        while(rowsum(j)==1)
            count=count+1;
            j=j-1;
        end
        if(count>10)
           bottom=j+floor(count/2);
           check=1;
        else
            count=0;
            j=j-1;
        end
        
    end
    
    im=im(top:bottom,:);
    
     
     
    %Vertical scanning
    hist=sum(im,1);
    hist=hist>(max(hist)-6);
    segments=[];


    j=1;
    
    while(hist(j)==0 && j<length(hist))
        j=j+1;
    end
    
    last=length(hist);
    while(hist(last)==0 && last>0)
        last=last-1;
    end
    
    while(j<last)
        if(hist(j)==1)
            count=0;
            k=j;
            while(hist(j)==1 && j<length(hist))
                j=j+1;
                count=count+1;
            end
            if(count>2)
                segments=[segments k+floor(count/2)];
            end
            
        else 
            j=j+1;
        end
        
    end
    
    if(length(segments)>7 && length(segments)<20)
        load('ex3weights.mat');
        figure;
        imshow(im);
        hold on
        
        for it=1:length(segments)
            if(it<length(segments))
                letter=im(:,segments(it): segments(it+1));
            end
            
            letter=imresize(letter,[20,20]);
            letter=1-letter;
           
            X=[letter(:)]';
            if(it==5)
%                 imshow(letter)
                pred = predict(Theta1, Theta2, X);
                if(pred==10)
                    pred=0;
                end
                disp('Predicted character');
                disp(pred);
            end
            
            rectangle('Position', [segments(it),0,1,c],...
            'EdgeColor','r','LineWidth',2 )
        end
    end
    disp('Length of segments:');
    disp(length(segments))
end
