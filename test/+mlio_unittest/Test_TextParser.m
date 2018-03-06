classdef Test_TextParser < matlab.unittest.TestCase
	%% TEST_TEXTPARSER  

	%  Usage:  >> results = run(mlio_unittest.Test_TextParser)
 	%          >> result  = run(mlio_unittest.Test_TextParser, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$ 
 	%  was created $Date$ 
 	%  by $Author$,  
 	%  last modified $LastChangedDate$ 
 	%  and checked into repository $URL$,  
 	%  developed on Matlab 8.4.0.150421 (R2014b) 
 	%  $Id$ 
 	 

	properties 
        textParser
        textFqfilename = fullfile(getenv('HOME'), 'MATLAB-Drive/mlio/test/+mlio_unittest/p8047gluc1.img.rec')
 	end 

	methods (Test)
        function test_equalities(this)
            this.assumeEqual(1,1);
            this.verifyEqual(1,1);
            this.assertEqual(1,1);
        end
        function test_cellContents(this)
            cc = this.textParser.cellContents;
            this.verifyEqual(cc{2}, 'ecattoanalyze p8047gluc1.v');
        end
        function test_descrip(this)
            this.verifyTrue(lstrfind(this.textParser.descrip, 'mlio.TextParser'));
            this.verifyTrue(lstrfind(this.textParser.descrip, this.textFqfilename));
        end
        function test_load(this)
            tp = mlio.TextParser.load(this.textFqfilename);
            this.verifyClass(tp, 'mlio.TextParser');
            this.verifyNotEmpty(tp.cellContents);
        end
        function test_char(this)
            c = char(this.textParser);
            this.verifyEqual(c(1:14), 'rec p8047gluc1');
        end
        function test_parseAssignedString(this)
            v = this.textParser.parseAssignedString('Start time');
            this.verifyEqual(v, '18.933 sec');
        end
        function test_parseAssignedNumeric(this)
            nv = this.textParser.parseAssignedNumeric('Start time');
            this.verifyEqual(nv, 18.933);
        end
    end
       
    methods
  		function this = Test_TextParser(varargin) 
 			this = this@matlab.unittest.TestCase(varargin{:}); 
            this.textParser = mlio.TextParser.load(this.textFqfilename);
 		end 
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy 
end

