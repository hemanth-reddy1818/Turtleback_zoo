from flask import Flask, render_template, request, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import text
import pymysql, cryptography

pymysql.install_as_MySQLdb()

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:1234567890@localhost/turtleback_zoo'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)


def execute_query(query, params=None):
    try:
        result = db.session.execute(text(query), params)
        db.session.commit()
        return result
    except Exception as e:
        db.session.rollback()
        raise e


@app.route('/')
def test_query_execution():
    return render_template('index.html')


@app.route("/about")
def about():
    return render_template("about.html")


@app.route("/asset")
def asset():
    return render_template("asset.html")


@app.route("/asset/employee", methods=["GET", "POST"])
def employee():
    query = "SELECT * FROM Employee"
    result = execute_query(query)
    rows = result.fetchall()
    column_names = result.keys()
    data = [dict(zip(column_names, row)) for row in rows]
    print(data)

    return render_template("view_employee.html", data=data)


@app.route("/asset/employee/add", methods=["GET", "POST"])
def add_employee():
    if request.method == "POST":
        emp_id = request.form.get("employee_id")
        first_name = request.form.get("first_name")
        mid_name = request.form.get("middle_name")
        last_name = request.form.get("last_name")
        street = request.form.get("street")
        city = request.form.get("city")
        state = request.form.get("state")
        zipcode = request.form.get("Zipcode")
        job_type = request.form.get("Job_type")

        # Check if both values are provided
        if emp_id is not None and first_name is not None and mid_name is not None and last_name is not None and city is not None and state is not None and zipcode is not None and job_type is not None:
            # Use parameterized query to avoid SQL injection
            query = "INSERT INTO Employee (Employee_id, F_NAME,L_NAME,M_NAME,street,CITY,STATE,ZIP,JOB_TYPE,SUPERID," \
                    "H_ID,con_id,Zoo_id) VALUES (" \
                    ":emp_id, :first_name, :last_name, " \
                    ":middle_name,:street, :city ,:state, :zip, :type, :SUPERID, :H_ID, :con_id, :Zoo_id); "
            params = {"emp_id": emp_id, "first_name": first_name, "middle_name": mid_name, "last_name": last_name,
                      "street": street,
                      "city": city, "state": state, "zip": zipcode, "type": job_type, "SUPERID": None, "H_ID": None,
                      "con_id": None, "Zoo_id": None}
            execute_query(query, params)
            return redirect(url_for('employee'))

    return render_template("employee.html")


@app.route("/asset/employee/update", methods=["GET", "POST"])
def update_employee():
    if request.method == "POST":
        emp = {
            "Employee_ID": request.form.get("employee_id"),
            "F_NAME": request.form.get("first_name"),
            "M_NAME": request.form.get("middle_name"),
            "L_NAME": request.form.get("last_name"),
            "street": request.form.get("street"),
            "CITY": request.form.get("city"),
            "STATE": request.form.get("state"),
            "ZIP": request.form.get("Zipcode"),
            "JOB_TYPE": request.form.get("Job_type")
        }
        query = f"select * from Employee where Employee_ID={emp['Employee_ID']}"
        result = execute_query(query)
        rows = result.fetchall()
        column_names = result.keys()
        data = [dict(zip(column_names, row)) for row in rows]

        for key in emp.keys():
            if emp[f"{key}"] == "":
                emp[f"{key}"] = data[0][f"{key}"]

        print(emp)

        update_query = f"""
        UPDATE EMPLOYEE
        SET
          F_NAME = '{emp['F_NAME']}',
          L_NAME = '{emp['L_NAME']}',
          M_NAME = '{emp['M_NAME']}',
          street = '{emp['street']}',
          CITY = '{emp['CITY']}',
          STATE = '{emp['STATE']}',
          ZIP = '{emp['ZIP']}',
          JOB_TYPE = '{emp['JOB_TYPE']}'
        WHERE
          Employee_ID = {emp['Employee_ID']};
        """

        execute_query(update_query)
        return redirect(url_for('employee'))

    return render_template("update_employee.html")


@app.route("/asset/building", methods=["GET", "POST"])
def view_building():
    query = "SELECT * FROM Building"
    result = execute_query(query)
    rows = result.fetchall()
    column_names = result.keys()
    data = [dict(zip(column_names, row)) for row in rows]

    return render_template("view_building.html", data=data)


@app.route("/asset/building/add", methods=["GET", "POST"])
def add_building():
    if request.method == "POST":
        Building_ID = request.form.get("building_id")
        building_name = request.form.get("building_name")
        b_type = request.form.get("building_type")
        if Building_ID is not None and building_name is not None and b_type is not None:
            # Use parameterized query to avoid SQL injection
            query = "INSERT INTO Building (Building_ID, building_name, b_type) VALUES (" \
                    ":Building_ID, :building_name, :building_type  ); "
            params = {"Building_ID": Building_ID, "building_name": building_name, "building_type": b_type}
            execute_query(query, params)
            return redirect(url_for('view_building'))
    return render_template("add_building.html")


@app.route("/asset/building/update", methods=["GET", "POST"])
def update_building():
    if request.method == "POST":
        build = {
            "Building_ID": request.form.get("building_id"),
            "building_name": request.form.get("building_name"),
            "b_type": request.form.get("b_type")
        }

        query = f"select * from Building where Building_ID={build['Building_ID']}"
        result = execute_query(query)
        rows = result.fetchall()
        column_names = result.keys()
        data = [dict(zip(column_names, row)) for row in rows]

        for key in build.keys():
            if build[f"{key}"] == "":
                build[f"{key}"] = data[0][f"{key}"]
        update_query = f"""
               UPDATE Building
               SET
                 building_name = '{build["building_name"]}',
                 b_type = '{build["b_type"]}'
               
                
               WHERE
                 Building_ID = {build['Building_ID']};
               """

        execute_query(update_query)
        return redirect(url_for('view_building'))
    return render_template("update_building.html")


@app.route("/asset/rate", methods=["GET", "POST"])
def view_rate():
    query = "SELECT * FROM hourly_rate"
    result = execute_query(query)
    rows = result.fetchall()
    column_names = result.keys()
    data = [dict(zip(column_names, row)) for row in rows]

    return render_template("view_hourly_rates.html", data=data)


@app.route("/asset/rate/add", methods=["GET", "POST"])
def add_rate():
    if request.method == "POST":
        Hourly_id = request.form.get("Hourly_ID")
        rate = request.form.get("rate")
        if Hourly_id is not None and rate is not None:
            query = "INSERT INTO hourly_rate(Hourly_ID, rate) VALUES (" \
                    ":Hourly_ID, :rate  ); "
            params = {"Hourly_ID": Hourly_id, "rate": rate}
            execute_query(query, params)

            return redirect(url_for('view_rate'))
    return render_template("add_hourly_rates.html")


@app.route("/asset/rate/update", methods=["GET", "POST"])
def update_rate():
    if request.method == "POST":
        rate = {
            "Hourly_ID": request.form.get("Hourly_ID"),
            "rate": request.form.get("rate"),

        }

        query = f"select * from hourly_rate where Hourly_ID={rate['Hourly_ID']}"
        result = execute_query(query)
        rows = result.fetchall()
        column_names = result.keys()
        data = [dict(zip(column_names, row)) for row in rows]
        for key in rate.keys():
            if rate[f"{key}"] == "":
                rate[f"{key}"] = data[0][f"{key}"]
        update_query = f"""
                     UPDATE hourly_rate
                     SET
                       rate = '{rate["rate"]}'
                     


                     WHERE
                       Hourly_ID = {rate['Hourly_ID']};
                     """

        execute_query(update_query)
        return redirect(url_for('view_rate'))
    return render_template("update_hourly_rate.html")


@app.route("/asset/animal", methods=["GET", "POST"])
def view_animal():
    query = "SELECT * FROM animal"
    result = execute_query(query)
    rows = result.fetchall()
    column_names = result.keys()
    data = [dict(zip(column_names, row)) for row in rows]

    return render_template("view_animal.html", data=data)


@app.route("/asset/animal/add", methods=["GET", "POST"])
def add_animal():
    pass


@app.route("/asset/animal/update", methods=["GET", "POST"])
def update_animal():
    pass


if __name__ == '__main__':
    app.run(debug=True)
