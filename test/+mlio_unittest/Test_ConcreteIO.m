classdef Test_ConcreteIO < matlab.unittest.TestCase
	%% TEST_CONCRETEIO 

	%  Usage:  >> results = run(mlio_unittest.Test_ConcreteIO)
 	%          >> result  = run(mlio_unittest.Test_ConcreteIO, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 23-Jan-2016 18:37:16
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/Local/src/mlcvl/mlio/test/+mlio_unittest.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

	properties
 		registry
 		testObj
    end
    
    properties (Dependent)
        smallT1_fqfn
        test_fqfn
    end
    
    methods %% GET
        
        function g = get.smallT1_fqfn(this)
            g = this.registry.smallT1_fqfn;
        end
        function g = get.test_fqfn(this)
            g = fullfile(this.registry.fslPath, 'Test_ConcreteIO.test_fqfn.nii.gz');
        end
    end

	methods (Test)
        function test_ctorChar(this)
            this.verifyFalse(lexist(this.test_fqfn, 'file'));
            cio = mlio.ConcreteIO(this.test_fqfn);
            this.verifyFalse(lexist(this.test_fqfn, 'file'));
            cio.save;            
            this.verifyTrue(lexist(this.test_fqfn, 'file'));
        end
        function test_ctorStruct(this)
            js = mlniftitools.load_untouch_nii(this.smallT1_fqfn);
            [p,f] = myfileparts(this.test_fqfn);
            js.fileprefix = fullfile(p,f);
            this.verifyFalse(lexist(this.test_fqfn, 'file'));
            mlio.ConcreteIO(js);
            this.verifyTrue(lexist(this.test_fqfn, 'file'));
        end
        function test_ctorNumeric(this)
            mlio.ConcreteIO(magic(2));            
            this.verifyTrue(lexist('instance_mlfourd_InnerNIfTId.nii.gz', 'file'));
        end
		function test_ctorNIfTId(this)           
            niid = mlfourd.NIfTId.load(this.smallT1_fqfn);
            niid.fqfn = this.test_fqfn;
            this.verifyFalse(lexist(this.test_fqfn, 'file'));
            mlio.ConcreteIO(niid);
            this.verifyTrue(lexist(this.test_fqfn, 'file'));
 		end
		function test_ctorNIfTIc(this)
            f1 = fullfile(this.registry.fslPath, 'oc_default.nii.gz');
            f2 = fullfile(this.registry.fslPath, 'tr_default.nii.gz');
            niic = mlfourd.NIfTIc({f1 f2});
            niic = niic.prepend_fileprefix('Test_ConcreteIO_');
            this.verifyFalse(lexist(niic.get(1).fqfn, 'file'))
            this.verifyFalse(lexist(niic.get(2).fqfn, 'file'))
            mlio.ConcreteIO(niic);            
            this.verifyTrue(lexist(niic.get(1).fqfn, 'file'))
            this.verifyTrue(lexist(niic.get(2).fqfn, 'file'))
        end        
		function test_ctorCell(this) 
        end
        function test_ctorComposite(this)
        end
	end

 	methods (TestClassSetup)
 		function setupImagingContext(this)
            import mlfourd.*;
            this.registry = mlfourd.UnittestRegistry.instance;
            this.registry.sessionFolder = 'mm01-020_p7377_2009feb5'; 
            this.testObj_ = mlio.ConcreteIO(this.smallT1_fqfn);
 		end
 	end

 	methods (TestMethodSetup)
        function setupTest(this)
            this.deleteFiles;
            this.testObj = this.testObj_;
            this.addTeardown(@this.deleteFiles);
        end
    end
    
    %% PRIVATE
    
    properties (Access = private)
        testObj_
    end
    
    methods (Access = private)
        function deleteFiles(this)
            deleteExisting('instance_mlfourd_InnerNIfTId*');
            deleteExisting(fullfile(this.registry.fslPath, 'Test_ConcreteIO*'));
        end
    end
    
	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

