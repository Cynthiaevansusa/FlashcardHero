# FlashcardHero
A Flashcard App that integrates with Quizlet to help the user know what to study, and with fun and effective ways to study.

When you launch the app, you can log in to Quizlet, play anonymously with Publicly available sets, or both!

You download flashcards (sets) from Quizlet and then missions will be available for you to play, each mission with variations and rewards!

## Installing
After downloading, you must create a file that contains the following Struct, with at least the shown variables:

struct Secrets {
//TODO: FILL IN YOUR CLIENT ID AND SECRET KEY
static let QuizletClientID = "YOURQUIZLETCLIENTIDHERE"
static let QuizletSecretKey = "YOURQUIZLETSECRETKEYHERE"
}

appropriately fill in the QuizletClientID and QuizletSecretKey with your ID and Key.  If you are a Udacity reviewer, the keys were posted when this app was submitted.

## Usage
Download some sets, and start on your missions!
Check out some analysis of your performance after missions and in the Analysis tab!
