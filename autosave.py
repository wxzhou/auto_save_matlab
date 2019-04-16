"""Auto save current running script and variables.
"""

import os
import glob
import cloudpickle
import inspect

callername = inspect.stack()[1][1]

def recordContent(filename=callername):
    """Record the content of current running script.
    """

    with open(filename) as f:
        content = ''.join(f.readlines())
        return content

CODE_CONTENT_IN_THIS_RUN = recordContent()

def saveRunData(data={}, save=True):
    """Save the variables in current running script.
    """

    if type(data) is not dict:
        raise TypeError('The saving data must be a dict.')

    prename = os.path.splitext(callername)[0]
    runlist = glob.glob(prename + '_run*.pkl')
    runID = len(runlist) + 1
    filename = '%s_run%d.pkl' % (prename, runID)

    if save:
        data['CODE_CONTENT_IN_THIS_RUN'] = CODE_CONTENT_IN_THIS_RUN

        with open(filename, 'wb') as fid:
            cloudpickle.dump(data, fid, 2)

    return '%s_run%d' % (prename, runID)

def load(pklfile, *varnames):
    with open(pklfile, 'rb') as pkl:
        src = cloudpickle.load(pkl)

    if varnames:
        var = []
        keys = src.keys()
        for i in varnames:
            if i in keys:
                var.append(src[i])
            else:
                print 'Warning: Variable not found in %s: %s' % (pklfile, i)

        if len(var) == 1:
            return var[0]
        else:
            return tuple(var)
    else:
        return src
