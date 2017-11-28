function new_image = contrast_stretch(old_image)

         
    [old_rows,old_cols,dim]=size(old_image);
    
    new_image=zeros(old_rows,old_cols,dim);
    for i=1:dim
        dn_min=min(min(old_image(:,:,i)));
        dn_max=max(max(old_image(:,:,i)));
       
       
        new_image(:,:,i)=(old_image(:,:,i)-dn_min)./((dn_max-dn_min));
    end
    
   

end