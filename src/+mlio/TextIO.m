classdef TextIO < mlio.AbstractIO
	%% TEXTIO is a concrete class for filesystem I/O of ASCII/Unicode text
    
	%  $Revision$
 	%  was created $Date$
 	%  by $Author$, 
 	%  last modified $LastChangedDate$
 	%  and checked into repository $URL$, 
 	%  developed on Matlab 8.1.0.604 (R2013a)
 	%  $Id$

    properties (Constant)
        FILETYPE     = 'Plain Text';
        FILETYPE_EXT = '.txt';
    end
    
    properties (Dependent)
        contents
        descrip
    end
    
	methods (Static)
        function this  = load(fn) 
            assert(lexist(fn, 'file'));
            [pth, fp, fext] = fileparts(fn); 
            if (strcmp(mlio.TextIO.FILETYPE_EXT, fext) || ...
                isempty(fext))
                this = mlio.TextIO.loadText(fn); 
                this.fqfilename = fullfile(pth, [fp fext]);
                return 
            end
            error('mlio:unsupportedParam', 'TextIO.load does not support file-extension .%s', fext);
        end
        function ca    = textfileToCell(fqfn, eol)  %#ok<INUSD>
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
        function str   = textfileToString(fqfn)
            str = strjoin( ...
                  mlio.TextIO.textfileToCell(fqfn, '\n'), '');
        end
        function tf    = textfileStrcmp(str, fqfn, varargin)
            tf = strcmp(strtrim(str), ...
                        strtrim(mlio.TextIO.textfileToString(fqfn, varargin{:})));
        end
        function clls  = nonEmptyCells(clls)
            cal = mlpatterns.CellArrayList;
            cal.add(clls);
            for c = 1:length(cal)
                if (isempty(cal.get(c)))
                    cal.remove(c); end
            end
            clls = cell(1, length(cal));
            for c = 1:length(cal)
                clls{c} = cal.get(c);
            end            
        end
    end
    
    methods
        function c     = get.contents(this)
            c = char(this.contents_);
        end
        function d     = get.descrip(this)
            d = sprintf('%s read %s on %s', class(this), this.fqfilename, datestr(now));
        end
        function ch    = char(this)
            ch = this.contents;
        end
        function         save(this) 
            assert(~isempty(this.fqfilename));
            if (this.noclobber && lexist(this.fqfilename, 'file'))
                error('mlio:IOErr', 'TextIO.save.fqfilename->%s already exists; stopping...%s', this.fqfilename); end
            this.writeText;
        end
    end
    
    %% PRIVATE
    
    properties (Access = 'private')
        contents_
    end
    
    methods (Static, Access = 'private')
        function this = loadText(fn)
            import mlio.*;
            this = TextIO;
            this.contents_ = TextIO.textfileToString(fn);
        end
    end
    
    methods (Access = 'private')
        function writeText(this)
            try
                fid = fopen(this.fqfilename, 'w');
                fprintf(fid, '%s', this.contents_);
                fclose(fid);
            catch ME
                handexcept(ME);
            end            
        end
    end
    

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

