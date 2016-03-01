classdef LogParser < mlio.AbstractParser
	%% LOGPARSER parses numerical values to the right or left of a text field-name.
    %  For more fine-grained parsing features, see TextParser.

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.5.0.197613 (R2015a) 
 	%  $Id$   
    
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
        function [contnt,idx] = findNextCell(this, fieldName, idx0)
            assert(ischar(fieldName));
            assert(isnumeric(idx0));
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
                error('mlio:endOfFile', 'LogParser.findNextCell found nothing more'); end
        end	
        function [contntCells,idx] = findNextNCells(this, fieldName, idx0, N)
            assert(ischar(fieldName));
            assert(isnumeric(idx0));
            assert(isnumeric(N));
            contntCells = cell(1,N);
            idx = idx0;
            for c = idx0:length(this.cellContents_) 
                if (lstrfind(this.cellContents_{c}, fieldName))
                    for n = 1:N
                        contntCells{n} = this.cellContents_{c+n-1};
                    end
                    idx = c+N-1;
                    break
                end
            end
            if (isempty(contntCells))
                error('mlio:endOfFile', 'LogParser.findNextNCells found nothing more'); end
        end	
        function [nvs,idx1] = nextLineNNumeric(this, fieldName, varargin)
            p = inputParser;
            addRequired(p, 'fieldName', @ischar);
            addOptional(p, 'N',    1,   @isnumeric);
            addOptional(p, 'idx0', 1,   @isnumeric);
            parse(p, fieldName, varargin{:});
            
            [lines,idx1] = this.findNextNCells(p.Results.fieldName, p.Results.idx0, 2);
            if (isempty(lines) || isempty(lines{2}))
                nvs = []; 
                return
            end
            frmt = '\\s*(?<value1>%s)';
            spec = {this.ENG_PATT_LOW};
            for n = 2:p.Results.N
                frmt = [frmt '\\s+(?<value' num2str(n) '>%s)'];
                spec = [spec {this.ENG_PATT_LOW}];
            end
            args  = [{frmt} spec];
            names = regexp(lines{2}, sprintf(args{:}), 'names');
            for n = 1:p.Results.N
                nvs(1,n) = str2double(strtrim(names.(['value' num2str(n)])));
            end
        end
        function [nv,idx1] = rightSideChar(this, fieldName, varargin)
            p = inputParser;
            addRequired(p, 'fieldName', @ischar);
            addOptional(p, 'idx0', 1,   @isnumeric);
            parse(p, fieldName, varargin{:});
            
            [line,idx1] = this.findNextCell(fieldName, p.Results.idx0);
            if (isempty(line))
                nv = []; 
                return
            end
            names = regexp(line, sprintf('%s\\s*(?<value1>\\S+)', fieldName), 'names');
            nv    = strtrim(names.value1);
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
            nv    = str2num(strtrim(names.value1)); %#ok<ST2NM>
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
            nv    = str2num(strtrim([names.value1 ' ' names.value2])); %#ok<ST2NM>
        end
    end 
    
    %% PROTECTED
    
    methods (Static, Access = 'protected')
        function this = loadText(fn)
            import mlio.*;
            this = LogParser;
            this.cellContents_ = LogParser.textfileToCell(fn);
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

