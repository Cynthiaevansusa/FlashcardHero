# FlashcardHero
A Flashcard App that integrates with Quizlet to help the user know what to study, and with fun and effective ways to study.

When you launch the app, you can log in to Quizlet, play anonymously with Publicly available sets, or both!

You download flashcards (sets) from Quizlet and then missions will be available for you to play, each mission with variations and rewards!

## Installing, building, running

1. After downloading, you must create a file that contains the following Struct (usually Secrets.swift) that contains the following variables in a struct called "Secrets".  These are used by the QuizletAPI objects:

  ```swift
  struct Secrets {
  //TODO: FILL IN YOUR CLIENT ID AND SECRET KEY
  static let QuizletClientID = "YOURQUIZLETCLIENTIDHERE"
  static let QuizletSecretKey = "YOURQUIZLETSECRETKEYHERE"
  }
  ```
  Appropriately fill in the QuizletClientID and QuizletSecretKey with your ID and Key.

2. Build and run.

## Documentation
Check out the "Documents" directory.  It contains some supplimental documentation, like the "database" diagram. This can help you see the relationships in the data model, or other things.

## App Usage
Download some sets, and start on your missions!
Check out some analysis of your performance after missions and in the Analysis tab!

1. "Sets" Tab
  * Press the Plus button to search Quizlet for sets.
  * Select one or more sets from the search results, press done to download these sets
  * Use the red switch to the left of each set to turn it "on" or "off" during gameplay.  Sets that are "off" will not be asked during gameplay
  1. Logging in via Quizlet
    * press the person outline to be taken to Quizlet.com where you can log in.  Once you are logged, the "Your Sets" segment will be active, and you can see your sets there.
    * To refresh your sets, pull and release the table
    * Your login credentials are not stored in the app, nor does the app ever see them
    * Your tokens are securely saved to your keychain, and you should only ever have to log in once.

2. "Missions" Tab
  * Select which mission you wish you play.  There are variants of different games, depending on what has been unlocked by the developer.  If a mission is available, a large "Start Mission" button can be pressed to launch the game

3. Playing games
  * Games can vary in look and feel.
  * The player will be presented with some kind of question, or gameplay that somehow integrates information from the Sets downloaded.
  * In later versions of the game, Sets that have been successfully answered will give powerups to the user.  Some games are very simply, like True or False, and simply allow the player to study.
  * After the game criteria is won or lost, the user is given a results screen to see some basic performance metrics.
  * If the player successfully won, then the game level for that type of game will increase by one level.  If the player failed, the game level is reduced by two.  Higher game levels give harder challenges and greater rewards.

4. "Anyalysis" Tab
  * Find out some basic stats
  * See your performance for each set (later versions)
  * Find out where you need to focus on studying (later versions)

5. "Settings" Tab
  * Where you can set things
