from flask import Flask,render_template,request
from pymongo import MongoClient
import os, requests 


mongoURL = os.getenv('mongoURL', default='mongodb://root:example@mongodb:27017/')
tasks = ["createUser","createTask","updateUserProgress","updateTask","deleteUser","deleteTask"]
app = Flask(__name__)

##################################################################
@app.route('/', methods=['GET','POST'])
def home():
        if request.method == 'GET':
            return render_template('index.html',title='Home')
        if request.method == 'POST':
            try:
                client : MongoClient = MongoClient(mongoURL)
                usersCollection = client.mydb.users
                usersCollection.insert_one({"_id":1,"username":"admin","password":"admin"})
            except:
                userEntered =  request.form['User']
                passwordEntered = request.form['Password']
                returnedDictionary = usersCollection.find_one({"_id":1})
                if userEntered == returnedDictionary["username"] and passwordEntered == returnedDictionary["password"]: 
                    if userEntered == 'admin':
                        return render_template('adminPanel.html',title='Admin Panel')
                    else:
                        userData = usersCollection.find({})
                        return userData
                else:
                    return 'Incorrect Username/Password!'
##################################################################
@app.route('/adminPanel', methods=['GET','POST'])
def adminPanel():
    if request.method == 'POST':
        for task in tasks:
            if request.form.get(task) == task:
                title = task
                task += '.html'
                return render_template(task,title=title)
        if request.form.get('getAllUsers') == 'getAllUsers':
            client : MongoClient = MongoClient(mongoURL)
            usersCollection = client.mydb.users
            data = ''
            for doc in usersCollection.find():
                data += str(doc)
            data = data.split("{'_id'")
            return data
        elif request.form.get('getAllTasks') == 'getAllTasks':
            client : MongoClient = MongoClient(mongoURL)
            tasksCollection = client.mydb.tasks
            data = ''
            for doc in tasksCollection.find():
                data += str(doc)
            data = data.split("{'_id'")
            return data
    if request.method == 'GET':
            return render_template('index.html',title='Home')
##################################################################
@app.route('/createUser', methods=['POST'])
def createUser():
    userName = request.form['userName']
    userID = request.form['userID']
    client : MongoClient = MongoClient(mongoURL)
    usersCollection = client.mydb.users
    usersCollection.insert_one({"_id":userID,"username":userName,"tasks":[""]})
    return "OK"
##################################################################
@app.route('/createTask', methods=['POST'])
def createTask():
    taskName = request.form['taskName']
    instructionsURL = request.form['instructionsURL']
    client : MongoClient = MongoClient(mongoURL)
    tasksCollection = client.mydb.tasks
    tasksCollection.insert_one({"taskName":taskName,"instructionURL":instructionsURL})
    return "OK"
##################################################################
@app.route('/routeToUpdateUserProgress',methods=['POST'])
def routeToUpdateUserProgress():
    userID = request.form['userID']
    taskName = request.form['taskName']
    requests.put(f"http://127.0.0.1/updateUserProgress/{userID}/{taskName}")
    return "Updated"
##################################################################
@app.route('/updateUserProgress/<userID>/<taskName>', methods=['PUT']) 
def updateUserProgress(userID,taskName):
    userID = int(userID)
    client : MongoClient = MongoClient(mongoURL)
    usersCollection = client.mydb.users
    searchBy = {"_id" : userID}
    updatedValues = {"$push":{ "tasks":taskName}}
    usersCollection.update_one(searchBy,updatedValues)
    return "Updating"
##################################################################
@app.route('/routeToUpdateTask',methods=['POST'])
def routeToUpdateTask():
    taskName = request.form['taskName']
    newInstructions = str(request.form['newInstructions'])
    requests.put(f"http://127.0.0.1/updateTask/{taskName}/{newInstructions}")
    return "Updated"
##################################################################
@app.route('/updateTask/<taskName>/<newInstructions>', methods=['PUT']) 
def updateTask(taskName,newInstructions):
    client : MongoClient = MongoClient(mongoURL)
    tasksCollection = client.mydb.tasks
    searchBy = {"taskName" : taskName}
    updatedValues = {"$set":{ "instructionURL":newInstructions}}
    tasksCollection.update_one(searchBy,updatedValues)
    return "Updating"
##################################################################
@app.route('/routeToDeleteUser',methods=['POST'])
def routeToDeleteUser():
    id = request.form['IDToDelete']
    requests.delete(f"http://127.0.0.1/deleteUser/{id}")
    return "Deleted!"
##################################################################
@app.route('/deleteUser/<id>', methods=['DELETE'])
def deleteUser(id):
    client : MongoClient = MongoClient(mongoURL)
    usersCollection = client.mydb.users
    id = int(id)
    usersCollection.delete_one({"_id":id})
    return "OK"
##################################################################
@app.route('/routeToDeleteTask',methods=['POST'])
def routeToDeleteTask():
    taskName = request.form['taskToDelete']
    requests.delete(f"http://127.0.0.1/deleteTask/{taskName}")
    return "Deleted!"
##################################################################
@app.route('/deleteTask/<taskName>', methods=['DELETE'])
def deleteTask(taskName):
    client : MongoClient = MongoClient(mongoURL)
    tasksCollection = client.mydb.tasks
    tasksCollection.delete_one({"taskName":taskName})
    return "OK"
##################################################################
@app.errorhandler(404) #errorhandler returning an exception
def notFound(exception):
    return render_template('notFound.html',title='Page Not Found'), 404
##################################################################
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=True)


