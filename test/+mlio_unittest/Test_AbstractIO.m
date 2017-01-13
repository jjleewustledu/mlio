classdef Test_AbstractIO < mlfourd_unittest.Test_mlfourd
	%% TEST_ABSTRACTIO 

	%  Usage:  >> results = run(mlio_unittest.Test_AbstractIO)
 	%          >> result  = run(mlio_unittest.Test_AbstractIO, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

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
            this.verifyTrue(isa(aio, 'mlio.AbstractIO'));
            this.verifyTrue(~isempty(aio));
            this.abstractIO_ = aio;
        end
        function cl = get.abstractIO(this)
            if (isempty(this.abstractIO_))
                this.abstractIO_ = mlio.TextIO.load(this.testfile); end
            this.verifyTrue(isa(this.abstractIO_, 'mlio.AbstractIO'));
            cl = this.abstractIO_;
        end
        function tf = get.testfile(~)
            tf = fullfile(getenv('LOCAL'), 'src', 'mlcvl', 'mlio', 'test', '+mlio_unittest', 'test_TextIO.txt');
        end
        function tf = get.testfile2(this)
            [pth, f, e] = fileparts(this.testfile);
            tf = fullfile(pth, [f '2' e]);
        end
    end
    
	methods (Test)
        function test_filename(this)
            [~,fp,e] = fileparts(this.testfile);
            this.verifyEqual([fp e], this.abstractIO.filename);
        end
        function test_filepath(this)
            this.verifyEqual(fileparts(this.testfile), this.abstractIO.filepath);
        end
        function test_fileprefix(this)
            [~,fp] = fileparts(this.testfile);            
            this.verifyEqual(fp, this.abstractIO.fileprefix);
        end
        function test_filesuffix(this)
            [~,~,e] = fileparts(this.testfile); 
            this.verifyEqual(e, this.abstractIO.filesuffix);
        end
        function test_fqfilename(this)
            this.verifyEqual(this.testfile, this.abstractIO.fqfilename);
        end
        function test_fqfileprefix(this)
            [pth,fp] = fileparts(this.testfile);
            this.verifyEqual(fullfile(pth, fp), this.abstractIO.fqfileprefix);
        end
        function test_noclobber(this)
            this.abstractIO.noclobber = true;
            this.verifyError(@() error('mlio_unittest:exceptionTesting', 'test_noclobber.g'), 'mlio_unittest:exceptionTesting');
            this.verifyError(@() this.abstractIO.saveas(this.testfile), 'mlio:IOErr');
       end
    end 
    
    properties (Access = 'private')
        abstractIO_
    end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

