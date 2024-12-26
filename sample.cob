      ******************************************************************
      * A simplified COBOL 85 program that will read employee disk     *
      * records and create a printed payroll report containing the     *
      * computed wages for each employee along with the input data.    *
      * Adapted from Structured COBOL Programming 8ed by Stern/Stern.  *
      * User-defined symbols are lower-case, COBOL keywords are UC.    *
      ******************************************************************

       IDENTIFICATION DIVISION.
       PROGRAM-ID. sample.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
      * Input file name: `emp-dat`.
      * Output file name: `printer`.
       FILE-CONTROL.   
           SELECT employee-data ASSIGN TO emp-dat
      *------- This line is important, and is not in the textbook.
      *------- Without it, the GNUCobol compiler interprets newline
      *------- characters as part of the data rows of a file.
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT payroll-listing ASSIGN TO printer.
       DATA DIVISION.
       FILE SECTION.
       FD employee-data LABEL RECORDS ARE STANDARD.
       01 employee-record.
      * Fields within the record are on the 05 level, and as such are
      * subordinate to (part of) the 01-level entry.
           05 employee-name-in PICTURE X(20).
           05 hours-worked-in PICTURE 9(2).
           05 hourly-rate-in PICTURE 9V99.
      * Use standard label records because it's not actually a printer.
      * This also deviates from the textbook.
       FD payroll-listing LABEL RECORDS ARE STANDARD.
       01 print-rec.
           05 PICTURE X(20).
           05 name-out PICTURE X(20).
           05 PICTURE X(10).
           05 hours-out PICTURE 9(2).
           05 PICTURE X(8).
           05 rate-out PICTURE 9.99.
           05 PICTURE X(6).
           05 weekly-wages-out PICTURE 999.99.
       WORKING-STORAGE SECTION.
       01 are-there-more-records PICTURE XXX VALUE 'YES'.
       PROCEDURE DIVISION.
       100-MAIN-MODULE.
           OPEN INPUT employee-data
               OUTPUT payroll-listing
      *--- Repeatedly read one data record into the input area.
           PERFORM UNTIL are-there-more-records = 'NO '
               READ employee-data
                   AT END
                       MOVE 'NO ' TO are-there-more-records
                   NOT AT END
                       PERFORM 200-WAGE-ROUTINE
               END-READ
           END-PERFORM
           CLOSE employee-data
               payroll-listing
           STOP RUN.
       200-WAGE-ROUTINE.
           MOVE SPACES TO print-rec
           MOVE employee-name-in TO name-out
           MOVE hours-worked-in TO hours-out
           MOVE hourly-rate-in TO rate-out
           MULTIPLY hours-worked-in BY hourly-rate-in
               GIVING weekly-wages-out
           WRITE print-rec.
