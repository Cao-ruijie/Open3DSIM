function [dataparams,WF,Nx,Ny,Nz,raw_image] = read_data_2(datasets,output,numchannels,numframes,jchannel,jframe)

%% Set basic parameters
dataparams.datasets = datasets;
dataparams.numsteps = 5;
dataparams.numangles = 3;
dataparams.numchannels = numchannels;
dataparams.numframes = numframes;

%% read dv/tiff/tif
a = bfopen(char(datasets)); % open datafile
b = a{1};                                                  % extract variable with image data
allimages_in = cell2mat(permute(b(:,1),[3 2 1]));          % extract image data
clear a b;
numims = size(allimages_in,3);
numpixelsx = size(allimages_in,1)/3;
numpixelsy = size(allimages_in,2)/5;
dataparams.numpixelsx = numpixelsx;
dataparams.numpixelsy = numpixelsy;
dataparams.Nz = numims/dataparams.numchannels/dataparams.numframes;
Nz = dataparams.Nz;
dataparams.allimages_in = reshape(allimages_in,[numpixelsx*3 numpixelsy*5 dataparams.numchannels dataparams.Nz dataparams.numframes]);
clear allimages_in
dataparams.allimages_in = double(permute(dataparams.allimages_in,[1 2 3 5 4]));

%% Reorganize
allimages_in = zeros(numpixelsx,numpixelsy,5,Nz,numchannels,numframes,3);
for jNz = 1:Nz
    for jchannels = 1:numchannels
        for jframes = 1:numframes
            for jangle = 1:dataparams.numangles
                for jstep = 1:dataparams.numsteps
                    allimages_in(:,:,jstep,jNz,jchannels,jframes,jangle) = dataparams.allimages_in((jangle-1)*numpixelsx+1:jangle*numpixelsx,(jstep-1)*numpixelsy+1:jstep*numpixelsy,jchannels,jframes,jNz);
                end
            end
        end
    end
end

% %% Write
% allimages_in = allimages_in(51:51+511,159:159+511,:,:,:,:,:);
% max_ = max(max(max(max(max(max(max(allimages_in)))))));
% allimages_in = uint16(allimages_in./max_*65535);
% stackfilename = ['Actin_488_1024_11z.tif'];
% raw = uint16(zeros(512*3,512*5,11));
% for jNz = 1:11
%     for jangle = 1:3
%         for jstep = 1:5
%             raw((jangle-1)*512+1:(jangle)*512,(jstep-1)*512+1:(jstep)*512,jNz) = allimages_in(:,:,jstep,jNz,1,1,jangle);
%         end
%     end
% end
% for jNz = 1:11
%     imwrite(uint16(raw(:,:,jNz)), stackfilename, 'WriteMode','append') % 写入stack图像
% end


%% select one frame and one channel
dataparams.allimages_in = allimages_in(:,:,:,:,jchannel,jframe,:);
raw_image = dataparams.allimages_in;
dataparams.numchannels = 1;
dataparams.numframes = 1;

%% get WF image
[widefield,~] = get_widefield(dataparams.allimages_in);
max_widefield = max(max(max(widefield)));
widefield = uint8(widefield./max_widefield*255);
WF = widefield;
stackfilename = [output ,'WF.tif'];
for k = 1:Nz
    imwrite(uint8(WF(:,:,k)), stackfilename, 'WriteMode','append') % 写入stack图像
end
Nx = 2*numpixelsx;
Ny = 2*numpixelsy;

end