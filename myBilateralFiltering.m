function [B,RMSD] = myBilateralFiltering(A,N,sigma_spatial,sigma_int)
% Function performs bilateral filtering for the input image A
% N: Image Patch size
% sigma_Spatial: Gaussian Standard deviation user wishes to use in spatial
% domain
% sigma_int: Standard deviation user wishes to use in intensity domain 
% Standard deviation is kind of soft threshold. 

tic

imagesc(A); 
myNumOfColors=256; 
myColorScale=[[0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]', [0:1/(myNumOfColors-1):1]'];
colormap(myColorScale);

% Acquiring the basic parameters needed
% fspactial is the spatial gaussian weight matrix.
fspatial = fspecial('gaussian',N,sigma_spatial);
width = size(A,2);
height = size(A,1);
B = zeros(size(A));

for i=1:height
    for j=1:width
        %Intensity_matrix is the matrix containing the intensities of neighborhood of the concerned pixel
        Intensity_matrix = A(max(i-ceil(N/2)+1,1) : min(i+floor(N/2),height), max(j-ceil(N/2)+1,1) : min(j+floor(N/2),width) );
        
        % Following sub-section deals with appropriately cropping the
        % spatial gaussian in order to match the window size at any pixel
        if j<ceil(N/2)
            column_start = N - floor(N/2) -j + 1;
        else
            column_start = 1;
        end
        
        if j>width-floor(N/2)
            column_end = width-j+ceil(N/2);
        else 
            column_end = N;
        end
        
        if i<ceil(N/2)
            row_start = N - floor(N/2) -i +1;
        else 
            row_start = 1;
        end
        
        if i>height-floor(N/2)
            row_end = height-i+ceil(N/2);
        else 
            row_end = N;
        end
        
        fspatial_matrix = fspatial( row_start : row_end , column_start : column_end );
        gauss_intensity = 1/sqrt(2*pi*sigma_int^2)*exp(-1*(Intensity_matrix-A(i,j)).*(Intensity_matrix-A(i,j))/(2*sigma_int*sigma_int)) ;
        % I & W have the usual connotation
        I = sum(sum(gauss_intensity.*fspatial_matrix.*Intensity_matrix));
        W = sum(sum(gauss_intensity.*fspatial_matrix));
        % Assigning the intensity 
        B(i,j) = I/W;
    end
end

% Showing the final image
figure;
imagesc(B); 
colormap(myColorScale);

RMSD = sqrt(sum(sum((A-B).^2))/(height*width));

toc
end