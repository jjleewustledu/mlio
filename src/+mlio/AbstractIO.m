classdef (Abstract) AbstractIO < mlio.AbstractSimpleIO    
	%% ABSTRACTIO provides thin, minimalist methods for I/O.  Agnostic to all other object characteristics.
    
	%  $Revision$
 	%  was created $Date$
 	%  by $Author$, 
 	%  last modified $LastChangedDate$
 	%  and checked into repository $URL$, 
 	%  developed on Matlab 8.1.0.604 (R2013a)
 	%  $Id$

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
    
    methods
        
        %% Set/Get
        
        function this = set.filename(this, fn)
            assert(ischar(fn));
            [this.filepath,this.fileprefix,this.filesuffix] = myfileparts(fn);
        end
        function fn   = get.filename(this)
            fn = [this.fileprefix this.filesuffix];
        end
        function this = set.filepath(this, pth)
            this = this.setFilepath_(pth);
        end
        function pth  = get.filepath(this)
            pth = this.getFilepath_();
        end
        function this = set.fileprefix(this, fp)
            this = this.setFileprefix_(fp);
        end
        function fp   = get.fileprefix(this)
            fp = this.getFileprefix_();
        end
        function this = set.filesuffix(this, fs)
            this = this.setFilesuffix_(fs);
        end
        function fs   = get.filesuffix(this)
            fs = this.getFilesuffix_();
        end
        function this = set.fqfilename(this, fqfn)
            assert(ischar(fqfn));
            [p,f,e] = myfileparts(fqfn);
            if (~isempty(p))
                this.filepath = p;
            end
            if (~isempty(f))
                this.fileprefix = f;
            end
            if (~isempty(e))
                this.filesuffix = e;
            end        
        end
        function fqfn = get.fqfilename(this)
            fqfn = [this.fqfileprefix this.filesuffix];
        end
        function this = set.fqfileprefix(this, fqfp)
            assert(ischar(fqfp));
            [p,f] = fileprefixparts(fqfp);            
            if (~isempty(p))
                this.filepath = p;
            end
            if (~isempty(f))
                this.fileprefix = f;
            end
        end
        function fqfp = get.fqfileprefix(this)
            fqfp = fullfile(this.filepath, this.fileprefix);
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
            assert(islogical(nc));
            this.noclobber_ = nc;
        end
        function tf   = get.noclobber(this) 
            tf = this.noclobber_;
        end
        
        %%
        
        function obj  = fqfilenameObject(~, varargin)
            %  @override
            %  @param named typ has default 'fqfn'
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, 'fqfn', @ischar);
            addParameter(ip, 'tag', '', @ischar);
            addParameter(ip, 'typ', 'fqfn', @ischar);
            parse(ip, varargin{:});
            
            [pth,fp,ext] = myfileparts(ip.Results.fqfn);
            if (isempty(fp))                
                obj = imagingType('path', pth);
                return
            end
            fqfn_ = fullfile(pth, [fp ip.Results.tag ext]);
            obj = imagingType(ip.Results.typ, fqfn_);
        end        
        function this = AbstractIO(varargin)
            this = this@mlio.AbstractSimpleIO(varargin{:});
            if (isempty(this.filepath_))
                this.filepath_ = pwd;
            end
        end      
    end
    
    %% PROTECTED
    
    methods (Access = protected)
        function this = setFilepath_(this, pth)
            assert(ischar(pth));
            this.filepath_ = pth;
        end
        function pth  = getFilepath_(this)
            pth = this.filepath_;
        end
        function this = setFileprefix_(this, fp)
            assert(ischar(fp));
            assert(~isempty(fp));
            this.fileprefix_ = fp;
        end
        function fp   = getFileprefix_(this)
            fp = this.fileprefix_;
        end
        function this = setFilesuffix_(this, fs)
            assert(ischar(fs));
            if (~isempty(fs) && ~strcmp('.', fs(1)))
                fs = ['.' fs];
            end
            [~,~,this.filesuffix_] = myfileparts(fs);
        end
        function fs   = getFilesuffix_(this)
            if (isempty(this.filesuffix_))
                fs = ''; return; end
            if (~strcmp('.', this.filesuffix_(1)))
                this.filesuffix_ = ['.' this.filesuffix_]; end
            fs = this.filesuffix_;
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

