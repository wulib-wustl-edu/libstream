# LibStream (Streaming Reserves application)

* Ruby version: ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-darwin17]

* Rails version: 5.1.6


Functionality needed:

Session/duration: logged-in user session should have a reasonable duration (not immediate cut-off)

Upload: 
    
- Upload video files to Wowza Server
- Upload files in batch or individually
- Gather metadata from Ares based on uploaded video file
- Update ARES record with URL
- URL of single streaming video page using JW Player created
- Allot space/scalable space

List of files:
    
- List all videos (or music) uploaded to Wowza
    - Title
    - ItemID
    - CourseID
    - SubTitles available
    - Course Instructor
    - Semester
    - URL
    - Delete option (remove from application list NOT from ARES)

- Batch Delete of Files
- Auto-Removal of Files (after end of semester)
- Sort/Filter List
- Search list of files

Login: 

- Login connected to active directory
- View (what user is able to see) based on login
- Can't view any content in admin interface without being logged in
    

Streaming Page: 

- Show Copyright information
- Requires JWPlayerJS be included in codebase
- Stream video uploaded to Wowza Server
- Display metadata about file along with streaming file


Stats/Usage:

- Stats/Usage Dashboard


Architecture: 

Model(s):

    Resource:
    
    - ItemID (string)
    - Title (string)
    - Subtitles (string)
    - CourseID (string)
    - CourseName (string)
    - Semester (string)
    - Instructor (string)
    - URL (string)
    - Type (string) # is it music, video, etc? 


Views: 

    - Upload View 
    - List View
    - Streaming File View
    - Home/Index View


Controller (other than Application Controller):

    Resource Controller:
    
    - Upload
    - List
    - Stream
    - Home/Index
    