from flask import Flask, request, jsonify
from pymongo import MongoClient

app = Flask(__name__)
client = MongoClient('mongodb://localhost:27017/')  
db = client['EmpSch']  

def get_next_user_id():
    counter_collection = db['user_counter']
    counter_doc = counter_collection.find_one_and_update(
        {'_id': 'user_id'},
        {'$inc': {'seq': 1}},
        upsert=True,
        return_document=True
    )
    return counter_doc['seq']

def get_user_by_credentials(username, password):
    users_collection = db['Signup']
    return users_collection.find_one({'username': username, 'password': password})

@app.route('/login',methods=['GET'])
def login_user():
    loginID = request.args.get('username')
    loginPassword = request.args.get('password')

    if not loginID or not loginPassword:
        return jsonify({'message':'Mising Credentials!'})
    
    user = get_user_by_credentials(loginID,loginPassword)

    if user:
        return jsonify({'message': 'Login successful', 'user_id': user['user_id']})
    else:
        return jsonify({'error': 'Invalid username or password'})
    

@app.route('/signup', methods=['POST'])
def add_user():
    data = request.json

    firstName = data.get('firstName')
    lastName = data.get('lastName')
    email = data.get('email')
    age = data.get('age')
    address = data.get('address')
    username = data.get('username')
    password = data.get('password')

    if not firstName or not lastName or not email or not age or not address or not username or not password:
        return jsonify({'error': 'Missing Fields!'})

    users_collection = db['Signup']

    user_id = get_next_user_id()

    user_data = {
        'user_id': user_id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'age': age,
        'address': address,
        'username': username,
        'password': password
    }

    try:
        result = users_collection.insert_one(user_data)
        if result.inserted_id:
            return jsonify({'message': 'User added to the database successfully'})
        else:
            return jsonify({'error': 'Failed to add user. Inserted ID not returned.'})
    except Exception as e:
        print(f'Error: {e}')  
        return jsonify({'error': f'Failed to add user. {str(e)}'})

if __name__ == '__main__':
    app.run(debug=True, port=5000)