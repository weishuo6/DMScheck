@echo off

if exist "c:\log_info" ( break && break ) else ( mkdir c:\log_info && net share myshare=c:\log_info /GRANT:everyone,READ) 
date/t >>c:\log_info\log_ok.txt
time/t >>c:\log_info\log_ok.txt
date/t >>c:\log_info\log_error.txt
time/t >>c:\log_info\log_error.txt
date/t >>c:\log_info\cpu_log.txt
time/t >>c:\log_info\cpu_log.txt
date/t >>c:\log_info\mem_log.txt
time/t >>c:\log_info\mem_log.txt

:cpu
for /f "tokens=2 delims==" %%a in ('wmic path Win32_PerfFormattedData_PerfOS_Processor get PercentProcessorTime /value^|findstr "PercentProcessorTime"') do (
set UseCPU=%%a
goto :mem
)
:mem
for /f "tokens=1,* delims==" %%i in ('systeminfo^|find "物理内存总量"') do ( 
for /f "tokens=1,* delims==" %%w in ('systeminfo^|find "可用的物理内存"') do ( 
set TalMem=%%i
set UseMem=%%w
goto :show
) 
)
:show
echo CPU使用率：%UseCPU%  >>c:\log_info\cpu_log.txt
echo %TalMem%  >>c:\log_info\mem_log.txt
echo %UseMem%  >>c:\log_info\mem_log.txt
)
for /f "skip=3 tokens=4" %%i in ('sc query tmlisten') do set "zt=%%i" &goto :next
:next
if /i "%zt%"=="RUNNING" (
    echo 已经发现OfficeScan NT Listener正在运行。>>c:\log_info\log_ok.txt
) else (
    echo OfficeScan NT Listener现在处于停止状态。>>c:\log_info\log_error.txt
)

for /f "skip=3 tokens=4" %%i in ('sc query  ntrtscan') do set "zt=%%i" &goto :next
:next
if /i "%zt%"=="RUNNING" (
    echo 已经发现OfficeScan NT RealTime Scan正在运行。 >>c:\log_info\log_ok.txt
) else (
    echo OfficeScan NT RealTime Scan服务现在处于停止状态。>>c:\log_info\log_error.txt
)

for /f "skip=3 tokens=4" %%i in ('sc query  BESClient') do set "zt=%%i" &goto :next
:next
if /i "%zt%"=="RUNNING" (
    echo 已经发现BESClient服务在运行。>>c:\log_info\log_ok.txt
) else (
    echo BESClient服务现在处于停止状态。>>c:\log_info\log_error.txt
)
for /f "skip=3 tokens=4" %%i in ('sc query  NewInterface') do set "zt=%%i" &goto :next
:next
if /i "%zt%"=="RUNNING" (
    echo 已经发现NewInterface服务在运行。>>c:\log_info\log_ok.txt
) else (
    echo NewInterface服务现在处于停止状态。>>c:\log_info\log_error.txt
)
for /f "skip=3 tokens=4" %%i in ('sc query  NewPeanuthullService') do set "zt=%%i" &goto :next
:next
if /i "%zt%"=="RUNNING" (
    echo 已经发现NewPeanuthullService正在运行。>>c:\log_info\log_ok.txt
) else (
    echo NewPeanuthullService服务现在处于停止状态。>>c:\log_info\log_error.txt
)
for /f "skip=3 tokens=4" %%i in ('sc query  MSSQLSERVER') do set "zt=%%i" &goto :next
:next
if /i "%zt%"=="RUNNING" (
    echo 已经发现SQL Server MSSQLSERVER 正在运行。>>c:\log_info\log_ok.txt
) else (
    echo SQL Server MSSQLSERVER 服务现在处于停止状态。>>c:\log_info\log_error.txt
)
for /f "skip=3 tokens=4" %%i in ('sc query  W3SVC') do set "zt=%%i" &goto :next
:next
if /i "%zt%"=="RUNNING" (
    echo 已经发现World Wide Web Publishing Service正在运行。>>c:\log_info\log_ok.txt
) else (
    echo World Wide Web Publishing Service服务现在处于停止状态。>>c:\log_info\log_error.txt
)


wmic logicaldisk where "drivetype=3" get name,freespace >>c:\log_info\free_log.txt
