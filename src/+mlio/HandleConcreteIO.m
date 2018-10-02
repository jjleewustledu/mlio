classdef HandleConcreteIO < handle & mlio.HandleIOInterface
	%% HANDLECONCRETEIO  

	%  $Revision$
 	%  was created 02-Jan-2016 17:29:04
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlio/src/+mlio.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	    
	methods 
        
        %%
        
        function        save(this)
            try
                c = sprintf('touch %s', this.fqfilename);
                mlbash(c);
            catch ME
                dispexcept(ME, 'mlio:filesystemError', ...
                    'HandleConcreteIO.save failed to save %s', c);
            end
        end
        function this = HandleConcreteIO(obj)
            import mlfourd.*;
            if (~exist('obj', 'var'))
                return
            end
            
            
            
            error('mlio:notImplementedError', 'HandleConcreteIO');
            
            
            
            switch (class(obj))
                case 'mlio.HandleConcreteIO'
                    this = obj;
                case 'char' 
                    if (strcmp(obj(end-3:end), '.mgz') || strcmp(obj(end-3:end), '.mgh'))
                        this.fqfileprefix = obj(1:end-4);
                        this.filesuffix   = obj(end-3:end);                    
                    else
                        this.fqfilename = obj;
                    end
                    if (~lexist(this.fqfilename) && verbose)
                        fprintf('mlio:fileNotOnFilesystemUponObjectCreation\n');
                        fprintf('HandleConcreteIO.ctor received fqfilename->%s which is not on the filesystem\n', ...
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
                        if (~obj.lexist)
                            obj.save;
                        end
                        this.fqfilename = obj.fqfilename;
                    elseif (isa(obj, 'mlfourd.NIfTIInterface'))
                        obj.save;
                        this.fqfilename = obj.fqfilename;
                    elseif (isa(obj, 'mlfourd.INIfTId'))
                        if (~obj.lexist)
                            obj.save;
                        end
                        this.fqfilename = obj.fqfilename;
                    elseif (isa(obj, 'mlfourd.INIfTIc'))
                        if (all(~cell2mat(obj.lexist)))
                            obj.save;
                        end
                        obj = obj.get(1);
                        this.fqfilename = obj.fqfilename;
                    elseif (isa(obj, 'mlfourdfp.IFourdfp'))
                        if (~obj.lexist)
                            obj.save;
                        end
                        this.fqfilename = obj.fqfilename;
                    elseif (iscell(obj))
                        assert(~isempty(obj));               
                        this = HandleConcreteIO(obj{1});
                    elseif isa(obj, 'mlpatterns.Composite')  
                        assert(~isempty(obj));
                        this = HandleConcreteIO(obj.get(1));
                    else
                        error('mlio:unsupportedSwitchCase', ...
                              'HandleConcreteIO.ctor does not support class(obj)->%s', class(obj));
                    end                    
            end
        end
    end 
    
    %% PRIVATE
    
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

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

