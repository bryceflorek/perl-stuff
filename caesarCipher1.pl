#! /usr/bin/perl -w

sub getMode{
    for(;;){
        print "Do you wish to (E)ncrypt or (D)ecrypt? \n";
        chomp($mode = <STDIN>); 						#get user input into variable $mode
        $lcMode = lc($mode);							#convert user input to lower case (to avoid conversion)
        if($lcMode eq 'e' || $lcMode eq 'd'){			#see if user correctly input an 'e' or a 'd'
            return $lcMode;								#if so -> return the mode type ('e' or 'd')
        }
        else {
            print "Please enter 'E' or 'D'\n"; 			#user input something other than 'e' or 'd'
        }												#note: this allows callback once, then program dies 
    }													#on second bad input from user.
}
sub getMessage{
    print"Enter your message: ";
    chomp($message = <STDIN>);							#assign user's message to a variable $message
	$message = lc($message);							#translate everything to lowercase (for now)
	@message = split(//, $message);						#split contents of the variable by single character
}														#assign each character to individual element in array @message
sub getKey{
    $maxSize = 26;										#there are only 26 letters in the alphabet, so 26 ahs to be max key size
    print"Enter key number (1-$maxSize) \n";		
    chomp($key = <STDIN>);								#get user input of key size and assign it to variable $key
    if($key >= 1 and $key <= $maxSize){ 				# -> returns value of good key
        return $key;
    }
    else{												#user input error (only accepts numbers etc)
        print"Key error\n";
        print"\n";
    }
    return $key;
}
sub getTranslatedMessage{								#encrypts and decrypts message
    if($mode eq 'd'){
        $key = -$key;
    }
    foreach(@message){									#cycle through array @message
            $num = ord($_);								
            if($num >= 97 and $num <= 122){             #skip over anything not a lowercase letter
                $num += $key; 							#add letter (in Unicode) to key
                if($num > ord("z")){
					$num -= 26;							#if key+letter goes past 122 in Unicode 
				}										#subtract 26 to make it "cycle around"
				elsif($num < ord("a")){					
					$num += 26;							#or if under 97 in Unicode -> add 26
				}
				$num = chr($num);						#convert back to ASCII then
				push(@trArray, $num);					#push each item back into the array
            }
            else{										#continues from top --> if a symbol is encountered
                $num = chr($num);						#come down here, re-convert and push into array
                push(@trArray, $num);
            }
        }
    return @trArray;
}

&getMode;												#call subroutine getMode
&getMessage;											#call subroutine getMessage
&getKey;												#call subroutine getKey
print(&getTranslatedMessage($mode, $message, $key));	#call subroutine getTranslatedMessage passing it mode, message and key