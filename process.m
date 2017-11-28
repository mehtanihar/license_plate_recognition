a=imread('test.jpg');
image=rgb2gray(a);
results = ocr(image);
regularExpr = '\S';
bboxes = locateText(results, regularExpr, 'UseRegexp', true);
digits = regexp(results.Text, regularExpr, 'match');
Idigits = insertObjectAnnotation(image, 'rectangle', bboxes,digits);
imshow(Idigits)
% image=rgb2gray(a);
% [rows,cols]=size(image);
% check=0;
% for i=1:cols
%     slider=image(:,i);
%     if(sum(slider<75)>(cols/250))
%         if(check==0)
%             image(:,i-1)=0;
%             disp(i-1)
%             check=1;
%         end
%     else
%         if(check==1)
%             check=0;
%         end
%     end
%     
%     
% end
%     
% imshow(image);
% 
