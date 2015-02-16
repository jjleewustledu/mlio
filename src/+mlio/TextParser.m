classdef TextParser < mlio.AbstractIO 
	%% TEXTPARSER   

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.4.0.150421 (R2014b) 
 	%  $Id$  	 


    properties (Constant)
        FILETYPE_EXT   = {'.txt' '.rec' '.log' '.out'} % supported file extension; all should be plain text
        ENG_PATT = '\-?\d+\.?\d*E?D?\+?\-?\d*'
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
            if (lstrfind(fext, mlio.TextParser.FILETYPE_EXT) || ...
                isempty(fext))
                this = mlio.TextParser.loadText(fn); 
                this.filepath_   = pth;
                this.fileprefix_ = fp;
                this.filesuffix_ = fext;
                return 
            end
            error('mlio:unsupportedParam', 'TextParser.load does not support file-extension .%s', fext);
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
    methods
        function ch = char(this)
            ch = strjoin(this.cellContents_);
        end
        function save(~)
            warning('mlio:notImplemented', 'TextParser.save');
        end
        
        function sv = parseAssignedString(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('%s\\s*=\\s*(?<valueName>.+$)', fieldName), 'names');
            sv = strtrim(names.valueName);
        end
        function nv = parseAssignedNumeric(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('%s\\s*=\\s*(?<valueName>%s)', fieldName, this.ENG_PATT), 'names');
            nv = str2num(strtrim(names.valueName)); %#ok<ST2NM>
        end           
        function sv = parseColonString(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('%s:\\s*(?<valueName>.+$)', fieldName), 'names');
            sv = strtrim(names.valueName);
        end
        function nv = parseColonNumeric(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('%s:\\s*(?<valueName>%s)', fieldName, this.ENG_PATT), 'names');
            nv = str2num(strtrim(names.valueName)); %#ok<ST2NM>
        end 
        function nv = parseLeftAssociatedNumeric(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('(?<valueName>%s)\\s+%s', this.ENG_PATT, fieldName), 'names');
            nv = str2num(strtrim(names.valueName)); %#ok<ST2NM>
        end
        function nv = parseRightAssociatedNumeric(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('%s\\s+(?<value1>%s)', fieldName, this.ENG_PATT), 'names');
            nv = str2num(strtrim(names.value1)); %#ok<ST2NM>
        end
        function nv = parseRightAssociatedNumeric2(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('%s\\s+(?<value1>%s)\\s+(?<value2>%s)', fieldName, this.ENG_PATT, this.ENG_PATT), 'names');
            nv = str2num(strtrim([names.value1 ' ' names.value2])); %#ok<ST2NM>
        end
        function [parsed,line] = findFirstCell(this, fieldName)
            assert(ischar(fieldName));
            parsed = [];
            for c = 1:length(this.cellContents_) 
                if (lstrfind(this.cellContents_{c}, fieldName))
                    parsed = this.cellContents_{c};
                    line = c;
                    break
                end
            end
        end
    end 
    
    %% PRIVATE
    
    properties (Access = 'private')
        cellContents_
    end
    
    methods (Static, Access = 'private')
        function this = loadText(fn)
            import mlio.*;
            this = TextParser;
            this.cellContents_ = TextParser.textfileToCell(fn);
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

