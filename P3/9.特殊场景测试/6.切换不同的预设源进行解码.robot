*** Settings ***
Library           ../../Python37/Lib/site-packages/RequestsLibrary/
Library           ../../Python37/Lib/site-packages/DatabaseLibrary/
Library           ../../Python37/Lib/site-packages/Selenium2Library/
Library           ../../Python37/Lib/site-packages/MyTest.py
Library           ../../Python37/Lib/site-packages/JSONLibrary/

*** Test Cases ***
6.1 切换不同的预设源进行解码
    FOR    ${var}    IN RANGE    1    #循环多少次
        ${var2}    Evaluate    ${var} * 2
        log    第${var2} 次切换---------------------------------------------------------------------------------------------------------
        解码切换
    END

*** Keywords ***
解码切换
    ${headers}    create dictionary    Content-Type=application/x-www-form-urlencoded    Authorization=Basic YWRtaW46YWRtaW4=    Content-Type=application/json
    @{list}    set variable    0    1
    FOR    ${var}    IN    @{list}    #切换成对应指定的解码预设源
        log    切换成解码预设${var}的源
        ${body}    create dictionary    id=${var}
        ${body1}    MyTest.To Json    ${body}
        ${rep}    My Post    http://192.168.43.187/api/codec/decode/add    ${body1}    ${headers}
        ${result}    get_json_value    ${rep}    result
        sleep    3
        ${result}    MyTest.To Json    ${result}
        Run Keyword If    ${result}=="ok"    log    用例执行成功，已切换成解码预设${var}的源
        Run Keyword If    ${result}!="ok"    fail    用例执行失败，切换解码预设源失败：${result}
        sleep    2
    END
