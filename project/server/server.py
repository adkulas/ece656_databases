from sqlalchemy import create_engine, MetaData, inspect, text
from flask import Flask, render_template, flash, request, redirect, url_for
from wtforms import (
    Form,
    TextField,
    TextAreaField,
    validators,
    StringField,
    SubmitField,
    widgets,
    SelectMultipleField,
    RadioField,
)
import pandas as pd

# App config.
DEBUG = True
app = Flask(__name__)
app.config.from_object(__name__)
app.config["SECRET_KEY"] = "7d441f27d441f27567d441f2b6176a"
engine = create_engine(
    "mysql+mysqlconnector://ece656project:ece656projectpass@localhost/UWmadison"
)


class MultiCheckboxField(SelectMultipleField):
    widget = widgets.ListWidget(prefix_label=False)
    option_widget = widgets.CheckboxInput()


class CleanOperationForm(Form):
    operation = RadioField(
        "Select Operation To perform",
        choices=[
            ("Replace Nulls with Mode", "Replace Nulls with Mode"),
            ("Replace Nulls with Mean", "Replace Nulls with Mean (Must be numeric)"),
            (
                "Replace Nulls with Median",
                "Replace Nulls with Median (Must be numeric)",
            ),
            ("Drop Nulls", "Drop Nulls"),
            ("Sample Data", "Sample Data (random sample of 20% of data) "),
            (
                "Normalize Data Min Max",
                "Normalize Data (Min-Max nomralization Must be numeric)",
            ),
            (
                "Normalize Data Z-score",
                "Normalize Data (Z-score nomralization Must be numeric)",
            ),
        ],
        validators=[validators.required()],
    )
    columns = MultiCheckboxField("Table_Name", validators=[validators.required()])


class CleanDataForm(Form):
    tables = SelectMultipleField("REPLACE_LABEL", validators=[validators.required()])


@app.route("/", methods=["GET", "POST"])
def home():
    form = CleanDataForm(request.form)

    print(form.errors)
    if request.method == "POST":
        name = request.form["name"]
        print(name)

        if form.validate():
            # Save the comment here.
            flash("Your form was valid")
        else:
            flash("All the form fields are required. ")

    return render_template("home.html", form=form)


@app.route("/selectdata", methods=["GET", "POST"])
def select_data():
    form = CleanDataForm(request.form)

    if request.method == "POST":
        if form.validate():
            print(request.form)
            print("Hello")
        else:
            print(form.errors)

    return render_template("selectdata.html", form=form)


@app.route("/cleandata", methods=["GET", "POST"])
def clean_data():
    form = CleanDataForm(request.form)

    table_names = engine.table_names()

    choices = [(x, x) for x in table_names if not x.startswith("backup_")]
    form.tables.label = "Select a table to clean"
    form.tables.choices = choices

    if request.method == "POST":
        selected_table = request.form["tables"]
        print(selected_table)

        if form.validate():
            return redirect(url_for("clean_data_operation", table_name=selected_table))
            pass
            # Save the comment here.
            # flash("Your form was valid")
        else:
            flash("A selection is required.")

    return render_template("cleandata.html", form=form)


@app.route("/cleandata/operation", methods=["GET", "POST"])
def clean_data_operation():

    table = request.args.get("table_name")
    form = CleanOperationForm(request.form)
    print(table)

    inspector = inspect(engine)
    columns = [x["name"] for x in inspector.get_columns(table)]

    choices = [(x, x) for x in columns]
    form.columns.label = "Select columns from the `{0}` table to apply operation to".format(
        table
    )
    form.columns.choices = choices
    if table == "grade_distributions":
        form.operation.choices.append(
            ("Convert to average GPA", "Convert Grade Distribution to Average GPA")
        )

    if request.method == "POST":
        operation = request.form.get("operation")
        selected_columns = request.form.getlist("columns")
        print(operation, selected_columns)

        if operation == "Replace Nulls with Mode":
            result = replace_nulls(table, selected_columns, method="mode")

        if operation == "Replace Nulls with Mean":
            result = replace_nulls(table, selected_columns, method="mean")

        if operation == "Replace Nulls with Median":
            result = replace_nulls(table, selected_columns, method="median")

        if operation == "Drop Nulls":
            result = replace_nulls(table, selected_columns, method="drop")

        if operation == "Sample Data":
            result = sample_data(table)

        if operation == "Normalize Data Min Max":
            result = replace_nulls(table, selected_columns, method="mean")

        if operation == "Normalize Data Z-score":
            result = replace_nulls(table, selected_columns, method="mean")

        if operation == "Convert to average GPA":
            result = replace_nulls(table, selected_columns, method="mean")

        if result:
            flash("The Query was successful")
        else:
            flash("The Query was unsuccessful")

        if form.validate():
            # Save the comment here.
            flash("Your form was valid")
        else:
            flash("All the form fields are required.")

    return render_template("cleandataoperation.html", form=form)


@app.route("/minedata", methods=["GET", "POST"])
def mine_data():

    return render_template("layout.html")


@app.route("/viewdata", methods=["GET", "POST"])
def view_data():

    df = pd.DataFrame(
        {"A": [0, 1, 2, 3, 4], "B": [5, 6, 7, 8, 9], "C": ["a", "b", "c--", "d", "e"]}
    )
    return render_template(
        "viewdata.html", tables=[df.to_html(classes="data")], titles=df.columns.values
    )


def replace_nulls(table, columns, method="mean", engine=engine):

    print("called function with", table, columns, method)

    conn = engine.connect()
    trans = conn.begin()

    try:
        for column in columns:

            if method == "mean":
                sql = f"""
                            UPDATE {table} as t1
                            NATURAL JOIN
                            (SELECT avg({column}) as average
                            FROM {table}) as t2
                            SET t1.{column} = t2.average WHERE t1.{column} IS NULL;
                        """

            if method == "median":
                sql = f"""
                            UPDATE {table} as t1
                            NATURAL JOIN
                            (
                                SELECT AVG(dd.{column}) as median_val
                                FROM (
                                SELECT d.{column}, @rownum:=@rownum+1 as `row_number`, @total_rows:=@rownum
                                FROM {table} d, (SELECT @rownum:=0) r
                                WHERE d.{column} is NOT NULL
                                ORDER BY d.{column}
                                ) as dd
                                WHERE dd.row_number IN ( FLOOR((@total_rows+1)/2), FLOOR((@total_rows+2)/2) )
                            ) as t2
                            SET t1.{column} = t2.median_val WHERE t1.{column} IS NULL;
                        """

            if method == "mode":
                sql = f"""
                            UPDATE {table} as t1
                            NATURAL JOIN
                            (
                                SELECT {column} AS mode, COUNT(*) 
                                FROM {table} 
                                WHERE {column} IS NOT NULL 
                                GROUP BY {column} ORDER BY COUNT(*) 
                                DESC LIMIT 1
                            ) AS t2
                            SET t1.{column} = t2.mode WHERE t1.{column} IS NULL;
                        """

            if method == "drop":
                sql = f"DELETE FROM {table} WHERE {column} IS NULL;"

            r1 = conn.execute(text(sql))
            # flash(r1.first())
        trans.commit()
    except Exception as e:
        flash(e)
        trans.rollback()
        conn.close()
        return False

    conn.close()
    return True


def sample_data(table, engine=engine):

    conn = engine.connect()
    trans = conn.begin()

    try:
        r1 = conn.execute(text(f"SELECT COUNT(*) FROM {table};"))
        count = r1.first()[0]
        r2 = conn.execute(text(f"DELETE FROM {table} ORDER BY RAND() LIMIT {round(count*0.8)};"))

        trans.commit()

    except Exception as e:
        flash(e)
        trans.rollback()
        conn.close()
        return False

    conn.close()
    return True


def convert_to_average_gpa():
    conn = engine.connect()
    trans = conn.begin()

    try:
        r1 = conn.execute(text(f"SELECT COUNT(*) FROM {table};"))
        count = r1.first()[0]
        r2 = conn.execute(text(f"DELETE FROM {table} ORDER BY RAND() LIMIT {round(count*0.8)};"))

        trans.commit()

    except Exception as e:
        flash(e)
        trans.rollback()
        conn.close()
        return False

    conn.close()
    return True  



if __name__ == "__main__":
    app.run()
