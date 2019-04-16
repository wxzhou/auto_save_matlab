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

Save the code as `Trial.m` and run it, you will find three new files in the same directory of `Trial.m`: `Trial_run1.mat`, `Trial_run1_fig1.fig`, and `Trial_run1_fig2.fig`. Clear your workspace and load `Trial_run1.mat`, you will find not only `omega`, `x`, `y` and `z` in your code, but also a new variable `CODE_CONTENT_IN_THIS_RUN` containing the code, the running time and other information of your computer.

If you change the value of `omega` from 1 to 2 and run the code the second time, you will find another three files: `Trial_run2.mat`, `Trial_run2_fig1.fig`, and `Trial_run2_fig2.fig`. Also, the variable `CODE_CONTENT_IN_THIS_RUN` is in the file `Trial_run2.mat`.

The code content is save in `CODE_CONTENT_IN_THIS_RUN` in the command `begin on`. Therefore, you are free to change your code during exeution if it takes a long time.

## For Python

Use `autosave.py` for Python 2.x and `autosave3.py` for Python 3.x.