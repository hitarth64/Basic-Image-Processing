function [B] = myAHE(A,N)
% Performs adaptive histogram equalization
% A: Input Image
% N: Patch size
% B: Output Image
    tic
    imshow(A);
    %B=zeros(size(A));
    input_height = size(A,1);
    input_width = size(A,2);
    
    for i=1:input_height
        win_top = max(1, i-ceil(N/2-1));
        win_bottom = min(input_height, i+floor(N/2));
        
        for j=1:input_width
            
           %win_left = max(1, j-ceil(N/2-1));
           %win_right = min(input_width, j+floor(N/2));
           
           if(j==1)
                [numberofpixels, intensity_values]=imhist(A( win_top : win_bottom , 1 : 1+floor(N/2)));
                cdf = cumsum(numberofpixels) / (win_bottom-win_top+1) / (floor(N/2)+1);
                B(i,j) = cdf(A(i,j)+1);
           
           elseif(j<=ceil(N/2))
                numberofpixels = numberofpixels + hist(A( win_top : win_bottom,j+floor(N/2)));
                cdf = cumsum(numberofpixels) / (win_bottom-win_top+1) / (j+floor(N/2));
                B(i,j) = cdf(A(i,j)+1);
           
           elseif (j>=input_width-floor(N/2-1))
                numberofpixels = numberofpixels - hist(A( win_top : win_bottom,j-ceil(N/2)));
                cdf = cumsum(numberofpixels) / (win_bottom-win_top+1) / (input_width - j + ceil(N/2));
                B(i,j) = cdf(A(i,j)+1);
           
           else
               numberofpixels = numberofpixels + hist(A( win_top : win_bottom,j+floor(N/2)));
               numberofpixels = numberofpixels - hist(A( win_top : win_bottom,j-ceil(N/2)));
               cdf = cumsum(numberofpixels) / (win_bottom-win_top+1) / (N);
               B(i,j) = cdf(A(i,j)+1);
           end
        end
    end
    
    figure; imshow(B);
    toc
                
               
end

