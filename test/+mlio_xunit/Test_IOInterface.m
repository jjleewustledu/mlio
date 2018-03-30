classdef Test_IOInterface < MyTestCase
	%% TEST_IOINTERFACE 
	%  Usage:  >> runtests tests_dir 
	%          >> runtests mlio.Test_IOInterface % in . or the matlab path
	%          >> runtests mlio.Test_IOInterface:test_nameoffunc
	%          >> runtests(mlio.Test_IOInterface, Test_Class2, Test_Class3, ...)
	%  See also:  package xunit

	%  $Revision$
 	%  was created $Date$
 	%  by $Author$, 
 	%  last modified $LastChangedDate$
 	%  and checked into repository $URL$, 
 	%  developed on Matlab 8.1.0.604 (R2013a)
 	%  $Id$
 	%  N.B. classdef (Sealed, Hidden, InferiorClasses = {?class1,?class2}, ConstructOnLoad)

	properties
 		nii
 	end

	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

        function test_saveas(this)
 			cd(this.fslPath);
            this.nii.saveas('Text_IOInterface_test_saveas');
            assertTrue(lexist('Text_IOInterface_test_saveas.nii.gz', 'file'));
            delete('Text_IOInterface_test_saveas.nii.gz');
 		end 
        function test_load(this)
 			import mlfourd.*; 
            this.assertObjectsEqual(this.nii, NIfTI.load(this.t1_fqfn));
            ic = ImagingComponent.load({this.t1_fqfn this.t2_fqfn});
            this.assertObjectsEqual(this.nii, ic.get(1));
        end   
 		function this = Test_IOInterface(varargin) 
 			this = this@MyTestCase(varargin{:}); 
            this.nii = mlfourd.NIfTI.load(this.t1_fqfn);
        end % ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

