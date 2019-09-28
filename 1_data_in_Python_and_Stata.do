
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

* Python与Stata的数据交互

python: print("Hello World")

python:
for i in range(1, 10):
	for j in range(1, i+1):
		print("%d*%d=%-4.0d" % (j, i, i*j), end="")
	print("")
	
end


*-1.获取Tushare存款利率数据
clear
python:
from sfi import Data
import tushare as ts

# 创建数据集和变量
df = ts.get_deposit_rate()
Data.addObs(df.shape[0])
Data.addVarStrL('date')
Data.addVarStrL('deposit_type')
Data.addVarStrL('rate')

# 存储数据
Data.store('date', None, df.iloc[:,0])
Data.store('deposit_type', None, df['deposit_type'])
Data.store('rate', None, df['rate'])

end
br


*-2.获取电影票房数据

clear
python:
from sfi import Data
import tushare as ts

# 创建数据集和变量
df = ts.day_boxoffice()
Data.addObs(df.shape[0])
for i in range(0, df.shape[1]):
	Data.addVarStrL(df.iloc[:, i].name)

# 存储数据
for i in range(0, df.shape[1]):
	Data.store(df.iloc[:, i].name, None, df.iloc[:, i])
	
end
br


*-3.获取Tushare股票数据

clear

python:
from sfi import Data
import matplotlib.pyplot as plt
import numpy as np
import tushare as ts

# 定义数据类型
intList = [np.int8, np.int16, np.int32, np.int64,
		   np.uint8, np.uint16, np.uint32, np.uint64]
floatList = [np.float16, np.float32, np.float64]

# 获取数据
df = ts.get_hist_data('hs300')
df = df.reset_index()  # 将索引转化为列

# 添加变量
Data.addObs(df.shape[0]) 

for i in range(0, df.shape[1]):
	if df.iloc[:, i].dtype in intList:
		Data.addVarInt(df.iloc[:, i].name)
	elif df.iloc[:, i].dtype in floatList:
		Data.addVarFloat(df.iloc[:, i].name)
	else:
		Data.addVarStrL(df.iloc[:, i].name)

# 存储数据
for i in range(0, df.shape[1]):
	Data.store(df.iloc[:, i].name, None, df.iloc[:, i])

#绘制图形
df[['close', 'ma5', 'ma10', 'ma20']].plot(
	kind='line',
	figsize=(16, 9), 
	grid=True, 
	title='HS300',
	fontsize=12)
plt.show()

end
br


