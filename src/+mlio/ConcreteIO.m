classdef ConcreteIO < mlio.AbstractIO
	%% CONCRETEIO  

	%  $Revision$
 	%  was created 02-Jan-2016 17:29:04
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlio/src/+mlio.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

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
        function this = ConcreteIO(obj)
            import mlfourd.*;
            this.noclobber = true;
            if (~exist('obj', 'var'))
                return
            end
            switch (class(obj))
                case 'char'
                    this.fqfilename = obj;
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
    
    methods (Static, Access = private)
        function tf = isJimmyShen(obj)
            tf = isfield(obj, 'hdr') && isfield(obj, 'filetype') && isfield(obj, 'fileprefix') && ...
                 isfield(obj, 'machine') && isfield(obj, 'ext') && isfield(obj, 'img') && isfield(obj, 'untouch');
        end
        function save_JimmyShen(obj)
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

