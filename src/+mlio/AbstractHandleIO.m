classdef AbstractHandleIO < handle
    
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
        
        function        set.filename(this, fn)
            assert(ischar(fn));
            [this.filepath,this.fileprefix,this.filesuffix] = myfileparts(fn);
        end
        function fn   = get.filename(this)
            fn = [this.fileprefix this.filesuffix];
        end
        function        set.filepath(this, pth)
            this.setFilepath_(pth);
        end
        function pth  = get.filepath(this)
            pth = this.getFilepath_();
        end
        function        set.fileprefix(this, fp)
            this.setFileprefix_(fp);
        end
        function fp   = get.fileprefix(this)
            fp = this.getFileprefix_();
        end
        function        set.filesuffix(this, fs)
            this.setFilesuffix_(fs)
        end
        function fs   = get.filesuffix(this)
            fs = this.getFilesuffix_();
        end
        function        set.fqfilename(this, fqfn)
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
        function        set.fqfileprefix(this, fqfp)
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
        function        set.fqfn(this, f)
            this.fqfilename = f;
        end
        function f    = get.fqfn(this)
            f = this.fqfilename;
        end
        function        set.fqfp(this, f)
            this.fqfileprefix = f;
        end
        function f    = get.fqfp(this)
            f = this.fqfileprefix;
        end
        function        set.noclobber(~, nc)
            assert(islogical(nc));
            fsr = mlsystem.FilesystemRegistry.instance;
            fsr.noclobber = nc;
        end
        function tf   = get.noclobber(~)
            tf = mlsystem.FilesystemRegistry.instance.noclobber;
        end
    end
    
    methods
        function saveas(this, fqfn)
            this.fqfilename = fqfn;
            this.save;
        end
        function saveasx(this, fqfn, x)
            this.fqfileprefix = fqfn(1:strfind(fqfn, x)-1);
            this.filesuffix_ = x;
            this.save;
        end
    end
    
    %% PROTECTED
    
    properties (Access = 'protected')
        filepath_
        fileprefix_
        filesuffix_
        filesystemRegistry_
    end
    
    methods (Access = 'protected')        
        function        setFilepath_(this, pth)
            assert(ischar(pth));
            this.filepath_ = pth;
        end
        function pth  = getFilepath_(this)
            if (isempty(this.filepath_))
                this.filepath_ = pwd; end
            pth = this.filepath_;
        end
        function        setFileprefix_(this, fp)
            assert(ischar(fp));
            assert(~isempty(fp));
            this.fileprefix_ = fp;
        end
        function fp   = getFileprefix_(this)
            fp = this.fileprefix_;
        end
        function        setFilesuffix_(this, fs)
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

end