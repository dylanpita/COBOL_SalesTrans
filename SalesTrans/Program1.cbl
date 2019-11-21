       program-id. Program1 as "SalesTrans.Program1".

       environment division.
       input-output section.
       file-control.   select sales-trans
                       assign to "C:\a\exercise7\input.txt"
                       organization is line sequential.

                       select sales-out
                       assign to "C:\a\exercise7\output.txt"
                       organization is line sequential.

       data division.
       file section.
       fd  sales-trans.
       01  sale-trans-record.                                 
           05 salesperson-number         picture S9(2).  
           05 salesperson-name           picture X(20).                 
           05 amount-of-sales            picture 9(5)V99.

       fd  sales-out.
       01  print-rec               picture x(80).

       working-storage section.
       01  hl-header-1.
           05      picture x(31) value spaces.
           05      picture x(32) value "TOTAL SALES FOR EACH SALESPERSON".
           05      picture x(4) value spaces.
           05  date-field-format    picture X(10).
           05      picture x(3) value spaces.

       01  hl-header-2.
           05      picture x(10) value spaces.
           05      picture x(15) value "SALESPERSON NO.".
           05      picture x(4) value spaces.
           05      picture x(16) value "SALESPERSON NAME".
           05      picture x(9) value spaces.
           05      picture x(11) value "TOTAL SALES".
           05      picture x(15) value spaces.

       01  sales-trans-out.
           05                          picture x(15) value spaces.
           05  salesperson-no-out      picture xx.
           05                          picture x(12) value spaces.
           05  salesperson-name-out    picture x(20).
           05                          picture x(5).
           05  total-sales-out         picture $ZZ,ZZZ.99.
           05                          picture x(16) value spaces.

       01  total-sales-temp        picture 99999999V99.
       01  company-trans-out.
           05                      picture x(40) value spaces.
           05                      picture x(19) value "TOTAL COMPANY SALES".
           05                      picture xxx value spaces.
           05  total-company-sales picture $$,$$$,$$9.99.
           05                      picture x(5) value spaces.

       01  date-field.
           05  year-field          picture 9(4).
           05  month-field         picture 9(2).
           05  day-field           picture 9(2).

       01  salesperson-no-array    picture xx occurs 20 times.
       01  salesperson-name-array  picture x(20) occurs 20 times.
       01  salesperson-total-sales picture 99999V99 occurs 20 times value 0.

       01  are-there-more-records picture x value "Y".

       procedure division.
       
       000-main-module.

           open input sales-trans         
                output sales-out                   
           move function current-date to date-field
           move day-field & "/" & month-field & "/" & year-field 
               to date-field-format

           perform 300-PRINT-HEADING-RTN
            
           perform until are-there-more-records = "N"
               read sales-trans             
                   at end                              
                       move "N" to are-there-more-records
                       perform 200-print-routine
                       PERFORM 500-termination-routine             
                   not at end
                       perform 100-calc-routine
               end-read 
           end-perform

           stop run.

       100-calc-routine.

           move salesperson-number to salesperson-no-array(salesperson-number)
           move salesperson-name to salesperson-name-array(salesperson-number)
           add amount-of-sales to salesperson-total-sales(salesperson-number)
           add amount-of-sales to total-sales-temp.
       
       200-print-routine.

           perform varying salesperson-number
                   from 1
                   by 1
                   until salesperson-number > 20

               move salesperson-no-array(salesperson-number)
                    to salesperson-no-out
               move salesperson-name-array(salesperson-number)
                    to salesperson-name-out
               move salesperson-total-sales(salesperson-number)
                    to total-sales-out

               write print-rec from sales-trans-out after advancing 1 lines

           end-perform.


       300-PRINT-HEADING-RTN.

           write print-rec from hl-header-1 after advancing 4 lines
           write print-rec from hl-header-2 after advancing 2 lines.

                                                        
       500-termination-routine.

           move total-sales-temp to total-company-sales             
           write print-rec from company-trans-out after advancing 2 lines
           close sales-trans                       
                 sales-out.
           

       end program Program1.
