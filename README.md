# PokemonBoxApp

## Requirements

- Develop an iOS application using UIKit that given a database of pokemon (provided by https://pokeapi.co) allows the user to browse it as a list and to search pokemon by name (ex: "Bulbasaur").
As a starting point you are provided with UI mockups of the pokemon list.
- The list is paginated and shows a maximum of 20 items at a time. The maximum limit should not be changed, but you have to download the next page when you reach the bottom of the list.
- Usage of a Reactive Framework for any blocking functions, api or heavier calculations.
- Setup the project without using the Storyboard
**Plus:**
- Add some unit tests in order to check the business logic correctness
**Supplied material**
- API documentation: https://pokeapi.co/docs/v2
- Mockup Exercise #1_iOS Developer_08/04/24 [PUBLIC]

## Setup

Run `pod install` and build the project.

## Explanation

I tried to make it look as similar to the mockup image as I can, although I was unable to find the right font for the text. 

I did not implement unit testing as I haven't used them in a while and I was too close to the deadline.

I picked RxSwift as a reactive framework. It's my first time using it so I hope I did everything correctly. Overall, I found it very useful. 
