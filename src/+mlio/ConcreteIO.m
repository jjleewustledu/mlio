classdef ConcreteIO < mlio.AbstractIO
	%% CONCRETEIO  

	%  $Revision$
 	%  was created 02-Jan-2016 17:29:04
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlio/src/+mlio.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

	properties
 		
    end

    methods (Static)
        function this = load(fn)
            this = mlio.ConcreteIO(fn);
        end
    end
    
	methods 
        function        save(this)
            try
                c = sprintf('touch %s', this.fqfilename);
                mlbash(c);
            catch ME
                handexcept(ME, 'mlio:filesystemError', ...
                    'ConcreteIO.save failed attempt to %s', c);
            end
        end
        function this = ConcreteIO(fqfn)
            assert(ischar(fqfn));
            this.fqfn = fqfn;
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

