% OVER Save all data and figures.
%
% OVER ON  saves all data in .mat file and all figures in .fig files,
% sharing the same run index.
%
% OVER OFF saves neither data nor the figures.
%
% OVER VAR saves all data but not figures with a new run index.
%
% OVER FIG saves all figures but not data with a new run index.
%
% OVER MODE fun1 fun2 ... also saves the codes in function fun1, fun2, ...,
% while MODE is ON or VAR.
%
% OVER MODE overwrites the MODE of `begin`, and OVER alone without MODE
% follows the MODE of `begin`.
%
% The name of the saved .mat file is:
%      [Caller Name]_run[Run Index].mat,
%
% and the names of the saved .fig files are:
%      [Caller Name]_run[Run Index]_fig[Fig Index].fig
%
% OVER checks existing saved .mat files and updates the run index in every
% run.
%
% Example:
%
% Using OVER ON in the end of file Trial.m will produce Trial_run1.mat,
% Trial_run1_fig1.fig, and Trial_run1_fig2.fig. And if Trial.m is run
% the second time, it will produce Trial_run2.mat, Trial_run2_fig1.fig
% and Trial_run2_fig2.fig.
%
% See also begin.

function over(varargin)

global IfSaveVar IfSaveFig FuncList TStart_Begin;
elapsed_time = toc(TStart_Begin);
fprintf('Elapsed time is %.6f seconds.\n', elapsed_time);

if isempty(varargin)
     % pass
elseif strcmpi(varargin{1},'on')
    IfSaveVar=true;
    IfSaveFig=true;
elseif strcmpi(varargin{1},'var')
    IfSaveVar=true;
    IfSaveFig=false;
elseif strcmpi(varargin{1},'fig')
    IfSaveVar=false;
    IfSaveFig=true;
else
    IfSaveVar=false;
    IfSaveFig=false;
end

if length(varargin)>1
    FuncList = varargin(2:end);
else
    FuncList = {};
end

if IfSaveVar  % Save all the variables
    Stack=dbstack('-completenames');
    codename = 'CODE_CONTENT_IN_THIS_RUN';
    evalin('caller', sprintf('if ~exist(''%s'', ''var''), %s = struct(); end', ...
        codename, codename));
    evalin('caller', sprintf('if ~isfield(%s,''main''), %s.main = fileread(''%s''); %s.main(%s.main==13) = []; end', ...
        codename, codename, Stack(2).file, codename, codename));
    evalin('caller', sprintf('%s.elapsed_time = %.6f;', codename, elapsed_time));
    
    for k = 1:length(FuncList)
        [~,funcname] = fileparts(FuncList{k});
        
        if exist(funcname, 'file') ~= 2
            warning('Function %s is not found and thus not saved. ', funcname);
            continue;
        end
        
        evalin('caller', sprintf('if ~isfield(%s,''%s''), %s.%s = fileread(''%s.m''); %s.%s(%s.%s==13) = []; end', ...
            codename, funcname, codename, funcname, funcname, codename, funcname, codename, funcname));
        
    end
    
    [MaxRun,Folder]=getMaxRun(Stack);
    RunName=[Stack(2).name,'_run',num2str(MaxRun+1),'.mat'];
    Command=['save(''', fullfile(Folder,RunName),''')'];
    evalin('caller','clear ans;');
    evalin('caller',Command);
end

if IfSaveFig % Save all the figures
    if IfSaveVar % So figures to be saved are attached to the existing run*.mat
        Run_ind=MaxRun+1;
    else         % So we open a new run
        Stack=dbstack('-completenames');
        [MaxRun,Folder]=getMaxRun(Stack);
        Run_ind=MaxRun+1;
    end
    
    hFigs=get(groot,'Children');
    hFigs=hFigs(end:-1:1);
    for k=1:length(hFigs)
        FileName=[Stack(2).name,'_run',num2str(Run_ind),'_fig',num2str(k),'.fig'];
        saveas( hFigs(k),fullfile(Folder,FileName),'fig' );
    end
end

function [MaxRun,Folder]=getMaxRun(Stack)
FileName=Stack(2).file;
Folder=fileparts(FileName);
AllFile=dir( fullfile(Folder,'*.mat'));
MaxRun=0;

for k=1:length(AllFile)
    run_ind=sscanf( AllFile(k).name,[Stack(2).name,'_run%d'],1);
    if ~isempty(run_ind) && run_ind>MaxRun
        MaxRun=run_ind;
    end
end