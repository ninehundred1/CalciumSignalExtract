function [ccimage]=CrossCorrImage_ROIExtraction(tc)

%Cross correletae image based on synchronized activities
%from
%http://labrigger.com/blog/2013/06/13/local-cross-corr-images/

% %     Here’s some code I’ve used to generate a first pass of ROIs.
% The simple idea is that the pixels that are located within cells will
% be highly correlated because during a fluorescence transient they will
% all exhibit similar time courses, and other regions (e.g., neuropil, blood
% vessels, etc.) will not be as correlated.
% %
% % The input is an X x Y x T 3D matrix (time or frame is the third dim).
% The output is an X x Y cross corr image. As written below, it looks at
% the 3 x 3 local neighborhood. If you increase the variable w to 2, then
% it will look at a 5 x 5 local neighborhood, and so forth.


w=1; % window size

% Initialize and set up parameters
ymax=size(tc,1);
xmax=size(tc,2);
numFrames=size(tc,3);
ccimage=zeros(ymax,xmax);
textprogressbar('Cross Corr Image: ');


for y=1+w:ymax-w
    
    textprogressbar((y/(ymax-1)*100));
    
    for x=1+w:xmax-w
        % Center pixel
        thing1 = reshape(tc(y,x,:)-mean(tc(y,x,:),3),[1 1 numFrames]); % Extract center pixel's time course and subtract its mean
        ad_a   = sum(thing1.*thing1,3);    % Auto corr, for normalization later
        
        % Neighborhood
        a = tc(y-w:y+w,x-w:x+w,:);         % Extract the neighborhood
        b = mean(tc(y-w:y+w,x-w:x+w,:),3); % Get its mean
        thing2 = bsxfun(@minus,a,b);       % Subtract its mean
        ad_b = sum(thing2.*thing2,3);      % Auto corr, for normalization later
        
        % Cross corr
        ccs = sum(bsxfun(@times,thing1,thing2),3)./sqrt(bsxfun(@times,ad_a,ad_b)); % Cross corr with normalization
        ccs((numel(ccs)+1)/2) = [];        % Delete the middle point
        ccimage(y,x) = mean(ccs(:));       % Get the mean cross corr of the local neighborhood
    end
end

textprogressbar(' - done');