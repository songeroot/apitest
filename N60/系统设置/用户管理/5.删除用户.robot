*** Settings ***
Suite Setup       获取全局Token
Library           Collections
Library           RequestsLibrary
Library           String
Resource          ../../Keyword.txt

*** Test Cases ***
删除单个用户测试
    [Documentation]    测试删除单个用户的功能
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    ids=test_user_001
    ${response}=    POST On Session    api    /api/systemctrl/users/remove    json=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_json}=    Evaluate    json.loads('''${response.text}''')    json
    Dictionary Should Contain Key    ${response_json}    result
    Should Be Equal As Strings    ${response_json['result']}    ok

批量删除用户测试
    [Documentation]    测试批量删除用户的功能
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${user_list}=    Create List    Jack    Bob    Alice
    ${data}=    Create Dictionary    ids=${user_list}
    ${response}=    POST On Session    api    /api/systemctrl/users/remove    json=${data}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_json}=    Evaluate    json.loads('''${response.text}''')    json
    Dictionary Should Contain Key    ${response_json}    result
    Should Be Equal As Strings    ${response_json['result']}    ok

删除单个用户参数为空测试
    [Documentation]    测试删除用户时用户名为空的情况
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    ids=${EMPTY}
    ${response}=    POST On Session    api    /api/systemctrl/users/remove    json=${data}    headers=${headers}
    Should Not Be Equal As Strings    ${response.status_code}    200

批量删除用户列表为空测试
    [Documentation]    测试批量删除用户时列表为空的情况
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${empty_list}=    Create List
    ${data}=    Create Dictionary    ids=${empty_list}
    ${response}=    POST On Session    api    /api/systemctrl/users/remove    json=${data}    headers=${headers}
    Should Not Be Equal As Strings    ${response.status_code}    200

删除不存在的用户测试
    [Documentation]    测试删除不存在的用户
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    ids=NonexistentUser
    ${response}=    POST On Session    api    /api/systemctrl/users/remove    json=${data}    headers=${headers}
    # 根据实际情况调整断言，可能返回成功或特定错误码
    Log    ${response.text}

批量删除包含不存在的用户测试
    [Documentation]    测试批量删除时包含不存在的用户
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${user_list}=    Create List    Jack    NonexistentUser    Bob
    ${data}=    Create Dictionary    ids=${user_list}
    ${response}=    POST On Session    api    /api/systemctrl/users/remove    json=${data}    headers=${headers}
    Log    ${response.text}

参数格式错误测试
    [Documentation]    测试参数格式错误的情况
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    ids=123    # 数字而不是字符串
    ${response}=    POST On Session    api    /api/systemctrl/users/remove    json=${data}    headers=${headers}
    Should Not Be Equal As Strings    ${response.status_code}    200

缺少必要参数测试
    [Documentation]    测试缺少ids参数的情况
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    # 空字典，不包含ids
    ${response}=    POST On Session    api    /api/systemctrl/users/remove    json=${data}    headers=${headers}
    Should Not Be Equal As Strings    ${response.status_code}    200

特殊字符用户名测试
    [Documentation]    测试包含特殊字符的用户名
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    ids=User@123
    ${response}=    POST On Session    api    /api/systemctrl/users/remove    json=${data}    headers=${headers}
    Log    ${response.text}

长用户名测试
    [Documentation]    测试超长用户名的处理
    ${long_username}=    Evaluate    'a' * 100
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${data}=    Create Dictionary    ids=${long_username}
    ${response}=    POST On Session    api    /api/systemctrl/users/remove    json=${data}    headers=${headers}
    Log    ${response.text}

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

清理测试数据
    [Documentation]    清理测试过程中创建的用户数据
    # 根据实际情况实现数据清理逻辑
    Log    数据清理完成
