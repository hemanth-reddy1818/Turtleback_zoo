import sqlalchemy
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
    except sqlalchemy.exc.OperationalError as e:
        db.session.rollback()

        raise e


@app.route('/')
def test_query_execution():
    return render_template('index.html')


@app.route("/error")
def error():
    return render_template("error.html")


@app.route("/reports")
def reports():
    return render_template("reports.html")


@app.route("/asset")
def asset():
    return render_template("asset.html")


@app.route("/asset/employee", methods=["GET", "POST"])
def employee():
    query = """SELECT 
    e.Employee_ID,
    e.F_NAME,
    e.L_NAME,
    e.M_NAME,
    e.street,
    e.CITY,
    e.STATE,
    e.ZIP,
    e.JOB_TYPE,
    e.SUPERID,
    hr.rate AS Hourly_Rate
FROM 
    EMPLOYEE e
LEFT JOIN 
    hourly_rate hr ON e.H_ID = hr.Hourly_ID;"""
    result = execute_query(query)
    rows = result.fetchall()
    column_names = result.keys()
    data = [dict(zip(column_names, row)) for row in rows]
    print(data)

    return render_template("view_employee.html", data=data)


@app.route("/asset/employee/add", methods=["GET", "POST"])
def add_employee():
    if request.method == "POST":
        SSN = request.form.get("SSN")
        first_name = request.form.get("first_name")
        mid_name = request.form.get("middle_name")
        last_name = request.form.get("last_name")
        street = request.form.get("street")
        city = request.form.get("city")
        state = request.form.get("state")
        zipcode = request.form.get("Zipcode")
        job_type = request.form.get("Job_type")
        start_date = request.form.get("start_date")

        employee_salary = {
            "Veterinarian": 1,
            "Animal care specialist": 1,
            "Maintenance": 2,
            "Customer Service": 3,
            "Ticket seller": 4,
            "Manager": 5,
            "Sales": 6
        }

        # Check if both values are provided
        if SSN is not None and first_name is not None and mid_name is not None and last_name is not None and city is not None and state is not None and zipcode is not None and job_type is not None and start_date is not None:
            # Use parameterized query to avoid SQL injection
            query = "INSERT INTO Employee (SSN, F_NAME,L_NAME,M_NAME,street,CITY,STATE,ZIP,JOB_TYPE,SUPERID," \
                    "H_ID,con_id,Zoo_id,start_date) VALUES (" \
                    ":SSN, :first_name, :last_name, " \
                    ":middle_name,:street, :city ,:state, :zip, :type, :SUPERID, :H_ID, :con_id, :Zoo_id, :start_date); "
            params = {"SSN": SSN, "first_name": first_name, "middle_name": mid_name, "last_name": last_name,
                      "street": street,
                      "city": city, "state": state, "zip": zipcode, "type": job_type, "SUPERID": 1,
                      "H_ID": employee_salary[f"{job_type}"],
                      "con_id": None, "Zoo_id": None, "start_date": start_date}
            try:
                execute_query(query, params)
            except (sqlalchemy.exc.OperationalError, sqlalchemy.exc.IntegrityError) as e:
                data = e.args[0]
                return render_template("error.html", data=data)


            else:
                return redirect(url_for('employee'))

    return render_template("employee.html")


@app.route("/asset/employee/update", methods=["GET", "POST"])
def update_employee():
    if request.method == "POST":
        emp = {
            "Employee_ID": request.form.get("employee_id"),
            "SSN": request.form.get("SSN"),
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
          SSN='{emp['SSN']}',
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

        try:
            execute_query(update_query)
        except (sqlalchemy.exc.OperationalError, sqlalchemy.exc.IntegrityErro, IndexError) as e:
            data = e.args[0]
            return render_template("error.html", data=data)
        else:
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

        building_name = request.form.get("building_name")
        b_type = request.form.get("building_type")
        if building_name is not None and b_type is not None:
            # Use parameterized query to avoid SQL injection
            query = "INSERT INTO Building ( building_name, b_type) VALUES (" \
                    ":building_name, :building_type  ); "
            params = {"building_name": building_name, "building_type": b_type}
            try:
                execute_query(query, params)
            except (sqlalchemy.exc.OperationalError, sqlalchemy.exc.IntegrityError) as e:
                data = e.args[0]
                return render_template("error.html", data=data)
            else:
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

        try:
            execute_query(update_query)
        except (sqlalchemy.exc.OperationalError, sqlalchemy.exc.IntegrityError, IndexError) as e:
            data = e.args[0]
            return render_template("error.html", data=data)
        else:
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
            try:
                execute_query(query, params)
            except (sqlalchemy.exc.OperationalError, sqlalchemy.exc.IntegrityError) as e:
                data = e.args[0]
                return render_template("error.html", data=data)
            else:
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

        try:
            execute_query(update_query)
        except (sqlalchemy.exc.OperationalError, sqlalchemy.exc.IntegrityError) as e:
            data = e.args[0]
            return render_template("error.html", data=data)
        else:
            return redirect(url_for('view_rate'))
    return render_template("update_hourly_rate.html")


@app.route("/asset/animal", methods=["GET", "POST"])
def view_animal():
    query = "SELECT * FROM animal"
    result = execute_query(query)
    rows = result.fetchall()
    column_names = result.keys()
    data = [dict(zip(column_names, row)) for row in rows]
    print(data)

    return render_template("view_animal.html", data=data)


@app.route("/asset/animal/add", methods=["GET", "POST"])
def add_animal():
    if request.method == "POST":
        animal_name = request.form.get("animal_name")
        sp_name = request.form.get("sp_name")
        a_status = request.form.get("a_status")
        birth_year = request.form.get("birth_year")
        En_id = request.form.get("En_id")
        b_id = request.form.get("b_id")

        if animal_name is not None and sp_name is not None and a_status is not None and birth_year is not None and En_id is not None and b_id is not None:
            query = "INSERT INTO animal (a_status, birth_year,animal_name,sp_name,En_id,b_id" \
                    ") VALUES (" \
                    ":a_status, :birth_year, :animal_name, " \
                    ":sp_name,:En_id, :b_id ); "
            params = {"a_status": a_status, "birth_year": birth_year, "animal_name": animal_name, "sp_name": sp_name,
                      "En_id": En_id,
                      "b_id": b_id}

            try:
                execute_query(query, params)
            except (sqlalchemy.exc.OperationalError, sqlalchemy.exc.IntegrityError) as e:
                data = e.args[0]
                return render_template("error.html", data=data)


            else:
                return redirect(url_for('view_animal'))

    return render_template("add_animal.html")


@app.route("/asset/animal/update", methods=["GET", "POST"])
def update_animal():
    if request.method == "POST":
        animal = {
            "Animal_ID": request.form.get("Animal_ID"),
            "animal_name": str(request.form.get("animal_name")),
            "sp_name": str(request.form.get("sp_name")),
            "a_status": str(request.form.get("a_status")),
            "birth_year": request.form.get("birth_year"),
            "En_id": request.form.get("En_id"),
            "b_id": request.form.get("b_id"),
        }
        print(animal["Animal_ID"])
        query = f"select * from animal where Animal_ID={animal['Animal_ID']}"
        result = execute_query(query)
        rows = result.fetchall()
        column_names = result.keys()
        data = [dict(zip(column_names, row)) for row in rows]
        for key in animal.keys():
            if animal[f"{key}"] == "":
                animal[f"{key}"] = data[0][f"{key}"]
        print(animal)

        update_query = f"""
                            UPDATE Animal
                            SET
                            
                            
                              a_status= "{str(animal['a_status'])}",
                              birth_year= {animal['birth_year']},
                              animal_name= "{str(animal['animal_name'])}",
                              sp_name= "{str(animal['sp_name'])}",
                              En_id= {animal['En_id']},
                              b_id= {animal['b_id']}
                             


                            WHERE
                              Animal_ID = {animal['Animal_ID']};
                              
                            """
        try:
            execute_query(update_query)
        except (sqlalchemy.exc.OperationalError, sqlalchemy.exc.IntegrityError) as e:
            data = e.args[0]
            return render_template("error.html", data=data)
        else:
            return redirect(url_for('view_animal'))
    return render_template("update_animal.html")


@app.route("/attraction/view", methods=["GET", "POST"])
def view_attraction():
    animal_show_query = "SELECT * FROM animal_show"
    result = execute_query(animal_show_query)
    rows = result.fetchall()
    column_names = result.keys()
    animal_data = [dict(zip(column_names, row)) for row in rows]

    query = "SELECT * FROM zoo_admissions"
    result = execute_query(query)
    rows = result.fetchall()
    column_names = result.keys()
    data = [dict(zip(column_names, row)) for row in rows]

    return render_template("view_attraction.html", data=animal_data, data2=data)


@app.route("/attraction/add", methods=["GET", "POST"])
def add_attraction():
    if request.method == "POST":
        attraction_type = request.form.get("attraction_type")
        attraction_name = request.form.get("attraction_name")
        adult_price = request.form.get("adult_price")
        children_price = request.form.get("children_price")
        senior_price = request.form.get("senior_price")

        if attraction_type is not None and attraction_name is not None and adult_price is not None and children_price is not None and senior_price is not None:
            params = {"children_price": children_price, "show_name": attraction_name, "senior_price": senior_price,
                      "adult_price": adult_price,
                      "attraction_type": attraction_type}
            query1 = "INSERT INTO Revenue_types (r_type, b_id" \
                     ") VALUES (" \
                     ":attraction_type, 3 " \
                     "); "
            execute_query(query1, params)
            last_row_query = "SELECT * FROM Revenue_types ORDER BY Revenue_ID DESC LIMIT 1;"
            result = execute_query(last_row_query)
            rows = result.fetchall()
            column_names = result.keys()
            data = [dict(zip(column_names, row)) for row in rows]

            if attraction_type == "zoo_admission":
                query = f"INSERT INTO zoo_admissions (Z_ID,show_name,senior_price, adult_price,children_price" \
                        f") VALUES ({data[0]['Revenue_ID']}," \
                        ":show_name,:senior_price, :adult_price, :children_price " \
                        "); "
            else:
                query = "INSERT INTO animal_show (A_ID,show_name,senior_price, adult_price,children_price" \
                        f") VALUES ({data[0]['Revenue_ID']}," \
                        ":show_name,:senior_price, :adult_price, :children_price " \
                        "); "

            try:
                execute_query(query, params)
            except (sqlalchemy.exc.OperationalError, sqlalchemy.exc.IntegrityError) as e:
                data = e.args[0]
                return render_template("error.html", data=data)
            else:
                return redirect(url_for('view_attraction'))

    return render_template("add_attraction.html")


@app.route("/daily_report", methods=["GET", "POST"])
def daily_report():
    # Initialize data to None
    data = None

    if request.method == "POST":
        desired_date = request.form.get("desired_date")
        if desired_date is not None:
            # Use parameterized query to avoid SQL injection

            query = f"""
                -- Select Zoo Admissions data
                SELECT
                    'Zoo Admissions' AS Event_Type,
                    za.Z_ID AS Revenue_id,
                    za.show_name as name,
                    ((za.senior_price * ret.sr_citizen_tickets_sold) +
                     (za.adult_price * ret.adult_tickets_sold) +
                     (za.children_price * ret.children_tickets_sold)) AS Revenue
                FROM
                    zoo_admissions za, revenue_events_tickets ret
                WHERE
                    za.Z_ID = ret.Rev_id AND ret.show_Date = :desired_date

                UNION

                -- Select Animal Shows data
                SELECT
                    'Animal shows' AS Event_Type,
                    ash.A_ID AS Revenue_id,
                    ash.show_name as name,
                    ((ash.senior_price * ret.sr_citizen_tickets_sold) +
                     (ash.adult_price * ret.adult_tickets_sold) +
                     (ash.children_price * ret.children_tickets_sold)) AS Revenue
                FROM
                    animal_show ash, revenue_events_tickets ret
                WHERE
                    ash.A_ID = ret.Rev_id AND ret.show_Date = :desired_date

                UNION

                -- Select Concessions data
                SELECT
                
                    'concession' AS Event_Type,
                    cs.C_ID AS Revenue_id,
                    cs.product as name,
                    ((cs.price * ret.sr_citizen_tickets_sold) +
                     (cs.price * ret.adult_tickets_sold) +
                     (cs.price * ret.children_tickets_sold)) AS Revenue
                FROM
                    concession cs, revenue_events_tickets ret
                WHERE
                    cs.C_ID = ret.Rev_id AND ret.show_Date = :desired_date;
            """

            # Execute the query with the parameters
            params = {"desired_date": desired_date}
            # Execute the query
            result = execute_query(query, params)

            # Fetch data and column names
            rows = result.fetchall()
            column_names = result.keys()

            # Convert the result into a list of dictionaries
            data = [dict(zip(column_names, row)) for row in rows]
            total = 0

            for event in data:
                total += event["Revenue"]

    return render_template("daily_report.html", data=data, total=total)


@app.route("/attendance_report", methods=["GET", "POST"])
def attendance_report():
    # Initialize data to None
    data = None

    if request.method == "POST":
        desired_date = request.form.get("desired_date")
        if desired_date is not None:
            # Use parameterized query to avoid SQL injection

            query = f"""
                -- Select Zoo Admissions data
                SELECT
                    'Zoo Admissions' AS Event,
                    za.Z_ID AS Revenue_id,
                     ret.sr_citizen_tickets_sold as senior_citizens,
                      ret.adult_tickets_sold as adults,
                    ret.children_tickets_sold AS children
                FROM
                    zoo_admissions za, revenue_events_tickets ret
                WHERE
                    za.Z_ID = ret.Rev_id AND ret.show_Date = :desired_date

                UNION

                -- Select Animal Shows data
                SELECT
                    'Animal shows' AS Event,
                    ash.A_ID AS Revenue,
                    ret.sr_citizen_tickets_sold as senior_citizens,
                    ret.adult_tickets_sold as adults,
                    ret.children_tickets_sold AS children
                FROM
                    animal_show ash, revenue_events_tickets ret
                WHERE
                    ash.A_ID = ret.Rev_id AND ret.show_Date = :desired_date

                UNION

                -- Select Concessions data
                SELECT
                    cs.product AS Event,
                    cs.C_ID AS Revenue_id,
                    ret.sr_citizen_tickets_sold as senior_citizens,
                    ret.adult_tickets_sold as adults,
                    ret.children_tickets_sold AS children
                FROM
                    concession cs, revenue_events_tickets ret
                WHERE
                    cs.C_ID = ret.Rev_id AND ret.show_Date = :desired_date;
            """

            # Execute the query with the parameters
            params = {"desired_date": desired_date}
            # Execute the query
            result = execute_query(query, params)

            # Fetch data and column names
            rows = result.fetchall()
            column_names = result.keys()

            # Convert the result into a list of dictionaries
            data = [dict(zip(column_names, row)) for row in rows]

    return render_template("attendance_report.html", data=data)


@app.route("/population_report")
def population_report():
    query = """SELECT Species.Species_name AS Species, a_status, COUNT(*) AS Total_Count, SUM(Species.Food_cost) AS Total_Food_Cost
          FROM Animal
          JOIN Species ON Animal.sp_name = Species.Species_name
          GROUP BY Species.Species_name, a_status;
          """
    result = execute_query(query)

    # Fetch data and column names
    rows = result.fetchall()
    column_names = result.keys()

    # Convert the result into a list of dictionaries
    data = [dict(zip(column_names, row)) for row in rows]
    return render_template("population_report.html", data=data)


@app.route("/employee_report")
def employee_report():
    query = """
    SELECT Species.Species_name AS Species, hourly_rate.rate * 40 * 4 AS Employee_cost
    FROM Species, Employee, hourly_rate
    WHERE Species.emp_id = Employee.Employee_id
        AND Employee.H_ID = hourly_rate.Hourly_ID
    """

    result = execute_query(query)
    # Handle the result as needed

    # Fetch data and column names
    rows = result.fetchall()
    column_names = result.keys()

    # Convert the result into a list of dictionaries
    data = [dict(zip(column_names, row)) for row in rows]
    return render_template("employee_report.html", data=data)


@app.route("/top3", methods=["GET", "POST"])
def top_three():
    if request.method == "POST":
        start_date = request.form.get("start_date")
        end_date = request.form.get("end_date")
        if start_date is not None and end_date is not None:
            query = f"""
            
               SELECT za.Z_ID as show_id,za.show_name as show_name,'zoo admissions' AS Attraction,ret.show_Date as show_date, za.Adult_price*ret.adult_tickets_sold + za.Senior_price*ret.sr_citizen_tickets_sold + za.children_price*ret.children_tickets_sold AS Revenue
               FROM  zoo_admissions za,revenue_events_tickets ret
            where za.Z_ID=ret.Rev_id and ret.show_Date between '{start_date}' and '{end_date}'
               union

                SELECT ash.A_ID as show_id,ash.show_name as show_name,'Animal show' AS Attraction,ret.show_Date as show_date, ash.Adult_price*ret.adult_tickets_sold + ash.Senior_price*ret.sr_citizen_tickets_sold + ash.children_price*ret.children_tickets_sold AS Revenue
                FROM  animal_show ash,revenue_events_tickets ret
                where ash.A_ID=ret.Rev_id and ret.show_Date between '{start_date}' and '{end_date}'

                ORDER BY Revenue DESC
                LIMIT 3;

            """
            result = execute_query(query)

            # Fetch data and column names
            rows = result.fetchall()
            column_names = result.keys()

            # Convert the result into a list of dictionaries
            data = [dict(zip(column_names, row)) for row in rows]
            return render_template("top_three.html", data=data)


@app.route("/top5", methods=["GET", "POST"])
def top_five():
    if request.method == "POST":

        month = request.form.get("month")
        month = str(month)
        print(month)
        month_number = {
            "january": 1,
            "february": 2,
            "march": 3,
            "april": 4,
            "may": 5,
            "june": 6,
            "july": 7,
            "august": 8,
            "september": 9,
            "october": 10,
            "november": 11,
            "december": 12
        }
        print(month_number[f'{month.lower()}'])

        if month is not None:
            query = f"""
            
     select t.show_Date,sum(t.Revenue) as Total_revenue from
        (
        SELECT
        'Zoo Admissions' AS Event_Type,
        za.Z_ID AS Revenue_id,
        za.show_name as name,
        ret.show_Date as show_Date,
        ((za.senior_price * ret.sr_citizen_tickets_sold) +
        (za.adult_price * ret.adult_tickets_sold) +
        (za.children_price * ret.children_tickets_sold)) AS Revenue
        FROM
        zoo_admissions za, revenue_events_tickets ret
        WHERE
        za.Z_ID = ret.Rev_id AND month(ret.show_Date) ={month_number[f'{month.lower()}']}
        
        
        UNION
        
        -- Select Animal Shows data
        SELECT
        'Animal shows' AS Event_Type,
        ash.A_ID AS Revenue_id,
        ash.show_name as name,
        ret.show_Date as show_Date,
        ((ash.senior_price * ret.sr_citizen_tickets_sold) +
        (ash.adult_price * ret.adult_tickets_sold) +
        (ash.children_price * ret.children_tickets_sold)) AS Revenue
        FROM
        animal_show ash, revenue_events_tickets ret
        WHERE
        ash.A_ID = ret.Rev_id AND month(ret.show_Date) ={month_number[f'{month.lower()}']}
        UNION
        
        -- Select Concessions data
        SELECT
                        
        'concession' AS Event_Type,
        cs.C_ID AS Revenue_id,
        cs.product as name,
        ret.show_Date as show_Date,
        ((cs.price * ret.sr_citizen_tickets_sold) +
        (cs.price * ret.adult_tickets_sold) +
        (cs.price * ret.children_tickets_sold)) AS Revenue
        FROM
        concession cs, revenue_events_tickets ret
        WHERE
        cs.C_ID = ret.Rev_id AND month(ret.show_Date) ={month_number[f'{month.lower()}']}
        )as t
        group by t.show_Date
        order by Total_revenue desc
        limit 5;
        
        






            """

            result = execute_query(query)
            # Handle the result as needed

            # Fetch data and column names
            rows = result.fetchall()
            column_names = result.keys()

            # Convert the result into a list of dictionaries
            data = [dict(zip(column_names, row)) for row in rows]
            print(data)
    return render_template("top_five.html", data=data)


@app.route("/average_revenue", methods=["GET", "POST"])
def average_revenue():
    if request.method == "POST":
        start_date = request.form.get("start_date")
        end_date = request.form.get("end_date")
        if start_date is not None and end_date is not None:
            query = f"""

                 select D.Attraction as sources,avg(D.Revenue) as average_revenue,sum(D.participation) as Total_participation
                 from(
                 SELECT za.Z_ID as show_id,'zoo admissions' AS Attraction,ret.show_Date as show_date, za.Adult_price*ret.adult_tickets_sold + za.Senior_price*ret.sr_citizen_tickets_sold + za.children_price*ret.children_tickets_sold AS Revenue,ret.adult_tickets_sold+ret.sr_citizen_tickets_sold+ret.children_tickets_sold as participation
                 FROM  zoo_admissions za,revenue_events_tickets ret
                 where za.Z_ID=ret.Rev_id and ret.show_Date between'{start_date}' and '{end_date}'
                 union

                 SELECT ash.A_ID as show_id,'Animal show' AS Attraction,ret.show_Date as show_date, ash.Adult_price*ret.adult_tickets_sold + ash.Senior_price*ret.sr_citizen_tickets_sold + ash.children_price*ret.children_tickets_sold AS Revenue,ret.adult_tickets_sold+ret.sr_citizen_tickets_sold+ret.children_tickets_sold as participation
                 FROM  animal_show ash,revenue_events_tickets ret
                 where ash.A_ID=ret.Rev_id and ret.show_Date between '{start_date}' and '{end_date}'

                 union

                 SELECT con.C_ID as show_id,con.product AS Attraction,ret.show_Date as show_date, con.price*ret.adult_tickets_sold + con.price*ret.sr_citizen_tickets_sold + con.price*ret.children_tickets_sold AS Revenue,ret.adult_tickets_sold+ret.sr_citizen_tickets_sold+ret.children_tickets_sold as participation
                 FROM  concession con,revenue_events_tickets ret
                 where con.C_ID=ret.Rev_id and ret.show_Date between '{start_date}' and '{end_date}'



                 ) as D
                group by D.Attraction;



               """
            result = execute_query(query)

            # Fetch data and column names
            rows = result.fetchall()
            column_names = result.keys()

            # Convert the result into a list of dictionaries
            data = [dict(zip(column_names, row)) for row in rows]
            return render_template("average_revenue.html", data=data)


@app.route("/add_show", methods=["GET", "POST"])
def add_show():
    if request.method == "POST":
        rev_id = request.form.get("rev_id")
        show_Date = request.form.get("show_Date")
        show_time = request.form.get("show_time")
        adult_tickets_sold = request.form.get("adult_tickets_sold")
        children_tickets_sold = request.form.get("children_tickets_sold")
        sr_citizen_tickets_sold = request.form.get("sr_citizen_tickets_sold")
        if rev_id is not None and show_Date is not None and show_time is not None and adult_tickets_sold is not None and children_tickets_sold is not None and sr_citizen_tickets_sold is not None:
            params = {"Rev_id": rev_id, "show_Date": show_Date, "show_time": show_time,
                      "adult_tickets_sold": adult_tickets_sold, "children_tickets_sold": children_tickets_sold,
                      "sr_citizen_tickets_sold": sr_citizen_tickets_sold}
            query = f"""INSERT INTO revenue_events_tickets (Rev_id,show_Date,show_time, adult_tickets_sold,
            children_tickets_sold,sr_citizen_tickets_sold) VALUES (:Rev_id, :show_Date, :show_time, :adult_tickets_sold,
            :children_tickets_sold, :sr_citizen_tickets_sold);  """

            execute_query(query, params)
            return redirect(url_for('view_show'))
    return render_template("add_completed_show.html")


@app.route("/view_show", methods=["GET", "POST"])
def view_show():
    query = """
    select ret.Rev_id as Revenue_id,za.show_name,'zoo_admission' as show_type,ret.show_Date,ret.show_time,ret.adult_tickets_sold,ret.children_tickets_sold,ret.sr_citizen_tickets_sold from
    revenue_events_tickets ret ,zoo_admissions za
    where za.Z_ID=ret.Rev_id
    union
    select ret.Rev_id as Revenue_id,ash.show_name,'animal_show' as show_type,ret.show_Date,ret.show_time,ret.adult_tickets_sold,ret.children_tickets_sold,ret.sr_citizen_tickets_sold from
    revenue_events_tickets ret ,animal_show ash
    where ash.A_ID=ret.Rev_id
    union
    select ret.Rev_id as Revenue_id,con.product,'concession' as show_type,ret.show_Date,ret.show_time,ret.adult_tickets_sold,ret.children_tickets_sold,ret.sr_citizen_tickets_sold from
    revenue_events_tickets ret ,concession con
    where con.C_ID=ret.Rev_id
    order by Revenue_id;

    """
    result = execute_query(query)
    rows = result.fetchall()
    column_names = result.keys()
    data = [dict(zip(column_names, row)) for row in rows]
    return render_template("view_completed_shows.html", data=data)


@app.route("/daily_attraction_report", methods=["GET", "POST"])
def daily_attraction_report():
    data = None

    if request.method == "POST":
        desired_date = request.form.get("desired_date")
        if desired_date is not None:
            # Use parameterized query to avoid SQL injection

            query = f"""
                   -- Select Zoo Admissions data
                   SELECT
                       'Zoo Admissions' AS Event_Type,
                       za.Z_ID AS Revenue_id,
                       za.show_name as name,
                       ((za.senior_price * ret.sr_citizen_tickets_sold) +
                        (za.adult_price * ret.adult_tickets_sold) +
                        (za.children_price * ret.children_tickets_sold)) AS Revenue
                   FROM
                       zoo_admissions za, revenue_events_tickets ret
                   WHERE
                       za.Z_ID = ret.Rev_id AND ret.show_Date = :desired_date

                   UNION

                   -- Select Animal Shows data
                   SELECT
                       'Animal shows' AS Event_Type,
                       ash.A_ID AS Revenue_id,
                       ash.show_name as name,
                       ((ash.senior_price * ret.sr_citizen_tickets_sold) +
                        (ash.adult_price * ret.adult_tickets_sold) +
                        (ash.children_price * ret.children_tickets_sold)) AS Revenue
                   FROM
                       animal_show ash, revenue_events_tickets ret
                   WHERE
                       ash.A_ID = ret.Rev_id AND ret.show_Date = :desired_date

                 

               
               """

            # Execute the query with the parameters
            params = {"desired_date": desired_date}
            # Execute the query
            result = execute_query(query, params)

            # Fetch data and column names
            rows = result.fetchall()
            column_names = result.keys()

            # Convert the result into a list of dictionaries
            data = [dict(zip(column_names, row)) for row in rows]
            total = 0

            for event in data:
                total += event["Revenue"]

    return render_template("daily_attraction_report.html", data=data, total=total)


@app.route("/daily_concession_report", methods=["POST", "GET"])
def daily_concession_report():
    data = None

    if request.method == "POST":
        desired_date = request.form.get("desired_date")
        if desired_date is not None:
            # Use parameterized query to avoid SQL injection

            query = f"""
                      -- Select Zoo Admissions data
                      SELECT
                          
                          con.C_ID AS Revenue_id,
                          con.product as name,
                          ((con.price * ret.sr_citizen_tickets_sold) +
                           (con.price * ret.adult_tickets_sold) +
                           (con.price * ret.children_tickets_sold)) AS Revenue
                      FROM
                          concession con, revenue_events_tickets ret
                      WHERE
                          con.C_ID = ret.Rev_id AND ret.show_Date = :desired_date

                    



                  """

            # Execute the query with the parameters
            params = {"desired_date": desired_date}
            # Execute the query
            result = execute_query(query, params)

            # Fetch data and column names
            rows = result.fetchall()
            column_names = result.keys()

            # Convert the result into a list of dictionaries
            data = [dict(zip(column_names, row)) for row in rows]
            total = 0

            for event in data:
                total += event["Revenue"]

    return render_template("daily_concession_report.html", data=data, total=total)


if __name__ == '__main__':
    app.run(debug=True)
