from flask import Flask, render_template, request, redirect
import MySQLdb

app = Flask(__name__)

# Connect to MySQL
db = MySQLdb.connect(
    host="localhost",
    user="root",
    passwd="YOUR_MYSQL_PASSWORD",
    db="DBMS"
)
cursor = db.cursor()

@app.route('/')
def home():
    cursor.execute("SELECT * FROM Vehicles")
    vehicles = cursor.fetchall()
    return render_template('index.html', vehicles=vehicles)

# Vehicle routes
@app.route('/add_vehicle', methods=['POST'])
def add_vehicle():
    brand = request.form['brand']
    model = request.form['model']
    color = request.form['color']
    status = request.form['status']
    insurance = request.form['insurance']

    query = "INSERT INTO Vehicles (Brand, Model, Color, Status, InsuranceStatus) VALUES (%s, %s, %s, %s, %s)"
    cursor.execute(query, (brand, model, color, status, insurance))
    db.commit()
    return redirect('/')

# Owner routes
@app.route('/owners')
def owners():
    cursor.execute("SELECT * FROM Owners")
    owners = cursor.fetchall()
    return render_template('owners.html', owners=owners)

@app.route('/add_owner', methods=['POST'])
def add_owner():
    fullname = request.form['fullname']
    contact = request.form['contact']
    email = request.form['email']
    address = request.form['address']

    query = "INSERT INTO Owners (FullName, ContactNumber, Email, Address) VALUES (%s, %s, %s, %s)"
    cursor.execute(query, (fullname, contact, email, address))
    db.commit()
    return redirect('/owners')

# Vehicle-Owner relationship routes
@app.route('/vehicle_owners')
def vehicle_owners():
    cursor.execute("""
        SELECT vo.VehicleOwnerID, v.Brand, v.Model, o.FullName, vo.PurchaseDate 
        FROM Vehicle_Owners vo
        JOIN Vehicles v ON vo.VehicleID = v.VehicleID
        JOIN Owners o ON vo.OwnerID = o.OwnerID
    """)
    vehicle_owners = cursor.fetchall()
    return render_template('vehicle_owners.html', vehicle_owners=vehicle_owners)

@app.route('/add_vehicle_owner', methods=['POST'])
def add_vehicle_owner():
    vehicle_id = request.form['vehicle_id']
    owner_id = request.form['owner_id']
    purchase_date = request.form['purchase_date']

    query = "INSERT INTO Vehicle_Owners (VehicleID, OwnerID, PurchaseDate) VALUES (%s, %s, %s)"
    cursor.execute(query, (vehicle_id, owner_id, purchase_date))
    db.commit()
    return redirect('/vehicle_owners')

# Insurance routes
@app.route('/insurance')
def insurance():
    cursor.execute("""
        SELECT i.InsuranceID, v.Brand, v.Model, i.InsuranceCompany, i.PolicyNumber, i.ExpiryDate, i.Status
        FROM Insurance i
        JOIN Vehicles v ON i.VehicleID = v.VehicleID
    """)
    insurance = cursor.fetchall()
    return render_template('insurance.html', insurance=insurance)

@app.route('/add_insurance', methods=['POST'])
def add_insurance():
    vehicle_id = request.form['vehicle_id']
    company = request.form['company']
    policy_number = request.form['policy_number']
    expiry_date = request.form['expiry_date']
    status = request.form['status']

    query = "INSERT INTO Insurance (VehicleID, InsuranceCompany, PolicyNumber, ExpiryDate, Status) VALUES (%s, %s, %s, %s, %s)"
    cursor.execute(query, (vehicle_id, company, policy_number, expiry_date, status))
    db.commit()
    return redirect('/insurance')

# Service History routes
@app.route('/service_history')
def service_history():
    cursor.execute("""
        SELECT s.ServiceID, v.Brand, v.Model, s.ServiceDate, s.ServiceDetails, s.Cost, s.ServiceCenter
        FROM Service_History s
        JOIN Vehicles v ON s.VehicleID = v.VehicleID
    """)
    service_history = cursor.fetchall()
    return render_template('service_history.html', service_history=service_history)

@app.route('/add_service', methods=['POST'])
def add_service():
    vehicle_id = request.form['vehicle_id']
    service_date = request.form['service_date']
    service_details = request.form['service_details']
    cost = request.form['cost']
    service_center = request.form['service_center']

    query = "INSERT INTO Service_History (VehicleID, ServiceDate, ServiceDetails, Cost, ServiceCenter) VALUES (%s, %s, %s, %s, %s)"
    cursor.execute(query, (vehicle_id, service_date, service_details, cost, service_center))
    db.commit()
    return redirect('/service_history')

# Fuel Log routes
@app.route('/fuel_log')
def fuel_log():
    cursor.execute("""
        SELECT f.FuelLogID, v.Brand, v.Model, f.Date, f.FuelType, f.Amount, f.Cost
        FROM Fuel_Log f
        JOIN Vehicles v ON f.VehicleID = v.VehicleID
    """)
    fuel_logs = cursor.fetchall()
    return render_template('fuel_log.html', fuel_logs=fuel_logs)

@app.route('/add_fuel_log', methods=['POST'])
def add_fuel_log():
    vehicle_id = request.form['vehicle_id']
    date = request.form['date']
    fuel_type = request.form['fuel_type']
    amount = request.form['amount']
    cost = request.form['cost']

    query = "INSERT INTO Fuel_Log (VehicleID, Date, FuelType, Amount, Cost) VALUES (%s, %s, %s, %s, %s)"
    cursor.execute(query, (vehicle_id, date, fuel_type, amount, cost))
    db.commit()
    return redirect('/fuel_log')

if __name__ == "__main__":
    app.run(debug=True)
