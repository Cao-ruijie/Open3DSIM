function [dataparams,WF,Nx,Ny,Nz,raw_image] = read_data_3(datasets,output,numchannels,numframes,jchannel,jframe)

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
numpixelsx = size(allimages_in,1); 
numpixelsy = size(allimages_in,2); 
numims = size(allimages_in,3);     
dataparams.numpixelsx = numpixelsx;
dataparams.numpixelsy = numpixelsy;
dataparams.Nz = numims/dataparams.numsteps/dataparams.numangles/dataparams.numchannels/dataparams.numframes;
Nz = dataparams.Nz;
dataparams.allimages_in = reshape(allimages_in,[numpixelsx numpixelsy dataparams.numchannels dataparams.numframes dataparams.numsteps dataparams.numangles dataparams.Nz]);
dataparams.allimages_in = double(permute(dataparams.allimages_in,[1 2 5 7 3 4 6]));

%% select one frame and one channel
dataparams.allimages_in = dataparams.allimages_in(:,:,:,:,jchannel,jframe,:);
raw_image = dataparams.allimages_in;
dataparams.numchannels = numchannels;
dataparams.numframes = numframes;

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

% %% Write
% allimages_in = dataparams.allimages_in;
% max_ = max(max(max(max(max(max(max(allimages_in)))))));
% allimages_in = uint8(allimages_in./max_*255);
% stackfilename = ['Actin_488_1024_26z.tif'];
% raw = uint16(zeros(512,512,390));
% kkk = 1;
% for jNz = 1:26
%     for jangle = 1:3
%         for jstep = 1:5
%             raw(:,:,kkk) = allimages_in(:,:,jstep,jNz,1,1,jangle);
%             kkk = kkk+1;
%         end
%     end
% end
% for kkk = 1:390
%     imwrite(uint16(raw(:,:,kkk)), stackfilename, 'WriteMode','append') % 写入stack图像
% end

end