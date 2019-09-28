*! Version 0.2 Sep 27, 2019
*! Clickable list of the post from theZenofStata
*! By zhangdashenqi @ theZenofStata
*! Email: zhangqingjun3@qq.com
*! GitHub: https://github.com/zhangdashenqi
*! WeChat Subscription Account: Stata之禅

* 0.1 Initial version
* 0.2 Release version 

cap program drop zstata
program define zstata, rclass
	version 15.0
	dis in w _n "{c TLC}{hline 60}{c TRC}" _n ///
		 "{c |}{space 22}{bf:the Zen of Stata}{space 22}{c |}" _n ///
		 "{c BLC}{hline 60}{c BRC}"
		 
	_zstata Stata-Graph/master/do/
	
	_zstata the_zen_of_stata/master/
	
	dis in w "{c TLC}{hline 60}{c TRC}"
	local cmd !start https://github.com/zhangdashenqi
	dis in w `"{c |} >> [{stata `"`cmd'"':Open GitHub}]"' ///
		`"{space 3}打开GitHub{space 30}{c |}"'
	dis in w "{c BLC}{hline 60}{c BRC}"
end


cap program drop _zstata
program define _zstata, rclass
	local url "https://raw.githubusercontent.com/zhangdashenqi/"
	local repo `url'`1'readme.md
	copy "`repo'" "list.txt", replace

	preserve
	quietly{
		clear
		set obs 1
		gen v = fileread("list.txt")
		split v, p("### ")
		drop v
		sxpose, clear
		gen item = ustrregexs(1) if ustrregexm(_var1 , `"\d{3}(.+?)\n"')
		gen link = ustrregexs(1) if ustrregexm(_var1 , `"]\(\./(.+?)\)"')
		drop if item==""|link==""
	}
	local url "https://raw.githubusercontent.com/zhangdashenqi/"
	local dolink `url'`1'
	local num = _N

 
	forvalues i = 1(1)`num'{
		local item = item[`i']
		local link = link[`i']
		dis `" [{stata `"copy "`dolink'`link'.do" "`link'.do""':download}]"' ///
			`" [{stata `"doedit "`link'.do""':edit}]"' ///
			`"{res} `item'"'
	}
	
	restore
	erase list.txt
end



