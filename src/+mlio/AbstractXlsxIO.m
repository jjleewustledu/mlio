classdef AbstractXlsxIO < mlio.AbstractIO
	%% ABSTRACTXLSXIO  

	%  $Revision$
 	%  was created 29-Mar-2018 15:26:26 by jjlee,
 	%  last modified $LastChangedDate$ and placed into repository /Users/jjlee/MATLAB-Drive/mlio/src/+mlio.
 	%% It was developed on Matlab 9.1.0.441655 (R2016b) for MACI64.  Copyright 2018 John Joowon Lee.
 	
	properties
 		
 	end

	methods (Access = protected)        
        function s    = excelNum2sec(~, excelnum)
            pm            = sign(excelnum);
            dt_           = datetime(abs(excelnum), 'ConvertFrom', 'excel');
            dt_.TimeZone  = mlpipeline.ResourcesRegistry.instance().preferredTimeZone;
            dt__          = datetime(dt_.Year, dt_.Month, dt_.Day);
            dt__.TimeZone = mlpipeline.ResourcesRegistry.instance().preferredTimeZone;
            s             = pm*seconds(dt_ - dt__);
        end
        function tbl  = correctDates2(this, tbl, varargin)
            vars = tbl.Properties.VariableNames;
            for v = 1:length(vars)
                col = tbl.(vars{v});
                if (this.hasTimings(vars{v}))
                    if (any(isnumeric(col)))                        
                        lrows = logical(~isnan(col) & ~isempty(col));
                        dt_   = mldata.Xlsx.datetimeConvertFromExcel2(tbl{lrows,v});
                        col   = NaT(size(col));
                        col.TimeZone = dt_.TimeZone;
                        col(lrows) = dt_;
                    end
                    if (any(isdatetime(col)))
                        col.TimeZone = mlpipeline.ResourcesRegistry.instance().preferredTimeZone;
                    end
                end
                tbl.(vars{v}) = col;
            end
        end
        function tf   = hasTimings(~, var)
            tf = lstrfind(lower(var), 'time') | lstrfind(lower(var), 'hh_mm_ss') | lstrfind(lower(var), 'hhmmss');
        end
 	end 

	%  Created with Newcl by John J. Lee after newfcn by Frank Gonzalez-Morphy
 end

