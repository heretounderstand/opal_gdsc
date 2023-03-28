# Opale-GDSC Solution Challenge 2023

Works on Android & iOS!

## Features

- Google Authentication
- Post, Edit user's solution
- Displaying solutions on google maps with radius of impact
- Filter solutions by UN goal
- Like, Save, Signal solutions
- Delete, End user's solution
- Comment (text only, text+image)
- Like, Save, Signal comments
- Delete, End user's comment
- Get info about UN goal
- Follow, Unfollow users
- User Profile

## Installation

- Create Firebase Project
- Enable Authentication (Google Sign In)
- Make Storage Rules
-for each goal from the page [UN-goals](https://developers.google.com/community/gdsc-solution-challenge/UN-goals), copy the goal's logo and add it to the Firebase Storage

- Create a Firestore Database
- Make Firestore Rules

- Start a collection named "unProjects" and for each projects from the page [UN-goals](https://developers.google.com/community/gdsc-solution-challenge/UN-goals) create a doc with the following fields:
- - id: the id of the doc (string)
- - name: the name of the project (string)
- - link: the link of the project (string)

- Start a collection named "unGoals" and for each goal from the page [UN-goals](https://developers.google.com/community/gdsc-solution-challenge/UN-goals) create a doc with the following fields:
- - id: the id of the doc (string)
- - rank: the rank of the goal (example: 1 for No Poverty) (number)
- - color: the hexadecimal code of the goal's color (example: 4294810916 for No Poverty) (number)
- - description: the description below the name of the goal (example: "End poverty in all its forms, everywhere." for No Poverty) (string)
- - info: the address of the link with the text "Infographic" (string)
- - logo: the link of the goal's logo in the Storage (string)
- - name: the name of the goal (string)
- - targets: the address of the link with the text "Why it matters" (string)
- - targets: the address of the link with the text "The United Nations targets for this goal" (string)
- - projects: the id of each istance in the collection unProjects listed below "EXAMPLE PROJECTS:" (array)

- Create Android & iOS Apps
- Use FlutterFire CLI to add the Firebase Project to this app.

## Tech Used
**Server**: Firebase Auth, Firebase Storage, Firebase Firestore

**Client**: Flutter, Google Maps
    
## Feedback

If you have any feedback, please reach out to me at kadrilud@gmail.com
