classdef Filesystem < mlio.AbstractIO
    %% FILESYSTEM encapsulates IO primitives for value classes.
    %  
    %  Created 04-Dec-2021 23:35:04 by jjlee in repository /Users/jjlee/MATLAB-Drive/mlio/src/+mlio.
    %  Developed on Matlab 9.11.0.1809720 (R2021b) Update 1 for MACI64.  Copyright 2021 John J. Lee.
    
    methods (Static)
        function this = createFromString(str)
            [pth,fp,x] = myfileparts(str);
            this = mlio.Filesystem('filepath', pth, 'fileprefix', fp, 'filesuffix', x);
        end
    end

    methods
        function this = Filesystem(varargin)
            %% FILESYSTEM 
            %  Args:
            %      filepath (text): is a parameter.
            %      fileprefix (text): is a parameter.
            %      filesuffix (text): is a parameter.
            %      noclobber (logical): is a parameter.
            
            this = this@mlio.AbstractIO(varargin{:})
        end
    end
    
    %  Created with mlsystem.Newcl, inspired by Frank Gonzalez-Morphy's newfcn.
end
