# coding=utf-8
import pymysql
from AutoTestTools.conf import dbhost, port, user, passd, dbname, charset
from Conf.Properties import bus_dir
from Util.RFMethodName import BusinessName


def execute_sql(sql):  # 获取数据库的数据
	conn = pymysql.connect(host=dbhost, port=port, user=user, passwd=passd, db=dbname, charset=charset)
	cur = conn.cursor()
	cur.execute(sql)
	results = cur.fetchall()  # 搜取所有结果
	cur.close()
	conn.close()
	return results


def get_business_sql(case_id):
	sql_business = "SELECT b.business_id,c.`name`,c.nameEn,c.params FROM (`autotestapp_business` a  LEFT JOIN `autotestapp_business_basic` c on  a.bus_basic_id=c.id) inner join `autotestapp_case_business` b on a.id=b.business_id WHERE b.case_id=" + str(
		case_id) + " ORDER BY b.id"
	sql_business_data = execute_sql(sql_business)
	b_data = []
	for business in sql_business_data:
		b1 = []
		b1.append(business[1])

		bus_name = BusinessName().get_business_name(bus_dir)
		if business[2] in bus_name.get("API", "") and business[2] in bus_name.get("GUI", ""):
			b1.append("green")
		elif business[2] in bus_name.get('API', ""):
			b1.append("blue")
		elif business[2] in bus_name.get('GUI', ""):
			b1.append("chocolate")
		else:
			b1.append("red")

		if business[3]:
			b3 = business[3].split(",")
			b3_sort = b3.copy()
			b3_sort.sort()

			sql_params = "SELECT a.varName,a.`value` FROM `autotestapp_data` a INNER JOIN `autotestapp_business_params` b  WHERE a.id=b.data_id AND b.business_id=" + str(
				business[0])
			sql_params_data = list(execute_sql(sql_params))
			sql_params_data.sort()
			p1 = []

			for i in range(len(b3)):
				index = b3_sort.index(b3[i])
				try:
					datainfo = sql_params_data[index][1]
				except:
					print(business[1])
					print("实参：" ,str(b3))
					print("传参：", str(sql_params_data))
					datainfo = "参数错误！"
				s = b3[i] + "=" + datainfo
				p1.append(s)
			b1.append("；".join(p1))
		b_data.append(b1)
	return b_data


def get_sql_data():
	sql = "SELECT id,`name`,documentation,sort FROM `autotestapp_case` WHERE del_flag=0 order by sort,id"
	sql_data = execute_sql(sql)
	data = []
	for i in range(len(sql_data)):
		d1 = []
		for s in sql_data[i]:
			d1.append(s)

		case_id = sql_data[i][0]
		sql_tag = "SELECT tagName FROM `autotestapp_case_tags` AS ct ,`autotestapp_tag` AS t WHERE  ct.tag_id=t.id AND t.del_flag=0 AND ct.case_id=" + str(
			case_id)
		sql_tag_data = execute_sql(sql_tag)
		tags = []
		for tag in sql_tag_data:
			tags.append(tag[0])
		d1.append(",".join(tags))

		d1.append(get_business_sql(case_id))
		data.append(d1)
	return data


def get_sql_data_funid(funid):
	if funid:
		sql = "SELECT id,`name`,documentation,sort FROM `autotestapp_case` WHERE del_flag=0 AND funmodule_id=" + str(
			funid) + " order by sort,id"
	else:
		sql = "SELECT id,`name`,documentation,sort FROM `autotestapp_case` WHERE del_flag=0 order by sort,id"
	sql_data = execute_sql(sql)
	data = []
	for i in range(len(sql_data)):
		d1 = []
		for s in sql_data[i]:
			d1.append(s)

		case_id = sql_data[i][0]
		sql_tag = "SELECT tagName FROM `autotestapp_case_tags` AS ct ,`autotestapp_tag` AS t WHERE  ct.tag_id=t.id AND t.del_flag=0 AND ct.case_id=" + str(
			case_id)
		sql_tag_data = execute_sql(sql_tag)
		tags = []
		for tag in sql_tag_data:
			tags.append(tag[0])
		d1.append(",".join(tags))

		d1.append(get_business_sql(case_id))
		data.append(d1)
	return data
