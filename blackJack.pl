#!/usr/bin/perl -w

#----------------------------------------------------------------------
#	If you find a bug e-mail me:  bdf2@njit.edu
#----------------------------------------------------------------------

use List::Util qw(shuffle);

@deck = ("2d","2c","2h","2s","3d","3c","3h","3s","4d","4c","4h","4s","5d","5c","5h","5s","6d","6c","6h","6s","7d","7c","7h","7s",
		  "8d","8c","8h","8s","9d","9c","9h","9s","Td","Tc","Th","Ts","Jd","Jc","Jh","Js",
						"Qd","Qc","Qh","Qs","Kd","Kc","Kh","Ks","Ad","Ac","Ah","As");
$plHit = -1;
$opHit = -1;
$oppSum1 = 0;
$playerSum1 = 0;
$endGame = 0;
$opponentWinTotal = 0;
$playerWinTotal = 0;
$waitAtEnd = '';


sub shuffleDeck{						
	@shufDeck = shuffle(@deck);

	#foreach(@shufDeck){
	#	print $_ . "\n";
	#}
}

sub welcome{
	print "Welcome to Bryce's Black Jack program!\n";
	print "What is your name?\n";
	chomp($playerName = <STDIN>);
	print "\n---------------------------------\n\n";
	print "Ready to begin? Type 'd' to deal, 'q' to quit\n";
	chomp($playerResponse = <STDIN>);
	if($playerResponse eq 'd' or $playerResponse eq 'D'){
		&beginGame();
	}
	else{
		exit;
	}
}

sub beginGame{

	&shuffleDeck(); #shuffles the deck
	
	&getPlayerCard();					#get player's first card
	push(@playerHand, $playerCard);		#add to player's hand
	
	&getOpponentCard();					#get opponent's first card
	push(@opponentHand, $opponentCard);	#add to opponent's hand
	
	&getPlayerCard();					#get player's second card
	push(@playerHand, $playerCard);		#add to player's hand
	
	&getOpponentCard();					#get opponent's second card
	push(@opponentHand, $opponentCard);	#add to opponent's hand
	
	&afterDeal( \@opponentHand, \@playerHand );
}

sub afterDeal{
	@opponentHand1 = @{ $_[0] };
	$opHandSize = $#opponentHand1;			#returns the size of the array
	@playerHand1   = @{ $_[1] };
	$plHandSize = $#playerHand1;
	
	print "\nOpponent's hand: \n";
	print "-- ";
	for($i = 1; $i <= $opHandSize; $i++){ 	#print opponents cards with "--" for the first card (flipped over)
		print $opponentHand1[$i] . " ";
	}
	print "\n";
	
	print "\n" . $playerName . "'s hand: \n";		#print player's hand.
	for($j = 0; $j <= $plHandSize; $j++){
		print $playerHand1[$j] . " ";
	}
	print "\n";
	
	$sum = &addHand(@opponentHand1);
	
	if ($oppSum1 ne 0){ 					#check if this is not the first time total was counted
		$oppSum1 = 0;
		$oppSum = $sum;
		$oppSum1 += $oppSum;
		$sum = -1;
	}
	else{									#otherwise add like normal
		$oppSum = $sum;
		$oppSum1 += $oppSum;
		$sum = -1;
	}
	
	if($oppSum1 > 21){
		$endGame = 1;
	}
	if($endGame eq 1){
		$sum = &addHand(@playerHand1);
		if($playerSum1 ne 0){				#check to see if this is not the first time total was counted for player
			$playerSum1 = 0;
			$playerSum = $sum;
			$playerSum1 += $playerSum;
			&finish($oppSum1, $playerSum1);
		}
		else{								#add like normal for end of game
			$playerSum = $sum;
			$playerSum1 += $playerSum;
			&finish($oppSum1, $playerSum1);
		}
	}
	else{						
		if($oppSum1 < 17){					#opponent is dealer ... dealer must hit on any hand below 17
			$opHit = 1;
		}
		else{								#if opponent's hand is at or above 17 -> make random decision to hit or stay
			$opDecision = int(rand(10));	#pick random number between 0-10
			if($opDecision ge 5){			#if the number is > 5
				$opHit = 1;					#opponent hits
			}
			else{							#if the number is < 5
				$opHit = 0;					#opponent doesn't hit (stays)
			}
		}
	}
	$sum = &addHand(@playerHand1);
	if($playerSum1 ne 0){				#check to see if this is not the first time total was added
		$playerSum1 = 0;				#clear running total
		$playerSum = $sum;
		$playerSum1 += $playerSum;		#new running total
	}
	else{
		$playerSum = $sum;
		$playerSum1 += $playerSum;
	}
	$sum = -1;
	if($playerSum1 > 21){
		&finish($oppSum1, $playerSum1);
	}
	else{
		print $playerName . "'s total: $playerSum1\n\n";
		print "(h)it or (s)tay?\n";
		chomp($resp = <STDIN>);
		if($resp eq 'h' or $resp eq 'H'){
			$plHit = 1;
		}
		else{
			$plHit = 0;
		}
	}
	if($opHit eq 0 and $plHit eq 0){		#both want to stay
		$sum = &addHand(@playerHand1);
		$playerSum1 = 0;
		$playerSum = $sum;
		$playerSum1 += $playerSum;
		$sum = 0;
		$sum = &addHand(@opponentHand1);
		$oppSum1 = 0;
		$oppSum = $sum;
		$oppSum1 += $oppSum;
		&finish($oppSum1, $playerSum1);
	}
	if($opHit eq 1){
		&getOpponentCard();
		push(@opponentHand1, $opponentCard);
	}
	$opHit = -1;
	if($plHit eq 1){
		&getPlayerCard();
		push(@playerHand1, $playerCard);
	}
	$plHit = -1;
	
	&afterDeal( \@opponentHand1, \@playerHand1 );

}

sub getPlayerCard{
	undef $playerCard;
	$playerCard = pop @shufDeck;
}

sub getOpponentCard{
	undef $opponentCard;
	$opponentCard = pop @shufDeck;
}

sub addHand{
	my @tmpArray1;
	my @tmpArray2;
	my @aceArray = ();
	my $tmpVar;
	$sum = 0;
	foreach(@_){
		@tmpArray1 = split(//,$_); 		#split the first and second char from card
		$tmpVar = $tmpArray1[0];		#get the 0th element from tmpArray into tmpVar 
		push(@tmpArray2, $tmpVar);		#push item in tmpVar into tmpArray2
	}
	foreach(@tmpArray2){
		if($_ eq 'T' or $_ eq 'J' or $_ eq 'Q' or $_ eq 'K'){
			$sum += 10;
		}
		elsif($_ eq 'A'){
			push(@aceArray, 'A');
		}
		else{
		$sum += $_;
		}
	}
	foreach(@aceArray){			#for each ace, add 11
		$sum += 11;				
		if($sum > 21){			#check if the hand total exceeds 21
			$sum -= 10;			#if so, make the Ace a 1
		}
	}
	
	return $sum;
}

sub finish($$){
	($opTotal, $plTotal) = @_;
	print "\n\nOpponent Total: " . $opTotal . "\n";
	print $playerName . "'s Total: " . $plTotal . "\n";
	if($opTotal gt 21 and $plTotal gt 21){
		print "Both players bust.  No one wins\n";
	}
	elsif($plTotal gt 21){
		print "$playerName busts\n\n";
		$opponentWinTotal++;
	}
	elsif($opTotal gt 21){
		print "Opponent busts\n\n";
		$playerWinTotal++;
	}
	elsif($opTotal > $plTotal){
		print "Opponent wins. Sorry :(\n\n";
		$opponentWinTotal++;
	}
	elsif($opTotal < $plTotal){
		print "$playerName wins!!\n\n";
		$playerWinTotal++;
	}
	elsif($opTotal eq $plTotal){
		print "Dealer wins tie.  Sorry :(\n\n";
		$opponentWinTotal++;
	}
	
	#ask if you want to play again - remember to push cards back into deck - recall beginGame
	print "Play again? (y)es or (n)o: \n";
	chomp($resp1 = <STDIN>);
	if($resp1 eq 'y' or $resp1 eq 'Y'){
		foreach(@opponentHand1){	#cycle through hand and push cards back
			push(@shufDeck, $_);
		}
		foreach(@playerHand1){		#cycle through hand and push cards back
			push(@shufDeck, $_);
		}
		@playerHand = ();  			#clear player hand
		@opponentHand = (); 		#clear opponent hand
		@playerHand1 = ();			#clear player hand
		@opponentHand1 = ();		#clear opponent hand
		$resp1 = '';
		$opTotal = 0;
		$plTotal = 0;
		$endGame = 0;
		print "\nRedealing...\n\n";
		&beginGame();
	}
	else{
		print $playerName . "'s won $playerWinTotal times!\n";
		print "Opponent won $opponentWinTotal times.\n";
		print "\nOverall winner of the game is: ";
		if($playerWinTotal > $opponentWinTotal){
			print $playerName;
		}
		elsif($playerWinTotal eq $opponentWinTotal){
			print " It was a tie!";
		}
		else{
			print "Opponent.\n\n";
		}
		$waitAtEnd = <STDIN>;
			exit;
	}
}

&welcome(); #initialization