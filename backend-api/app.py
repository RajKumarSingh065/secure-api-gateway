from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route('/public', methods=['GET'])
def public_endpoint():
    return jsonify({"message": "This is a public endpoint."})

@app.route('/admin', methods=['POST'])
def admin_endpoint():
    # Simulates an admin-only endpoint
    # In a real application, you'd add JWT verification here as well,
    # checking for an 'admin' role or similar claim in the token.
    return jsonify({"message": "Admin action successful!"})

@app.route('/', methods=['GET'])
def index():
    print("Root endpoint / was accessed!")
    return jsonify({"message": "Welcome to the Flask API!"})

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy", "message": "API is running"})

@app.route('/protected', methods=['GET'])
def protected_endpoint():
    # Simulates a protected endpoint
    # In a real application, you'd add JWT verification here.
    return jsonify({"message": "This is a protected endpoint."})

