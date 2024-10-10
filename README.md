# Connectify(real_time chat App)
Connectify is a real-time chat app offering one-to-one messaging and a range of features, all within a user-friendly interface for a seamless communication experience.


![icon](https://github.com/user-attachments/assets/37b093ac-62e5-4d51-a791-54ebef11f596)

## Technologies used in Connectify 
  - **Flutter (Dart)** for the frontend, utilizing sqflite for local storage to save user chats and messages.

  - **Python - Django** for the backend, with PostgreSQL for storing users and profiles information of logged-in users.

  - **WebSockets** for enabling real-time messaging.

  - **Firebase cloud messaging** for sending notifications

  - **Http restful APIs**

## Main Design Patterns used
   - **Singleton** design pattern ensures that only one instance of the database is created throughout the application’s lifecycle.

   - **Proxy** pattern acts as an intermediary layer between the authentication system and the application, managing login and signup requests.

   - **Chain of Responsibility** pattern handles authentication and authorization by choosing the appropriate handler according to the current state, such as verifying the email, phone number, and authentication code.

   - **Builder** pattern is used to construct complex objects, such as messages and chats, step by step. It allows for flexible configuration and customization, making it easier to build different parts of a message or chat.

   - **Observer** pattern notifies all pages when a mode switch occurs, ensuring that any changes in the theme are automatically updated across the application.

   - **Mediator** pattern is employed to reduce the direct dependencies between APIs and other application logic, promoting loose coupling. It centralizes communication, ensuring that different components interact through the mediator.


## App Features

  - Secure **Login** and **Signup** Authentication and Authorization
    -  featuring email **verification** by sending a code to the user's email account expired after five minutes.
    -  After successful login, a session code or token is provided to enhance security throughout the process.

  - **One-to-one messaging**
    - supports image sharing.
    - real-time communication.
    - Send **Notifications** to users when they are not active in the chat or when the application is running in the background.

  - The **self-chat** functionality
    - allows users to create a personal chat space where they can message themselves.
    -  This feature serves as a private notepad.

  - **Contact Access Permission**
    - Granting access to your contacts enables Connectify to identify which of your contacts are also using the app.

  - **Messages queued on the server** if the receiver is offline
    - The server delivers these queued messages once the receiver reconnects.

  - **Replying to messages**
    - enhances communication
    -  allowing for more engaging and interactive conversations.

  - **Starred messages** allow users to highlight and prioritize specific messages for easy access.

  - Users can upload **profile photos** to personalize their accounts and enhance their presence within the app.

  - **Search feature** for messages enables easy access and retrieval of specific conversations.

  - **Pagination for loading chats**
     -  along with **auto-scrolling to the bottom**.
     -  boosts efficiency and enhances the overall user experience.

 - Chats are sorted on the home page based on the **most recent message**, ensuring users can easily find their latest conversations.

 - A **mode switch** feature
   - allows users to toggle between light and dark themes
   -  providing a customizable.
   -  comfortable viewing experience based on their preferences.

 - **Favorite contacts** enable users to prioritize specific individuals for quicker access and enhanced communication.

 - **Delete chats** to optimize storage efficiency by removing unimportant conversations.

 - **Message indicators**
   - seen indicator.
   - delivered indicator.
   -  enhance communication by providing users with visibility on whether their messages have been read.
   - Show the count of **message alerts** on the home screen to provide users with a quick overview of their unread messages.

 - **Delete Account** option allows users to remove their account and all associated data.

 - **Logout**

## Screen shots 

![2eda414c-09ad-4b1b-8f9f-ca157996c223](https://github.com/user-attachments/assets/a8953f81-b9cf-487a-bd28-cd81ff0078ae)



![590750d3-9424-4195-8cca-7c1944704a6a](https://github.com/user-attachments/assets/13bae290-dca3-47bc-ab9c-4efefdc2712e)


![e5e1740b-d590-4599-9114-209aa5fdada1](https://github.com/user-attachments/assets/0194eb92-1bd3-405b-86f5-c65cb51e53f4)


![65f1b6ce-cb88-4124-a588-acf73340eb7f](https://github.com/user-attachments/assets/3fca6d12-9851-4238-a7cf-902ce381e5a5)


![a2d2aa8f-2a65-4b3d-9364-60d2088e1654](https://github.com/user-attachments/assets/af8c2107-2be6-4bee-9096-41a61f2ccf9b)


![23b741d6-72e0-4dfb-9982-f694d562857b](https://github.com/user-attachments/assets/2a156cf9-b449-476a-aa3b-274995acc792)


![96110d61-067f-4eb8-9463-4c0a5e74d253](https://github.com/user-attachments/assets/a835147a-58c9-48af-abf2-8d495a6b55d0)


![f7fd547c-65ab-40e4-b105-f8409b436c36](https://github.com/user-attachments/assets/fff68f08-2125-444d-a235-5ef37c5498f4)

![77306f27-642f-41b4-8c04-2b17e8865899](https://github.com/user-attachments/assets/8e77c63c-4706-47c9-87bf-2a43d1b5cb1d)

![e8f2dd87-b76b-4485-9643-08aab394f3a1](https://github.com/user-attachments/assets/48e516d7-4e2c-4cc5-90b2-cb92a3d90bb4)


![095138b6-2cd6-4dd6-81af-3a95b98b1864](https://github.com/user-attachments/assets/2bb549a8-6823-47db-8f9d-023c26f6cdef)



![4c0652ec-0bcf-4a72-8709-bc99f61973a6](https://github.com/user-attachments/assets/c831dabb-0eee-4bf4-9545-3a7e26b77062)


![b7388569-98a0-4385-ba83-a30a7d1cb784](https://github.com/user-attachments/assets/f1bf0d90-dff8-473e-9b14-8d42b827db38)

## Linkedin Post and Video

https://example.com](https://www.linkedin.com/posts/rowan-mohammad-902327288_introducing-connectify-your-real-time-activity-7250109637864083457-pU9A?utm_source=share&utm_medium=member_desktop

## Steps To run the app

clone the repo

######
      git clone https://github.com/porvah/Connectify
for Backend 

1 - install python

2 - install PostgreSQL, you should create your database and add the database username and password to a .env file in the project's root directory. This file has been created but is not included in the GitHub repository.

2 - install django

#####
     pip install django

3 - make migrations

######
      python manage.py makemigrations

4 - migrate

######
      python manage.py migrate

5 - run Server

######
      daphne -b 127.0.0.1 -p 8000 connectifyServer.asgi:application

for Frontend

1 - install android studio and flutter

2 - create an emulator

3 - install packages

######
      flutter pub get

4 - Create a .env file to store the IP host address.
      
5 - start debugging


 










