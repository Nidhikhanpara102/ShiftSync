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

def link_user_to_availability(username, availability_id):
    users_collection = db['Signup']
    users_collection.update_one(
        {'username': username},
        {'$set': {'availability_id': availability_id}}
    )

def login_user():
    loginID = request.args.get('username')
    loginPassword = request.args.get('password')

    if not loginID or not loginPassword:
        return jsonify({'message': 'Missing Credentials!'})
    
    user = get_user_by_credentials(loginID, loginPassword)

    if user:
        # Convert ObjectId to string for _id and availability_id fields in the response
        user_data = {key: str(value) if key in ('_id', 'availability_id') else value for key, value in user.items()}
        return jsonify({'message': 'Login successful', 'user_data': user_data})
    else:
        return jsonify({'error': 'Invalid username or password'})

@app.route('/login', methods=['GET'])  # Add this line to associate the route with the function
def login_route():
    return login_user()

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

    Monday = data.get('Monday')
    Tuesday = data.get('Tuesday')
    Wednesday = data.get('Wednesday')
    Thursday = data.get('Thursday')
    Friday = data.get('Friday')
    Saturday = data.get('Saturday')
    Sunday = data.get('Sunday')

    if not firstName or not lastName or not email or not age or not address or not username or not password:
        return jsonify({'error': 'Missing Fields!'})

    users_collection = db['Signup']
    availabilities_collection = db['Availabilities']

    user_data = {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'age': age,
        'address': address,
        'username': username,
        'password': password
    }

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
        # Insert user data
        result_user = users_collection.insert_one(user_data)
        
        # Insert availability data
        result_availability = availabilities_collection.insert_one(availabilities_data)

        if result_user.inserted_id and result_availability.inserted_id:
            # Link user to availability
            link_user_to_availability(username, result_availability.inserted_id)

            # Exclude '_id' and 'availability_id' fields from the response
            response_user_data = {key: value for key, value in user_data.items() if key != '_id'}
            response_availability_data = {key: value for key, value in availabilities_data.items() if key != '_id'}

            return jsonify({
                'message': 'User and availability added to the database successfully',
                'user_data': response_user_data,
                'availability_data': response_availability_data
            })
        else:
            return jsonify({'error': 'Failed to add user or availability. Inserted ID not returned.'})
    except Exception as e:
        print(f'Error: {e}')  
        return jsonify({'error': f'Failed to add user or availability. {str(e)}'})

if __name__ == '__main__':
    app.run(debug=True, port=5000)