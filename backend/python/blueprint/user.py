from flask import Blueprint, jsonify
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
    return jsonify({'message': '获取用户详情'})

