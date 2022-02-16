@echo off

@echo ************************************************************
@echo Stop Services
@echo ************************************************************

FOR /F %%B IN ('sc query MongoDB_Standalone ^| find "SERVICE_NAME"') DO net stop MongoDB_Standalone


