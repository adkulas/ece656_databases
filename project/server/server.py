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
    IntegerField,
    DecimalField,
)
import pandas as pd
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

# App config.
DEBUG = True
app = Flask(__name__)
app.config.from_object(__name__)
app.config["SECRET_KEY"] = "7d441f27d441f27567d441f2b6176a"
engine = create_engine(
    "mysql+mysqlconnector://ece656project:ece656projectpass@localhost/UWmadison"
)


# Forms


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
        ],
        validators=[validators.required()],
    )
    columns = MultiCheckboxField("Table_Name", validators=[validators.required()])


class CleanDataForm(Form):
    tables = SelectMultipleField("REPLACE_LABEL", validators=[validators.required()])


class MiningParameters(Form):
    splitter = RadioField(
        "Select splitter (Default=Best)",
        choices=[("best", "best"), ("random", "random")],
    )
    max_depth = IntegerField("max_depth (default=None)")
    criterion = RadioField(
        "Select splitting measure (Default=mse)",
        choices=[("mse", "mse"), ("friedman_mse", "friedman_mse"), ("mae", "mae")],
    )
    min_impurity_decrease = DecimalField("min_impurity_decrease (Default=0.0)")


# Views


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

    run_flag = request.args.get("run")
    if run_flag == "True":
        call_revert_database(engine)

    if request.method == "POST":
        pass

    return render_template("selectdata.html")


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
            result = convert_to_average_gpa()

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

    run_flag = request.args.get("run")
    if run_flag == "True":
        call_stored_procedure(engine)
    form = MiningParameters(request.form)

    if request.method == "POST":

        splitter = request.form.get("splitter")
        max_depth = request.form.get("max_depth")
        criterion = request.form.get("criterion")
        min_impurity_decrease = request.form.get("min_impurity_decrease")

        print(splitter, max_depth, criterion, min_impurity_decrease)

        create_decision_tree_classifier(
            splitter=splitter,
            max_depth=max_depth,
            criterion=criterion,
            min_impurity_decrease=min_impurity_decrease,
        )

    return render_template("minedata.html", form=form)


@app.route("/viewdata", methods=["GET", "POST"])
def view_data():

    form = CleanDataForm(request.form)

    table_names = engine.table_names()

    choices = [(x, x) for x in table_names if not x.startswith("backup_")]
    form.tables.label = "Select a table to clean"
    form.tables.choices = choices

    if request.method == "POST":
        selected_table = request.form["tables"]
        print(selected_table)

        df = pd.read_sql(f"SELECT * FROM {selected_table}", engine).head(100)
        return render_template(
            "viewdata.html",
            tables=[df.to_html(classes="data")],
            titles=df.columns.values,
        )

        if form.validate():
            return redirect(url_for("clean_data_operation", table_name=selected_table))
            pass
            # Save the comment here.
            # flash("Your form was valid")
        else:
            flash("A selection is required.")

    return render_template("cleandata.html", form=form)


# Cleanup Functions


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
        r2 = conn.execute(
            text(f"DELETE FROM {table} ORDER BY RAND() LIMIT {round(count*0.8)};")
        )
        r3 = conn.execute(text(f"SELECT COUNT(*) FROM {table};"))
        count_after = r3.first()[0]

        trans.commit()
        flash(
            f"The table has been reduced from {count} records to {count_after} records"
        )

    except Exception as e:
        flash(e)
        trans.rollback()
        conn.close()
        return False

    conn.close()
    return True


def convert_to_average_gpa(engine=engine):
    conn = engine.connect()
    trans = conn.begin()

    try:
        r1 = conn.execute(
            text(
                """ALTER TABLE grade_distributions
                    ADD avg_gpa float,
                    ADD num_grades int(11);"""
            )
        )
        r2 = conn.execute(
            text(
                """UPDATE grade_distributions as t1
                    INNER JOIN
                    (
                        SELECT
                        course_offering_uuid,
                        (4.0 * a_count + 3.5 * ab_count + 3.0 * b_count + 2.5 * bc_count + 2 * c_count + 1 * d_count) / IF((a_count + ab_count + b_count + bc_count + c_count + d_count + f_count)=0,1,(a_count + ab_count + b_count + bc_count + c_count + d_count + f_count)) AS avg_gpa,
                        a_count + ab_count + b_count + bc_count + c_count + d_count + f_count AS num_grades
                        FROM grade_distributions
                    ) AS t2
                    USING (course_offering_uuid)
                    SET t1.avg_gpa = t2.avg_gpa, t1.num_grades = t2.num_grades;"""
            )
        )

        trans.commit()
        flash("Columns avg_gpa and num_grades successfully created")

    except Exception as e:
        flash(e)
        trans.rollback()
        conn.close()
        return False

    conn.close()
    return True


# Mining Algorithms


def call_stored_procedure(engine=engine):
    conn = engine.connect()
    trans = conn.begin()

    sql = text("CALL GetDataset()")

    try:
        conn.execute(sql)
        # r1.first()
        trans.commit()
        flash("Stored procedure has been run in the background to create dataset")

    except Exception as e:
        flash(e)
        trans.rollback()
        conn.close()
        return False

    conn.close()
    return True


def call_revert_database(engine=engine):
    conn = engine.connect()
    trans = conn.begin()

    flash("Calling revert on database")
    sql = text("CALL RevertDatabase()")
    engine.execute(sql)

    return True


def create_decision_tree_classifier(
    max_depth=None, criterion="mse", min_impurity_decrease=0.0, splitter="best"
):

    if "course_offering_mining" not in engine.table_names():
        flash("Please Run Stored Procedure Before Creating Model")
        return False

    dtree = DecisionTreeRegressor(
        random_state=1337,
        max_depth=max_depth,
        criterion=criterion,
        min_impurity_decrease=min_impurity_decrease,
        splitter=splitter,
    )
    flash(dtree)

    # Get data from database
    df = pd.read_sql("SELECT * FROM course_offering_mining", engine, index_col="cid")
    df = df.dropna()
    y = df["avg_gpa"].values
    X = df.drop("avg_gpa", axis=1).values

    # split data into train test split
    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.30, random_state=42
    )

    # train decision tree
    dtree = DecisionTreeRegressor()
    dtree.fit(X_train, y_train)

    # score results on holdout data
    y_pred = dtree.predict(X_test)
    r2 = r2_score(y_test, y_pred)
    mse = mean_squared_error(y_test, y_pred)
    mae = mean_absolute_error(y_test, y_pred)
    flash(
        f"""The classifer has been trained on {df.shape[0]} Samples. 70% of the samples
        were used to train the model the remaining 30% were used for validation. The model
        was able to predict grades with a r2 accuracy of {r2}, mean squared error of {mse}
        and mean absolute error of {mae}"""
    )

    return True


if __name__ == "__main__":
    app.run()
