IMPORT util
IMPORT com
IMPORT XML
--gsform -M -i -keep gui.4fd POUR COMPILER 4FD TO .per

GLOBALS
    TYPE MyRecord RECORD
        id         INT,
        username   VARCHAR(100),
        age        int
    END RECORD
    DEFINE http_in RECORD
           verb  STRING,
           url   STRING,
           headers DYNAMIC ARRAY OF RECORD
                 name  STRING,
                 value  STRING
                 END RECORD
           END RECORD
END GLOBALS
    
MAIN
    DEFINE  rec MyRecord,
            result STRING,
            req com.HTTPServiceRequest;
    DISPLAY "nb params : ", num_args()
    DISPLAY "param 0 : ", arg_val(0)
    CLOSE WINDOW SCREEN
    OPEN WINDOW window WITH FORM "gui"
    DIALOG ATTRIBUTES(UNBUFFERED)
        INPUT BY NAME rec.* 
        END INPUT
        ON ACTION ACCEPT
            EXIT DIALOG;               
        ON ACTION sendToServer ATTRIBUTES(TEXT="Send")
            CALL sendGetToServer("http://localhost:8080/camunda/api/admin/auth/user/default") RETURNING result;
        ON ACTION CANCEL
            EXIT DIALOG
    END DIALOG
END MAIN

FUNCTION sendGetToServer(URL)
    DEFINE  URL VARCHAR(100),
            req com.HTTPRequest,
            res com.HTTPResponse,
            doc STRING;
    LET req = com.HttpRequest.Create(URL);
    CALL req.setMethod("GET");
    CALL req.setHeader("Accept", "application/json, text/plain, */*")
    CALL req.setHeader("Cookie", "JSESSIONID=52BBC25AC011EA0A08F3AEAA0F1EF2A9")

    --- WILL PLANT THE APPLICATION IF SERVER DOESN'T RESPOND
    -- PLEASE TRY CATCH THE NEXT CALL
    CALL req.doRequest()
    LET res = req.getResponse()
    IF res.getStatusCode() != 200 THEN
        DISPLAY  "HTTP Error ("||res.getStatusCode()||") ", res.getStatusDescription()
        RETURN "error"
    ELSE
        LET doc = res.getTextResponse()
        DISPLAY "Response was: ",  doc
        RETURN doc;
    END IF
        DISPLAY "request don't work"
    DISPLAY "1"
END FUNCTION

FUNCTION sendFormToServer(URL, username, pwd)
    DEFINE  URL VARCHAR(100),
            data STRING,
            username STRING,
            pwd STRING,
            req com.HTTPRequest,
            res com.HTTPResponse,
            doc STRING;
    LET req = com.HttpRequest.Create(URL);
    CALL req.setMethod("POST");
    --- CALL req.setHeader("Content-Type", "application/json")
    CALL req.setHeader("Accept", "application/json, text/plain, */*")
    CALL req.setHeader("Access-Control-Allow-Credentials", "true")
    DISPLAY "1"
    LET data = "username="
    LET data = data.append(username)
    LET data = data.append("&password=")
    LET data = data.append(pwd)
    DISPLAY data
    CALL req.doFormEncodedRequest(data, TRUE)
    LET res = req.getResponse()
    IF res.getStatusCode() != 200 THEN
        DISPLAY  "HTTP Error ("||res.getStatusCode()||") ", res.getStatusDescription()
        RETURN "error"
    ELSE
        LET doc = res.getTextResponse()
        DISPLAY "Response was: ",  doc
        RETURN doc;
    END IF
        DISPLAY "request don't work"
END FUNCTION

FUNCTION sendPostToServer(URL, rec)
    DEFINE  URL VARCHAR(100),
            rec MyRecord,
            req com.HTTPRequest,
            res com.HTTPResponse,
            doc STRING;
    LET req = com.HttpRequest.Create(URL);
    CALL req.setMethod("POST");
    CALL req.setHeader("Content-Type", "application/json")
    CALL req.setHeader("Accept", "application/json")
    CALL req.doTextRequest(util.JSON.stringify(rec));
    LET res = req.getResponse()
    IF res.getStatusCode() != 200 THEN
        DISPLAY  "HTTP Error ("||res.getStatusCode()||") ", res.getStatusDescription()
        RETURN "error"
    ELSE
        LET doc = res.getTextResponse()
        DISPLAY "Response was: ",  doc
        RETURN doc;
    END IF
        DISPLAY "request don't work"
END FUNCTION