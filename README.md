# demo

A new Flutter project.

## Getting Started

# Expense Tracker App

The Expense Tracker App is a Flutter application that helps you manage your expenses. With this app, you can record and categorize your expenses, view expense statistics, and more.

## Features

- **Expense Upload**: Easily upload your expenses with details such as amount, description, category, date, and receipt image (optional).

- **Expense List**: View a list of your recorded expenses, including the ability to edit and delete individual expenses.

- **Profile Screen**: Get your personal information with attractive UI, allowing you to see and update your personal information.

## Installation

1. Clone this repository to your local machine using `git clone`.

2. Open the project in your preferred Flutter development environment (e.g., Android Studio, VSCode).

3. Run `flutter pub get` to install the required packages.

4. Configure Firebase for the app:
    - Create a Firebase project on the [Firebase Console](https://console.firebase.google.com/).
    - Follow Firebase's setup instructions to add your Android and iOS apps to the project.
    - Download the `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) files and place them in the appropriate directories in your project.
    - Enable Firestore and Firebase Authentication in the Firebase project.

5. Build and run the app on your preferred emulator or physical device.

## Usage

### Expense Upload Screen

- Open the app and navigate to the "Upload Expense" screen.
- Fill in the required details such as the amount, description, and category.
- Optionally, select a date and upload a receipt image.
- Tap the "Submit" button to add the expense.

### Expense List Screen

- Navigate to the "Expense List" screen to view a list of all recorded expenses.
- Tap the "Edit" button to edit an expense or the "Delete" button to remove it.

## Firebase Integration

The app integrates with Firebase to store expense data and user information. Ensure that you have set up Firebase as mentioned in the installation steps.

## Contributing

Contributions are welcome! Feel free to open issues and submit pull requests to improve the app.

## License

This app is open-source and available under the [MIT License](LICENSE)
