classdef AbstractComponentIO <  mlio.AbstractSimpleIO
	%% ABSTRACTCOMPONENTIO provides thin, minimalist methods for I/O for composite design patterns.  
    %  As compared to AbstractIO, AbstractComponentIO forwards property setters/getters to a cachedNext-property.
    %  Both conform conform to AbstractSimpleIO.

	%  $Revision: 2467 $
 	%  was created $Date: 2013-08-10 21:27:41 -0500 (Sat, 10 Aug 2013) $
 	%  by $Author: jjlee $, 
 	%  last modified $LastChangedDate: 2013-08-10 21:27:41 -0500 (Sat, 10 Aug 2013) $
 	%  developed on Matlab 8.1.0.604 (R2013a)
 	%  $Id: AbstractComposite.m 2467 2013-08-11 02:27:41Z jjlee $
    
    
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

    methods %% Set/Get mostly delegate to this.cachedNext
        function this = set.filename(this, fn)
            this.cachedNext.filename = fn;
        end
        function fn   = get.filename(this)
            fn = this.cachedNext.filename;
        end
        function this = set.filepath(this, pth)
           this.cachedNext.filepath = pth;
        end
        function pth  = get.filepath(this)
            pth = this.cachedNext.filepath;
        end
        function this = set.fileprefix(this, fp)
            this.cachedNext.fileprefix = fp;
        end
        function fp   = get.fileprefix(this)
            fp = this.cachedNext.fileprefix;
        end
        function this = set.filesuffix(this, fs)
            this.cachedNext.filesuffix = fs;
        end
        function fs   = get.filesuffix(this)
            fs = this.cachedNext.filesuffix;
        end
        function this = set.fqfilename(this, fqfn)
            this.cachedNext.fqfilename = fqfn;
        end
        function fqfn = get.fqfilename(this)
            fqfn = this.cachedNext.fqfilename;
        end
        function this = set.fqfileprefix(this, fqfp)
            this.cachedNext.fqfileprefix = fqfp;
        end
        function fqfp = get.fqfileprefix(this)
            fqfp = this.cachedNext.fqfileprefix;
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
            this.cachedNext.noclobber = nc;
        end
        function tf   = get.noclobber(this)
            tf = this.cachedNext.noclobber;
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

