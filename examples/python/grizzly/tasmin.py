#!/Users/lkroll/miniconda3/envs/weld/bin/python

import numpy as np
import grizzly.numpy_weld as npw
import grizzly.grizzly as gr
import pandas as pd
#import netCDF4 as nc
import xarray as xr
import matplotlib.pyplot as plt



dss = ["data/tasmin_Amon_MIROC5_historical_r1i1p1_185001-201212.nc",
	"data/tasmax_Amon_MIROC5_historical_r1i1p1_185001-201212.nc",
	#"data/tasmin_Amon_inmcm4_historical_r1i1p1_185001-200512.nc",
	#"data/tasmin_Amon_IPSL-CM5A-LR_historical_r1i1p1_185001-200512.nc"
]
def prepare(path):
	ds = xr.open_dataset(path)
	print "opened {0}".format(path)
	return ds.tasmin.to_dataframe().drop(columns=['height'])

preps = map(prepare, dss)

def monther(t):
	return t[0].month

def meaner(x):
	r = x.groupby(['lat', 'lon']).mean()
	return r

#aggsSeason = map(lambda df: df.groupby("time.season").apply(lambda x: x.mean(dim="time")), preps)
aggsMonth = map(lambda df: df.groupby(monther).apply(meaner), preps)
print aggsMonth
#averageSeason = reduce(lambda x,y: x+y, aggsSeason) / len(aggsSeason)
averageMonth = reduce(lambda x,y: x+y, aggsMonth) / len(aggsMonth)
#diffSeason = map(lambda x: x - averageSeason, aggsSeason)
diffMonth = map(lambda x: x - averageMonth, aggsMonth)
amonxr = averageMonth.to_xarray().rename({"level_0" : "month"})
print amonxr
amonxr.tasmin.plot.pcolormesh('lon', 'lat', col='month', col_wrap=3, robust=True, cmap='viridis')
for d  in diffMonth:
	d.to_xarray().rename({"level_0" : "month"}).tasmin.plot.pcolormesh('lon', 'lat', col='month', col_wrap=3, robust=True, cmap='viridis')

plt.show()

#for season,data in average.groupby("season"):
#	print season
#	data.plot.pcolormesh('lon', 'lat', col='season', col_wrap=3, robust=True, cmap='viridis')


#raw_data1 = dataIPSL["tasmin"][0:1,0, 0]
#print raw_data1
#dataIPSL = gr.DataFrameWeld(dfIPSL)
#res1 = dataIPSL[dataIPSL["tasmin"] > 280]
#res2 = res1.groupby("lat").sum()
#print res1["tasmin"].evaluate()

#print dataIPSL["tasmin"][:]


