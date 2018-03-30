classdef Test_TextIO < mlfourd_unittest.Test_mlfourd
	%% TEST_TEXTIO 
    
	%  Usage:  >> results = run(mlio_unittest.Test_TextIO)
 	%          >> result  = run(mlio_unittest.Test_TextIO, 'test_dt')
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
        textIO
    end
    
    properties (Dependent)
        textfile
    end

    methods %% SET/GET
        function fn = get.textfile(~)
            fn = fullfile(getenv('HOME'), 'MATLAB-Drive', 'mlio', 'test', '+mlio_unittest', 'test_TextIO.txt');
        end
    end
    
	methods (Test)
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

        
 		function test_ctor(this) 
            this.verifyTrue(isa(this.textIO, 'mlio.TextIO'));
            this.verifyEqual(this.textfile, this.textIO.fqfilename);
 		end 
 		function test_contents(this)
            CHECK_STRING = '# william, wagner, bruckner, rainier Configuration';
            this.verifyEqual(25, strfind(this.textIO.contents, CHECK_STRING));
 		end 
 		function test_descrip(this) 
            CHECK_STRING = sprintf('mlio.TextIO read %s on %s', this.textfile, datestr(now, 'dd-mmm-yyyy'));
            this.verifyEqual(1, strfind(this.textIO.descrip, CHECK_STRING));
 		end 
 		function test_load(this) 
            this.verifyEqual(this.textfile, this.textIO.fqfilename);
 		end 
 		function test_textfileToCell(this) 
            this.verifyTrue(iscell(mlio.TextIO.textfileToCell(this.textfile)));
 		end 
 		function test_textfileToString(this) 
            this.verifyTrue(ischar(mlio.TextIO.textfileToString(this.textfile)));
 		end 
 		function test_textfileStrcmp(this) 
            this.verifyTrue(mlio.TextIO.textfileStrcmp(this.textIO.contents, this.textfile));
 		end 
        function test_save(this)
            [pth,fp,e] = fileparts(this.textfile);
            savedfile  = fullfile(pth, [fp '_save' e]);
            this.textIO.fqfilename = savedfile;
            this.textIO.save;
            this.verifyEqual(this.textIO.contents, mlio.TextIO.textfileToString(savedfile));
            delete(savedfile);
        end
    end
    
    methods        
 		function this = Test_TextIO(varargin) 
 			this = this@mlfourd_unittest.Test_mlfourd(varargin{:}); 
            this.textIO = mlio.TextIO.load(this.textfile);
 		end% ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

