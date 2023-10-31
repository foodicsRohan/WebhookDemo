/*------------------------------------------------------------
Author/s: Dev
------------------------------------------------------------*/
@RestResource(urlmapping='/testNafith/*')
global  class WebhookNafith {
 @HttpPost
    global static void getcallBack(){
        try{
             RestRequest request = RestContext.request; 
             RestResponse response=RestContext.response;
            // fetching the body
            //get hash value from header
            String hashedval = request.headers.get('X-Hub-Signature-256');
            System.debug('hashedval: '+hashedval);
            Blob bB = request.requestBody;
            System.debug(bB.toString());
            Blob hmac = Crypto.generateMac ('hmacSHA256', bB, Blob.valueOf('webhooktrial'));
            //Blob hmac Crypto.generateMac (hmacSHA256', Blob.valueOf('test'), Blob.valueOf('webhooktrial'));
             String hmacstring = 'sha256='+EncodingUtil.convertToHex(hmac);
            System.debug('hmac: '+EncodingUtil.convertToHex(hmac));
            if( hashedval == hmacstring) {
                System.debug('Secret value Matched and source can be trusted!');
                //githubpushdetails pusherdetails = githubpushdetails.parse(bB.toString()); //iterate through JSON
                JSONParser parser = JSON.createParser(request.requestBody.toString());
                pusher ps;
                head_commit hc;
				String repo;
                while (parser.nextToken() != null) {
                 if (parser.getText()== 'pusher')
                     {
                         parser.nextToken();
                         ps = (pusher)parser.readValueAs(pusher.class); 
                         System.debug(ps);
                     }   
                       if (parser.getText()== 'head_commit')
                       {
                           parser.nextToken();
                            hc = (head_commit)parser.readValueAs(head_commit.class); 
                            System.debug(hc);
                       }
                     if (parser.getText()== 'full_name')
                       {
                           parser.nextToken();
                          repo = parser.getText(); 
                            System.debug(hc);
                       }
                }
                /*
                //Create GitHub_Push_Details_c based on received details
                GitHub_Push_Details_c detail =new GitHub_Push_Details_c();
                detail.Committer_Name_c = ps!=null?ps.name: ''; 
                detail.Committer_Email_c = ps!-null?ps.email:''; 
                detail.Commit_Message_c = hc!=null?hc.message:'';
                detail.Commit_Timestamp_c = hc!=null?hc.timestamp:** detail.Committed_URL__c = hc!=null?hc.url: '';

*/
                  response.statusCode =200;
                response.responseBody = Blob.valueOf(JSON.serialize(new SFDCResponse('Success Process','sdsd')));
            }
            
        }catch(Exception e){
            system.debug(e.getMessage());
        }
    }
    
    public class SFDCResponse{
        string response;
        string message;
        public SFDCResponse(string resp, string msg){
            response = resp;
            message = msg;
        }
    }
    
    public class pusher{
      public   string name;
      public  string email;
        public pusher(string name,string email){
            name =name;
            email = email;
        }
    }
     public class head_commit{
      public   string name;
      public  string email;
        public head_commit(string name,string email){
            name =name;
            email = email;
        }
    }
    
}