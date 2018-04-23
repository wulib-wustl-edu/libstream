class ResourcesController < ApplicationController
  def home
  end

  def index
    @resources = Resource.all
  end


  def show
    @resource = Resource.find(params[:id])
  end

  def new
  end

  def edit
    @resource = Resource.find(params[:id])
  end

  def create
    @resource = Resource.new(resource_params)

    # Call to Ares based on ItemID
    client = TinyTds::Client.new username: 'AresHydraAccess', password: 'pIfA2HvR0@ODBC', host: 'libsqlclust08.wulib.wustl.edu', database: 'AresData'
    video = client.execute('SELECT ItemID, Title, Items.Description, Author, PubDate, Items.CourseID AS AresCourseID, Courses.Name AS CourseName, Courses.Semester, Courses.Instructor FROM Items JOIN Courses ON Items.CourseID = Courses.CourseID WHERE ItemID = ' + @resource[:item_id].to_s)

    video.each(:symbolize_keys => true, :cache_rows => false) do |row|
      @resource.item_id = row[:ItemID]
      @resource.title = row[:Title]
      @resource.instructor = row[:Instructor]
      @resource.semester = row[:Semester]
      @resource.course_id = row[:AresCourseID]
      @resource.course_name = row[:CourseName]
    end
    @resource.video = resource_params[:original_filename]
    # @resource.save

    if @resource.save
      puts "Success!!!!"
      video.cancel
      redirect_to resources_path
    else
      render 'new'
    end
  end

  def update
    @resource = Resource.find(params[:id])

    if @resource.update(resource_params)
      redirect_to @resource
    else
      render 'edit'
    end
  end


  def destroy
    @resource = Resource.find(params[:id])
    @resource.remove_video!
    @resource.destroy
    redirect_to resources_path
  end

  private
  def resource_params
    params.require(:resource).permit(:item_id, :video)
  end
end
