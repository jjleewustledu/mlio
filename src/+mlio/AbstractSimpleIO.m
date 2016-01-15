classdef AbstractSimpleIO < mlio.IOInterface
	%% ABSTRACTSIMPLEIO implements highly conserved portions of IOInterface;
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
        function this = saveas(this, fqfn)
            this.fqfilename = fqfn;
            this.save;
        end
        function this = saveasx(this, fqfn, x)
            this.fqfileprefix = fqfn(1:strfind(fqfn, x)-1);
            this.filesuffix_ = x;
            this.save;
        end
    end
    
    properties (Access = 'protected')
        filepath_   = '';
        fileprefix_ = '';
        filesuffix_ = '';
        noclobber_  = false;
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

