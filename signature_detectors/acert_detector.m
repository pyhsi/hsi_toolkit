function [acert_out,mu,siginv] = acert_detector(hsi_img,tgt_sig,mask,mu,siginv)
%
%function [ace_out,mu,siginv] = ace_detector(hsi_img,tgt_sig,mask,,mu,siginv)
%
% Adaptive Cosine/Coherence Estimator
%
% inputs:
%  hsi_image - n_row x n_col x n_band hyperspectral image
%  tgt_sig - target signature (n_band x 1 - column vector)
%  mask - binary image limiting detector operation to pixels where mask is true
%         if not present or empty, no mask restrictions are used
%  mu - background mean (n_band x 1 column vector) 
%  siginv - background inverse covariance (n_band x n_band matrix) 
%
% outputs:
%  ace_out - detector image
%  mu - mean of background
%  siginv - inverse covariance of background
%
% 8/8/2012 - Taylor C. Glenn
% 6/2/2018 - Edited by Alina Zare
%

if ~exist('mask','var'), mask = []; end
if ~exist('mu','var'), mu = []; end
if ~exist('siginv','var'), siginv = []; end
addpath(fullfile('..','util'));

[acert_out,mu,siginv] = img_det(@acert_det,hsi_img,tgt_sig,mask,mu,siginv);

end

function [acert_data,mu,siginv] = acert_det(hsi_data,tgt_sig,mu,siginv)

if isempty(mu)
    mu = mean(hsi_data,2);
end
if isempty(siginv)
    siginv = pinv(cov(hsi_data'));
end

s = tgt_sig - mu;
z = bsxfun(@minus,hsi_data,mu);

st_siginv = s'*siginv;
st_siginv_s = s'*siginv*s;


A = sum(st_siginv*z,1);
B = sqrt(st_siginv_s);
C = sqrt(sum(z.*(siginv*z),1));

acert_data = A./(B.*C);

end



