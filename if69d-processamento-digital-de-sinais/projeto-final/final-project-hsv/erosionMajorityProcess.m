function result = erosionMajorityProcess(block, kernelSize)

%     immatrix = [1 1 1; 1 1 1; 1 1 1];
%     blockand = block & immatrix;
    sumb = sum(block(:));
    result = sumb >= kernelSize*2 && sumb < kernelSize^2;
%     result = sumb >= (2*kernelSize) && sumb > 0;
    