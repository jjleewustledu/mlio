classdef (Abstract) AbstractIO < mlio.IOInterface    
	%% ABSTRACTIO provides thin, minimalist methods for I/O.  Agnostic to all other object characteristics.
    %  Support handle classes using AbstractHandleIO.

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
        
        function this = set.filename(this, s)
            assert(istext(s));
            [this.filepath,this.fileprefix,this.filesuffix] = myfileparts(s);
        end
        function g    = get.filename(this)
            if isstring(this.fileprefix)
                g = this.fileprefix + this.filesuffix;
                return
            end
            if ischar(this.fileprefix)
                g = [this.fileprefix this.filesuffix];
                return
            end
            error("mlio:TypeError", "AbstractIO.get.filename")
        end
        function this = set.filepath(this, s)
            this = this.setFilepath_(s);
        end
        function g = get.filepath(this)
            g = this.getFilepath_();
        end
        function this = set.fileprefix(this, s)
            this = this.setFileprefix_(s);
        end
        function g    = get.fileprefix(this)
            g = this.getFileprefix_();
        end
        function this = set.filesuffix(this, s)
            this = this.setFilesuffix_(s);
        end
        function g    = get.filesuffix(this)
            g = this.getFilesuffix_();
        end
        function this = set.fqfilename(this, s)
            assert(istext(s));
            [this.filepath,this.fileprefix,this.filesuffix] = myfileparts(s);
        end
        function g    = get.fqfilename(this)
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
        function this = set.fqfileprefix(this, s)
            [this.filepath,this.fileprefix] = myfileparts(s);
        end
        function g    = get.fqfileprefix(this)
            g = fullfile(this.filepath, this.fileprefix);
        end
        function this = set.fqfn(this, s)
            this.fqfilename = s;
        end
        function g    = get.fqfn(this)
            g = this.fqfilename;
        end
        function this = set.fqfp(this, s)
            this.fqfileprefix = s;
        end
        function g    = get.fqfp(this)
            g = this.fqfileprefix;
        end
        function this = set.noclobber(this, s)
            assert(islogical(s));
            this.filesystemRegistry_.noclobber = s;
        end
        function g    = get.noclobber(this)
            g = this.filesystemRegistry_.noclobber;
        end
        
        %%
        
        function c = char(this, varargin)
            c = convertStringsToChars(this.fqfilename, varargin{:});
        end
        function obj = fqfilenameObject(~, varargin)
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
        function this = saveas(this, fqfn)
            this.fqfilename = fqfn;
            this.save();
        end
        function this = saveasx(this, fqfn, x)
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
        function this = setFilepath_(this, pth)
            assert(istext(pth));
            this.filepath_ = pth;
        end
        function pth  = getFilepath_(this)
            if (isempty(this.filepath_))
                this.filepath_ = pwd; 
            end
            pth = this.filepath_;
        end
        function this = setFileprefix_(this, fp)
            assert(istext(fp));
            this.fileprefix_ = fp;
        end
        function fp   = getFileprefix_(this)
            fp = this.fileprefix_;
        end
        function this = setFilesuffix_(this, fs)
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
        function g    = getFilesuffix_(this)
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

        function this = AbstractIO(varargin)
            %% ABSTRACTHANDLEIO 
            %  Args:
            %      filepath (text): is a parameter.
            %      fileprefix (text): is a parameter.
            %      filesuffix (text): is a parameter.
            %      noclobber (logical): is a parameter.
            
            [pth_,fp_] = fileparts(tempname);
            
            ip = inputParser;
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
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

