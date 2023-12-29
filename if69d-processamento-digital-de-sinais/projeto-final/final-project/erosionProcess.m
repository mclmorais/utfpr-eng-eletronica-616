function result = erosionProcess(block, kernelSize)

    process = block & ones(kernelSize);    
    result = isequal(block & ones(kernelSize), ones(kernelSize));