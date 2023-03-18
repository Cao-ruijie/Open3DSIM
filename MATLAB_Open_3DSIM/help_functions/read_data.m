function [dataparams,WF,Nx,Ny,Nz,raw_image] = read_data(datasets,output,numchannels,numframes,jchannel,jframe,read_type)

if read_type == 1
    [dataparams,WF,Nx,Ny,Nz,raw_image] = read_data_1(datasets,output,numchannels,numframes,jchannel,jframe);
elseif read_type == 2
    [dataparams,WF,Nx,Ny,Nz,raw_image] = read_data_2(datasets,output,numchannels,numframes,jchannel,jframe);
elseif read_type == 3
    [dataparams,WF,Nx,Ny,Nz,raw_image] = read_data_3(datasets,output,numchannels,numframes,jchannel,jframe);
end

end