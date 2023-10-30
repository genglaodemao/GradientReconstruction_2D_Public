function [fig]=find2img(img,res,X,Y,R)
%transfer the featfind results to image.
%INPUT: 
%img - original image
%res - tracking results
%X Y Z - then column id of x coordinates, y coordinates and size  
img=double(img);
img=img-min(img(:));
img=img/max(img(:))*255;
img=uint8(img);
fig=img;
l=length(res(:,1));
figure;
    imagesc(img,[0 255]),colormap(gray);
    hold on
    
theta = 0:0.001:2*pi;
    for i = 1:l
        r=res(i,R);
        cx = res(i,X) + r*cos(theta);
        cy = res(i,Y) + r*sin(theta);
        plot(cx,cy,'g-','linewidth',1.5)
    end

end





