@echo off

@echo ************************************************************
@echo Start Services
@echo ************************************************************

FOR /F %%B IN ('sc query MongoDB_Standalone ^| find "SERVICE_NAME"') DO net start MongoDB_Standalone



