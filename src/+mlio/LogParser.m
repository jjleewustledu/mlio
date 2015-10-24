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
    
    methods (Static, Access = 'protected')
        function this = loadText(fn)
            import mlio.*;
            this = LogParser;
            this.cellContents_ = LogParser.textfileToCell(fn);
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

