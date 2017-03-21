function [B] = myHE(A)
%A: Input Image
%B: Output Image
% Function performs global histogram equalization
tic
    imshow(A);
    
    dimension = size(A,3);
    B=zeros(size(A));
    
    for i=1:dimension
        [pixel_number, intensity_values]=imhist(A(:,:,i));
        cdf = cumsum(pixel_number) /(size(A,1) * size(A,2)); 
        
        B(:,:,i) = cdf(A(:,:,i)+1);
    end
    figure; imshow(B);
    toc
end