from flask import Flask, request, jsonify
from pymongo import MongoClient
from bson import ObjectId  # Import ObjectId

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
    return str(counter_doc['_id'])  # Convert ObjectId to string

def get_user_by_credentials(username, password):
    users_collection = db['Signup']
    return users_collection.find_one({'username': username, 'password': password})

@app.route('/login', methods=['GET'])
def login_user():
    loginID = request.args.get('username')
    loginPassword = request.args.get('password')

    if not loginID or not loginPassword:
        return jsonify({'message': 'Missing Credentials!'})
    
    user = get_user_by_credentials(loginID, loginPassword)

    if user:
        # Convert ObjectId to string in the response
        user_data = {key: str(value) if key == '_id' else value for key, value in user.items()}
        return jsonify({'message': 'Login successful', 'user_data': user_data})
    else:
        return jsonify({'error': 'Invalid username or password'})


@app.route('/availabilities', methods=['POST'])
def add_availability():
    data = request.json

    Monday = data.get('Monday')
    Tuesday = data.get('Tuesday')
    Wednesday = data.get('Wednesday')
    Thursday = data.get('Thursday')
    Friday = data.get('Friday')
    Saturday = data.get('Saturday')
    Sunday = data.get('Sunday')

    if not Monday or not Tuesday or not Wednesday or not Thursday or not Friday or not Saturday or not Sunday:
        return jsonify({'error': 'Missing Fields, Check Availabilities!'})

    user_collection = db['Availabilities']

    availabilities_data = {
        'Monday': Monday,
        'Tuesday': Tuesday,
        'Wednesday': Wednesday,
        'Thursday': Thursday,
        'Friday': Friday,
        'Saturday': Saturday,
        'Sunday': Sunday,
    }

    try:
        result = user_collection.insert_one(availabilities_data)
        if result:
            return jsonify({'message': 'User availability added to the database successfully'})
        else:
            return jsonify({'error': 'Failed to add user availability.'})
    except Exception as e:
        print(f'Error: {e}')
        return jsonify({'error': f'Failed to add user availability. {str(e)}'})

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
            # Exclude '_id' field from the response
            response_data = {key: value for key, value in user_data.items() if key != '_id'}
            return jsonify({'message': 'User added to the database successfully', 'user_data': response_data})
        else:
            return jsonify({'error': 'Failed to add user. Inserted ID not returned.'})
    except Exception as e:
        print(f'Error: {e}')  
        return jsonify({'error': f'Failed to add user. {str(e)}'})

if __name__ == '__main__':
    app.run(debug=True, port=5000)