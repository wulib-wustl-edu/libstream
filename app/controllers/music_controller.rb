class MusicController < ApplicationController
  skip_before_action :verify_authenticity_token
  helper_method :sort_column, :sort_direction
  before_action :authenticate_user!, :except => [:show]

  def home
  end

  def index
    if current_user[:group] == 'mradmin' || current_user[:group] == 'superadmin'
      @resources = Resource.where("content_type = 'music'").order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
      if params[:search]
        @resources = Resource.where("content_type = 'music'").search(params[:search]).order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
      else
        @resources = Resource.where("content_type = 'music'").order(sort_column + " " + sort_direction).paginate(:per_page => 10, :page => params[:page])
      end
    else
      render 'resources/access_denied'
    end
  end

  def show
    @resource = Resource.find(params[:id])
  end

  def new
    if current_user[:group] == 'mradmin' || current_user[:group] == 'superadmin'
    else
      render 'resources/access_denied'
    end
  end

  def edit
    if current_user[:group] == 'superadmin'
      @resource = Resource.find(params[:id])
    else
      render 'resources/access_denied'
    end
  end

  def create
    query_id = resource_params[:video].original_filename.to_s[0..-5]
    # create temp resource and make call to ares for values
    temp_resource = ares_call(query_id)

    temp_resource[:size] = File.size(resource_params[:video].tempfile)
    temp_resource[:content_type] = 'music'

    puts temp_resource

    @temp_upload = Resource.new(temp_resource)

    @upload = Resource.where(:item_id => @temp_upload.item_id).first

    if @upload.nil?
      @upload = Resource.create(temp_resource)
    else
      if @upload.size.nil?
        @upload.size = @temp_upload[:size]
      else
        @upload.size += @temp_upload[:size]
      end
    end

    # post to jw_player and get mediaid back
    if @upload[:media_id].empty?
      jw_mediaid = jw_call(temp_resource[:title], temp_resource[:item_id], temp_resource[:content_type])

      temp_resource[:media_id] = jw_mediaid
      @upload[:media_id] = temp_resource[:media_id]
    else
    end

    # move file to uploads/reserves for storage in wowza nfs
    p = resource_params[:video]
    name = p.original_filename
    directory = "uploads/reserves"
    path = File.join(directory, name.gsub(" ","_"))
    File.open(path, "ab") { |f| f.write(p.read) }

    # carrierwave connection for delete/upload attachment
    @upload[:video] = name
  rescue ArgumentError => error
    logger.warn "#{error}"
    flash[:error] = "Upload Failed. Please Contact Sys Admin."
    render json: {:error => error.to_s}, status: :unprocessable_entity
  else
    respond_to do |format|
      if @upload.save
        format.html {
          render :json => [@upload.to_jq_upload].to_json,
                 :content_type => 'text/html',
                 :layout => false
        }
        format.json { render json: {files: [@upload.to_jq_upload]}, status: :created, location: @upload}
      else
        format.html { render action: "new" }
        format.json { render json: [@upload.to_jq_upload].errors, status: :unprocessable_entity }
      end
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
    if current_user[:group] == 'sradmin' || current_user[:group] == 'superadmin'
      begin
        @resource = Resource.find(params[:id])

        # Initiate call to JW Player for delete
        jw_call = JWPlayer::API::Client.new(key: Figaro.env.jw_api_key, secret: Figaro.env.jw_api_secret)
        signed_url = jw_call.signed_url('videos/delete', 'video_key': @resource.media_id)
        response = Typhoeus.post(signed_url)
        @resource.destroy
        redirect_to music_index_path
      rescue ArgumentError => error
        logger.warn "#{error}"
        flash[:error] = 'Delete Failed. Please contact Sys Admin'
        redirect_to music_index_path
      end
    else
      render 'resources/access_denied'
    end
  end

  def destroy_upload
    if current_user[:group] == 'superadmin'
      begin
        @resource = Resource.find_by(:video => params[:name].to_s + '.mp4')
        if @resource.present?
          # Initiate call to JW Player for delete
          jw_call = JWPlayer::API::Client.new(key: Figaro.env.jw_api_key, secret: Figaro.env.jw_api_secret)
          signed_url = jw_call.signed_url('videos/delete', 'video_key': @resource.media_id)
          response = Typhoeus.post(signed_url)
          @resource.destroy
          redirect_to new_music_path(@resource, format: :json)
        end
      rescue ArgumentError => error
        logger.warn "#{error}"
        flash[:error] = 'Delete Failed. Please contact Sys Admin'
      end
    else
      render 'new'
    end
  end

  def destroy_multiple
    if current_user[:group] == 'sradmin' || current_user[:group] == 'superadmin'
      begin
        @resources = params[:resource_ids].to_a

        if @resources.present?
          @resources.each do |resource_id|
            @resource = Resource.find(resource_id.to_i)
            # Initiate call to JW Player for delete
            jw_call = JWPlayer::API::Client.new(key: Figaro.env.jw_api_key, secret: Figaro.env.jw_api_secret)
            signed_url = jw_call.signed_url('videos/delete', 'video_key': @resource.media_id)
            response = Typhoeus.post(signed_url)
            @resource.destroy
          end
          redirect_to music_index_path
        end
      rescue ArgumentError => error
        logger.warn "#{error}"
        flash[:error] = 'Delete Failed. Please contact Sys Admin'
        redirect_to music_index_path
      end
    else
      render 'resources/access_denied'
    end
  end

  def ares_call(query_id)
    resource = Hash.new
    # Call to Ares based on ItemID
    client = TinyTds::Client.new username: Figaro.env.ares_user, password: Figaro.env.ares_password, host: Figaro.env.ares_host, database: Figaro.env.ares_db
    video = client.execute('SELECT ItemID, Title, Items.Description, Author, PubDate, ArticleTitle, Items.CourseID AS AresCourseID, Courses.Name AS CourseName, Courses.Semester, Courses.Instructor FROM Items JOIN Courses ON Items.CourseID = Courses.CourseID WHERE ItemID = ' + query_id.to_s)

    video.each(:symbolize_keys => true, :cache_rows => false) do |row|
      resource[:item_id] = row[:ItemID]
      resource[:title] = row[:Title]
      resource[:subtitles] = row[:ArticleTitle]
      resource[:instructor] = row[:Instructor]
      resource[:semester] = row[:Semester]
      resource[:course_id] = row[:AresCourseID]
      resource[:course_name] = row[:CourseName]
      resource[:media_id] = ""
      resource[:video] = ""
    end
    return resource
  end

  def jw_call(title, item_id, content_type)
    # Initiate call to JW Player
    jw_call = JWPlayer::API::Client.new(key: Figaro.env.jw_api_key, secret: Figaro.env.jw_api_secret)
    signed_url = jw_call.signed_url('videos/create', 'title': title, 'sourcetype': 'url', 'sourceformat': 'mp4', 'sourceurl': 'http://' + Figaro.env.wowza_server + '/reserves/' + item_id.to_s + '.' + content_type.to_s)
    response = Typhoeus.post(signed_url)
    json = JSON.parse(response.body)
    media_id = json.dig('video', 'key')

    return media_id
  end

  private
  def resource_params
    params.require(:resource).permit(:id, :item_id, :title, :subtitles, :course_id, :course_name, :semester, :content_type, :instructor, :url, :type, :hashid, :video, :media_id, :size, :resource)
  end

  def sort_column
    Resource.column_names.include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end