from flask import Blueprint, jsonify
message_bp = Blueprint('message', __name__ , url_prefix='/message')
#所有消息列表
@message_bp.route('/list', methods=['GET'])
def index():
    return jsonify({'message': '获取所以消息'})
#消息详情
@message_bp.route('/detail', methods=['POST'])
def detail():
    return jsonify({'message': '获取消息详情'})

