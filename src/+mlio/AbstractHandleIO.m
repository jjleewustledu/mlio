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
    
    methods %% Set/Get
        function        set.filename(this, fn)
            [this.filepath,this.fileprefix,this.filesuffix] = myfileparts(fn);
        end
        function fn   = get.filename(this)
            fn = [this.fileprefix this.filesuffix];
        end
        function        set.filepath(this, pth)
            assert(ischar(pth));
            this.filepath_ = pth;
        end
        function pth  = get.filepath(this)
            if (isempty(this.filepath_))
                this.filepath_ = pwd; end
            pth = this.filepath_;
        end
        function        set.fileprefix(this, fp)
            assert(ischar(fp));
            [~,this.fileprefix_] = myfileparts(fp);
        end
        function fp   = get.fileprefix(this)
            fp = this.fileprefix_;
        end
        function        set.filesuffix(this, fs)
            assert(ischar(fs));
            this.filesuffix_ = fs;
        end
        function fs   = get.filesuffix(this)
            if (isempty(this.filesuffix_))
                fs = ''; return; end
            if (~strcmp('.', this.filesuffix_(1)))
                this.filesuffix_ = ['.' this.filesuffix_]; end
            fs = this.filesuffix_;
        end
        function        set.fqfilename(this, fqfn)
            [this.filepath,this.fileprefix,this.filesuffix] = myfileparts(fqfn);           
        end
        function fqfn = get.fqfilename(this)
            fqfn = [this.fqfileprefix this.filesuffix];
        end
        function        set.fqfileprefix(this, fqfp)
            [this.filepath, this.fileprefix] = myfileparts(fqfp);
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
        function        set.noclobber(this, nc)
            assert(islogical(nc));
            this.noclobber_ = nc;
        end
        function tf   = get.noclobber(this)
            tf = this.noclobber_;
        end
    end
    
    methods
        function saveas(this, fqfn)
            this.fqfilename = fqfn;
            this.save;
        end
    end
    
    properties (Access = 'protected')
        filepath_
        fileprefix_
        filesuffix_
        noclobber_ = false;
    end

end