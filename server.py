import eventlet
import json
from flask import Flask, render_template, jsonify, request
from flask import Flask, render_template, redirect, url_for, request, make_response
from flask_mqtt import Mqtt
from flask_socketio import SocketIO
from flask_bootstrap import Bootstrap
from flaskext.mysql import MySQL
import requests
import threading
import time
from datetime import datetime,timedelta
from flask_restplus import Resource, Api
import thread

eventlet.monkey_patch()

app = Flask(__name__)
api = Api(app)

# broker init
app.config['MQTT_BROKER_URL'] = 'eu.thethings.network'
app.config['MQTT_USERNAME'] = 'electric-vehicle-charging-station-ua'
app.config['MQTT_PASSWORD'] = 'ttn-account-v2.GNEAONKKwzyOzHmBiFrFngvGsTk86Xz4I6eYNx9bvkE'
app.config['MQTT_REFRESH_TIME'] = 1.0  # refresh time in seconds
app.config['MQTT_TLS_ENABLED'] = True
app.config['MQTT_BROKER_PORT'] = 8883
app.config['MQTT_TLS_ENABLED'] = True
app.config['MQTT_TLS_CA_CERTS'] = 'mqtt-ca.pem'
mqtt = Mqtt(app)
socketio = SocketIO(app)
bootstrap = Bootstrap(app)

# MySQL init
mysql = MySQL()
app.config['MYSQL_DATABASE_USER'] = 'root'
app.config['MYSQL_DATABASE_PASSWORD'] = 'sxwk8tfF%Iro'
app.config['MYSQL_DATABASE_DB'] = 'thethingsnetwork'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)


@api.route('/hello')                   #  Create a URL route to this resource
class HelloWorld(Resource):            #  Create a RESTful resource
    def get(self):                     #  Create GET endpoint
        return {'hello': 'world'}


def db_execute(query):
	conn = mysql.connect()
	cur = conn.cursor()
	cur.execute(query)
	conn.commit()
	res = cur.fetchall()
	cur.close()
	conn.close()
	return res

def db_execute_one(query):
	conn = mysql.connect()
	cur = conn.cursor()
	cur.execute(query)
	conn.commit()
	res = cur.fetchone()
	cur.close()
	conn.close()
	return res


@api.route('/callback_clear')
class CallbackClear(Resource):
	def get(self):
		db_execute("TRUNCATE TABLE thethingsnetwork.requests")

		return json.dumps({'message':'success'}), 200, {'ContentType':'application/json'}
		#return make_response({'message':'success'}, 200, {'Content-Type': 'text/json'})

def convert_state(current_state, variable):
	# parking_state
	if variable == "parking_state":
		if current_state == "available":
			return 'free'
		else:
			return 'occupied'

	# charging_socket_location
	elif variable == "charging_socket_location":
		if current_state == "out-of-service":
			return 'unknown'
		elif current_state == "charging" or current_state == "charged":
			return 'car'
		elif current_state == "detached":
			return 'detached'
		else:
			return 'station'

	# charging_state
	elif variable == "charging_state":
		if current_state == "charging":
			return 'charging'
		elif current_state == "charged":
			return 'charged'
		else:
			return 'not-charging'

# THREAD SUPPORT
def check_station_status():
	# call this function every minute
	threading.Timer(60.0, check_station_status).start() # called every minute

	# get all devices except which are already out of service
	mysql_response = db_execute("SELECT * FROM GET_ACTIVE_STATIONS")

	for row in mysql_response:
		if datetime.strptime(str(row[1]), "%Y-%m-%d %H:%M:%S") + timedelta(minutes=30) < datetime.now():
			station_id = row[0]
			station_state = "out-of-service"

			# these variables are state depended
			parking_state = convert_state(station_state, 'parking_state')
			charging_socket_location = convert_state(station_state, 'charging_socket_location')
			charging_state = convert_state(station_state, 'charging_state')

			db_execute("CALL STATION_STATE_CHANGE('%s','%s','%s','%s','%s')" % (station_id, station_state, parking_state, charging_socket_location, charging_state))

check_station_status()


# THREAD SUPPORT
@socketio.on('publish')
def handle_publish(topic,payload):
	try:
		thread.start_new_thread( mqtt_publish_tipic, (topic, payload, ) )
	except Exception as e:
		print "Error: unable to start thread ," + str(e)


def mqtt_publish_tipic(topic,payload):
	mqtt.publish(topic, '{"payload_fields":' + payload + '}')


@api.route('/callback/<callback_number>')
class DefineCallback(Resource):
	def get(self, callback_number):
		# get callback url from callback_number
		callback_url = str(db_execute_one("SELECT GET_CALLBACK_URL('%s')" % (callback_number))[0])

		return make_response(render_template('callback_form.html', callback_url=callback_url), 200, {'Content-Type': 'text/html'})

	def post(self, callback_number):
		# set new callback_url
		db_execute_one("SELECT SET_CALLBACK_URL('%s','%s')" % (callback_number, request.form['callback_url']))

		# get callback url from callback_number
		callback_url = str(db_execute_one("SELECT GET_CALLBACK_URL('%s')" % (callback_number))[0])

		return make_response(render_template('callback_form.html', callback_url=callback_url), 200, {'Content-Type': 'text/html'})


# APP DEMONSTRATION
@app.route('/proxy_post', methods=['POST'])
def proxy_post():
	if request.method == 'POST':
		try:
			post_data = json.loads(request.data)
		except Exception as e:
			return json.dumps({'message':'invalid-json-format'}), 400, {'ContentType':'application/json'}

		station_state = post_data['station_state']
		station_id = post_data['station_id']
		message_type = post_data['message_type']

		mysql_response = db_execute("SELECT * FROM GET_CALLBACKS")

		message = dict()
		if station_state == 'available' and message_type == 'state_update':
			message['station_id'] = station_id
			message['station_state'] = station_state
			message['message_type'] = message_type
			message['parking_state'] = 'free'
			message['charging_socket_location'] = 'station'
			message['charging_state'] = 'not-charging'

		elif station_state == 'parked' and message_type == 'state_update':
			message['station_id'] = station_id
			message['station_state'] = station_state
			message['message_type'] = message_type
			message['parking_state'] = 'occupied'
			message['charging_socket_location'] = 'station'
			message['charging_state'] = 'not-charging'

		elif station_state == 'detached' and message_type == 'state_update':
			message['station_id'] = station_id
			message['station_state'] = station_state
			message['message_type'] = message_type
			message['parking_state'] = 'occupied'
			message['charging_socket_location'] = 'detached'
			message['charging_state'] = 'not-charging'

		elif station_state == 'charging' and message_type == 'state_update':
			message['station_id'] = station_id
			message['station_state'] = station_state
			message['message_type'] = message_type
			message['parking_state'] = 'occupied'
			message['charging_socket_location'] = 'car'
			message['charging_state'] = 'charging'

		elif station_state == 'charging':
			message['station_id'] = station_id
			message['station_state'] = station_state
			message['message_type'] = message_type
			message['parking_state'] = 'occupied'
			message['charging_socket_location'] = 'car'
			message['charging_state'] = 'charging'
			message['charging_percentage'] = post_data['percentage']
			message['charging_consumption_total'] = int(post_data['percentage']) - 10
			if message['charging_consumption_total'] == 0:
				message['charging_consumption_periodic'] = 0
			else:
				message['charging_consumption_periodic'] = 15

		elif station_state == 'charged' and message_type == 'state_update':
			message['station_id'] = station_id
			message['station_state'] = station_state
			message['message_type'] = message_type
			message['parking_state'] = 'occupied'
			message['charging_socket_location'] = 'car'
			message['charging_state'] = 'charged'

		elif station_state == 'charged':
			message['station_id'] = station_id
			message['station_state'] = station_state
			message['message_type'] = message_type
			message['parking_state'] = 'occupied'
			message['charging_socket_location'] = 'car'
			message['charging_state'] = 'charged'
			message['charging_percentage'] = 100
			message['charging_consumption_periodic'] = 0
			message['charging_consumption_total'] = 90

		for callback in mysql_response:
			make_post_request(message, callback[0])

	return json.dumps({'message':'success'}), 200, {'ContentType':'application/json'}


# SUPPORT THREADS
@app.route('/stations', methods=['GET', 'POST'])
def stations():
	if request.method == 'POST':
		try:
			post_data = json.loads(request.data)
		except Exception as e:
			return json.dumps({'message':'invalid-json-format'}), 400, {'ContentType':'application/json'}

		if 'station_id' not in post_data or 'new_state' not in post_data:
			return json.dumps({'message':'station_id-or-new_state-not-present'}), 400, {'ContentType':'application/json'}

		station_id = post_data['station_id']
		new_state = post_data['new_state']

		# convert state name to number
		state_to_dec = {"out-of-service" : 0, "available" : 1, "parked" : 2, "detached" : 3, "charging" : 4, "charged" : 5}
		if new_state in state_to_dec:
			station_state = str(state_to_dec[new_state])
		else:
			return json.dumps({'message':'invalid state'}), 400, {'ContentType':'application/json'}

		# get device_id from station_id
		device_eui = db_execute_one("SELECT GET_DEVICE_EUI('%s')" % (station_id))[0]

		# get device_id from station_id
		device_id = db_execute_one("SELECT GET_DEVICE_ID('%s')" % (station_id))[0]

		# get station number from station_id
		station_number = db_execute_one("SELECT GET_STATION_NUMBER('%s')" % (station_id))[0]

		# get permission to perform request
		delay_between_requests = 60
		permission_request = db_execute_one("SELECT PERFORM_REQUEST('%s','%s',%d)" % (station_id, device_eui, delay_between_requests))[0]
		if permission_request != 'success':
			return json.dumps({'message':permission_request}), 403, {'ContentType':'application/json'}

		# publish
		handle_publish(app.config['MQTT_USERNAME'] + '/devices/'+device_id+'/down', '{"state": '+station_state+', "station": '+station_number+'}')

		return json.dumps({'message':permission_request}), 200, {'ContentType':'application/json'}

	else:
		return render_template('stations.html')

# SUPPORT THREADS
@app.route('/actions/<dev_eui>', methods=['GET'])
def action_station(dev_eui):
	return render_template('action_station.html', device=dev_eui)


@mqtt.on_connect()
def handle_connect(client, userdata, flags, rc):
	try:
		mqtt.subscribe('+/devices/+/up')
	except Exception as e:
		print("Exeption: " + e)

@mqtt.on_message()
def handle_mqtt_message(client, userdata, message):
	payload = json.loads(message.payload)

	print(payload)

	dev_eui = payload['hardware_serial']

	for station_index in payload['payload_fields']:
		station = payload['payload_fields'][station_index]
		message_type = str(station['message_type'])

		station_state = station['station_state']
		station_state_change = station['station_state_change']
		station_id = dev_eui + '_' + str(station['station_id'])

		# these variables are state depended
		parking_state = convert_state(station_state, 'parking_state')
		charging_socket_location = convert_state(station_state, 'charging_socket_location')
		charging_state = convert_state(station_state, 'charging_state')

		# station state stored at the database
		get_current_state = db_execute_one("SELECT GET_STATION_STATE('%s')" % (station_id))[0]

		if message_type == "1":
			if station_state_change or station_state != get_current_state: # in case of a message lost about the state update
				# SEND UPDATE TO APP
				mysql_response = db_execute("SELECT * FROM GET_CALLBACKS")
				
				message = dict()
				message['message_type'] = 'state_update'
				message['station_id'] = station_id
				message['station_state'] = station_state
				message['parking_state'] = parking_state
				message['charging_socket_location'] = charging_socket_location
				message['charging_state'] = charging_state

				for callback in mysql_response:
					make_post_request(message, callback[0])

			db_execute("CALL STATION_STATE_CHANGE('%s','%s','%s','%s','%s')" % (station_id, station_state, parking_state, charging_socket_location, charging_state))

		elif message_type == "4":
			charging_percentage = station['charging_percentage']
			charging_consumption_periodic = station['charging_consumption_periodic']
			charging_consumption_total = station['charging_consumption_total']


			if station_state_change or station_state != get_current_state: # in case of a message lost about the state update
				# SEND UPDATE TO APP
				mysql_response = db_execute("SELECT * FROM GET_CALLBACKS")
				
				message = dict()
				if station_state == 'charging':
					message['message_type'] = 'charging_start'
				else:
					message['message_type'] = 'charging_finished'

				message['station_id'] = station_id
				message['station_state'] = station_state
				message['charging_percentage'] = charging_percentage
				message['charging_consumption_periodic'] = charging_consumption_periodic
				message['charging_consumption_total'] = charging_consumption_total

				for callback in mysql_response:
					print("MYSQL RESQ")
					make_post_request(message, callback[0])
			else:
				# SEND NORMAL INFO TO APP
				mysql_response = db_execute("SELECT * FROM GET_CALLBACKS")

				message = dict()
				if station_state == 'charging':
					message['message_type'] = 'charging_update'
				else:
					message['message_type'] = 'charging_finished'
					
				message['station_id'] = station_id
				message['station_state'] = station_state
				message['charging_percentage'] = charging_percentage
				message['charging_consumption_periodic'] = charging_consumption_periodic
				message['charging_consumption_total'] = charging_consumption_total

				for callback in mysql_response:
					print("MYSQL RESQ")
					make_post_request(message, callback[0])

			db_execute("CALL STATION_CHARGED_STATE('%s','%s','%s','%s','%s',%f,%f,%f)" % (station_id, station_state, parking_state, charging_socket_location, charging_state, charging_percentage, charging_consumption_periodic, charging_consumption_total))


#@mqtt.on_log()
#def handle_logging(client, userdata, level, buf):
#    print(level, buf)

########### flask section ###########

# index
@app.route('/')
def index():
    return 'Index page'

# SUPPORT THREAD
def make_post_request(message, URL):
	print("POST REQUEST: " + str(message))
	# perform POST request
	try:
		thread.start_new_thread( requests_post, (message, URL, ) )
	except Exception as e:
		print "Error: unable to start thread ," + str(e)

	return True


def requests_post(message, URL):
	res = requests.post(URL, json=message)


# devices
@app.route('/devices')
def devices():
	mysql_response = db_execute("SELECT * FROM GET_DEVICES")

	# return json dictionary
	list_devices = list()
	
	for device in mysql_response:

		list_stations = list()
		dev_eui = device[0]

		mysql_stations = db_execute("SELECT * FROM GET_STATIONS WHERE dev_eui = '%s'" % (dev_eui))

		for station in mysql_stations:

			json_station = '{"station_id": "%s", "dev_eui": "%s", "station_state": "%s", "station_type": "%s", "charging_state": "%s", "charging_percentage": %f, "charging_consumption_periodic": %f, "charging_consumption_total": %f, "charging_socket_location": "%s", "charging_socket_type": "%s", "charging_power": "%f", "parking_state": "%s", "update_time": "%s"}'
			list_stations.append(json.loads(json_station % station))
		
		# row parse
		json_device_test = '{"dev_eui": "%s", "dev_id": "%s", "description": "%s", "app_id": "%s", "latitude": %f, "longitude": %f, "altitude": %f, "stations": []}'
		json_device = json.loads(json_device_test % device[0:7])
		json_device['stations'] = list_stations

		# add row to the device list
		list_devices.append(json_device)

	return jsonify(list_devices)

# devices
@app.route('/devices/<dev_uid>')
def device_info(dev_uid):
	mysql_response = db_execute("SELECT * FROM GET_DEVICES WHERE dev_eui = '%s'" % dev_uid)

	# return json dictionary
	list_devices = list()
	
	for device in mysql_response:

		list_stations = list()
		dev_eui = device[0]

		mysql_stations = db_execute("SELECT * FROM GET_STATIONS WHERE dev_eui = '%s'" % (dev_eui))

		for station in mysql_stations:

			json_station = '{"station_id": "%s", "dev_eui": "%s", "station_state": "%s", "station_type": "%s", "charging_state": "%s", "charging_percentage": %f, "charging_consumption_periodic": %f, "charging_consumption_total": %f, "charging_socket_location": "%s", "charging_socket_type": "%s", "charging_power": "%f", "parking_state": "%s", "update_time": "%s"}'
			list_stations.append(json.loads(json_station % station))
		
		# row parse
		json_device_test = '{"dev_eui": "%s", "dev_id": "%s", "description": "%s", "app_id": "%s", "latitude": %f, "longitude": %f, "altitude": %f, "stations": []}'
		json_device = json.loads(json_device_test % device[0:7])
		json_device['stations'] = list_stations

		# add row to the device list
		list_devices.append(json_device)

	return jsonify(list_devices)


@app.route('/stations/<station_id>')
def stations_info(station_id):
	mysql_stations = db_execute("SELECT * FROM GET_STATIONS WHERE station_id = '%s'" % (station_id))[0]

	json_station = '{"station_id": "%s", "dev_eui": "%s", "station_state": "%s", "station_type": "%s", "charging_state": "%s", "charging_percentage": %f, "charging_consumption_periodic": %f, "charging_consumption_total": %f, "charging_socket_location": "%s", "charging_socket_type": "%s", "charging_power": "%f", "parking_state": "%s", "update_time": "%s"}'

	return jsonify(json.loads(json_station % mysql_stations))


# update_devices
'''@app.route('/update_devices')
def update_devices():
	url = 'http://eu.thethings.network:8084/applications/'+ app_id +'/devices'

	headers = {'Content-Type': 'application/json', 'Authorization': 'Key ' + app_access_key}
	payload = {'app_id':app_id}

	r = requests.get(url, headers=headers, data=json.dumps(payload))
    
	json_data = json.loads(r.text)

	# for each LoRa device
	for device in json_data['devices']:

		# add/update device info
		st_query = "CALL ADD_UPDATE_DEVICE('%s','%s','%s',%f,%f,%f,'%s')"
		st_data = (device.get('lorawan_device').get('dev_eui') or '', device.get('app_id') or '', device.get('dev_id') or '', float(device.get('latitude') or 0), float(device.get('longitude') or 0), float(device.get('altitude') or 0), device.get('description') or '')
		db_execute(st_query % st_data)

	return jsonify(json.loads('{"response": "Devices updated successfully"}'))'''

if __name__ == '__main__':
    socketio.run(app, host='0.0.0.0', port=80, use_reloader=False, debug=True)
