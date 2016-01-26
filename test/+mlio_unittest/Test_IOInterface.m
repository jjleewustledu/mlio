classdef Test_IOInterface < mlfourd_unittest.Test_mlfourd
	%% TEST_IOINTERFACE 

	%  Usage:  >> results = run(mlio_unittest.Test_IOInterface)
 	%          >> result  = run(mlio_unittest.Test_IOInterface, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created $Date$
 	%  by $Author$, 
 	%  last modified $LastChangedDate$
 	%  and checked into repository $URL$, 
 	%  developed on Matlab 8.1.0.604 (R2013a)
 	%  $Id$
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
 		niid
 	end

	methods (Test)
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

         function test_saveas(this)
             deleteExisting(fullfile(this.fslPath, 'Text_IOInterface_test_saveas.nii.gz'));
             this.niid.saveas('Text_IOInterface_test_saveas');
             this.verifyTrue(lexist('Text_IOInterface_test_saveas.nii.gz', 'file'));
             deleteExisting('Text_IOInterface_test_saveas.niid.gz');
 		end 
         function test_load(this)
             import mlfourd.*;
             this.verifyEqual(this.niid, NIfTId.load(this.tr_fqfn));
        end   
    end
    
    methods (TestClassSetup)
        function setupIOInterface(this)
  			cd(this.fslPath);
            this.niid = mlfourd.NIfTId.load(this.tr_fqfn);
        end
    end
    

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

