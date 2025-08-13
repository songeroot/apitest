*** Settings ***
Library           ../../Python37/Lib/site-packages/RequestsLibrary/
Library           ../../Python37/Lib/site-packages/DatabaseLibrary/
Library           ../../Python37/Lib/site-packages/Selenium2Library/
Library           ../../Python37/Lib/site-packages/MyTest.py
Library           ../../Python37/Lib/site-packages/JSONLibrary/
Library           OperatingSystem
Library           Collections

*** Variables ***
${url}            http://192.168.43.105

*** Test Cases ***
3.2.1 获得设备流服务列表
    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded
    log    测试设备地址为：
    log    ${url}
    ${rep}    My Get    ${url}/api/streamer/v1/stream/list    ${headers}
    log    ${rep}    level=TRACE
    Comment    ${byte}    Set Variable    ${rep}
    Comment    ${rep1}    Evaluate    ${rep.replace('false', 'False')}
    Comment    ${string}=    Evaluate    ${rep}.decode('utf-8')
    Comment    ${rep1}    MyTest.To Json    ${string}
    Comment    ${rep2}    Get From List    ${rep1}    0
    Comment    ${id_value}=    Get From Dictionary    ${rep2}    id
    Comment    log    ${id_value}
    Comment    Run Keyword If    ${result}==200 and ${status}=="OK"    log    用例执行成功，返回信息${rep}
    Comment    Run Keyword If    ${status}!="OK" or ${result}!=200    fail    用例执行失败，打印失败信息${rep}
