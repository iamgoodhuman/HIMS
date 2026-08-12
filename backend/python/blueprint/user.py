from flask import Blueprint, jsonify,request
from db import get_db_connection  # 导入我们写的获取连接的方法
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
    username = data.get('username')
    
    print("username",username)
    return jsonify({
        "msg":"用户注册",
        "data":data
    })