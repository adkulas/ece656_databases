# Installing and Preparing environment

## Create Database
First you must create the database. Use the following command to create the mysql database:
```console
mysql -u root -p < create_uwmad_db.sql
```

This will create a database called `UWmadison` and it will also create a user that the client/server application will to execute queries for the selection options. 
The username is `ece656project`, and the password is `ece656projectpass`

## Setup python environment
Python3 is used for the server application. Make sure that your `python` command points to python 3.x 
You can check this with:
```console
python --version
```

Create the virtual environment, download dependencies and run the server by executing the `run` script

```console
./run
```

The webserver will be running and the website can be reached at [localhost:5000](http://localhost:5000)