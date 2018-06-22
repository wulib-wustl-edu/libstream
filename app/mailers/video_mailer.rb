class VideoMailer < ApplicationMailer
  default from: Figaro.env.from_email,
          to: (Figaro.env.to_email)

  def video_upload_alert(error)
    mail(subject: 'Video Upload Error', body: "Video Upload Error \n\n" + error.to_s)
  end

  def video_destroy_alert(error)
    mail(subject: 'Video Destroy Error', body: "Video Destroy Error \n\n" + error.to_s)
  end

  def video_jwcall_alert(error)
    mail(subject: 'Video JW Player API Error', body: "Video JW Player API Error \n\n" + error.to_s)
  end

  def video_tinytds_alert(error)
    mail(subject: 'Video ARES Call Error', body: "Video Ares Call Error \n\n" + error.to_s)
  end
end