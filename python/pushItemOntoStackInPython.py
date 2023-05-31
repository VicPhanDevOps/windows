#!/bin/python

# push item onto stack in Python

import colorama, os, sys, traceback
from colorama import Fore, Style 
from datetime import datetime
colorama.init()


def checkOs():
    print("Started checking operating system at", datetime.now().strftime("%m-%d-%Y %I:%M %p"))

    if sys.platform == "win32":
        print(Fore.GREEN + "Operating System:", end=""); sys.stdout.flush()
        os.system('ver')
        print(Style.RESET_ALL, end="")
        operatingSystem = "Windows"

    elif sys.platform == "darwin": 
        print(Fore.GREEN + "Operating System: ")
        os.system('sw_vers')
        print(Style.RESET_ALL, end="")
        operatingSystem = "macOS"

    elif sys.platform == "linux": 
        print(Fore.GREEN + "Operating System: ")
        os.system('uname -r')
        print(Style.RESET_ALL, end="")
        operatingSystem = "Linux"
    
    print("Finished checking operating system at", datetime.now().strftime("%m-%d-%Y %I:%M %p"))
    print("")
    return operatingSystem


def createStack(operatingSystem):
    stack = []

    if operatingSystem == "Windows": 
        numList = int(input("Please type the number of items in the stack and press the \"Enter\" key (Example: 4): "))

        print("")

        def addItemToStackOnWin(numList): 
            if numList > 0: 
                addItem = str(input("Please type an item you wish to add to the stack and press the \"Enter\" key (Example: 1): "))

                stack.append(addItem)
                addItemToStackOnWin(numList-1)

        addItemToStackOnWin(numList)

    else: 
        numList = int(input("Please type the number of items in the stack and press the \"return\" key (Example: 4): "))

        print("")

        def addItemToStackOnMacOrLinux(numList): 
            if numList > 0: 
                addItem = str(input("Please type an item you wish to add to the stack and press the \"return\" key (Example: 1): "))


                stack.append(addItem)
                addItemToStackOnMacOrLinux(numList-1)

        addItemToStackOnMacOrLinux(numList)

    print("")
    return stack


def checkParameters(stack): 
    print("Started checking parameter(s) at", datetime.now().strftime("%m-%d-%Y %I:%M %p"))
    valid = True 

    print("Parameter(s):")
    print("------------------------")
    print("stack: {0}".format(stack))
    print("------------------------")

    if stack == None or stack == "": 
        print(Fore.RED + "stack is not set" + Style.RESET_ALL)
        valid = False 

    if valid == True: 
        print(Fore.GREEN + "All parameter check(s) passed." + Style.RESET_ALL)

        print("Finished checking parameter(s) at", datetime.now().strftime("$m-%d-%Y %I:%M %p"))
        print("")

    else: 
        print(Fore.RED + "One or more parameters are incorrect." + Style.RESET_ALL)

        print("Finished checking parameter(s) at", datetime.now().strftime("$m-%d-%Y %I:%M %p"))
        exit("")


def pushItemFromStack(): 
    print("\nPush item onto Stack in Python.\n")

    operatingSystem = checkOs()
    stack           = createStack(operatingSystem)

    checkParameters(stack)

    try: 
        startDateTime = datetime.now()
        print("Started pushing item from stack at", startDateTime.strftime("%m-%d-%Y %I:%M %p"))

        print(Fore.BLUE + "The stack is: {0}".format(stack) + Style.RESET_ALL)
        print("")

        if operatingSystem == "Windows": 
            popItem = str(input("Please type the item you wish to push onto the stack and press the \"Enter\" key: "))

        else: 
            popItem = str(input("Please type the item you wish to push onto the stack and press the \"return\" key: "))

        stack.append(popItem)
        print(Fore.BLUE + "The stack is now: {0}".format(stack))
        print(Fore.GREEN + "Successfully pushed item onto stack." + Style.RESET_ALL)

        finishedDateTime = datetime.now()

        print("Finished pushing item from stack at", finishedDateTime.strftime("%m-%d-%Y %I:%M %p"))

        duration = finishedDateTime - startDateTime
        print("Total execution time: {0} second(s)".format(duration.seconds))
        print("")

    except Exception: 
        print(Fore.RED + "Failed to push item onto stack.")
        traceback.print_exc()
        exit("" + Style.RESET_ALL)


pushItemFromStack()
