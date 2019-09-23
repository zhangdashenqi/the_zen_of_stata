
			************************************************
			****				Stata之禅				****
			****			the Zen of Stata			****
			************************************************

* Python与Stata的数据交互——时间变量的处理

*-1. 使用Stata内部函数处理

clear

python:
from sfi import Data
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
	
end
br
gen date2 = date(date, "YMD")
format date2 %tdCCYY-NN-DD
order date*


*-2. 使用Python处理

clear

python:
from sfi import Data, Datetime
import matplotlib.pyplot as plt
import numpy as np
import tushare as ts

# 定义数据类型
intList = [np.int8, np.int16, np.int32, np.int64,
		   np.uint8, np.uint16, np.uint32, np.uint64]
floatList = [np.float16, np.float32, np.float64]

# 获取数据
df = ts.get_hist_data('hs300')
# df = df.reset_index()  # 将索引转化为列

# 处理时间变量
df.index = pd.to_datetime(df.index.tolist()) # 将object转换为Datetime
dateSIF = [Datetime.getSIF(i, '%tdCCYY-NN-DD') for i in df.index]

# 添加变量
Data.addObs(df.shape[0]) 

Data.addVarFloat('date')  # 添加Date变量

for i in range(0, df.shape[1]):
	if df.iloc[:, i].dtype in intList:
		Data.addVarInt(df.iloc[:, i].name)
	elif df.iloc[:, i].dtype in floatList:
		Data.addVarFloat(df.iloc[:, i].name)
	else:
		Data.addVarStrL(df.iloc[:, i].name)

# 存储数据
Data.store('date', None, dateSIF) # 存储时间变量
Data.setVarFormat('date', '%tdCCYY-NN-DD')  # 设置变量形式

for i in range(0, df.shape[1]):
	Data.store(df.iloc[:, i].name, None, df.iloc[:, i])

end
br


*-3. 使用Pandas内部迭代方法

clear

python:
from sfi import Data
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

for item, frame in df.iteritems():
	if frame.dtype in intList:
		Data.addVarInt(item)
	elif frame.dtype in floatList:
		Data.addVarFloat(item)
	else:
		Data.addVarStrL(item)
	Data.store(item, None, frame) # 存储数据
	
end
br

