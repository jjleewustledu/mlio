classdef FilesystemRegistry < handle
	%% FILESYSTEMREGISTRY is a singleton providing filesystem utilities	 
	%  Version $Revision: 2642 $ was created $Date: 2013-09-21 17:58:30 -0500 (Sat, 21 Sep 2013) $ by $Author: jjlee $,  
 	%  last modified $LastChangedDate: 2013-09-21 17:58:30 -0500 (Sat, 21 Sep 2013) $ and checked into svn repository $URL: file:///Users/jjlee/Library/SVNRepository_2012sep1/mpackages/mlfourd/src/+mlfourd/trunk/FilesystemRegistry.m $ 
 	%  Developed on Matlab 7.13.0.564 (R2011b) 
 	%  $Id: FilesystemRegistry.m 2642 2013-09-21 22:58:30Z jjlee $ 
    
    properties 
        noclobber = false
    end
    
    methods (Static)        
        function this = instance(varargin)
            %% INSTANCE uses string qualifiers to implement registry behavior that
            %  requires access to the persistent uniqueInstance
            %  Usage:   obj = FilesystemRegistry.instance([qualifier, qualifier2, ...])
            %                                              e.g., 'initialize'
            persistent uniqueInstance
            
            for v = 1:length(varargin) %#ok<*FORFLG>
                if (strcmp(varargin{v}, 'initialize'))
                    uniqueInstance = []; 
                end
            end
            if (isempty(uniqueInstance))
                this = mlio.FilesystemRegistry;
                uniqueInstance = this;
            else
                this = uniqueInstance;
            end
        end
        
        function        cellToTextfile(cll, varargin)
            ip = inputParser;
            addRequired(ip, 'cll', @iscell);
            parse(ip, cll);
            
            cal = mlpatterns.CellArrayList;
            cal.add(ip.Results.cll);
            mlio.FilesystemRegistry.cellArrayListToTextfile(cal, varargin{:});
        end
        function        cellArrayListToTextfile(varargin)
            ip = inputParser;
            addRequired(ip, 'cal',       @(x) isa(x, 'mlpatterns.CellArrayList'));
            addRequired(ip, 'fqfn',      @istext);
            addOptional(ip, 'perm', 'w', @istext);
            parse(ip, varargin{:});
            
            iter = ip.Results.cal.createIterator;
            try
                fid = fopen(ip.Results.fqfn, ip.Results.perm);
                while (iter.hasNext)
                    fprintf(fid, '%s\n', char(iter.next));
                end
                fclose(fid);
            catch ME
                handexcept(ME);
            end
        end
        function s    = extractNestedFolders(pth, patt)
            %% EXTRACTNESTEDFOLDERS finds folders with string-pattern in the specified filesystem path
            %  and moves the folders to the path (flattens)
            %  Usage:  status = FilesystemRegistry.extractNestedFolders(path, string_pattern)
            %  See also:  mlfourd.AbstractDicomConverter
            
            s = 0;
            if (lstrfind(pth, patt))
                try
                    dlist = mlsystem.DirTool(fullfile(pth, '*', ''));
                    for d = 1:length(dlist.fqdns) %#ok<*FORFLG>
                        [s,msg,mid] = movefile(dlist.fqdns{d}, fullfile(pth, '..', ''));
                    end
                catch ME
                    handexcept(ME, msg, mid);
                end
            end
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
            catch ME
                handexcept(ME);
            end
            if (isempty(ca) || isempty(ca{1}))
                error('mlio:IOError', '%s was empty', fqfn);
            end
        end
        function cal  = textfileToCellArrayList(varargin)
            cal = mlpatterns.CellArrayList;
            cal.add( ...
                mlio.FilesystemRegistry.textfileToCell(varargin{:}));
        end
        function tf   = textfileStrcmp(fqfn, str)
            ca = mlio.FilesystemRegistry.textfileToCell(fqfn, true);
            castr = '';
            for c = 1:length(ca)
                castr = [castr ca{c}]; %#ok<AGROW>
            end
            tf = strcmp(strtrim(castr), strtrim(str));
        end
    end
    
	methods (Access = 'private')
 		function this = FilesystemRegistry() 
 			%% FILESYSTEMREGISTRY (ctor) is private to enforce instantiation through instance 
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end 
