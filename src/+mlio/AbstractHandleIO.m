classdef AbstractHandleIO < handle & matlab.mixin.Copyable & mlio.IOInterface
    %% ABSTRACTHANDLEIO provides thin, minimalist methods for I/O.  Agnostic to all other object characteristics.
    %  Support value classes using AbstractIO.
    
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
        
        function     set.filename(this, s)
            assert(istext(s));
            [this.filepath,this.fileprefix,this.filesuffix] = myfileparts(s);
        end
        function g = get.filename(this)
            if isstring(this.fileprefix)
                g = this.fileprefix + this.filesuffix;
                return
            end
            if ischar(this.fileprefix)
                g = [this.fileprefix this.filesuffix];
                return
            end
            error("mlio:TypeError", "AbstractHandleIO.get.filename")
        end
        function     set.filepath(this, pth)
            this.setFilepath_(pth);
        end
        function g = get.filepath(this)
            g = this.getFilepath_();
        end
        function     set.fileprefix(this, fp)
            this.setFileprefix_(fp);
        end
        function g = get.fileprefix(this)
            g = this.getFileprefix_();
        end
        function     set.filesuffix(this, fs)
            this.setFilesuffix_(fs)
        end
        function g = get.filesuffix(this)
            g = this.getFilesuffix_();
        end
        function     set.fqfilename(this, s)
            assert(istext(s));
            [this.filepath,this.fileprefix,this.filesuffix] = myfileparts(s);
        end
        function g = get.fqfilename(this)
            if isstring(this.fqfileprefix)
                g = this.fqfileprefix + this.filesuffix;
                return
            end
            if ischar(this.fqfileprefix)
                g = [this.fqfileprefix this.filesuffix];
                return
            end
            error("mlio:TypeError", "AbstractHandleIO.get.fqfilename")
        end
        function     set.fqfileprefix(this, s)
            [this.filepath,this.fileprefix] = myfileparts(s);
        end
        function g = get.fqfileprefix(this)
            g = fullfile(this.filepath, this.fileprefix);
        end
        function     set.fqfn(this, f)
            this.fqfilename = f;
        end
        function g = get.fqfn(this)
            g = this.fqfilename;
        end
        function     set.fqfp(this, f)
            this.fqfileprefix = f;
        end
        function g = get.fqfp(this)
            g = this.fqfileprefix;
        end
        function     set.noclobber(this, s)
            assert(islogical(s));
            this.filesystemRegistry_.noclobber = s;
        end
        function g = get.noclobber(this)
            g = this.filesystemRegistry_.noclobber;
        end

        %%

        function c = char(this, varargin)
            c = convertStringsToChars(this.fqfilename, varargin{:});
        end
        function obj  = fqfilenameObject(~, varargin)
            %  Args:
            %      fqfn (text): fully-qualified file name.
            %      tag (text): string to add to file prefix.
            %      typ (text): typeclass understood by mlfourd.ImagingContext2.imagingType.
            %  Returns:
            %      obj: returned by mlfourd.ImagingContext2.imagingType.
            
            ip = inputParser;
            ip.KeepUnmatched = true;
            addRequired( ip, "fqfn", @istext);
            addParameter(ip, "tag", '', @istext);
            addParameter(ip, "typ", 'fqfn', @istext);
            parse(ip, varargin{:});
            ipr = ip.Results;
            
            [pth,fp,x] = myfileparts(ipr.fqfn);
            if 0 == strlength(fp) 
                obj = imagingType("path", pth);
                return
            end
            fqfn_ = fullfile(pth, [fp ipr.tag x]);
            obj = imagingType(ipr.typ, fqfn_);
        end  
        function save(this)
            save(this.fqfilename, "this");
        end
        function saveas(this, fqfn)
            this.fqfilename = fqfn;
            this.save();
        end
        function saveasx(this, fqfn, x)
            this.fqfileprefix = extractBefore(fqfn, x);
            this.filesuffix_ = x;
            this.save();
        end
        function s = string(this, varargin)
            s = convertCharsToStrings(this.fqfilename, varargin{:});
        end
    end
    
    %% PROTECTED
    
    properties (Access = protected)
        filepath_
        fileprefix_
        filesuffix_
        filesystemRegistry_
    end
    
    methods (Access = protected)
        function     setFilepath_(this, pth)
            assert(istext(pth));
            this.filepath_ = pth;
        end
        function g = getFilepath_(this)
            if (isempty(this.filepath_))
                this.filepath_ = pwd; 
            end
            g = this.filepath_;
        end
        function     setFileprefix_(this, fp)
            assert(istext(fp));
            this.fileprefix_ = fp;
        end
        function g = getFileprefix_(this)
            g = this.fileprefix_;
        end
        function     setFilesuffix_(this, fs)
            assert(istext(fs));
            if isstring(this.fileprefix) && 0 == strlength(fs)
                this.filesuffix_ = "";
                return
            end
            if ischar(this.fileprefix) && 0 == strlength(fs)
                this.filesuffix_ = '';
                return
            end
            if isstring(fs) && ~startsWith(fs, ".")
                fs = "." + fs;
            end
            if ischar(fs) && ~startsWith(fs, '.')
                fs = ['.' fs];
            end
            this.filesuffix_ = fs;
        end
        function g = getFilesuffix_(this)
            if isempty(this.filesuffix_) && isstring(this.fileprefix)
                g = "";
                return
            end
            if isempty(this.filesuffix_) && ischar(this.fileprefix)
                g = '';
                return
            end
            g = this.filesuffix_;
        end

        function this = AbstractHandleIO(varargin)
            %% ABSTRACTHANDLEIO 
            %  Args:
            %      filepath (text): is a parameter.
            %      fileprefix (text): is a parameter.
            %      filesuffix (text): is a parameter.
            %      noclobber (logical): is a parameter.

            [pth_,fp_] = fileparts(tempname);
            fp_ = strcat(strrep(class(this), '.', '_'), '_', fp_);

            ip = inputParser;
            ip.KeepUnmatched = true;
            addParameter(ip, 'filepath', pth_, @istext);
            addParameter(ip, 'fileprefix', fp_, @istext);
            addParameter(ip, 'filesuffix', '.mat', @istext);
            addParameter(ip, 'noclobber', false, @istext);
            parse(ip, varargin{:});
            ipr = ip.Results;
            
            this.filepath_   = ipr.filepath;
            this.fileprefix_ = ipr.fileprefix;
            this.filesuffix_ = ipr.filesuffix;
            this.filesystemRegistry_ = mlio.FilesystemRegistry.instance();
            this.filesystemRegistry_.noclobber = ipr.noclobber;
        end
        function that = copyElement(this)
            that = copyElement@matlab.mixin.Copyable(this);
        end
    end

end