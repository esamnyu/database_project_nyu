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

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        # Here, you would add the logic to validate the user's credentials
        # For example, checking the email and password against a database
        # If login is successful:
        return redirect(url_for('books'))  # Redirect to the books view
    else:
        return render_template('login.html')  # The template for the GET request

@app.route('/book/create', methods=['GET', 'POST'])
def create_book():
    if request.method == 'POST':
        isbn = request.form['isbn']
        title = request.form['title']
        publication_year = request.form['publication_year']
        price = request.form['price']

        # Retrieve and validate authors and categories from the form
        authors = request.form.getlist('authors')
        categories = request.form.getlist('categories')

        # Convert and filter out invalid entries
        authors = [int(a) for a in authors if a.isdigit()]
        categories = [int(c) for c in categories if c.isdigit()]

        conn = db_connection.cursor()
        try:
            conn.execute("START TRANSACTION")

            # Insert the new book
            sql = "INSERT INTO Books (ISBN, Title, PublicationYear, Price) VALUES (%s, %s, %s, %s)"
            conn.execute(sql, (isbn, title, publication_year, price))

            # Insert author relationships
            for author_id in authors:
                conn.execute("INSERT INTO BookAuthors (BookISBN, AuthorID) VALUES (%s, %s)", (isbn, author_id))

            # Insert category relationships
            for category_id in categories:
                conn.execute("INSERT INTO BookCategories (BookISBN, CategoryID) VALUES (%s, %s)", (isbn, category_id))

            conn.execute("COMMIT")
        except Exception as e:
            conn.execute("ROLLBACK")
            print("Error: ", e)
            return f"An error occurred: {e}", 500
        finally:
            conn.close()

        return redirect(url_for('books'))
    else:
        # Prepare form data for GET request
        conn = db_connection.cursor()
        conn.execute("SELECT AuthorID, AuthorName FROM Authors")
        authors = conn.fetchall()
        conn.execute("SELECT CategoryID, CategoryName FROM Categories")
        categories = conn.fetchall()
        conn.close()

        return render_template('create_book.html', authors=authors, categories=categories)









@app.route('/book/<string:book_isbn>/update', methods=['GET', 'POST'])
def update_book(book_isbn):
    conn = db_connection.cursor(pymysql.cursors.DictCursor)

    if request.method == 'POST':
        title = request.form['title']
        publication_year = request.form['publication_year']
        authors = request.form.getlist('authors')  # Assumes a multi-select field for authors in the form
        categories = request.form.getlist('categories')  # Assumes a multi-select field for categories in the form
        average_rating = request.form.get('average_rating')  # Assumes a dropdown for average rating in the form

        try:
            conn.execute("START TRANSACTION")  # Start a transaction

            # Update the Books table
            sql_update_book = "UPDATE Books SET Title = %s, PublicationYear = %s WHERE ISBN = %s"
            conn.execute(sql_update_book, (title, publication_year, book_isbn))

            # Update authors. This assumes a many-to-many relationship between books and authors
            conn.execute("DELETE FROM BookAuthors WHERE BookISBN = %s", (book_isbn,))
            for author_id in authors:
                sql_insert_author = "INSERT INTO BookAuthors (BookISBN, AuthorID) VALUES (%s, %s)"
                conn.execute(sql_insert_author, (book_isbn, author_id))

            # Update categories. This also assumes a many-to-many relationship between books and categories
            conn.execute("DELETE FROM BookCategories WHERE BookISBN = %s", (book_isbn,))
            for category_id in categories:
                sql_insert_category = "INSERT INTO BookCategories (BookISBN, CategoryID) VALUES (%s, %s)"
                conn.execute(sql_insert_category, (book_isbn, category_id))

            # Update the average rating for the book
            sql_update_rating = "UPDATE BookRatings SET AverageRating = %s WHERE BookISBN = %s"
            conn.execute(sql_update_rating, (average_rating, book_isbn))

            conn.execute("COMMIT")  # Commit the transaction
        except Exception as e:
            conn.execute("ROLLBACK")  # Rollback the transaction in case of error
            return f"An error occurred: {e}", 500
        finally:
            conn.close()

        return redirect(url_for('books'))

    else:
        # For a GET request, fetch the current data to populate the form
        conn.execute("SELECT * FROM Books WHERE ISBN = %s", (book_isbn,))
        book = conn.fetchone()

        conn.execute("SELECT AuthorID, AuthorName FROM Authors")
        authors = conn.fetchall()

        conn.execute("SELECT CategoryID, CategoryName FROM Categories")
        categories = conn.fetchall()

        # Example static ratings, replace with database fetch if dynamic ratings are used
        ratings = [{'RatingValue': i} for i in range(1, 6)]

        conn.close()

        return render_template('update_book.html', book=book, authors=authors, categories=categories, ratings=ratings)




    
@app.route('/book/<string:book_isbn>/delete', methods=['POST'])
def delete_book(book_isbn):
    conn = db_connection.cursor()
    try:
        # SQL to delete book
        sql = "DELETE FROM Books WHERE ISBN = %s"
        conn.execute(sql, (book_isbn,))
        db_connection.commit()
    except Exception as e:
        db_connection.rollback()
        return f"An error occurred during deletion: {e}", 500
    finally:
        conn.close()
    return redirect(url_for('books'))



@app.route('/books')
def books():
    conn = db_connection.cursor(pymysql.cursors.DictCursor)
    sql = """
    SELECT b.ISBN, b.Title, b.PublicationYear,
           GROUP_CONCAT(DISTINCT a.AuthorName ORDER BY a.AuthorName) AS Authors,
           GROUP_CONCAT(DISTINCT c.CategoryName ORDER BY c.CategoryName) AS Categories,
           br.AverageRating
    FROM Books b
    LEFT JOIN BookAuthors ba ON b.ISBN = ba.BookISBN
    LEFT JOIN Authors a ON ba.AuthorID = a.AuthorID
    LEFT JOIN BookCategories bc ON b.ISBN = bc.BookISBN
    LEFT JOIN Categories c ON bc.CategoryID = c.CategoryID
    LEFT JOIN BookRatings br ON b.ISBN = br.BookISBN
    GROUP BY b.ISBN, b.Title, b.PublicationYear, br.AverageRating
    """
    conn.execute(sql)
    books = conn.fetchall()
    print(books)  # Debugging: Output fetched data to console
    conn.close()
    return render_template('books.html', books=books)

if __name__ == '__main__':
    app.run(debug=True)
