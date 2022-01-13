classdef HandleFilesystem < handle & mlio.AbstractHandleIO
    %% HANDLEFILESYSTEM encapsulates IO primitives for handle classes.
    %  
    %  Created 04-Dec-2021 23:34:02 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlio/src/+mlio.
    %  Developed on Matlab 9.11.0.1809720 (R2021b) Update 1 for MACI64.  Copyright 2021 John J. Lee.
    
    methods (Static)
        function this = createFromString(str)
            [pth,fp,x] = myfileparts(str);
            this = mlio.HandleFilesystem('filepath', pth, 'fileprefix', fp, 'filesuffix', x);
        end
    end

    methods
        function tf = isfile(this)
            tf = isfile(this.fqfilename);
        end
        function tf = isfolder(this)
            tf = isfolder(this.filepath);
        end
        function this = HandleFilesystem(varargin)
            %% HANDLEFILESYSTEM 
            %  Args:
            %      filepath (text): is a parameter.
            %      fileprefix (text): is a parameter.
            %      filesuffix (text): is a parameter.
            %      noclobber (logical): is a parameter.
            
            this = this@mlio.AbstractHandleIO(varargin{:})            
        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
