#!/bin/python

# enable UAC on Windows  

# run this script as admin

import colorama, os, sys, traceback 
from colorama import Fore, Style
from datetime import datetime
colorama.init()


def checkOsForWindows(): 
	print("Started checking operating system at", datetime.now().strftime("%m-%d-%Y %H:%M %p"))

	if sys.platform == "win32": 
		print(Fore.GREEN + "Operating System:", end=""); sys.stdout.flush()
		os.system('ver')
		print(Style.RESET_ALL, end="")

		print("Finished checking operating system at", datetime.now().strftime("%m-%d-%Y %H:%M %p"))

		print("")

	else: 
		print(Fore.RED + "Sorry but this script only runs on Windows." + Style.RESET_ALL)

		print("Finished checking operating system at", datetime.now().strftime("%m-%d-%Y %H:%M %p"))

		exit("")


def enableUserAccessControl(): 
	print("\nEnable User Access Control on Windows.\n")
	checkOsForWindows()

	try:
		startDateTime = datetime.now()
		
		print("Started disabling User Access Control at", startDateTime.strftime("%m-%d-%Y %H:%M %p"))

		if os.system('reg.exe ADD HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 1 /f') != 0:
		
			raise Exception("Attempt threw an error!")

		print(Fore.GREEN + "Successfully enabled User Access Control." + Style.RESET_ALL)

		finishedDateTime = datetime.now()

		print("Finished disabling User Access Control at", finishedDateTime.strftime("%m-%d-%Y %H:%M %p"))

		duration = finishedDateTime - startDateTime
		print("Total execution time: {0} second(s)".format(duration.seconds))
		print("")

		print(Fore.BLUE + "Please save your documents and close your application.")
		input("Press any key to restart the computer:" + Style.RESET_ALL)
		os.system('shutdown /r /t 0')

	except Exception as e: 
		print(Fore.RED + "Failed to enable User Access Control.")
		print(e)
		print(traceback.print_stack)
		exit("" + Style.RESET_ALL)


enableUserAccessControl()
