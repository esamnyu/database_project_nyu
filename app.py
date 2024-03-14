from flask import Flask, request, render_template, redirect, url_for
import pymysql

app = Flask(__name__)

# Configure Database Connection
db_connection = pymysql.connect(
    host='localhost',
    user='root',
    password='Es91110291!',
    db='OnlineBookstore',
    charset='utf8mb4'
)

@app.route('/')
def index():
    conn = db_connection.cursor(pymysql.cursors.DictCursor)
    conn.execute("SELECT * FROM Users")
    users = conn.fetchall()
    conn.close()
    return render_template('index.html', users=users)

@app.route('/create', methods=['GET', 'POST'])
def create():
    if request.method == 'GET':
        return render_template('create.html')
    else:
        name = request.form['name']
        email = request.form['email']
        password = request.form['password']
        conn = db_connection.cursor()
        sql = "INSERT INTO Users (Name, Email, Password) VALUES (%s, %s, %s)"
        conn.execute(sql, (name, email, password))
        db_connection.commit()
        conn.close()
        return redirect(url_for('index'))

@app.route('/update/<int:id>', methods=['GET', 'POST'])
def update(id):
    conn = db_connection.cursor(pymysql.cursors.DictCursor)
    if request.method == 'POST':
        # Get the updated values from the form
        name = request.form['name']
        email = request.form['email']
        password = request.form['password']  # You should handle password hashing
        
        # Update the record in the database
        sql = "UPDATE Users SET Name=%s, Email=%s, Password=%s WHERE UserID=%s"
        conn.execute(sql, (name, email, password, id))
        db_connection.commit()
        conn.close()
        return redirect(url_for('index'))
    else:
        # GET method: pre-populate the form with the existing user data
        conn.execute("SELECT * FROM Users WHERE UserID=%s", (id,))
        user = conn.fetchone()
        conn.close()
        return render_template('update.html', user=user)


@app.route('/delete/<int:id>', methods=['POST'])
def delete(id):
    conn = db_connection.cursor()
    # Execute a query to delete the user with the given id
    sql = "DELETE FROM Users WHERE UserID=%s"
    conn.execute(sql, (id,))
    db_connection.commit()
    conn.close()
    # Redirect to the home page (or wherever you list the users) after deletion
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True)
