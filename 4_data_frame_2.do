
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

*-Stata16之frame介绍2

*-设置参数
global github "https://raw.githubusercontent.com/zhangdashenqi"
webuse set "${github}/the_zen_of_stata/master/data"

*-载入股票数据
webuse stock.dta, clear

*-创建2个新的数据框
frame create 账面价值
frame 账面价值: webuse bookValue.dta, clear

frame create 市场收益
frame 市场收益: webuse market.dta

frame dir

*-连接数据框
frame change default // 确保当前数据框为default
frlink 1:1 stkcd year, frame(账面价值)
frlink m:1 year, frame(市场收益)

*-从已连接的数据框中获取变量
gen BookValue = ln(frval(账面价值, bookValue)) // 以frval()函数的形式

frget mktRtn1 = mktRtn, from(市场收益)  // 以frget命令
frget mktRtn, from(市场收益) suffix(_2)

