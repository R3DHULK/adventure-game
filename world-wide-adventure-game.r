# define the game map as a matrix
game_map <- matrix(c(
  "##########",
  "#    |   #",
  "#    @   #",
  "#    |   #",
  "#        #",
  "#   |    #",
  "##########"
), nrow = 7, byrow = TRUE)

# define the player's initial position
player_pos <- c(3, 5)

# define a function to print the game map with the player's position
print_map <- function() {
  for (i in 1:nrow(game_map)) {
    for (j in 1:ncol(game_map)) {
      if (i == player_pos[1] && j == player_pos[2]) {
        cat("@")
      } else {
        cat(substr(game_map[i, j], 1, 1))
      }
    }
    cat("\n")
  }
}

# define a function to move the player in a given direction
move_player <- function(dir) {
  new_pos <- player_pos
  if (dir == "up") {
    new_pos[1] <- new_pos[1] - 1
  } else if (dir == "down") {
    new_pos[1] <- new_pos[1] + 1
  } else if (dir == "left") {
    new_pos[2] <- new_pos[2] - 1
  } else if (dir == "right") {
    new_pos[2] <- new_pos[2] + 1
  }
  if (new_pos[1] < 1 || new_pos[1] > nrow(game_map) ||
      new_pos[2] < 1 || new_pos[2] > ncol(game_map) ||
      substr(game_map[new_pos[1], new_pos[2]], 1, 1) == "#") {
    print("You cannot move in that direction.")
  } else {
    player_pos <<- new_pos
    print_map()
  }
}

# print the game map and prompt the user for input
print_map()
while (TRUE) {
  cat("Enter a direction to move (up, down, left, right):\n")
  dir <- readline()
  move_player(dir)
}
