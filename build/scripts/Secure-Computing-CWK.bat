@rem
@rem Copyright 2015 the original author or authors.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem      https://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@if "%DEBUG%"=="" @echo off
@rem ##########################################################################
@rem
@rem  Secure-Computing-CWK startup script for Windows
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%"=="" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%..

@rem Resolve any "." and ".." in APP_HOME to make it shorter.
for %%i in ("%APP_HOME%") do set APP_HOME=%%~fi

@rem Add default JVM options here. You can also use JAVA_OPTS and SECURE_COMPUTING_CWK_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS=

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if %ERRORLEVEL% equ 0 goto execute

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto execute

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:execute
@rem Setup the command line

set CLASSPATH=%APP_HOME%\lib\Secure-Computing-CWK.jar;%APP_HOME%\lib\freemarker-2.3.29.jar;%APP_HOME%\lib\sqlite-jdbc-3.34.0.jar;%APP_HOME%\lib\jbcrypt-0.4.jar;%APP_HOME%\lib\javax-websocket-server-impl-9.4.24.v20191120.jar;%APP_HOME%\lib\javax-websocket-client-impl-9.4.24.v20191120.jar;%APP_HOME%\lib\websocket-server-9.4.24.v20191120.jar;%APP_HOME%\lib\websocket-client-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-client-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-deploy-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-quickstart-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-jmx-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-annotations-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-plus-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-jndi-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-servlets-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-rewrite-9.4.24.v20191120.jar;%APP_HOME%\lib\http2-server-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-jaspi-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-webapp-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-servlet-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-security-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-server-9.4.24.v20191120.jar;%APP_HOME%\lib\http2-client-9.4.24.v20191120.jar;%APP_HOME%\lib\http2-common-9.4.24.v20191120.jar;%APP_HOME%\lib\http2-hpack-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-http-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-alpn-client-9.4.24.v20191120.jar;%APP_HOME%\lib\websocket-common-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-io-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-xml-9.4.24.v20191120.jar;%APP_HOME%\lib\jetty-util-9.4.24.v20191120.jar;%APP_HOME%\lib\websocket-servlet-9.4.24.v20191120.jar;%APP_HOME%\lib\javax.websocket-api-1.0.jar;%APP_HOME%\lib\javax.servlet-api-3.1.0.jar;%APP_HOME%\lib\javax.mail.glassfish-1.4.1.v201005082020.jar;%APP_HOME%\lib\slf4j-api-1.7.25.jar;%APP_HOME%\lib\javax.annotation-api-1.3.jar;%APP_HOME%\lib\asm-commons-7.2.jar;%APP_HOME%\lib\asm-analysis-7.2.jar;%APP_HOME%\lib\asm-tree-7.2.jar;%APP_HOME%\lib\asm-7.2.jar;%APP_HOME%\lib\javax.security.auth.message-1.0.0.v201108011116.jar;%APP_HOME%\lib\jetty-continuation-9.4.24.v20191120.jar;%APP_HOME%\lib\javax.transaction-api-1.3.jar;%APP_HOME%\lib\websocket-api-9.4.24.v20191120.jar;%APP_HOME%\lib\javax.activation-1.1.0.v201105071233.jar;%APP_HOME%\lib\javax.websocket-client-api-1.0.jar


@rem Execute Secure-Computing-CWK
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %SECURE_COMPUTING_CWK_OPTS%  -classpath "%CLASSPATH%" comp3911.cwk2.AppServer %*

:end
@rem End local scope for the variables with windows NT shell
if %ERRORLEVEL% equ 0 goto mainEnd

:fail
rem Set variable SECURE_COMPUTING_CWK_EXIT_CONSOLE if you need the _script_ return code instead of
rem the _cmd.exe /c_ return code!
set EXIT_CODE=%ERRORLEVEL%
if %EXIT_CODE% equ 0 set EXIT_CODE=1
if not ""=="%SECURE_COMPUTING_CWK_EXIT_CONSOLE%" exit %EXIT_CODE%
exit /b %EXIT_CODE%

:mainEnd
if "%OS%"=="Windows_NT" endlocal

:omega
