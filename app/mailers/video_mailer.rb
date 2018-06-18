class VideoMailer < ApplicationMailer
  default from: 'CFU-LIBappmon@email.wustl.edu',
          to: ('phil.suda@wustl')

  def video_upload_alert(error)
    mail(subject: 'Video Upload Error', body: "Video Upload Error \n\n" + error.to_s)
  end
end