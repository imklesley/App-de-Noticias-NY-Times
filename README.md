# NewYorkTimes -  My Simple version

NewYorkTimes is an application that allows users to access the latest news, updates and content that an administrator creates. It provides users with access to social news and fashion news. The admin of the app can create, update and delete news, structure images, text and galleries of images.

<div align="center">
    <img src="github\assets\working_app.gif"/>
</div>

## Features

* Create and update news
* Delete news
* Structure images, text and galleries
* Social news and fashion news
* Login and Forgot Password Process

## Requirements

* Flutter - sdk: ">=2.7.0 <3.0.0"
* Firebase

## Setting Up Firebase

To become an administrator user, after configuring firebase in the application, just create a new user of type email and password in the firebase authentication tab, and when created, copy the UUID and go to the Firestore Database tab and create a collection called " administradores", and within that collection create another collection where the name will be the UUID, copied earlier, and within that collection you will create a field called "nome" of type string with the value being the name  of the admin user that you created.

## Usage

### Admin

Admin can create, update and delete news from the app. They can also structure images, text and galleries.

### User

Users can access the latest news, updates and content that an administrator creates. It provides users with access to social news and fashion news.

##

<p align="center">Developed by <span color="#007DFF" >Klesley Gonçalves</span></p>