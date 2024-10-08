# Connectify(real_time chat App)
Connectify is a real-time chat app offering one-to-one messaging and a range of features, all within a user-friendly interface for a seamless communication experience.

![icon](https://github.com/user-attachments/assets/869c74aa-d551-43b4-a98e-d1d51ba1450c)

## Technologies used in Connectify include
1 - **Flutter (Dart)** for the frontend, utilizing sqflite for local storage to save user chats and messages.

2 - **Python - Django** for the backend, with PostgreSQL for storing users and profiles information of logged-in users.

3 - **WebSockets** for enabling real-time messaging.

4 - **Firebase cloud messaging** for sending notifications

5 - **Http restful APIs**

### App Features

1 - Secure **Login** and **Signup** Authentication and Authorization, featuring email **verification** by sending a code to the user's email account. After successful login, a session code or token is provided to enhance security throughout the process.

2 - **One-to-one messaging** supports image sharing and real-time communication.

3 - The **self-chat** functionality allows users to create a personal chat space where they can message themselves. This feature serves as a private notepad.

4 - **Contact Access Permission** Granting access to your contacts enables Connectify to identify which of your contacts are also using the app

5 - **Messages queued on the server** if the receiver is offline. The server delivers these queued messages once the receiver reconnects.

6 - Send **Notifications** to users when they are not active in the chat or when the application is running in the background

7 - **Replying to messages** enhances communication, allowing for more engaging and interactive conversations.

8 - **Starred messages** allow users to highlight and prioritize specific messages for easy access.

9 - Users can upload **profile photos** to personalize their accounts and enhance their presence within the app.

10 - **Search feature** for messages enables easy access and retrieval of specific conversations.

11 - **Pagination for loading chats**, along with **auto-scrolling to the bottom**, boosts efficiency and enhances the overall user experience.

12 - Chats are sorted on the home page based on the **most recent message**, ensuring users can easily find their latest conversations.

13 - A **mode switch** feature allows users to toggle between light and dark themes, providing a customizable and comfortable viewing experience based on their preferences.

14 - **Favorite contacts** enable users to prioritize specific individuals for quicker access and enhanced communication.

15 - **Delete chats** to optimize storage efficiency by removing unimportant conversations.

16 - **Message delivered and seen indicators** enhance communication by providing users with visibility on whether their messages have been read.

17 - Show the count of **message alerts** on the home screen to provide users with a quick overview of their unread messages.

18 - **Delete Account** option allows users to remove their account and all associated data.

19 - **Logout**

#### Screen shots 



##### To run the app

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


 










