classdef AbstractCompositeIO < mlio.IOInterface
	%% ABSTRACTCOMPOSITEIO  

	%  $Revision$
 	%  was created 14-Jan-2016 20:51:08
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlio/src/+mlio.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	
	properties (Dependent)
        filename
        filepath
        fileprefix 
        filesuffix
        fqfilename
        fqfileprefix
        fqfn
        fqfp
        noclobber 
    end

    methods %% Set/Get 
        function this = set.filename(this, fn)
            this = this.innerCellComp_.setter('filename', fn);
        end
        function fn   = get.filename(this)
            fn = this.innerCellComp_.getter('filename');
        end
        function this = set.filepath(this, pth)
            this = this.innerCellComp_.setter('filepath', pth);
        end
        function pth  = get.filepath(this)
            pth = this.innerCellComp_.getter('filepath');
        end
        function this = set.fileprefix(this, fp)
            this = this.innerCellComp_.setter('fileprefix', fp);
        end
        function fp   = get.fileprefix(this)
            fp = this.innerCellComp_.getter('fileprefix');
        end
        function this = set.filesuffix(this, fs)
            this = this.innerCellComp_.setter('filesuffix', fs);
        end
        function fs   = get.filesuffix(this)
            fs = this.innerCellComp_.getter('filesuffix');
        end        
        function this = set.fqfilename(this, fqfn)
            this = this.innerCellComp_.setter('fqfilename', fqfn);
        end
        function fqfn = get.fqfilename(this)
            fqfn = this.innerCellComp_.getter('fqfilename');
        end
        function this = set.fqfileprefix(this, fqfp)
            this = this.innerCellComp_.setter('fqfileprefix', fqfp);
        end
        function fqfp = get.fqfileprefix(this)
            fqfp = this.innerCellComp_.getter('fqfileprefix');
        end
        function this = set.fqfn(this, f)
            this.fqfilename = f;
        end
        function f    = get.fqfn(this)
            f = this.fqfilename;
        end
        function this = set.fqfp(this, f)
            this.fqfileprefix = f;
        end
        function f    = get.fqfp(this)
            f = this.fqfileprefix;
        end
        function this = set.noclobber(this, nc)
            this = this.innerCellComp_.setter('noclobber', nc);
        end
        function tf   = get.noclobber(this)
            tf = this.innerCellComp_.getter('noclobber');
        end
    end
    
    methods 
        function this = saveas(this, fqfn)
            this = this.innerCellComp_.setter('fqfilename', fqfn);
            this = this.innerCellComp_.fevalThis('save');
        end
        function this = saveasx(this, fqfn, x)
            this = this.innerCellComp_.setter('fqfilename', fqfn);
            this = this.innerCellComp_.setter('filesuffix', x);
            this = this.innerCellComp_.fevalThis('save');
        end
    end    

    %% PROTECTED
    
    properties (Abstract, Access = protected)
        innerCellComp_
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

