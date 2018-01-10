--@author Daniel Jordan
--@version 1.0
--@date 2/8/17

with Ada.Text_IO; use Ada.Text_IO;

procedure binpals is

   --Declaration of Modular type for input numbers of 1 .. 4 billion
   type Integer is mod 2**32; --Integer is declared a new type
   package PositiveFourBillion_IO is new
     Ada.Text_IO.Modular_IO (Num => Integer);
   use PositiveFourBillion_IO;

   --Procedure diffOrSame takes in two numbers
   --and compares them and print the appropriate response
   procedure diffOrSame(originalNum, calculatedNum: in Integer) is

   begin

      if(originalNum = calculatedNum) then
         put(" Same");

      elsif (originalNum /= calculatedNum) then
         put(" Different");
      end if;

   end diffOrSame;

   --Procedure pruneCalculated takes in the calculated inverse of the original
   --number and prunes the leading and trailing 0's
   procedure pruneCalculated(calculatedNum: in Integer; firstPruneNum: in out Integer) is

      calculatedComparable: Integer := calculatedNum;
      calculatedToPrint: Integer := calculatedNum;
      calculatedToPrint1: Integer := calculatedNum;
      calculatedPruneStart, calculatedPruneStop: Natural := 0; --stopping points
      calculatedBit: Integer;
      countEnds3, countEnds4: Natural := 0; --used to short circuit loop when 1 is found

      --Variables that are used to calculate the "pruned" binary number
      range2: Natural := 0;
      calculatedPrune2: Integer := 0;
      pruneComparable2: Integer := calculatedNum;
      countExponent: Natural := 0;

   begin
      --This first loop, loops from left to right and saves the position of the
      --first 1 it encounters
      for iii in reverse 0 .. 31 loop

         if ((2**iii) <= calculatedComparable) then
            calculatedPruneStop := iii;
            countEnds3 := countEnds3 + 1;--short circuits the loop
         end if;

         exit when countEnds3 > 0;

      end loop;

      --This second loop, loops from right to left and saves the position of the
      --first 1 it encounters
      for jjj in 0 .. 31 loop

         calculatedBit := calculatedComparable mod 2;

         if(calculatedBit = 1) then
            calculatedPruneStart := jjj;
            countEnds4 := countEnds4 + 1;--short circuits the loop
         end if;

         calculatedComparable := calculatedComparable / 2;

         exit when countEnds4 > 0;

      end loop;

      range2 := calculatedPruneStop - calculatedPruneStart;

      --This third loop, loops from the stopping point to the start point
      --and calculates what the "pruned" binary number is
      for lll in reverse calculatedPruneStart .. calculatedPruneStop loop

         if((2**lll) <= calculatedToPrint1) then

            calculatedToPrint1 := (calculatedToPrint1 - (2**lll));
            calculatedPrune2 := (calculatedPrune2 + (2**range2));

         end if;

         exit when range2 = 0;
         range2 := range2 - 1;

      end loop;

      diffOrSame(firstPruneNum, calculatedPrune2);

      --4th line of output begins
      New_Line;
      put("Reversed: ");
      put(calculatedPrune2);
      put(" ");

      --This fourth loop, loops from the stopping point to the start point
      --and prints the "pruned" binary bits
      for kkk in reverse calculatedPruneStart .. calculatedPruneStop loop

         exit when calculatedToPrint <= 0;--for an input of 0

         if ((2**kkk) > calculatedToPrint) then
            put(0, Width => 1);

         else --Because ((2**kkk) <= calculatedToPrint)
            put(1, Width => 1);
            calculatedToPrint := (calculatedToPrint - (2**kkk));
         end if;

      end loop;

      New_Line;--Here to space out the output

   end pruneCalculated;

   --Procedure pruneOriginal takes in the original number and prunes the leading
   --and trailing zeros, the in out parameter is just there to pass on.
   procedure pruneOriginal(originalNum1: in Integer; calculatedNum1: in out Integer) is

      --Variables that are used to print/calculate the "pruned" binary bits
      decimalComparable: Integer := originalNum1;
      originalToPrint, originalToPrint1: Integer := originalNum1;
      originalPruneStart, originalPruneStop: Natural := 0;
      originalBit: Integer;
      countEnds1, countEnds2: Natural := 0;

      --Variables that are used to calculate the "pruned" binary number
      range1: Natural;
      calculatedPrune1: Integer := 0;
      pruneComparable1: Integer := originalNum1;

   begin

      --This first loop, loops from left to right and saves the position of the
      --first 1 it encounters
      for ii in reverse 0 .. 31 loop

         if ((2**ii) <= decimalComparable) then
            originalPruneStop := ii;
            countEnds1 := countEnds1 + 1;--Short circuits the loop
         end if;

         exit when countEnds1 > 0;

      end loop;

      --This second loop, loops from right to left and saves the position of the
      --first 1 it encounters
      for jj in 0 .. 31 loop

         originalBit := decimalComparable mod 2;

         if(originalBit = 1) then
            originalPruneStart := jj;
            countEnds2 := countEnds2 + 1;
         end if;

         decimalComparable := decimalComparable / 2;

         exit when countEnds2 > 0;

      end loop;

      range1 := originalPruneStop - originalPruneStart;

      --This third loop, loops from the stopping point to the start point
      --and calculates what the "pruned" binary number is
      --for ll in reverse 0 .. range1 loop
      for ll in reverse originalPruneStart .. originalPruneStop loop

         if((2**ll) <= originalToPrint1) then

            originalToPrint1 := (originalToPrint1 - (2**ll));
            calculatedPrune1 := (calculatedPrune1 + (2**range1));

         end if;

         exit when range1 = 0;
         range1 := range1 - 1;

      end loop;

      --3rd line of output begins
      New_Line;
      put("Pruned  : ");
      put(calculatedPrune1);
      put(" ");

      --This fourth loop, loops from the stopping point to the start point
      --and prints the "pruned" binary bits
      for kk in reverse originalPruneStart .. originalPruneStop loop

         exit when originalToPrint <= 0;

         if ((2**kk) > originalToPrint) then
            put(0, Width => 1);
            --end if;

         else --Because ((2**kk) <= originalToPrint)
            put(1, Width => 1);
            originalToPrint := (originalToPrint - (2**kk));
         end if;

      end loop;

      pruneCalculated(calculatedNum1, calculatedPrune1);

   end pruneOriginal;

   --Procedure printReverse takes in the original number
   --prints the binary bits of the original input in reverse
   --and calculates the new binary inverse
   procedure printReverse (secondOperation: in Integer) is

      --Variables used to calculate the reversed decimal number
      reverseBinaryBit1: Integer; --used to store each bit
      newCalculatedDecimal: Integer := 0; --will be the sum of inverse bits
      baseTenNumber1: Integer := secondOperation; --helps with first calculation

      --Variables used to print the reverse binary bits
      reverseBinaryBit2: Integer;
      baseTenNumber2: Integer := secondOperation;

      --Variables that are used to save the original int and the calculated
      --inverse to pass them to diffOrSame
      originalNumber: Integer := secondOperation;

      --Variables used to pass the decimal and the newly calculated decimal to
      --prune procedure
      originalDecimal: Integer := secondOperation;

   begin

      --This loop calculates the reverse binary number into base 10 form
      for k in reverse 0 .. 31 loop

         reverseBinaryBit1 := baseTenNumber1 mod 2;
         if(reverseBinaryBit1 = 1) then
            newCalculatedDecimal := newCalculatedDecimal + (2**(k));
         end if;
         baseTenNumber1 := baseTenNumber1 / 2;

      end loop;



      --sending the data to diffOrSame in order to print out diff or same
      diffOrSame(originalNumber, newCalculatedDecimal);

      --2nd line of output begins
      New_Line;
      put("   Rev  : ");
      put(newCalculatedDecimal);
      put(" ");

      --prints the binary bits in reverse
      for l in  0 .. 31 loop

         reverseBinaryBit2 := baseTenNumber2 mod 2;
         put(Item => reverseBinaryBit2, Width => 1);
         baseTenNumber2 := baseTenNumber2 / 2;

      end loop;

      --Sending the original num and the binary inverse to "prune" them
      pruneOriginal(originalDecimal, newCalculatedDecimal);

   end printReverse;

   --Procedure printForward takes in a number and performs binary operations
   --on that number.
   procedure printForward (firstOperation: in Integer) is

      passToReverse: Integer := firstOperation;
      comparable: Integer := firstOperation;

   begin
      --prints the binary bits from left to right
      for j in reverse 0 .. 31 loop

         if ((2**j) > comparable) then
            put(0, Width => 1);
         end if;

         if ((2**j) <= comparable) then
            put(1, Width => 1);
            comparable := (comparable - (2**j));
         end if;

      end loop;

      --Passing the input to printReverse
      printReverse(passToReverse);

   end printForward;

   --Procedure setup takes in the first int to establish how many data values
   --are coming in.
   procedure setup (stop: in Integer) is

      --start is the constant starting point of the setup loop
      start: CONSTANT Integer := 1;

      --This variable is the actual number that will be operated on to produce
      --output.
      input: Integer;

   begin

      --This loop "gets" the input that will computed in all the binary operations
      for i in 1 .. stop loop

         --Getting the data to perform operations
         get(input);

         --1st line of output
         New_Line;
         put("Original: "); put(input); put(" ");

         --Sending input to printForward
         printForward(input);

      end loop;

   end setup;

   --Declaration of variables for procedure binpals
   loopController: Integer;

   --Begin binpals main
begin

   --Get the first int which will be a loop control variable for binpals
   get(loopController);
   --Pass loopController to setup
   setup(loopController);

   --End binpals
end binpals;
