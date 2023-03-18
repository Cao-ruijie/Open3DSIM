function ftorderims = get_orders(ftrawimages,patternphases,module,numorders,patternpitch,jangle)
% This function unmixes the FT of the orders based on the found pattern
% phases.

%% Basic parameters
[Nx,Ny,numsteps,Nz] = size(ftrawimages);

%% compute mixing and unmixing matrix
mixing_matrix = zeros(numsteps,numorders);
for m=-2:2       % 2,1,0,-1,-2
    jorder = (5+1)/2+m;
    mixing_matrix(:,jorder) = exp(-1i*m*patternphases)/numsteps;
end

mixing_matrix(:,1) = mixing_matrix(:,1)*module(4)/2;
mixing_matrix(:,2) = mixing_matrix(:,2)*module(2)/2;
mixing_matrix(:,4) = mixing_matrix(:,4)*module(2)/2;
mixing_matrix(:,5) = mixing_matrix(:,5)*module(4)/2;

unmixing_matrix = pinv(mixing_matrix); % take pseudo-inverse

%% get orders,    % 3->(0),2->(-1),1-(-2)
ftorderimstemp = zeros(Nx,Ny,numsteps,Nz);
for jorder = 1:5
    jorderbis = [3 4 5 2 1];
    jorderbis = jorderbis(jorder);
    for jstep = 1:numsteps
        ftorderimstemp(:,:,jorder,:) = ftorderimstemp(:,:,jorder,:) + unmixing_matrix(jorderbis,jstep)*ftrawimages(:,:,jstep,:);
    end
end
ftorderims = zeros(Nx,Ny,numsteps,Nz);
ftorderims(:,:,1,:) = ftorderimstemp(:,:,1,:);
ftorderims(:,:,3,:) = ftorderimstemp(:,:,2,:);
ftorderims(:,:,2,:) = ftorderimstemp(:,:,4,:);
ftorderims(:,:,5,:) = ftorderimstemp(:,:,3,:);
ftorderims(:,:,4,:) = ftorderimstemp(:,:,5,:);

end