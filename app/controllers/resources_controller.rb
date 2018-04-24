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
    client = TinyTds::Client.new username: Figaro.env.ares_user, password: Figaro.env.ares_password, host: Figaro.env.ares_host, database: Figaro.env.ares_db
    video = client.execute('SELECT ItemID, Title, Items.Description, Author, PubDate, Items.CourseID AS AresCourseID, Courses.Name AS CourseName, Courses.Semester, Courses.Instructor FROM Items JOIN Courses ON Items.CourseID = Courses.CourseID WHERE ItemID = ' + @resource[:item_id].to_s)

    video.each(:symbolize_keys => true, :cache_rows => false) do |row|
      @resource.item_id = row[:ItemID]
      @resource.title = row[:Title]
      @resource.instructor = row[:Instructor]
      @resource.semester = row[:Semester]
      @resource.course_id = row[:AresCourseID]
      @resource.course_name = row[:CourseName]
    end
    @resource.video = resource_params[:video]

    # Initiate call to JW Player
    jw_call = JWPlayer::API::Client.new(key: Figaro.env.jw_api_key, secret: Figaro.env.jw_api_secret)
    signed_url = jw_call.signed_url('videos/create', 'title': @resource.title, 'sourcetype': 'url', 'sourceformat': 'mp4', 'sourceurl': 'rtmp://128.252.67.12:1935/reserves/' + @resource.item_id + '.mp4')
    response = Typhoeus.post(signed_url)
    json = JSON.parse(response.body)
    media_id = json.dig('video', 'key')

    @resource.media_id = media_id


    if @resource.save
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
    @resource.destroy
    # Initiate call to JW Player for delete
    jw_call = JWPlayer::API::Client.new(key: Figaro.env.jw_api_key, secret: Figaro.env.jw_api_secret)
    signed_url = jw_call.signed_url('videos/delete', 'video_key': @resource.media_id)
    response = Typhoeus.post(signed_url)

    redirect_to resources_path
  end

  private
  def resource_params
    params.require(:resource).permit(:item_id, :video)
  end


end
