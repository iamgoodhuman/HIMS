from flask import Blueprint, jsonify,request
from gitdb.util import exists
import uuid
import pymysql
from db import get_db_connection  # 导入我们写的获取连接的方法
from werkzeug.security import generate_password_hash, check_password_hash
user_bp = Blueprint('user', __name__ , url_prefix='/user')
#所有用户列表
@user_bp.route('/list', methods=['GET'])
def index():
    sql = 'select * from users'
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute(sql)
            users = cursor.fetchall()
            return jsonify({'message': '获取所以用户', 'data': users , 'code':200})
    except Exception as e:
        return jsonify({
            'message': f'获取用户列表失败: {e}','code':400
        })
    finally:
        conn.close()
#用户详情
@user_bp.route('/detail', methods=['POST'])
def detail():
    data = request.get_json()
    return jsonify({'message': '获取用户详情',"data":data})

#用户注册
@user_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    if data is None:
        return jsonify({
            "msg":"请求体为空",
            "code":400
        })
    username = data.get('username')
    email = data.get('email')
    password = data.get('password')
    if not username or not email or not password:
        return jsonify({
            "msg":"用户名、邮箱、密码不能为空",
            "code":400
        })
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            #检查邮箱和用户名是否存在
            check_sql = """
                select user_id from users where email = %s or username = %s
            """
            cursor.execute(check_sql,(email,username))
            exists_user = cursor.fetchone()
            print("exists_user",exists_user)
            if exists_user:
                return jsonify({
                    "msg": "邮箱或者重复",
                    "code": 400
                })
            password_hash = generate_password_hash(password)
            new_uuid = uuid.uuid4()
            sql_insert = """
                INSERT INTO users(username,email,password_hash)
                VALUES (%s,%s,%s)
            """
            cursor.execute(sql_insert,(username,email,password_hash))
            connection.commit()
            return jsonify({
                "msg": "注册成功",
                "code": 200
            })
    finally:
        cursor.close()

#用户登录
@user_bp.route('/login',methods=['POST'])
def login():
    data = request.get_json()
    if data is None:
        return jsonify({
            "msg": "请求体为空",
            "code": 400
        })
    username = data.get('username')
    password = data.get('password')
    if not username or not password:
        return jsonify({
            "msg": "用户名或密码不能为空",
            "code": 400
        })

    connection = get_db_connection()
    try:
        cursor = connection.cursor(pymysql.cursors.DictCursor)
        sql_select = """
            select username,password_hash from users where username = %s
        """
        cursor.execute(sql_select,(username,))
        user = cursor.fetchone()
        print("user",user)
        if not user:
            return jsonify({
                "msg": "用户不存在",
                "code": 400
            })

        stored_password_hash = user['password_hash']
        if not check_password_hash(stored_password_hash,password):
            return jsonify({
                "msg": "密码错误",
                "code": 400
            })

        return jsonify({
            "msg": "登录成功",
            "code": 200
        })
    finally:
        cursor.close()