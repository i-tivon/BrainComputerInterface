function zfvec = zoInterp(x, numInterp)
    zfvec = reshape(repmat(x,numInterp,1),[1,length(x)*numInterp]);
end
