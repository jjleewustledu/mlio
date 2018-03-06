classdef Test_LogParser < matlab.unittest.TestCase
	%% TEST_LOGPARSER 

	%  Usage:  >> results = run(mlio_unittest.Test_LogParser)
 	%          >> result  = run(mlio_unittest.Test_LogParser, 'test_dt')
 	%  See also:  file:///Applications/Developer/MATLAB_R2014b.app/help/matlab/matlab-unit-test-framework.html

	%  $Revision$
 	%  was created 26-Feb-2016 17:15:15
 	%  by jjlee,
 	%  last modified $LastChangedDate$
 	%  and checked into repository /Users/jjlee/MATLAB-Drive/mlio/test/+mlio_unittest.
 	%% It was developed on Matlab 9.0.0.307022 (R2016a) Prerelease for MACI64.
 	

	properties
 		registry
 		testObj
 	end

	methods (Test)
		function test_rightSideNumeric(this)
 			[nv,idx1] = this.testObj.rightSideNumeric('eta,q', 1);
            this.verifyEqual(nv, 0.43829);
            this.verifyEqual(idx1, 30);
 		end
		function test_nextLineNNumeric(this)
            [nvs,idx1] = this.testObj.nextLineNNumeric('parameters', 6, 30);
            this.verifyEqual(nvs, [0.2506    0.0266    0.0712   -0.2442    0.2305   -0.2641]);
            this.verifyEqual(idx1, 33);
            [nvs,idx2] = this.testObj.nextLineNNumeric('100000*second partial in parameter space', 6, idx1);
            this.verifyEqual(nvs, [745.      721.      956.      448.      518.      333.]);
            this.verifyEqual(idx2, 90);
        end
        function test_rightSideChar(this)
            [nv,idx1] = this.testObj.rightSideChar('Reading image:', 1);
            this.verifyEqual(nv, 'NP995_09fdg_v1_frame4_b55.4dfp.img');
            this.verifyEqual(idx1, 6);    
            [nv,idx1] = this.testObj.rightSideChar('Reading image:', 7);
            this.verifyEqual(nv, 'NP995_09fdg_v1_frame5_b55.4dfp.img');
            this.verifyEqual(idx1, 19);
            [nv,idx1] = this.testObj.rightSideChar('Reading image:', 20);
            this.verifyEqual(nv, 'NP995_09fdg_v1_frame4_b55.4dfp.img');
            this.verifyEqual(idx1, 105);    
            [nv,idx1] = this.testObj.rightSideChar('Reading image:', 106);
            this.verifyEqual(nv, 'NP995_09fdg_v1_frame5_b55.4dfp.img');
            this.verifyEqual(idx1, 118);
            [nv,idx1] = this.testObj.rightSideChar('Reading image:', 119);
            this.verifyEqual(nv, 'NP995_09fdg_v1_frame4_b55.4dfp.img');
            this.verifyEqual(idx1, 169);
            [nv,idx1] = this.testObj.rightSideChar('Reading image:', 170);
            this.verifyEqual(nv, 'NP995_09fdg_v1_frame6_b55.4dfp.img');
            this.verifyEqual(idx1, 182);
            [nv,idx1] = this.testObj.rightSideChar('Reading image:', 183);
            this.verifyEqual(nv, 'NP995_09fdg_v1_frame4_b55.4dfp.img');
            this.verifyEqual(idx1, 268);
            [nv,idx1] = this.testObj.rightSideChar('Reading image:', 269);
            this.verifyEqual(nv, 'NP995_09fdg_v1_frame6_b55.4dfp.img');
            this.verifyEqual(idx1, 281);
            [nv,idx1] = this.testObj.rightSideChar('Reading image:', 282);
            this.verifyEqual(nv, 'NP995_09fdg_v1_frame4_b55.4dfp.img');
            this.verifyEqual(idx1, 332);
            [nv,idx1] = this.testObj.rightSideChar('Reading image:', 333);
            this.verifyEqual(nv, 'NP995_09fdg_v1_frame7_b55.4dfp.img');
            this.verifyEqual(idx1, 345);
        end
        function test_np497(this)            
 			import mlio.*;
 			lp = LogParser.load( ...
                fullfile(getenv('POWERS'), 'np497', 'jjlee', 'matlab_2016jun17_1033_fu.log'));
            idx0 = 1;
            fus  = [];
            while (1)
                try
                    [fu,idx1] = lp.rightSideNumeric('BEST-FIT    param  fu value', idx0);
                    idx0 = idx1 + 1;
                    fus  = [fus; fu];
                catch ME
                    handwarning(ME);
                    break
                end
            end
            fprintf('%s\n', mat2str(fus));
        end
	end

 	methods (TestClassSetup)
		function setupLogParser(this)
 			import mlio.*;
 			this.testObj_ = LogParser.load( ...
                fullfile(getenv('HOME'), 'MATLAB-Drive/mlio/test/+mlio_unittest', 'imgreg_4dfp.log'));
 		end
	end

 	methods (TestMethodSetup)
		function setupLogParserTest(this)
 			this.testObj = this.testObj_;
 			this.addTeardown(@this.cleanFiles);
 		end
	end

	properties (Access = private)
 		testObj_
 	end

	methods (Access = private)
		function cleanFiles(this)
 		end
	end

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

