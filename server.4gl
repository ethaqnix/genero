IMPORT com

##############################################################################
#
# Web Service Server:
# - Publication of the services
# - Handle the SOAP protocol
#

MAIN
    DEFINE ret INTEGER

    CALL createservice()
  
    DISPLAY "Starting server..."   

    CALL com.WebServiceEngine.Start()

    DISPLAY "The server is listening."

    WHILE TRUE
      # Process each incoming requests (infinite loop)
      LET ret = com.WebServiceEngine.ProcessServices(-1)

      DISPLAY "Processing request..."

      CASE ret
          WHEN 0
              DISPLAY "Request processed." 
          WHEN -1
              DISPLAY "Timeout reached."
          WHEN -2
              DISPLAY "Disconnected from application server."
              EXIT PROGRAM 
          WHEN -3
              DISPLAY "Client Connection lost."
          WHEN -4
              DISPLAY "Server interrupted with Ctrl-C."
          WHEN -10
              DISPLAY "Internal server error."
      END CASE

      IF int_flag<>0 THEN
        LET int_flag=0
        EXIT WHILE
      END IF 
    END WHILE

    DISPLAY "Server stopped"
END MAIN

FUNCTION createservice()
    DEFINE service  com.WebService    # A WebService
    DEFINE op    com.WebOperation  # Operation of a WebService

    #Create WebService object
    #LET service = com.WebService.CreateWebService(<name>, <namespace>)

    #Create WebOperation object
    #LET op = com.WebOperation.CreateRPCStyle(<function>, <operation>, <input record>, <output record> )

    #publish the operation, associating with the WebService object
    #CALL service.publishOperation(op,NULL)

    #Register the webService 
    #CALL com.WebServiceEngine.RegisterService(service)
    
END FUNCTION

