from sqlalchemy import create_engine, MetaData, inspect
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


class ReusableForm(Form):
    name = TextField("Name:", validators=[validators.required()])


class MultiCheckboxField(SelectMultipleField):
    widget = widgets.ListWidget(prefix_label=False)
    option_widget = widgets.CheckboxInput()


class SimpleForm(Form):
    string_of_files = ["one\r\ntwo\r\nthree\r\n"]
    list_of_files = string_of_files[0].split()
    # create a list of value/description tuples
    files = [(x, x) for x in list_of_files]
    example = MultiCheckboxField("Label", choices=files)


class CleanOperationForm(Form):
    operation = RadioField(
        "Select Operation To perform", choices=[('Replace Nulls', 'Replace Nulls'), ('Sample Data', 'Sample Data'), ('Normalize Data', 'Normalize Data'),],
        validators=[validators.required()]
    )
    columns = MultiCheckboxField("Table_Name", validators=[validators.required()])


class CleanDataForm(Form):
    tables = SelectMultipleField("REPLACE_LABEL", validators=[validators.required()])


@app.route("/", methods=["GET", "POST"])
def home():
    form = ReusableForm(request.form)

    print(form.errors)
    if request.method == "POST":
        name = request.form["name"]
        print(name)

        if form.validate():
            # Save the comment here.
            flash("Your form was valid")
        else:
            flash("All the form fields are required. ")

    return render_template("layout.html", form=form)


@app.route("/selectdata", methods=["GET", "POST"])
def select_data():
    form = SimpleForm(request.form)

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
    form.columns.label = "Select columns from the {0} table to apply operation to".format(
        table
    )
    form.columns.choices = choices

    if request.method == "POST":
        operation = request.form.get('operation')
        selected_columns = request.form.getlist("columns")
        print(operation, selected_columns)

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

    df = pd.DataFrame({'A': [0, 1, 2, 3, 4],
                   'B': [5, 6, 7, 8, 9],
                   'C': ['a', 'b', 'c--', 'd', 'e']})
    return render_template('viewdata.html',  tables=[df.to_html(classes='data')], titles=df.columns.values)


if __name__ == "__main__":
    app.run()
