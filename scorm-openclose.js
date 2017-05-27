// Put all your page JS here


//Scorm
var processedUnload = false;

//$.noConflict();
$(document).ready(function() {
// Code that uses jQuery's $ can follow here.
 
  //record the time that the learner started the SCO so that we can report the total time
  var startTimeStamp = new Date();
 
  //initialize communication with the LMS
  ScormProcessInitialize();

  
  //Resume Prompt
  ResumePrompt();

  //Resume href - onclick
  $("body").on('click','#resume',function(event) {
     event.preventDefault();
     var href = $(this).attr("href");
     
     //Go to page
     $("#display_frame").attr("src",href);
     updateMainPaginationOnResume(href);
     
     //Hide Link
     $(this).hide();
     
     
  }
  );
  

$("#close").click(function(){
    
    
    //don't call this function twice
    if (processedUnload == true) { return; }

    processedUnload = true;
    
    RecordExitStatus();   
    ScormProcessFinish();
    

});




 //Set initial first page
            $("#display_frame").attr("src",Pages[0]);
            $("#total_pages").html(Pages.length);
            $("#current_page").html(PageCount+1);
          
          
            //Record Page has been processed
            Page_Processed[0]=1;
          
          
            $("a").click(function(event) {
             event.preventDefault();
              $("#resume:visible").hide();
            });
          
            
            //functions for previous and next
            $("#prev").click(function() {
               
               if (PageCount > 0) {
                 PageCount--;
               }
               
                $("#display_frame").attr("src",Pages[PageCount]);
                $("#current_page").html(PageCount+1);
                
                //save the current location as the bookmark
                ScormProcessSetValue("cmi.core.lesson_location", PageCount);
                
                
                //Added
                var total_page_processed=0;
                for (var i=0;i<Pages.length;i++) {
                    if (Page_Processed[i] == 1) {
                        total_page_processed ++;
                    }
                }
                
                //Course completed if all pages processed
                if (total_page_processed == Pages.length) {
                     ScormProcessSetValue("cmi.core.lesson_status", "completed");
                     ScormProcessSetValue("cmi.core.lesson_location", "0");
                    
                }
                
                
            });
          
          
            $("#next").click(function() {
               
               if (PageCount < Pages.length - 1) {
                 PageCount++;
               }
               
                $("#display_frame").attr("src",Pages[PageCount]);
                $("#current_page").html(PageCount+1);
                
                //Record Page has been processed
                Page_Processed[PageCount]=1;
                
                //save the current location as the bookmark
                ScormProcessSetValue("cmi.core.lesson_location", PageCount);
                
                var total_page_processed=0;
                for (var i=0;i<Pages.length;i++) {
                    if (Page_Processed[i] == 1) {
                        total_page_processed ++;
                    }
                }
                
                //Course completed if all pages processed
                if (total_page_processed == Pages.length) {
                     ScormProcessSetValue("cmi.core.lesson_status", "completed");
                     ScormProcessSetValue("cmi.core.lesson_location", "0");
                    
                }
                
                
            });           





});


//I don't think I need this - I am not saving any time data - just location
function RecordExitStatus() {
    
    for (var i=0;i<Pages.length;i++) {
        if (Page_Processed[i] == 0) {
             
             ScormProcessSetValue("cmi.core.exit", "suspend");
             return;
        }
    }
    
     
     ScormProcessSetValue("cmi.core.lesson_location", "0"); //Reset
      
     //set exit to normal
     ScormProcessSetValue("cmi.core.exit", "");
      
     
}


function ResumePrompt() {


   //it's a best practice to set the lesson status to incomplete when
   //first launching the course (if the course is not already completed)
   var completionStatus = ScormProcessGetValue("cmi.core.lesson_status");
   if (completionStatus == "not attempted") {
            ScormProcessSetValue("cmi.core.lesson_status", "incomplete");
    }
  

  
  //see if the user stored a bookmark previously (don't check for errors
  //because cmi.core.lesson_location may not be initialized
   var bookmark = ScormProcessGetValue("cmi.core.lesson_location");
        
        //if there isn't a stored bookmark, or the bookmark is zero - start the user at the first page
        if ((bookmark == "") || (bookmark=="0")){

        }
        else{
            //There is a stored bookmark
            
           $("#resume").css({"display":"block"});
           $("#resume").attr("href",Pages[parseInt(bookmark)]);
        }
 
    
    
}


//Called from chidren pages - hrefs
//Updates Main Pagination based on xml_file
function updateMainPagination(xml_file) {
              
              $("#resume:visible").hide();
              
              //Find the Page Count
              for (var i=0;i<Pages.length;i++) {
                 if (Pages[i] == Pages_File[xml_file]) {    
                    PageCount = i; 
                    break;
                  }
              }
              
              //Update Button Currrent Page Display
              $("#current_page").html(PageCount+1);
             
             
              //Record Page has been processed
              Page_Processed[PageCount]=1;
              
              //save the current location as the bookmark
              ScormProcessSetValue("cmi.core.lesson_location", PageCount);
              
}
 
//Resume Button 
//Updates Main Pagination based on html file
//Marks previous Pages as Processed
function updateMainPaginationOnResume(html_file) {
  
              //Find the Page Count
              for (var i=0;i<Pages.length;i++) {
                 if (Pages[i] == html_file) {    
                    PageCount = i; 
                    break;
                  }
              }
  
              //Update Button Currrent Page Display
              $("#current_page").html(PageCount+1);
             
             
              //Record this and prtevious pages are processed
              for (var i=0;i<=PageCount;i++) {
                Page_Processed[i]=1;
              }
              
              //save the current location as the bookmark
              ScormProcessSetValue("cmi.core.lesson_location", PageCount);
              
  
}  



