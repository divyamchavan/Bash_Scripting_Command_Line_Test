#!/bin/bash

option=Y
while [ $option = "Y" -o  $option = "y" ] #check if the user wants to continue
do
echo -e "-----Welcome to Command Line Test-----"
echo "----MENU----"
echo -e "1. Sign up\n2. Sign in\n3. Exit"
read -p "Enter the choice " choice #read the choice
flag=0
flag1=0
pass=y
case $choice in
    1) 	read -p "Enter the username: " username #read username
	user=(`cat user.csv`) #save all the usernames in array
	for i in ${user[@]} #get the usernames one by one
	do
	    if [ "$username" = "$i" ] #check if username already exists
	    then
		echo "OPPS! $username already exists. Kindly choose a different username"
		flag=1 #flag is set if user name is not found
		break
	    fi
	done
	if [ $flag -ne 1 ] #if user name is found
	then
	    echo $username >> user.csv #append the username in file
	    while [ $pass = "y" ] 
	    do
	    read -sp "Create a password:" password
	    echo 
	    read -sp "Confirm password:" password1
	    echo
	    if [ "$password" != "$password1" ] #check if password and confirm password are saame
	    then
		echo "confirm password and password does not match"
	    else
		echo "$password" >> password.csv #add the password in file
		pass=n
		echo "Signed up successfully!!!"
	     read -p "Do you want to continue (y/n): " option
	    fi	
	    done
	fi;;
    2) while [ "$pass" = "y" ]
        do 
	read -p "Enter username: " username
	user=(`cat user.csv`)  #save all the usernames in array
	pssd=(`cat password.csv`)  #save all the passwords in array
	len=${#user[@]} #calculate the length
	for i in `seq 0 $(($len-1))`
	do
	    if [ "$username" = "${user[$i]}" ] #check if user name exists in file
	    then
	       flag1=1
		read -sp "enter password " password #ask for password
		echo 
	       if [ "$password" = "${pssd[$i]}" ] #check if password is matching
	       then
	       echo "Signed in successfully !!!!"
	       pass=n
	       echo "Welcome to the test. All the best!!!" #begin the test
                 for i in `seq 10 -1 1`
                 do
                     echo -ne "\rYour test begins in $i \a"
                     sleep 1
                 done
                 echo
                for i in `seq 5 5 50` #get questions from file 1 by 1
                do
                    head -$i question.txt | tail -5 #get the question from file
                        for j in `seq 9 -1 1`
                        do
                             echo -ne "\rEnter the option: $j " 
                             read -t 1 option

                            if [ -n "$option" ] #if option entered go to next question
                            then
                                break
                            else
                               option="e" #if timeout then mark it as e
                            fi
                        done
                  echo "$option" >> user_ans.txt #save the option entered in the file
                      if [  "$option" = "e" ]
                      then
                         echo
                      fi
                 done
                total=0
                user_ans=(`cat user_ans.txt`) #get the user answers in array
                correct_ans=(`cat correct_ans.txt`) #get the correct answers in array
                for i in `seq 0 9`
                do
                  if [ ${user_ans[$i]} = ${correct_ans[$i]} ] #if correct answer
                  then
                    echo "Correct"
                    total=$(($total+1))
                  elif [ ${user_ans[$i]} = "e" ] #if timeout
                  then
                   echo "Timeup"
                 else #if wrong
                   echo "Wrong" 
                 fi
               done
              echo "Result is $total/10" #display marks
	     read -p "Do you want to continue (y/n):" option
	       else
               echo "Incorrect password"
	       break
               fi
	    fi
	  done
	  if [ $flag1 -ne 1 ]
	  then
             echo "Username not found"
	     read -p "Do you want to continue (y/n):" option
	     break
	  fi
        done;;
    3) echo "BYE!!! Have a nice day!"
	break;;
    *) echo "Choice is invalid.Kindly choose from the menu";;
esac
done

