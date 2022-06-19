# create connectivity matrix from timeseries data

import numpy as np
import pandas as pd

from pathlib import Path


def get_ccmtx(tsdir):
    tsfiles = sorted(tsdir.glob('*.txt'))
    print(f'found {len(tsfiles)} timeseries files')

    tsdata = None
    for f in tsfiles:
        filedata = np.loadtxt(f, dtype=np.float16)
        tsdata = filedata if tsdata is None else np.vstack((tsdata, filedata))

    print('computing correlation matrix')
    cc = np.corrcoef(tsdata.T)
    print(cc.shape)
    return(cc)


if __name__ == "__main__":
    tsdir = Path('/data/myconnectome/combined_data_scrubbed')

    cc = get_ccmtx(tsdir)
    
    # reorder based on parcel info
    parcel_info = pd.read_csv('parcel_data.txt', sep='\t', header=None, index_col=0)
    parcel_info.columns = ['hemis', 'X', 'Y', 'Z', 'lobe', 
                         'region', 'network', 'yeo7network', 'yeo17network']
    parcel_info_sorted = parcel_info.sort_values(by=['hemis', 'network'])
    tmp = cc[parcel_info_sorted.index - 1, :]
    cc_sorted = tmp[:, parcel_info_sorted.index - 1]
    np.savetxt('ccmtx_sorted.txt', cc_sorted)