*** Settings ***
Force Tags        DocTest    Activity
Library           ../../Lib/JsonRead.py
Library           Collections
Resource          ../../Business/API/BusApiCom.robot
Variables         ../../Data/Variables.py


*** Test Cases ***
get/activity
	[Documentation]    活动列表
	[Tags]    Run
	${resp}    getApiResp    get    /activity
	${result}    docmentAssert    get    /activity    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/pointQuestion/home
	[Documentation]    小心心首页
	[Tags]    Run
	${params}    getParam_doc    get    /activity/pointQuestion/home
	set to dictionary      ${params}     shareMark=${EMPTY}
	${resp}    getApiResp    get    /activity/pointQuestion/home    params=${params}
	set suite variable      ${chance}     ${resp['chance']}
	${result}    docmentAssert    get    /activity/pointQuestion/home    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/APM/ranking
	[Documentation]    小心心手速排行榜
	[Tags]    Run
	${resp}    getApiResp    get    /activity/APM/ranking
	${result}    docmentAssert    get    /activity/APM/ranking    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/pointQuestion/final
	[Documentation]    小心心提交点击次数，返回数据
	[Tags]    Run
	pass execution if      ${chance}==0      剩余机会为0，不能在点击了
	${params}    getParam_doc    get    /activity/pointQuestion/final
	set to dictionary      ${params}     num=42
	${resp}    getApiResp    get    /activity/pointQuestion/final    params=${params}
	${result}    docmentAssert    get    /activity/pointQuestion/final    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/details
	[Documentation]    拼团详情页
	[Tags]    NotRun
	${params}    getParam_doc    get    /activity/details
	${resp}    getApiResp    get    /activity/details    params=${params}
	${result}    docmentAssert    get    /activity/details    ${resp}
	should be true     ${result[0]}     ${result}

post/activity/draw/help
	[Documentation]    好友助力
	[Tags]    NotRun
	${params}    getParam_doc    post    /activity/draw/help
	${resp}    getApiResp    post    /activity/draw/help    params=${params}
	${result}    docmentAssert    post    /activity/draw/help    ${resp}
	should be true     ${result[0]}     ${result}

post/activity/draw/join
	[Documentation]    抽签结果上报
	[Tags]    NotRun
	${params}    getParam_doc    post    /activity/draw/join
	${resp}    getApiResp    post    /activity/draw/join    params=${params}
	${result}    docmentAssert    post    /activity/draw/join    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/draw/shareUser
	[Documentation]    分享用户详情
	[Tags]    NotRun
	${params}    getParam_doc    get    /activity/draw/shareUser
	${resp}    getApiResp    get    /activity/draw/shareUser    params=${params}
	${result}    docmentAssert    get    /activity/draw/shareUser    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/goods
	[Documentation]    拼团成功详情页
	[Tags]    NotRun
	${params}    getParam_doc    get    /activity/goods
	${resp}    getApiResp    get    /activity/goods    params=${params}
	${result}    docmentAssert    get    /activity/goods    ${resp}
	should be true     ${result[0]}     ${result}

post/activity/join
	[Documentation]    发起拼团
	[Tags]    NotRun
	${resp}    getApiResp    post    /activity/join
	${result}    docmentAssert    post    /activity/join    ${resp}
	should be true     ${result[0]}     ${result}

post/activity/valentines/form
	[Documentation]    配对活动表单上传
	[Tags]    NotRun
	${params}    getParam_doc    post    /activity/valentines/form
	${resp}    getApiResp    post    /activity/valentines/form    params=${params}
	${result}    docmentAssert    post    /activity/valentines/form    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/valentines/form
	[Documentation]    配对活动表单
	[Tags]    NotRun
	${resp}    getApiResp    get    /activity/valentines/form
	${result}    docmentAssert    get    /activity/valentines/form    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/worldCup/cancelMatch
	[Documentation]    取消匹配
	[Tags]    NotRun
	${resp}    getApiResp    get    /activity/worldCup/cancelMatch
	${result}    docmentAssert    get    /activity/worldCup/cancelMatch    ${resp}
	should be true     ${result[0]}     ${result}

post/activity/worldCup/invite
	[Documentation]    世界杯配对活动邀请匹配
	[Tags]    NotRun
	${params}    getParam_doc    post    /activity/worldCup/invite
	${resp}    getApiResp    post    /activity/worldCup/invite    params=${params}
	${result}    docmentAssert    post    /activity/worldCup/invite    ${resp}
	should be true     ${result[0]}     ${result}

post/activity/worldCup/join
	[Documentation]    加入好友邀请
	[Tags]    NotRun
	${params}    getParam_doc    post    /activity/worldCup/join
	${resp}    getApiResp    post    /activity/worldCup/join    params=${params}
	${result}    docmentAssert    post    /activity/worldCup/join    ${resp}
	should be true     ${result[0]}     ${result}

post/activity/worldCup/kickOut
	[Documentation]    踢队友
	[Tags]    NotRun
	${resp}    getApiResp    post    /activity/worldCup/kickOut
	${result}    docmentAssert    post    /activity/worldCup/kickOut    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/worldCup/match
	[Documentation]    世界杯配对活动随机匹配
	[Tags]    NotRun
	${params}    getParam_doc    get    /activity/worldCup/match
	${resp}    getApiResp    get    /activity/worldCup/match    params=${params}
	${result}    docmentAssert    get    /activity/worldCup/match    ${resp}
	should be true     ${result[0]}     ${result}

post/activity/worldCup/remindTeammates
	[Documentation]    提醒队友
	[Tags]    NotRun
	${resp}    getApiResp    post    /activity/worldCup/remindTeammates
	${result}    docmentAssert    post    /activity/worldCup/remindTeammates    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/draw/details
	[Documentation]    抽签页面详情
	[Tags]    NotRun
	${resp}    getApiResp    get    /activity/draw/details
	${result}    docmentAssert    get    /activity/draw/details    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/decodeUserInfo
	[Documentation]    微信授权获取手机号
	[Tags]    NotRun
	${params}    getParam_doc    get    /activity/decodeUserInfo
	${resp}    getApiResp    get    /activity/decodeUserInfo    params=${params}
	${result}    docmentAssert    get    /activity/decodeUserInfo    ${resp}
	should be true     ${result[0]}     ${result}
get/activity/valentines/details
	[Documentation]    配对成功活动详情
	[Tags]    NotRun
	${resp}    getApiResp    get    /activity/valentines/details
	${result}    docmentAssert    get    /activity/valentines/details    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/valentines/ranking
	[Documentation]    配对活动排行榜
	[Tags]    NotRun
	${resp}    getApiResp    get    /activity/valentines/ranking
	${result}    docmentAssert    get    /activity/valentines/ranking    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/worldCup/barrage
	[Documentation]    弹幕
	[Tags]    NotRun
	${resp}    getApiResp    get    /activity/worldCup/barrage
	${result}    docmentAssert    get    /activity/worldCup/barrage    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/worldCup/peopleSum
	[Documentation]    参与人数
	[Tags]    NotRun
	${resp}    getApiResp    get    /activity/worldCup/peopleSum
	${result}    docmentAssert    get    /activity/worldCup/peopleSum    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/worldCup/ranking
	[Documentation]    世界杯配对活动排行榜
	[Tags]    NotRun
	${resp}    getApiResp    get    /activity/worldCup/ranking
	${result}    docmentAssert    get    /activity/worldCup/ranking    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/worldCup/share
	[Documentation]    世界杯配对活动点击气泡详情
	[Tags]    NotRun
	${params}    getParam_doc    get    /activity/worldCup/share
	${resp}    getApiResp    get    /activity/worldCup/share    params=${params}
	${result}    docmentAssert    get    /activity/worldCup/share    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/worldCup/teamDetails
	[Documentation]    世界配对成功活动详情
	[Tags]    NotRun
	${params}    getParam_doc    get    /activity/worldCup/teamDetails
	${resp}    getApiResp    get    /activity/worldCup/teamDetails    params=${params}
	${result}    docmentAssert    get    /activity/worldCup/teamDetails    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/worldCup/userDetails
	[Documentation]    世界配对成功活动详情
	[Tags]    NotRun
	${resp}    getApiResp    get    /activity/worldCup/userDetails
	${result}    docmentAssert    get    /activity/worldCup/userDetails    ${resp}
	should be true     ${result[0]}     ${result}

post/activity/magpieFestival/generateFragment
	[Documentation]    七夕节生成碎片
	[Tags]    NotRun
	${params}    getParam_doc    post    /activity/magpieFestival/generateFragment
	${resp}    getApiResp    post    /activity/magpieFestival/generateFragment    params=${params}
	${result}    docmentAssert    post    /activity/magpieFestival/generateFragment    ${resp}
	should be true     ${result[0]}     ${result}

put/activity/object/status
	[Documentation]    活动状态用户触发改变
	[Tags]    NotRun
	${params}    getParam_data    Activity    put/activity/object/status
	${resp}    getApiResp    put    /activity/object/status    params=${params}
	${result}    docmentAssert    put    /activity/object/status    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/object/status
	[Documentation]    查看活动状态
	[Tags]    NotRun
	${params}    getParam_doc    get    /activity/object/status
	${resp}    getApiResp    get    /activity/object/status    params=${params}
	${result}    docmentAssert    get    /activity/object/status    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/magpieFestival/onTime
	[Documentation]    指定活动是否在活动时间内
	[Tags]    NotRun
	${params}    getParam_doc    get    /activity/magpieFestival/onTime
	${resp}    getApiResp    get    /activity/magpieFestival/onTime    params=${params}
	${result}    docmentAssert    get    /activity/magpieFestival/onTime    ${resp}
	should be true     ${result[0]}     ${result}

post/activity/gifts
	[Documentation]    大礼包领取
	[Tags]    Run
	${resp}    getApiResp    post    /activity/gifts
	${result}    docmentAssert    post    /activity/gifts    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/gifts/status
	[Documentation]    大礼包领取状态
	[Tags]    Run
	${resp}    getApiResp    get    /activity/gifts/status
	${result}    docmentAssert    get    /activity/gifts/status    ${resp}
	should be true     ${result[0]}     ${result}

get/activity/subjectCut/list
	[Documentation]    砍价活动课程列表
	[Tags]    NotRun
	${resp}    getApiResp    get    /activity/subjectCut/list
	${result}    docmentAssert    get    /activity/subjectCut/list    ${resp}
	should be true     ${result[0]}     ${result}

