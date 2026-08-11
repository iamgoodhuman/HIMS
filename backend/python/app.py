from flask import Flask
from blueprint.user import user_bp
from blueprint.message import message_bp
app = Flask(__name__)
app.register_blueprint(user_bp)
app.register_blueprint(message_bp)

if __name__ == '__main__':
    app.run(debug=True)
