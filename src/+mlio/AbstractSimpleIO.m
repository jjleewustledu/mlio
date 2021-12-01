classdef (Abstract) AbstractSimpleIO < mlio.IOInterface
	%% ABSTRACTSIMPLEIO implements highly conserved portions of IOInterface;
    %  forks from AbstractCompositeIO.
    
	%  $Revision$
 	%  was created $Date$
 	%  by $Author$, 
 	%  last modified $LastChangedDate$
 	%  and checked into repository $URL$, 
 	%  developed on Matlab 8.1.0.604 (R2013a)
 	%  $Id$
    
    methods
        function c    = char(this, varargin)
            c = char(this.fqfilename, varargin{:});
        end
        function        save(this)
            save(this.fqfilename, 'this');
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
        function s    = string(this, varargin)
            s = string(this.fqfilename, varargin{:});
        end
        
        function this = AbstractSimpleIO(varargin)
            ip = inputParser;
            addParameter(ip, 'filepath',   '', @ischar);
            addParameter(ip, 'fileprefix', '', @ischar);
            addParameter(ip, 'filesuffix', '', @ischar);
            addParameter(ip, 'noclobber',  false, @ischar);
            parse(ip, varargin{:});
            
            this.filepath_   = ip.Results.filepath;
            this.fileprefix_ = ip.Results.fileprefix;
            this.filesuffix_ = ip.Results.filesuffix;
            this.noclobber_  = ip.Results.noclobber;
        end
    end
    
    properties (Access = protected)
        filepath_   = '';
        fileprefix_ = '';
        filesuffix_ = '';
        noclobber_  = false;
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

