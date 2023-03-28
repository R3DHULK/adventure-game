package main

import (
	"fmt"
	"os"
)

type Room struct {
	description string
	paths       map[string]*Room
}

func (r *Room) setDescription(description string) {
	r.description = description
}

func (r *Room) setPath(direction string, room *Room) {
	r.paths[direction] = room
}

func (r *Room) display() {
	fmt.Println(r.description)
	fmt.Println("Choose your path:")
	for direction, room := range r.paths {
		fmt.Printf("%s - %s\n", direction, room.description)
	}
}

func main() {
	// Define the rooms
	startRoom := &Room{}
	startRoom.setDescription("You are standing at the entrance of a dark cave.")
	
	firstRoom := &Room{}
	firstRoom.setDescription("You enter a room with two doors. One leads left, and the other leads right.")
	
	leftRoom := &Room{}
	leftRoom.setDescription("You enter a room with a treasure chest. You can take the treasure and go back, or go forward.")
	
	rightRoom := &Room{}
	rightRoom.setDescription("You enter a room with a sleeping dragon. You can try to sneak past him, or go back.")
	
	// Set the paths between the rooms
	startRoom.paths = map[string]*Room{
		"left":  firstRoom,
		"right": firstRoom,
	}
	firstRoom.paths = map[string]*Room{
		"left":  leftRoom,
		"right": rightRoom,
		"back":  startRoom,
	}
	leftRoom.paths = map[string]*Room{
		"take":  firstRoom,
		"forward": rightRoom,
	}
	rightRoom.paths = map[string]*Room{
		"sneak": firstRoom,
		"back":  firstRoom,
	}
	
	// Start the game
	currentRoom := startRoom
	for {
		currentRoom.display()
		
		// Get the user's input
		var input string
		fmt.Scan(&input)
		
		// Check if the input is valid
		nextRoom, ok := currentRoom.paths[input]
		if !ok {
			fmt.Println("Invalid input. Please try again.")
			continue
		}
		
		// Move to the next room
		currentRoom = nextRoom
		
		// Check if the player has won or lost
		if currentRoom == leftRoom {
			fmt.Println("Congratulations! You found the treasure and won the game!")
			os.Exit(0)
		} else if currentRoom == rightRoom {
			fmt.Println("You woke up the dragon! He ate you and you lost the game.")
			os.Exit(0)
		}
	}
}
