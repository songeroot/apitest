*** Settings ***
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../Keyword.txt

*** Variables ***
${LOGIN_ENDPOINT}    /api/systemctrl/users/login
${VALID_USERNAME}    admin
${VALID_PASSWORD}    Admin123
${INVALID_USERNAME}    wronguser
${INVALID_PASSWORD}    WrongPass123

*** Test Cases ***
1.1使用正确的用户名密码登录
    [Documentation]    测试使用有效凭据登录
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    App={"language":"en"}    Content-Type=application/json
    ${payload}=    Create Dictionary    username=${VALID_USERNAME}    password=${VALID_PASSWORD}
    ${response}=    POST On Session    api    ${LOGIN_ENDPOINT}    json=${payload}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()}[result]    ok
    Dictionary Should Contain Key    ${response.json()}[data]    token
    Dictionary Should Contain Key    ${response.json()}[data]    alias
    Dictionary Should Contain Key    ${response.json()}[data]    changed
    Should Not Be Empty    ${response.json()}[data][token]
    Should Not Be Empty    ${response.json()}[data][alias]
    Delete All Sessions

1.2使用错误密码登录
    [Documentation]    测试使用错误密码登录
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    App={"language":"en"}    Content-Type=application/json
    ${payload}=    Create Dictionary    username=${VALID_USERNAME}    password=${INVALID_PASSWORD}
    ${response}=    POST On Session    api    ${LOGIN_ENDPOINT}    json=${payload}    headers=${headers}    expected_status=200
    Should Not Be Equal As Strings    ${response.json()}[result]    ok
    Should Be Equal As Strings    ${response.json()}[result]    error
    Log    Response: ${response.json()}
    Delete All Sessions

1.3使用错误用户名登录
    [Documentation]    测试使用错误用户名登录
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    App={"language":"en"}    Content-Type=application/json
    ${payload}=    Create Dictionary    username=${INVALID_USERNAME}    password=${VALID_PASSWORD}
    ${response}=    POST On Session    api    ${LOGIN_ENDPOINT}    json=${payload}    headers=${headers}    expected_status=200
    Should Not Be Equal As Strings    ${response.json()}[result]    ok
    Should Be Equal As Strings    ${response.json()}[result]    error
    Should Be Equal As Strings    ${response.json()}[msg]    Unknown User
    Log    Response: ${response.json()}
    Delete All Sessions

1.4缺少用户名参数登录
    [Documentation]    测试缺少用户名参数
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    App={"language":"en"}    Content-Type=application/json
    ${payload}=    Create Dictionary    password=${VALID_PASSWORD}
    ${response}=    POST On Session    api    ${LOGIN_ENDPOINT}    json=${payload}    headers=${headers}    expected_status=422
    Log    Response: ${response.json()}
    Delete All Sessions

1.5缺少密码参数登录
    [Documentation]    测试缺少密码参数
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    App={"language":"en"}    Content-Type=application/json
    ${payload}=    Create Dictionary    username=${VALID_USERNAME}
    ${response}=    POST On Session    api    ${LOGIN_ENDPOINT}    json=${payload}    headers=${headers}    expected_status=422
    Log    Response: ${response.json()}
    Delete All Sessions

1.6缺少App请求头时msg为null
    [Documentation]    测试缺少App请求头时msg为null
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${payload}=    Create Dictionary    username=${VALID_USERNAME}    password=${VALID_PASSWORD}
    ${response}=    POST On Session    api    ${LOGIN_ENDPOINT}    json=${payload}    headers=${headers}
    Should Be Equal    ${response.json()}[msg]    ${None}
    Delete All Sessions

1.7中文语言环境下的登录
    [Documentation]    测试中文语言环境下的登录
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    App={"language":"zh"}    Content-Type=application/json
    ${payload}=    Create Dictionary    username=${VALID_USERNAME}    password=${VALID_PASSWORD}
    ${response}=    POST On Session    api    ${LOGIN_ENDPOINT}    json=${payload}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal As Strings    ${response.json()}[result]    ok
    Dictionary Should Contain Key    ${response.json()}[data]    token
    Delete All Sessions

1.8验证token和alias的数据结构
    [Documentation]    验证token和alias的数据结构
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    App={"language":"en"}    Content-Type=application/json
    ${payload}=    Create Dictionary    username=${VALID_USERNAME}    password=${VALID_PASSWORD}
    ${response}=    POST On Session    api    ${LOGIN_ENDPOINT}    json=${payload}    headers=${headers}
    # 验证token不为空
    ${token}=    Get From Dictionary    ${response.json()}[data]    token
    Should Not Be Empty    ${token}    ^[a-f0-9]{32}$
    # 验证alias不为空
    ${alias}=    Get From Dictionary    ${response.json()}[data]    alias
    Should Not Be Empty    ${alias}
    # 验证changed字段为布尔值
    ${changed}=    Get From Dictionary    ${response.json()}[data]    changed
    Should Be True    ${changed}==True or ${changed}==False
    Delete All Sessions

*** Keywords ***
Login And Get Token
    [Arguments]    ${username}=${VALID_USERNAME}    ${password}=${VALID_PASSWORD}    ${language}=en
    [Documentation]    登录并获取token，返回token字符串
    Create Session    api    ${URL}
    ${headers}=    Create Dictionary    App={"language":"${language}"}    Content-Type=application/json
    ${data}=    Create Dictionary    username=${username}    password=${password}
    ${response}=    POST On Session    api    ${LOGIN_ENDPOINT}    json=${data}    headers=${headers}
    # 验证响应状态
    Should Be Equal As Strings    ${response.status_code}    200
    # 提取token并返回
    ${token}=    Set Variable    ${response.json()['data']['token']}
    RETURN    ${token}
