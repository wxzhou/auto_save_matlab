# autosave
Automatically save running results of your disposable code.

Software engineers use Git, SVN or other professional tools to mange their code. But scientists use computer as their experiment tools and write codes for scientific computation or simulation. Tools such as Git may seem too professional for their disposable codes. That's why I wrote `autosave`.

Currently supported language: Matlab, Python.

## For Matlab

Use `begin.m` and `over.m`. Typically, `begin.m` and `over.m` are the first and last line of your code, respectively (apart from comments and subfunctions).

A simple example:

```matlab
begin on;
omega = 1;

x = linspace(-pi,pi,100);
y = sin(omega.*x);
z = cos(omega.*x);

figure;
plot(x,y);

figure;
plot(x,z);

over;
```

Save the code as `Trial.m` and run it, you will find three new files in the same directory of `Trial.m`: `Trial_run1.mat`, `Trial_run1_fig1.fig`, and `Trial_run1_fig2.fig`. Clear your workspace and load `Trial_run1.mat`, you will find not only `omega`, `x`, `y` and `z` in your code, but also a new variable `CODE_CONTENT_IN_THIS_RUN` containing the code, the running time and other information of your computer. `CODE_CONTENT_IN_THIS_RUN` is designed to have such a long and all uppercase name to avoid conflict with your own variable.

If you change the value of `omega` from 1 to 2 and run the code the second time, you will find another three files: `Trial_run2.mat`, `Trial_run2_fig1.fig`, and `Trial_run2_fig2.fig`. Also, the variable `CODE_CONTENT_IN_THIS_RUN` is in the file `Trial_run2.mat`.

The code content is saved in `CODE_CONTENT_IN_THIS_RUN` in the command `begin on`. Therefore, you are free to change your code during exeution if it takes a long time.

`over` is default to save all variables in the workspace. Delete the variables before using `over` if you don't want to save them.

## For Python

Use `autosave.py` for Python 2.x and `autosave3.py` for Python 3.x.

The python part is not as convenient as that of matlab. You have to save the figure by yourself. A simple example:

```python
import numpy as np
import matplotlib.pyplot as plt
from autosave import saveRunData

omega = 1
x = np.linspace(-10,10,100)
y = np.sin(omega*x)
run_id = saveRunData({'omega':omega, 'x':x, 'y':y})

plt.figure
plt.plot(x,y)
plt.savefig(run_id+'_fig1.png')
```

Save the code as `Trial.py` and run it, you will find two new files in the same directory of `Trial.py`: `Trial_run1.pkl` and `Trial_run1_fig1.png`. Load data in `Trial_run1.pkl` using the package `cloudpickle` or the function `load` in `autosave.py`, you will find not only the key `omega`, `x` and `y`, but also `CODE_CONTENT_IN_THIS_RUN` containing the code content of your code.

If you change the value of `omega` from 1 to 2 and run the code the second time, you will find another two files: `Trial_run2.pkl` and `Trial_run2_fig1.png`. Also, the variable `CODE_CONTENT_IN_THIS_RUN` is in the file `Trial_run2.pkl`.

The code content is saved in `CODE_CONTENT_IN_THIS_RUN` when `saveRunData` is imported. Therefore, you are free to change your code during exeution if it takes a long time.