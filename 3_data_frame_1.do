			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

*-Stata16之frame介绍

*-设置参数
global github "https://raw.githubusercontent.com/zhangdashenqi"
webuse set "${github}/the_zen_of_stata/master/data"

*-载入股票数据
webuse stock.dta, clear

*-创建一个新的数据框
frame create 账面价值
frame 账面价值: webuse bookValue.dta, clear

*-数据框的查询
frame dir	// 查询内存中的所有数据框

frame pwf   // 查询当前工作的数据框
pwf			// 同上

*-数据框的重命名
frame rename default 股票数据
frame dir

*-切换数据框
frame change 账面价值
cwf 账面价值  // 效果同上

*-对于指定的数据框执行命令
frame 股票数据: sum stkcd year mktValue stkRtn

frame 股票数据{
	#delimit ;
	twoway (scatter stkRtn mktValue)
		   (lfit stkRtn mktValue),
		ytitle("收益率%")
		xtitle("市值")
		legend(ring(0) pos(1))
		scheme(s1mono)
	;
	#delimit cr
}

