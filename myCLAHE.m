function [B] = myCLAHE(A,N,threshold)
%A: Input Image
%N: Patch Size
%threshold: thershold while doing Contrast Limited AHE
%B: Output image

tic
imshow(A);
%B=zeros(size(A));
input_height = size(A,1);
input_width = size(A,2);

 for k=1:size(A,3)
    for i=1:input_height
        for j=1:input_width
            
           win_left = max(1, j-ceil(N/2-1));
           win_right = min(input_width, j+floor(N/2));
           win_top = max(1, i-ceil(N/2-1));
           win_bottom = min(input_height, i+floor(N/2));
           
           pixel_number=imhist(A( win_top : win_bottom , win_left : win_right, k)) / (win_bottom-win_top+1) / (win_right - win_left + 1);
           
           excess = sum(pixel_number (pixel_number > threshold) - threshold) / 256;
           pixel_number (pixel_number > threshold) = threshold;
           pixel_number = pixel_number  + excess;
           cdf = cumsum(pixel_number);
           B(i,j,k) = cdf(A(i,j,k)+1);
        end
    end
 end
 
figure; imshow(B);
toc
                
                

end