from flask import Flask, render_template, flash, request
from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField, widgets, SelectMultipleField
 
# App config.
DEBUG = True
app = Flask(__name__)
app.config.from_object(__name__)
app.config['SECRET_KEY'] = '7d441f27d441f27567d441f2b6176a'
 
class ReusableForm(Form):
    name = TextField('Name:', validators=[validators.required()])
 
class MultiCheckboxField(SelectMultipleField):
    widget = widgets.ListWidget(prefix_label=False)
    option_widget = widgets.CheckboxInput()


class SimpleForm(Form):
    string_of_files = ['one\r\ntwo\r\nthree\r\n']
    list_of_files = string_of_files[0].split()
    # create a list of value/description tuples
    files = [(x, x) for x in list_of_files]
    example = MultiCheckboxField('Label', choices=files)


class CleanDataForm(Form):
    tables = MultiCheckboxField(
                        'Label', 
                        choices=[
                            'course_offerings', 
                            'courses', 
                            'grade_distributions', 
                            'instructors', 
                            'rooms', 
                            'schedules', 
                            'sections', 
                            'subject_memberships', 
                            'subjects', 
                            'teachings']
                                    )

['course_offerings', 'courses', 'grade_distributions', 'instructors', 'rooms', 'schedules', 'sections', 'subject_memberships', 'subjects', 'teachings']

@app.route("/", methods=['GET', 'POST'])
def home():
    form = ReusableForm(request.form)
 
    print(form.errors)
    if request.method == 'POST':
        name=request.form['name']
        print(name)
    
        if form.validate():
            # Save the comment here.
            flash('Your form was valid')
        else:
            flash('All the form fields are required. ')
    
    return render_template('layout.html', form=form)



@app.route("/selectdata", methods=['GET', 'POST'])
def select_data():
    form = SimpleForm(request.form)
    
    if request.method == 'POST':
        if form.validate():
            print(request.form)
            print('Hello')
        else:
            print(form.errors)

    return render_template('selectdata.html', form=form)

@app.route("/cleandata", methods=['GET', 'POST'])
def clean_data():
    form = ReusableForm(request.form)
 
    print(form.errors)
    if request.method == 'POST':
        tables = request.form['tables']
        print(tables)
    
        if form.validate():
            # Save the comment here.
            flash('Your form was valid')
        else:
            flash('All the form fields are required. ')
    
    return render_template('layout.html', form=form)
    return render_template('layout.html')

@app.route("/minedata", methods=['GET', 'POST'])
def mine_data():
   
    return render_template('layout.html')

@app.route("/viewdata", methods=['GET', 'POST'])
def view_data():
   
    return render_template('layout.html')


if __name__ == "__main__":
    app.run()