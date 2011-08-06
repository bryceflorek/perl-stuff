#!/usr/bin/perl -w

print("Guess the Number Game\n");
print("---------------------\n\n");
print("You have 5 guesses to get the correct number or else you lose.\n");

$range = 50;
$minum = 1;
$randomNumb = int(rand($range)) +$minum;

for($i = 5; $i > 0; $i -= 1){
	print("You have $i guesses left\n");
	chomp($guess = <STDIN>);
	if($guess > $randomNumb){
		print("Too high!\n");
	}
	elsif($guess < $randomNumb){
		print("Too Low!\n");
	}
	elsif($guess == $randomNumb){
		last;		
	}
	else{
		die "Something went wrong\n";
	}
	push(@guessArray, $guess);
}

if($guess == $randomNumb){
	print("Good job!\nAnswer was $randomNumb.  You got it right!\n");
	print("You had $i guesses left.\n");
}

print("Answer was: $randomNumb\n");
print("Your guesses were:\n");
foreach(@guessArray){
	$howClose = $randomNumb - $_;
	if($howClose < 0){
		$close = $howClose * -1;
		print("$_ which was $close away from $randomNumb\n");
	}
	else{
		print("$_ which was $howClose away from $randomNumb\n");
	}
}