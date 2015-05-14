classdef LogParser < mlio.AbstractIO 
	%% LOGPARSER   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.5.0.197613 (R2015a) 
 	%  $Id$ 
 	 

	properties (Constant)		 
        FILETYPE_EXT   = {'.txt' '.rec' '.log' '.out'} % supported file extension; all should be plain text
        ENG_PATT_UP    = '\-?\d+\.?\d*E?D?\+?\-?\d*'
        ENG_PATT_LOW   = '\-?\d+\.?\d*e?d?\+?\-?\d*'
 	end 

    properties (Dependent)
        cellContents
        descrip
        length
    end
    
	methods % GET
        function c = get.cellContents(this)
            assert(~isempty(this.cellContents_));
            c = this.cellContents_;
        end
        function d = get.descrip(this)
            d = sprintf('%s read %s on %s', class(this), this.fqfilename, datestr(now));
        end
        function l = get.length(this)
            l = length(this.cellContents);
        end
    end    
    
	methods (Static)
        function this = load(fn)
            assert(lexist(fn, 'file'));
            [pth, fp, fext] = fileparts(fn); 
            if (lstrfind(fext, mlio.LogParser.FILETYPE_EXT) || ...
                isempty(fext))
                this = mlio.LogParser.loadText(fn); 
                this.filepath_   = pth;
                this.fileprefix_ = fp;
                this.filesuffix_ = fext;
                return 
            end
            error('mlio:unsupportedParam', 'LogParser.load does not support file-extension .%s', fext);
        end
        function this = loadx(fn, ext)
            if (~lstrfind(fn, ext))
                if (~strcmp('.', ext(1)))
                    ext = ['.' ext];
                end
                fn = [fn ext];
            end
            assert(lexist(fn, 'file'));
            [pth, fp, fext] = filepartsx(fn, ext); 
            this = mlio.LogParser.loadText(fn);
            this.filepath_   = pth;
            this.fileprefix_ = fp;
            this.filesuffix_ = fext;
        end
    end
    
	methods 		 
        function ch = char(this)
            ch = strjoin(this.cellContents_);
        end
        function fprintf(this)
            for c = 1:this.length
                fprintf('%s\n', this.cellContents{c});
            end
        end
        function save(this)
            try
                fid = fopen(this.fqfilename, 'w');
                for c = 1:length(this.cellContents_)
                    fprintf(fid, '%s\n', this.cellContents_{c});
                end
                fclose(fid);
            catch ME
                handexcept(ME);
            end
        end
        
        function [nv,idx1] = rightSideNumeric(this, fieldName, varargin)
            p = inputParser;
            addRequired(p, 'fieldName', @ischar);
            addOptional(p, 'idx0', 1,   @isnumeric);
            parse(p, fieldName, varargin{:});
            
            [line,idx1] = this.findNextCell(fieldName, p.Results.idx0);
            if (isempty(line))
                nv = []; 
                return
            end
            names = regexp(line, sprintf('%s\\s+(?<value1>%s)', fieldName, this.ENG_PATT_LOW), 'names');
            nv = str2num(strtrim(names.value1)); %#ok<ST2NM>
        end
        function [nv,idx1] = rightSideNumeric2(this, fieldName, varargin)
            p = inputParser;
            addRequired(p, 'fieldName',      @ischar);
            addOptional(p, 'fieldName2', '', @ischar);
            addOptional(p, 'idx0', 1,        @isnumeric);
            parse(p, fieldName, varargin{:});
            
            [line,idx1] = this.findNextCell(fieldName, p.Results.idx0);
            if (isempty(line))
                nv = []; 
                return
            end
            names = regexp(line, ...
                    sprintf('%s\\s+(?<value1>%s)\\s+%s\\s+(?<value2>%s)', ...
                            p.Results.fieldName, this.ENG_PATT_LOW, p.Results.fieldName2, this.ENG_PATT_LOW), 'names');
            nv = str2num(strtrim([names.value1 ' ' names.value2])); %#ok<ST2NM>
        end
 		
        function [contnt,idx] = findNextCell(this, fieldName, idx0)
            contnt = [];
            idx = idx0;
            for c = idx0:length(this.cellContents_) 
                if (lstrfind(this.cellContents_{c}, fieldName))
                    contnt = this.cellContents_{c};
                    idx = c;
                    break
                end
            end
            if (isempty(contnt))
                throw(MException('mlio:endOfFile', 'LogParser.findNextCell found nothing more')); end
        end
    end 
    
    %% PROTECTED
    
    properties (Access = 'protected')
        cellContents_
    end
    
    methods (Static, Access = 'protected')
        function this = loadText(fn)
            import mlio.*;
            this = LogParser;
            this.cellContents_ = LogParser.textfileToCell(fn);
        end
        function ca   = textfileToCell(fqfn, eol)  %#ok<INUSD>
            if (~exist('eol','var'))
                fget = @fgetl;
            else
                fget = @fgets;
            end
            ca = {[]};
            try
                fid = fopen(fqfn);
                i   = 1;
                while 1
                    tline = fget(fid);
                    if ~ischar(tline), break, end
                    ca{i} = tline;
                    i     = i + 1;
                end
                fclose(fid);
                assert(~isempty(ca) && ~isempty(ca{1}))
            catch ME
                fprintf('mlio.TextIO.textfileToCell:  exception thrown while reading \n\t%s\n\tME.identifier->%s', fqfn, ME.identifier);
            end
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

