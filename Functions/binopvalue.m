function [pval] = binopvalue(x,n,p,tail)
% [pval] = binopvalue(x,n,p,tail)
% calculates p-value of observing as extreme a number of successes 'x'
%  from a binomial distribution with parameters (n,p)
%
% the purpose of this function is to give correct two-tailed p-values.
% If you naively call binocdf, you could get a wrong result, because
% the CDF is the probability of less than *or equal to* the number of
% successes. In particular, using the CDF directly would underestimate
% the p-value if the observed probability of success is greater than
% the hypothetical probability.
%
% For example, this is a correct left-tailed p-value:
% >> binocdf(4,10,.5)
% ans =
%     0.3770
% 
% But this is a wrong right-tailed p-value:
% >> 1-binocdf(6,10,.5)
% ans =
%     0.1719
%
% Corrected:
% >> binopvalue(4,10,.5,'left')
% ans =
%     0.3770
% >> binopvalue(6,10,.5,'right')
% ans =
%     0.3770

if nargin < 4 || isempty(tail)
    tail = 'both';
end;

pval_left = binocdf(x,n,p);
pval_right = 1-binocdf(x-1,n,p);

switch tail
    case 'left'
        pval = pval_left;
    case 'right'
        pval = pval_right;
    case 'both'
        pval = min(1,2*min(pval_left,pval_right));
    otherwise
        error('unknown p-value tail!');
end;
