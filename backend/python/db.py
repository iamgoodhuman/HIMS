import pymysql
DB_CONFIG = {
    'host':'localhost',
    'user':'root',
    'password':'ZXThwc123.',
    'database':'hims',
    'charset':'utf8',
    'cursorclass':pymysql.cursors.DictCursor
}
# 封装一个获取数据库连接的函数
def get_db_connection():
    return pymysql.connect(**DB_CONFIG)