*** Settings ***
Suite Setup       获取全局Token
Library           Collections
Library           RequestsLibrary
Resource          ../../Keyword.txt

*** Test Cases ***
修改用户昵称
    [Documentation]    修改已存在用户的昵称，预期返回成功
    [Tags]    positive
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${data}=    Create Dictionary    id=test_user_001    alias=test11    enable_web=true    enable_api=true
    ${response}=    POST    ${url}/api/systemctrl/users/modify    json=${data}    headers=${headers}
    Status Should Be    200    ${response}
    ${response_json}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${response_json}    result
    Should Be Equal    ${response_json['result']}    ok

*** Keywords ***
Login And Get Token
    [Documentation]    登录并获取token，返回token字符串
    # [Arguments]    ${username}="admin"    ${password}="Admin123"    ${language}=en
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    App={"language":"en"}    Content-Type=application/json
    ${data}=    Create Dictionary    username=admin    password=Admin123
    ${response}=    POST On Session    api    /api/systemctrl/users/login    json=${data}    headers=${headers}
    # 验证响应状态
    Should Be Equal As Strings    ${response.status_code}    200
    # 提取token并返回
    ${token}=    Set Variable    ${response.json()['data']['token']}
    [Return]    ${token}

获取全局Token
    ${token}=    Login And Get Token
    Set Suite Variable    ${AUTH_TOKEN}    ${token}
