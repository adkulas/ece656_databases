from sqlalchemy import create_engine
from flask import Flask, render_template, flash, request, redirect
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

# App config.
DEBUG = True
app = Flask(__name__)
app.config.from_object(__name__)
app.config["SECRET_KEY"] = "7d441f27d441f27567d441f2b6176a"
engine = create_engine("mysql+mysqlconnector://ece656project:ece656projectpass@localhost/UWmadison")



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
    operation = RadioField('Select Operation To perform', choices=[(1,1), (2,2), (3,3)])
    columns = MultiCheckboxField("Table_Name")

class CleanDataForm(Form):
    tables = SelectMultipleField('REPLACE_LABEL')


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

    choices = [(x, x) for x in table_names if not x.startswith('backup_')]
    form.tables.label = 'Select a table to clean'
    form.tables.choices = choices
     
    if request.method == "POST":
        tables = request.form["tables"]
        print(tables)

        if form.validate():
            
            pass
            # Save the comment here.
            # flash("Your form was valid")
        else:
            flash("A selection is required.")

    return render_template("cleandata.html", form=form)


@app.route("/cleandata/operation", methods=["GET", "POST"])
def clean_data_operation():

    table = request.args.get('table_name')  
    form = CleanOperationForm(request.form)
    
    table_names = [
        "course_offerings",
        "courses",
        "grade_distributions",
        "instructors",
        "rooms",
        "schedules",
        "sections",
        "subject_memberships",
        "subjects",
        "teachings",
    ]

    choices = [(x, x) for x in table_names]
    form.columns.label = "New_Name"
    form.columns.choices = choices

    if request.method == "POST":
        operation = request.form["operation"]
        print(operation)

        if form.validate():
            # Save the comment here.
            flash("Your form was valid")
        else:
            flash("All the form fields are required. ")

    return render_template("cleandataoperation.html", form=form)


@app.route("/minedata", methods=["GET", "POST"])
def mine_data():

    return render_template("layout.html")


@app.route("/viewdata", methods=["GET", "POST"])
def view_data():

    return render_template("layout.html")


if __name__ == "__main__":
    app.run()
