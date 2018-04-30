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
    query_id = resource_params[:video].original_filename.to_s[0..-5]
    # create temp resource and make call to ares for values
    temp_resource = ares_call(query_id)

    temp_resource[:size] = File.size(resource_params[:video].tempfile)

    @temp_upload = Resource.new(temp_resource)

    @upload = Resource.where(:item_id => @temp_upload.item_id).first

    if @upload.nil?
      @upload = Resource.create(temp_resource)
      puts "UPLOAD EMPTY? >>>> " + @upload.inspect
    else
      if @upload.size.nil?
        puts "UPLOAD SIZE >>> " + @upload.size.to_s
        @upload.size = @temp_upload[:size]
      else
        @upload.size += @temp_upload[:size]
      end
    end

    # post to jw_player and get mediaid back
    jw_mediaid = jw_call(temp_resource[:title], temp_resource[:item_id])

    temp_resource[:media_id] = jw_mediaid
    @upload[:media_id] = temp_resource[:media_id]
    @upload.video = resource_params[:video]

    puts "TEMP >>> "  + @temp_upload.inspect

    p = resource_params[:video]
    name = p.original_filename
    directory = "uploads/reserves"

    path = File.join(directory, name.gsub(" ","_"))
    File.open(path, "ab") { |f| f.write(p.read) }

    respond_to do |format|
      if @upload.save
        format.html {
          render :json => [@upload].to_json,
                 :content_type => 'text/html',
                 :layout => false
        }
        format.json { render json: {files: [@upload]}, status: :created, location: @upload }
      else
        format.html { render action: "new" }
        format.json { render json: @upload.errors, status: :unprocessable_entity }
      end
    end
    # if @upload.save
    #   redirect_to resources_path
    # else
    #   render 'new'
    # end
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

  def ares_call(query_id)
    resource = Hash.new
    # Call to Ares based on ItemID
    client = TinyTds::Client.new username: Figaro.env.ares_user, password: Figaro.env.ares_password, host: Figaro.env.ares_host, database: Figaro.env.ares_db
    video = client.execute('SELECT ItemID, Title, Items.Description, Author, PubDate, Items.CourseID AS AresCourseID, Courses.Name AS CourseName, Courses.Semester, Courses.Instructor FROM Items JOIN Courses ON Items.CourseID = Courses.CourseID WHERE ItemID = ' + query_id.to_s)

    video.each(:symbolize_keys => true, :cache_rows => false) do |row|
      resource[:item_id] = row[:ItemID]
      resource[:title] = row[:Title]
      resource[:instructor] = row[:Instructor]
      resource[:semester] = row[:Semester]
      resource[:course_id] = row[:AresCourseID]
      resource[:course_name] = row[:CourseName]
      resource[:media_id] = ""
      resource[:video] = ""
    end
    return resource
  end

  def jw_call(title, item_id)
    # Initiate call to JW Player
    jw_call = JWPlayer::API::Client.new(key: Figaro.env.jw_api_key, secret: Figaro.env.jw_api_secret)
    signed_url = jw_call.signed_url('videos/create', 'title': title, 'sourcetype': 'url', 'sourceformat': 'mp4', 'sourceurl': 'rtmp://128.252.67.12:1935/reserves/' + item_id.to_s + '.mp4')
    response = Typhoeus.post(signed_url)
    json = JSON.parse(response.body)
    media_id = json.dig('video', 'key')

    return media_id
  end

  private
  def resource_params
    params.require(:resource).permit(:item_id, :video)
  end



end
