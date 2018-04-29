classdef ConcreteIO < mlio.AbstractIO
	%% CONCRETEIO  

	%  $Revision$
 	%  was created 02-Jan-2016 17:29:04
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlio/src/+mlio.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

    properties (Dependent)
        viewer
    end
    
    methods %% GET        
        function v    = get.viewer(this)
            v = this.viewer_;
        end
        function this = set.viewer(this, v)
            this.viewer_ = v;
        end
    end
    
    methods (Static)
        function this = load(fn)
            this = mlio.ConcreteIO(fn);
        end
    end
    
	methods 
        function        save(this)
            try
                c = sprintf('touch %s', this.fqfilename);
                mlbash(c);
            catch ME
                handexcept(ME, 'mlio:filesystemError', ...
                    'ConcreteIO.save failed attempt to %s', c);
            end
        end
        function        view(this, varargin)
            this.launchExternalViewer(this.viewer, varargin{:});
        end
        function this = ConcreteIO(obj)
            import mlfourd.*;
            if (~exist('obj', 'var'))
                return
            end
            switch (class(obj))
                case 'mlio.ConcreteIO'
                    this = obj;
                case 'char' 
                    if (strcmp(obj(end-3:end), '.mgz') || strcmp(obj(end-3:end), '.mgh'))
                        this.fqfileprefix = obj(1:end-4);
                        this.filesuffix   = obj(end-3:end);                    
                    else
                        this.fqfilename = obj;
                    end
                    if (~lexist(this.fqfilename))
                        fprintf('mlio:fileNotOnFilesystemUponObjectCreation\n');
                        fprintf('ConcreteIO.ctor received fqfilename->%s which is not on the filesystem\n', ...
                            this.fqfilename);
                    end
                case 'struct'
                    if (this.isJimmyShen(obj))
                        if (~lexist([obj.fileprefix '.nii.gz']))
                            this.save_JimmyShen(obj);
                        end
                        this.filename = [obj.fileprefix '.nii.gz'];
                    end
                otherwise
                    if (isnumeric(obj))
                        obj = NIfTId(obj);
                        if (~obj.lexistFile)
                            obj.save;
                        end
                        this.fqfilename = obj.fqfilename;
                    elseif (isa(obj, 'mlfourd.NIfTIInterface'))
                        obj.save;
                        this.fqfilename = obj.fqfilename;
                    elseif (isa(obj, 'mlfourd.INIfTId'))
                        if (~obj.lexistFile)
                            obj.save;
                        end
                        this.fqfilename = obj.fqfilename;
                    elseif (isa(obj, 'mlfourd.INIfTIc'))
                        if (all(~cell2mat(obj.lexistFile)))
                            obj.save;
                        end
                        obj = obj.get(1);
                        this.fqfilename = obj.fqfilename;
                    elseif (isa(obj, 'mlfourdfp.IFourdfp'))
                        if (~obj.lexistFile)
                            obj.save;
                        end
                        this.fqfilename = obj.fqfilename;
                    elseif (iscell(obj))
                        assert(~isempty(obj));               
                        this = ConcreteIO(obj{1});
                    elseif isa(obj, 'mlpatterns.Composite')  
                        assert(~isempty(obj));
                        this = ConcreteIO(obj.get(1));
                    else
                        error('mlio:unsupportedSwitchCase', ...
                              'ConcreteIO.ctor does not support class(obj)->%s', class(obj));
                    end                    
            end
        end
    end 
    
    %% PRIVATE
    
    properties (Access = private)
        viewer_ = 'freeview'
    end
    
    methods (Static, Access = private)
        function tf = isJimmyShen(obj)
            tf = isfield(obj, 'hdr') && isfield(obj, 'filetype') && isfield(obj, 'fileprefix') && ...
                 isfield(obj, 'machine') && isfield(obj, 'ext') && isfield(obj, 'img') && isfield(obj, 'untouch');
        end
        function      save_JimmyShen(obj)
            assert(isfield(obj, 'untouch'));
            if (obj.untouch)
                mlniftitools.save_untouch_nii(obj, [obj.fileprefix '.nii.gz']);
            else
                mlniftitools.save_nii(obj, [obj.fileprefix '.nii.gz']);
            end
        end
    end
    
    methods (Access = private)        
        function      launchExternalViewer(this, app, varargin)
            assert(ischar(app));
            assert(lexist(this.fqfilename, 'file'));
            
            if (strcmp(this.filesuffix, '.4dfp.ifh'))
                this.filesuffix = '.4dfp.ifh';
            end
            if (isempty(varargin))
                cmdline = sprintf('%s %s',    app, this.fqfilename);
            else
                cmdline = sprintf('%s %s %s', app, this.fqfilename, imaging2str(varargin{:}));
            end  
            mlbash(cmdline);
        end
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

