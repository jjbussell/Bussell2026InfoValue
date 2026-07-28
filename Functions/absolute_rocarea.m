function [absrocarea] = absolute_rocarea(N,S,method)
% [absrocarea] = absolute_xval_rocarea(N,S,method)
%
% compute 'absolute ROC area' between N(oise) and S(ignal) distributions,
% using a pseudo-crossvalidation method to ensure that if there is no true
% difference between the distributions the expected result = 0.5
% 
% This is unlike the simple, traditional way of computing it which is
% biased so that even if there is no true difference it is nearly always 
% > 0.5 especially with small or high-variance datasets.
%
% Effectively, if there is a small/high-variance dataset, the traditional
% method is biased toward HIGH values of the absolute ROC area (e.g. toward
% 1), while the new method is biased toward LOW values indicating no effect
% (i.e. toward 0.5). Whereas if the data is reasonably strong, the new and 
% old methods will give the same answers.
%
% inputs:
% - N(oise) is an nn x nbins matrix of data from each time bin 
%   of the nn trials done in the 'noise' condition
% - S(ignal) is an ns x nbins matrix of 
%   of the ns trials done in the 'signal' condition
% - method controls what type of result is calculated:
%   'raw': traditional 'absolute ROC area'
%     done by calculating ROC area, then if it is below 0.5, 'flipping' it
%     to be above 0.5, i.e. absroc = 0.5 + abs(roc-0.5)
%   'xval': new pseudo-crossvalidated method
%     done by splitting N and S each into halves ('odd' and 'even' trials),
%     the calculating rocarea separately for odd and even halves. Then, 
%     'flip' each half's rocarea based on whether the OTHER half's rocarea 
%     is > 0.5. Then, as a final step average the two rocareas. This way,
%     if there is no true effect, the flipping of each half will be
%     randomized, so it will have an expected value of 0.5.
%   (default: 'xval')

assert(size(N,2) == size(S,2),'N and S must have same # columns');

if nargin < 3
    method = 'xval';
end

switch method
    case 'raw'
        % calculate ROC area the standard way, then 'flip' to force it to 
        % be >= 0.5.
        rocarea = rocarea3(N,S);
        absrocarea = 0.5 + abs(rocarea-0.5);
    case 'xval'
        assert(size(N,1) > 1 & size(S,1) > 1,'N and S must each have at least two rows to do pseudo-crossvalidation method');
        
        % split data into 'odd half' and 'even half' of trials
        % (we could split into 'first half' vs 'second half' of trials,
        %  but this way we reduce potential issues that could arise when
        %  analyzing datasets whose properties change over time, by making
        %  sure each half evenly samples both early and late trials in the
        %  dataset)
        N1 = N(1:2:end,:);
        N2 = N(2:2:end,:);
        
        S1 = S(1:2:end,:);
        S2 = S(2:2:end,:);
        
        % calculate ROC area in each half
        rocarea1 = rocarea3(N1,S1);
        rocarea2 = rocarea3(N2,S2);
        
        % convert to absolute ROC area by flipping the sign of 'odd' data 
        % based on the sign of the 'even' data, and vice versa.
        sign1 = sign(rocarea1 - 0.5);
        sign2 = sign(rocarea2 - 0.5);
        
        okflip1 = sign2 < 0;
        okflip2 = sign1 < 0;
        
        rocarea1(okflip1) = 0.5 + sign2(okflip1).*(rocarea1(okflip1)-0.5);
        rocarea2(okflip2) = 0.5 + sign1(okflip2).*(rocarea2(okflip2)-0.5);
        
        % average the 'odd' and 'even' absolute ROC areas to get the
        % overall result.
        absrocarea = (rocarea1 + rocarea2).*0.5;
    otherwise
        error('unknown method of calculating absolute ROC areas, expected "xval" or "raw"');
end
