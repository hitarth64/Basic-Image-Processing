function [B] = myMeanShiftSegmentation(Input,iterations,h_I,h_s,Knn)
%myMeanShiftSegmentation function perform the mean shift segmentation 
%   algorithm using both intensity and spatial weights
% iteration : integer - number of iterations we want
% Knn: Number of segments we want
tic

A=im2double(Input);
p_x = repmat([1:size(A,2)], size(A,1),1);
p_y = repmat([1:size(A,1)]', 1, size(A,2));
p_x = p_x(:)/h_s;
p_y = p_y(:)/h_s;
p_red = A(:,:,1)/h_I;
p_green = A(:,:,2)/h_I;
p_blue = A(:,:,3)/h_I;
p = [p_red(:), p_green(:), p_blue(:), p_x, p_y ];
q = p;

h=waitbar(0, 'I love Baboons...!!');

for i=1:iterations
    [IDX,D] = knnsearch(p,p,'k',Knn,'Distance','euclidean');
    
    for j=1:size(p,1)
        weights = exp(-(D(j,:).^2))';
        weighted_value = bsxfun(@times,p(IDX(j,:),1:3),weights);
        value = sum(weighted_value,1) / sum(weights);
        q(j,1:3) = value;
    end
    p = q;
    waitbar(i/iterations);
end
close(h);
B(:,:,1) = reshape(h_I*p(:,1),size(A,1),size(A,2));
B(:,:,2) = reshape(h_I*p(:,2),size(A,1),size(A,2));
B(:,:,3) = reshape(h_I*p(:,3),size(A,1),size(A,2));

toc
end

