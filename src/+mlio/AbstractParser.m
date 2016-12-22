classdef AbstractParser < mlio.AbstractIO
	%% ABSTRACTPARSER  

	%  $Revision$
 	%  was created 16-Oct-2015 14:12:25
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlio/src/+mlio.
 	%% It was developed on Matlab 8.5.0.197613 (R2015a) for MACI64.
 	
	properties (Constant)		 
        FILETYPE_EXT = {'.txt' '.ifh' '.rec' '.log' '.out' '.hdrinfo'} % supported file extension; all should be plain text
        ENG_PATT_UP  = '\-?\d+\.?\d*E?D?\+?\-?\d*'
        ENG_PATT_LOW = '\-?\d+\.?\d*e?d?\+?\-?\d*'
 	end 

    properties (Dependent)
        cellContents
        descrip
        length
    end

	methods % GET/SET
        function c = get.cellContents(this)
            assert(~isempty(this.cellContents_));
            c = this.cellContents_;
        end
        function this = set.cellContents(this, s)
            assert(iscell(s));
            this.cellContents_ = s;
        end
        function d = get.descrip(this)
            d = sprintf('%s read %s on %s', class(this), this.fqfilename, datestr(now));
        end
        function l = get.length(this)
            l = length(this.cellContents); %#ok<CPROP>
        end
    end  
    
	methods (Static, Abstract)
        this = load(filename)
        this = loadx(filename, ext) % specifies multi-dottied file extensions
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
                for c = 1:length(this.cellContents_) %#ok<CPROP>
                    fprintf(fid, '%s\n', this.cellContents_{c});
                end
                fclose(fid);
            catch ME
                handexcept(ME);
            end
        end  
    end     
    
    %% PROTECTED
    
    properties (Access = 'protected')
        cellContents_
    end
    
    methods (Static, Access = 'protected')
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
                handexcept('mlio.ioException', ...
                           'AbstractParser.textfileToCell:  could not read %s; ME.identifier->%s', ...
                           fqfn, ME.identifier);
            end
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

