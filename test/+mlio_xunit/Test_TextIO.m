classdef Test_TextIO < MyTestCase
	%% TEST_TEXTIO 
	%  Usage:  >> runtests tests_dir 
	%          >> runtests mlio.Test_TextIO % in . or the matlab path
	%          >> runtests mlio.Test_TextIO:test_nameoffunc
	%          >> runtests(mlio.Test_TextIO, Test_Class2, Test_Class3, ...)
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
        textIO
    end
    
    properties (Dependent)
        textfile
    end

    methods %% SET/GET
        function fn = get.textfile(this)
            fn = fullfile(this.testPath, 'IOInterface', 'test_TextIO.txt');
        end
    end
    
	methods 
 		% N.B. (Static, Abstract, Access='', Hidden, Sealed) 

        
 		function test_ctor(this) 
            assertTrue(isa(this.textIO, 'mlio.TextIO'));
            assertEqual(this.textfile, this.textIO.fqfilename);
 		end 
 		function test_contents(this)
            CHECK_STRING = '# william, wagner, bruckner, rainier Configuration';
            assertEqual(3, strfind(this.textIO.contents, CHECK_STRING));
 		end 
 		function test_descrip(this) 
            CHECK_STRING = sprintf('mlio.TextIO read %s on %s', this.textfile, datestr(now, 'dd-mmm-yyyy'));
            assertEqual(1, strfind(this.textIO.descrip, CHECK_STRING));
 		end 
 		function test_load(this) 
            assertEqual(this.textfile, this.textIO.fqfilename);
 		end 
 		function test_textfileToCell(this) 
            assertTrue(iscell(mlio.TextIO.textfileToCell(this.textfile)));
 		end 
 		function test_textfileToString(this) 
            assertTrue(ischar(mlio.TextIO.textfileToString(this.textfile)));
 		end 
 		function test_textfileStrcmp(this) 
            assertTrue(mlio.TextIO.textfileStrcmp(this.textIO.contents, this.textfile));
 		end 
        function test_save(this)
            [pth,fp,e] = fileparts(this.textfile);
            savedfile  = fullfile(pth, [fp '_save' e]);
            this.textIO.fqfilename = savedfile;
            this.textIO.save;
            assertEqual(this.textIO.contents, mlio.TextIO.textfileToString(savedfile));
            delete(savedfile);
        end
        
 		function this = Test_TextIO(varargin) 
 			this = this@MyTestCase(varargin{:}); 
            this.textIO = mlio.TextIO.load(this.textfile);
 		end% ctor 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

