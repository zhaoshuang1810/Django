#coding=utf-8
from AutoTestTools.mysql import execute_sql

planType = ['DAILY_PRACTICE', 'LEARNING_PLAN', 'CHAPTER_PRACTICE', 'MY_COLLECT', 'MY_WRONG', 'SIMULATION_EXAM',
			'RANDOM_PRACTICE', 'ONLY_WRONG_PRACTICE', 'HIGH_WRONG_PRACTICE']

reqchannel = ['MASTER', 'MANGO_ACCOUNTING']


def get_usertoken(userId):
	sql = "SELECT token FROM `autotestapp_user` WHERE userId="+ str(userId)
	results = execute_sql(sql)
	return results[0][0]

# me
userId = 130395
token = get_usertoken(userId)
token_30 = token[-30:]

userId_m = 129799
token_m = get_usertoken(userId_m)
token_m_30 = token_m[-30:]

# anan
userId01 = 130432
token01 = get_usertoken(userId01)

userId_m01 = 130784
token_m01 = get_usertoken(userId_m01)

# haiyan
token02 = "eyJhbGciOiJIUzUxMiJ9.eyJhIjpudWxsLCJzIjoibzJFSVYwU3NWbTBSaExtMHhneDhodXE3SVJBWSIsImMiOjE1MzY3MTk4MDMwODksImUiOjE1MzgwMTU4MDMwODksImkiOjEzMTE2N30.8cxcxMln6EvP7t19qY9Xzf3isYk1tUYpqmayHU7MkjFFw_7gCaq_2Aq2xLs2zke5DinWzj3VlThy4qxTtpmdRg"
userId02 = 131167

token_m02 = "eyJhbGciOiJIUzUxMiJ9.eyJhIjpudWxsLCJzIjoib1hJbTA1SkV3dUZxQXByR1Vka1l1aEZSRlFCdyIsImMiOjE1MzY3MTk1MDQ3MzksImUiOjE1MzgwMTU1MDQ3MzksImkiOjEzMDk4MX0.8PKsPQHX24V8OGPVqkuf9UAYb_ojDHQ7trpm8BCam0fLu8d1lapHIDKyXJlfusYVtw87bzsluGuApnxjcionpg"
userId_m02 = 130981
