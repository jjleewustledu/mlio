classdef TextParser < handle & mlio.AbstractParser
	%% TEXTPARSER parses strings and numbers arranged in various ways with identifying field-names.  
    %  For simpler parsing of numbers next to a field-name, see LogParser.

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.4.0.150421 (R2014b) 
 	%  $Id$  	 

	methods (Static)
        function this = load(fn)
            assert(lexist(fn, 'file'));
            [pth, fp, fext] = myfileparts(fn); 
            if (lstrfind(fext, mlio.TextParser.FILETYPE_EXT) || ...
                isempty(fext))
                this = mlio.TextParser.loadText(fn); 
                this.filepath_   = pth;
                this.fileprefix_ = fp;
                this.filesuffix_ = fext;
                return 
            end
            error('mlio:unsupportedParam', 'TextParser.load does not support file-extension %s', fext);
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
            this = mlio.TextParser.loadText(fn);
            this.filepath_   = pth;
            this.fileprefix_ = fp;
            this.filesuffix_ = fext;
        end
    end
    
    methods
        function e  = lineElements(this, varargin)
            ip = inputParser;
            addOptional(ip, 'lineNum', 1, @(x) isnumeric(x) && x <= this.length);
            parse(ip, varargin{:});
            
            line = this.cellContents{ip.Results.lineNum};
            e = textscan(line, '%s');
            e = e{1};
        end
        function sv = parseAssignedString(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('%s\\s*=\\s*(?<valueName>.+$)', fieldName), 'names');
            sv = strtrim(names.valueName);
        end
        function nv = parseAssignedNumeric(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('%s\\s*=\\s*(?<valueName>%s)', fieldName, this.ENG_PATT_UP), 'names');
            nv = str2num(strtrim(names.valueName)); %#ok<ST2NM>
        end           
        function sv = parseColonString(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('%s:\\s*(?<valueName>.+$)', fieldName), 'names');
            sv = strtrim(names.valueName);
        end
        function nv = parseColonNumeric(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('%s:\\s*(?<valueName>%s)', fieldName, this.ENG_PATT_UP), 'names');
            nv = str2num(strtrim(names.valueName)); %#ok<ST2NM>
        end 
        function nv = parseLeftAssociatedNumeric(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('(?<valueName>%s)\\s+%s', this.ENG_PATT_UP, fieldName), 'names');
            nv = str2num(strtrim(names.valueName)); %#ok<ST2NM>
        end
        function nv = parseRightAssociatedNumeric(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('%s\\s+(?<value1>%s)', fieldName, this.ENG_PATT_UP), 'names');
            nv = str2num(strtrim(names.value1)); %#ok<ST2NM>
        end
        function nv = parseRightAssociatedNumeric2(this, fieldName)
            line = this.findFirstCell(fieldName);
            names = regexp(line, sprintf('%s\\s+(?<value1>%s)\\s+(?<value2>%s)', fieldName, this.ENG_PATT_UP, this.ENG_PATT_UP), 'names');
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
    
    %% PROTECTED
    
    methods (Static, Access = 'protected')
        function this = loadText(fn)
            import mlio.*;
            this = TextParser;
            this.cellContents_ = TextParser.textfileToCell(fn);
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

