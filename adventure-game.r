# Define a function for the player's turn
player_turn <- function(player_stats, environment) {
  # Display the current environment
  cat("You are in a", environment$name, "with", environment$resources, "resources.\n")
  
  # Prompt the player to choose their action
  repeat {
    cat("Choose your action:\n1. Gather resources\n2. Rest\n3. Move to a new location\n")
    choice <- as.integer(readline(prompt = "Enter your choice: "))
    if (choice >= 1 & choice <= 3) {
      break
    } else {
      cat("Invalid choice. Try again.\n")
    }
  }
  
  # Handle the player's action
  if (choice == 1) {
    resource_gain <- min(environment$resources, player_stats$gather_rate)
    player_stats$resources <- player_stats$resources + resource_gain
    environment$resources <- environment$resources - resource_gain
    cat("You gather", resource_gain, "resources.\n")
  } else if (choice == 2) {
    player_stats$health <- min(player_stats$health + player_stats$rest_rate, player_stats$max_health)
    cat("You rest and restore", player_stats$rest_rate, "health.\n")
  } else {
    new_environment <- sample(environments, 1)
    cat("You move to a new", new_environment$name, ".\n")
    environment <- new_environment
  }
  
  # Check if the player has survived
  player_stats$health <- player_stats$health - environment$damage_per_turn
  if (player_stats$health <= 0) {
    cat("You have died.\n")
    return(FALSE)
  }
  
  # Check if the player has won
  if (player_stats$resources >= WIN_CONDITION) {
    cat("You have survived and won the game!\n")
    return(TRUE)
  }
  
  # Continue the game
  player_turn(player_stats, environment)
}

# Define the main function for the game
play_game <- function() {
  cat("Welcome to the Survival Game!\n")
  
  # Set up the game environment
  environments <- list(
    list(name = "forest", resources = 50, damage_per_turn = 10),
    list(name = "desert", resources = 30, damage_per_turn = 20),
    list(name = "mountain", resources = 40, damage_per_turn = 15),
    list(name = "coast", resources = 60, damage_per_turn = 5)
  )
  starting_environment <- sample(environments, 1)
  
  # Set up the player's initial stats
  player_stats <- list(
    resources = 0,
    max_health = 100,
    health = 100,
    gather_rate = 10,
    rest_rate = 20
  )
  
  # Start the game
  player_wins <- player_turn(player_stats, starting_environment)
  
  # Display the result
  if (player_wins) {
    cat("Congratulations, you win!\n")
  } else {
    cat("Better luck next time.\n")
  }
}
