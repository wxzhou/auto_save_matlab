% BEGIN Get ready for the run of a new programme. 

function begin(varargin)
evalin('caller','clear variables;close all;clc;tic;');

global IfSaveVar IfSaveFig FuncList TStart_Begin;
TStart_Begin = tic;

if isempty(varargin)
     IfSaveVar = false;
     IfSaveFig = false;
elseif strcmpi(varargin{1},'on')
    IfSaveVar = true;
    IfSaveFig = true;
elseif strcmpi(varargin{1},'var')
    IfSaveVar = true;
    IfSaveFig = false;
elseif strcmpi(varargin{1},'fig')
    IfSaveVar = false;
    IfSaveFig = true;
else
    IfSaveVar = false;
    IfSaveFig = false;
end

if length(varargin) > 1
    FuncList = varargin(2:end);
else
    FuncList = {};
end

if IfSaveVar
    Stack=dbstack('-completenames');
    codename = 'CODE_CONTENT_IN_THIS_RUN';
    
    evalin('caller',sprintf('%s.main = fileread(''%s'');', codename, Stack(2).file));
    evalin('caller',sprintf('%s.main(%s.main==13) = [];', codename, codename));
    evalin('caller',sprintf('%s.version = version;', codename));
    evalin('caller',sprintf('%s.computer = ''%s'';', codename, getenv('computername')));
    
    for k = 1:length(FuncList)
        [~,funcname] = fileparts(FuncList{k});
        
        if exist(funcname, 'file') ~= 2
            warning('Function %s is not found and thus not saved. ', funcname);
            continue;
        end
        
        evalin('caller', sprintf('if ~isfield(%s,''%s''), %s.%s = fileread(''%s.m''); %s.%s(%s.%s==13) = []; end', ...
            codename, funcname, codename, funcname, funcname, codename, funcname, codename, funcname));
    end
end