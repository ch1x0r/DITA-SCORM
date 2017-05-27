         //$.noConflict();      
          
          
          $(document).ready(function() {
          
            //internal hrefs
            $("a.internal").click(function( event ) {
                 event.preventDefault();
                 window.location = parent.Pages_File[$(this).attr("href")];
                 parent.updateMainPagination($(this).attr("href"));
            });
            
          });
          