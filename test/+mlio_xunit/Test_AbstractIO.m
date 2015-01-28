classdef Test_AbstractIO < MyTestCase
	%% TEST_ABSTRACTIO 
	%  Usage:  >> runtests tests_dir 
	%          >> runtests mlio.Test_AbstractIO % in . or the matlab path
	%          >> runtests mlio.Test_AbstractIO:test_nameoffunc
	%          >> runtests(mlio.Test_AbstractIO, Test_Class2, Test_Class3, ...)
	%  See also:  package xunit

	%  $Revision$
 	%  was created $Date$
 	%  by $Author$, 
 	%  last modified $LastChangedDate$
 	%  and checked into repository $URL$, 
 	%  developed on Matlab 8.1.0.604 (R2013a)
 	%  $Id$
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties (Dependent)
        abstractIO
        testfile
        testfile2
    end

    methods %% SET/GET
        function this = set.abstractIO(this, aio)
            assert(isa(aio, 'mlio.AbstractIO'));
            assert(~isempty(aio));
            this.abstractIO_ = aio;
        end
        function cl = get.abstractIO(this)
            if (isempty(this.abstractIO_))
                this.abstractIO_ = mlio.TextIO.load(this.testfile); end
            assert(isa(this.abstractIO_, 'mlio.AbstractIO'));
            cl = this.abstractIO_;
        end
        function tf = get.testfile(this)
            tf = fullfile(this.testPath, 'IOInterface', 'test_TextIO.txt');
        end
        function tf = get.testfile2(this)
            [pth, f, e] = fileparts(this.testfile);
            tf = fullfile(pth, [f '2' e]);
        end
    end
    
	methods 
        function test_filename(this)
            [~,fp,e] = fileparts(this.testfile);
            assertEqual([fp e], this.abstractIO.filename);
        end
        function test_filepath(this)
            assertEqual(fileparts(this.testfile), this.abstractIO.filepath);
        end
        function test_fileprefix(this)
            [~,fp] = fileparts(this.testfile);            
            assertEqual(fp, this.abstractIO.fileprefix);
        end
        function test_filesuffix(this)
            [~,~,e] = fileparts(this.testfile); 
            assertEqual(e, this.abstractIO.filesuffix);
        end
        function test_fqfilename(this)
            assertEqual(this.testfile, this.abstractIO.fqfilename);
        end
        function test_fqfileprefix(this)
            [pth,fp] = fileparts(this.testfile);
            assertEqual(fullfile(pth, fp), this.abstractIO.fqfileprefix);
        end
%         function test_noclobber(this)
%             this.abstractIO.noclobber = true;
%             import matlab.unitttest.TestCase.*;
%             this.verifyError(@() error('mlio_xunit:exceptionTesting', 'test_noclobber.g'), 'mlio_xunit:exceptionTesting');
%             this.verifyError(@() this.abstractIO.saveas(this.testfile), 'identifier');
%        end
%        function test_saveas(this)
%           warning('not implemented');
%        end
        
 		function this = Test_AbstractIO(varargin) 
 			this = this@MyTestCase(varargin{:}); 
        end % ctor 
    end 
    
    properties (Access = 'private')
        abstractIO_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

