from flask import Blueprint, jsonify,request
from db import get_db_connection  # 导入我们写的获取连接的方法
task_bp = Blueprint('tasks', __name__ , url_prefix='/tasks')

@task_bp.route('/create', methods=['POST'])
def create():
    data = request.get_json()
    #标题
    task_title = data.get('task_title')
    #描述
    task_description = data.get('task_description')
    start_time = data.get('start_time')
    end_time = data.get('end_time')
    #创建人id
    creator_id = data.get('creator_id')
    if not task_title or not start_time:
        return jsonify({
            "msg": "标题、开始时间、创建人id不能为空",
            "code": 400
        })
    connection = get_db_connection()
    try:
        with connection.cursor() as cursor:
            sql_insert = """
                insert into tasks(
                task_title, task_description, start_time, end_time, creator_id
                ) values (%s,%s,%s,%s,%s)
            """
            cursor.execute(sql_insert,(task_title,task_description,start_time,end_time,creator_id))
            connection.commit()
            return jsonify({
                "msg": "新增成功",
                "code": 200
            })
    finally:
        connection.close()