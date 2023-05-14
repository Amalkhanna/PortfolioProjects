import random

choices = ["rock", "paper", "scissors"]

# Computer choices

while True:
    your_Choice = input("Choose a move: Rock, Paper, Scissors. Or press q to leave: ").lower()  # Question

    random_choice = random.randint(0, 2)    # Random index generator
    pc_pick = choices[random_choice]

    your_points = 0
    pc_points = 0

    if your_Choice == "q":
        print("End game")
        break
    if your_Choice not in choices:
        continue

    if your_Choice == "rock":                   # Conditions
        if pc_pick == "scissors":
            print("The computer picked scissors")
            print("You picked rock")
            print("You win!")
            your_points +=1
        elif pc_pick == "paper":
            print("The computer picked paper")
            print("You picked rock")
            print("Computer wins!")
            pc_points +=1
        elif pc_pick == "rock":
            print("The computer picked rock")
            print("You picked rock")
            print("Tie!")
    if your_Choice == "paper":
        if pc_pick == "scissors":
            print("The computer picked scissors")
            print("You picked paper")
            print("Computer wins!")
            pc_points +=1
        elif pc_pick == "paper":
            print("The computer picked paper")
            print("You picked paper")
            print("Tie!")
        elif pc_pick == "rock":
            print("The computer picked rock")
            print("You picked paper")
            print("You win!")
            your_points +=1
    if your_Choice == "scissors":
        if pc_pick == "scissors":
            print("The computer picked scissors")
            print("You picked scissors")
            print("Tie!")
        elif pc_pick == "paper":
            print("The computer picked paper")
            print("You picked scissors")
            print("You win!")
            your_points +=1
        elif pc_pick == "rock":
            print("The computer picked rock")
            print("You picked scissors")
            print("Computer Wins!")
            pc_points +=1

    print(your_points)          # Points
    print(pc_points)





