classdef AbstractIOInterface < mlio.IOInterface
	%% ABSTRACTIOINTERFACE implements highly conserved portions of IOInterface;
    %  forks from AbstractIO to support AbstractCompositeIO
    %  Yet abstract:  IOInterface static methods load; methods save
    
	%  $Revision$
 	%  was created $Date$
 	%  by $Author$, 
 	%  last modified $LastChangedDate$
 	%  and checked into repository $URL$, 
 	%  developed on Matlab 8.1.0.604 (R2013a)
 	%  $Id$
    
    methods
        function c = char(this, varargin)
            c = char(this.fqfilename, varargin{:});
        end
        function this = saveas(this, fqfn)
            this.fqfilename = fqfn;
            this.save;
        end
        function this = saveasx(this, fqfn, x)
            this.fqfileprefix = fqfn(1:strfind(fqfn, x)-1);
            this.filesuffix_ = x;
            this.save;
        end
        function s = string(this, varargin)
            s = string(this.fqfilename, varargin{:});
        end
    end
    
    properties (Access = 'protected')
        filepath_   = ''
        fileprefix_ = ''
        filesuffix_ = ''
        filesystemRegistry_
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

